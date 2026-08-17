#!/usr/bin/env python3
"""Materialize repo-governed OpenHands user skills without touching user skills."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import tempfile
import tomllib
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
PARITY = REPO / "adapters/runtime/model-lanes/cross-runtime-agent-parity.toml"
MARKER = ".accelerate-openhands-skill.json"
MANAGED_BY = "accelerate"
MANAGED_SCHEMA = 1
VALID_NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")


def _assert_regular_tree(path: Path) -> None:
    if path.is_symlink() or not path.is_dir():
        raise ValueError(f"skill source is not a real directory: {path}")
    if not (path / "SKILL.md").is_file() or (path / "SKILL.md").is_symlink():
        raise ValueError(f"skill source lacks a regular SKILL.md: {path}")
    for entry in path.rglob("*"):
        if entry.is_symlink() or not (entry.is_dir() or entry.is_file()):
            raise ValueError(f"skill source contains unsafe path: {entry}")


def _tree_digest(path: Path) -> str:
    _assert_regular_tree(path)
    digest = hashlib.sha256()
    for entry in sorted(path.rglob("*")):
        relative = entry.relative_to(path).as_posix()
        if relative == MARKER:
            continue
        digest.update(relative.encode("utf-8"))
        digest.update(b"\0")
        if entry.is_file():
            digest.update(entry.read_bytes())
            digest.update(b"\0")
    return digest.hexdigest()


def _marker(name: str, digest: str) -> str:
    return json.dumps(
        {
            "managed_by": MANAGED_BY,
            "managed_schema": MANAGED_SCHEMA,
            "name": name,
            "source_digest": digest,
        },
        indent=2,
        sort_keys=True,
    ) + "\n"


def _is_managed(path: Path, name: str) -> bool:
    marker = path / MARKER
    if marker.is_symlink() or not marker.is_file():
        return False
    try:
        payload = json.loads(marker.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return False
    return (
        payload.get("managed_by") == MANAGED_BY
        and payload.get("managed_schema") == MANAGED_SCHEMA
        and payload.get("name") == name
    )


def _validate_target(target_dir: Path, *, apply: bool) -> None:
    if target_dir.exists() and (target_dir.is_symlink() or not target_dir.is_dir()):
        raise ValueError(f"skill target is not a real directory: {target_dir}")
    if not target_dir.exists() and apply:
        target_dir.mkdir(mode=0o755, parents=True)


def _stage(source: Path, target_dir: Path, name: str, digest: str) -> Path:
    stage_root = Path(tempfile.mkdtemp(prefix=f".{name}.", dir=target_dir))
    stage = stage_root / name
    try:
        shutil.copytree(source, stage)
        (stage / MARKER).write_text(_marker(name, digest), encoding="utf-8")
        return stage
    except Exception:
        shutil.rmtree(stage_root, ignore_errors=True)
        raise


def _replace_managed(destination: Path, staged: Path) -> None:
    backup = staged.parent / f"{destination.name}.previous"
    moved_previous = False
    try:
        if destination.exists():
            os.replace(destination, backup)
            moved_previous = True
        os.replace(staged, destination)
        if moved_previous:
            if backup.is_symlink() or backup.is_file():
                backup.unlink()
            else:
                shutil.rmtree(backup)
    except Exception:
        if not destination.exists() and moved_previous and backup.exists():
            os.replace(backup, destination)
        raise
    finally:
        shutil.rmtree(staged.parent, ignore_errors=True)


def _is_approved_legacy_symlink(
    destination: Path, name: str, source: Path, legacy_root: Path
) -> bool:
    if not destination.is_symlink():
        return False
    try:
        resolved = destination.resolve(strict=True)
    except OSError:
        return False
    if resolved != (legacy_root / name).resolve():
        return False
    try:
        _assert_regular_tree(resolved)
    except ValueError:
        return False
    return (resolved / "SKILL.md").read_bytes() == (source / "SKILL.md").read_bytes()


def reconcile(
    target_dir: Path,
    expected: dict[str, Path],
    *,
    apply: bool,
    legacy_root: Path | None = None,
) -> int:
    _validate_target(target_dir, apply=apply)
    legacy_root = legacy_root or (Path.home() / ".codex/skills")
    drift = 0
    for name, source in sorted(expected.items()):
        if not VALID_NAME.fullmatch(name):
            raise ValueError(f"invalid OpenHands governed skill name: {name!r}")
        _assert_regular_tree(source)
        digest = _tree_digest(source)
        destination = target_dir / name
        if destination.is_symlink():
            if not _is_approved_legacy_symlink(destination, name, source, legacy_root):
                raise ValueError(f"refusing unmanaged skill symlink: {destination}")
            drift += 1
            if apply:
                _replace_managed(destination, _stage(source, target_dir, name, digest))
            continue
        if destination.exists():
            if not destination.is_dir():
                raise ValueError(f"refusing non-directory skill target: {destination}")
            if not _is_managed(destination, name):
                raise ValueError(f"refusing to overwrite unmanaged skill: {destination}")
            current = _tree_digest(destination)
            if current == digest:
                continue
        drift += 1
        if apply:
            _replace_managed(destination, _stage(source, target_dir, name, digest))
    return 0 if apply else drift


def load_registry(path: Path = PARITY) -> dict[str, Path]:
    with path.open("rb") as stream:
        registry = tomllib.load(stream)["openhands_skill_registry"]
    names = registry["skills"]
    if len(names) != len(set(names)):
        raise ValueError("duplicate OpenHands governed skill name")
    source_root = REPO / registry["source_root"]
    return {name: source_root / name for name in names}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--target-dir", type=Path, default=Path.home() / ".agents/skills"
    )
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()
    try:
        expected = load_registry()
        drift = reconcile(args.target_dir, expected, apply=args.apply)
    except (OSError, ValueError, KeyError, tomllib.TOMLDecodeError) as error:
        print(f"FAIL: {error}")
        return 2
    if drift:
        print(f"FAIL: OpenHands governed skill drift: {drift} skill(s)")
        return 1
    action = "applied" if args.apply else "verified"
    print(f"PASS: OpenHands governed skills {action}: {len(expected)} skill(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
