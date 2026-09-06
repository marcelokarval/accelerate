#!/usr/bin/env python3
"""Materialize repository-owned operational skills into guarded runtime roots."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import sys
import tempfile
import tomllib
from datetime import UTC, datetime
from pathlib import Path
from typing import Any


REPO = Path(__file__).resolve().parents[1]
REGISTRY = REPO / "adapters/runtime/operational-skill-projections.toml"
MARKER = ".accelerate-operational-skill.json"
MANAGED_BY = "accelerate"
MANAGED_SCHEMA = 1
VALID_NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
VALID_RUN = re.compile(r"^\d{8}T\d{6}Z-[a-z0-9-]+$")


def _is_python_cache(entry: Path, root: Path) -> bool:
    if entry.is_symlink():
        return False
    rel_parts = entry.relative_to(root).parts
    if "__pycache__" in rel_parts:
        return True
    return entry.is_file() and entry.name.endswith((".pyc", ".pyo"))


def assert_regular_tree(path: Path) -> None:
    if path.is_symlink() or not path.is_dir():
        raise ValueError(f"unsafe source tree: {path}")
    skill = path / "SKILL.md"
    if skill.is_symlink() or not skill.is_file():
        raise ValueError(f"unsafe source tree lacks regular SKILL.md: {path}")
    for entry in path.rglob("*"):
        if entry.is_symlink():
            raise ValueError(f"unsafe source entry: {entry}")
        if _is_python_cache(entry, path):
            continue
        if not (entry.is_dir() or entry.is_file()):
            raise ValueError(f"unsafe source entry: {entry}")


def tree_digest(path: Path) -> str:
    assert_regular_tree(path)
    digest = hashlib.sha256()
    for entry in sorted(path.rglob("*")):
        if _is_python_cache(entry, path):
            continue
        relative = entry.relative_to(path).as_posix()
        if relative == MARKER:
            continue
        digest.update(relative.encode("utf-8"))
        digest.update(b"\0")
        if entry.is_file():
            digest.update(entry.read_bytes())
            digest.update(b"\0")
    return digest.hexdigest()


def _safe_relative(value: str, label: str) -> Path:
    path = Path(value)
    if path.is_absolute() or not path.parts or ".." in path.parts:
        raise ValueError(f"invalid {label} path: {value}")
    return path


def load_registry(
    registry_path: Path = REGISTRY,
    repo_root: Path = REPO,
) -> tuple[dict[str, Path], dict[str, Path]]:
    with registry_path.open("rb") as stream:
        payload = tomllib.load(stream)
    if set(payload) != {"schema_version", "managed_by", "marker", "skills", "targets"}:
        raise ValueError("projection registry schema drift")
    if payload["schema_version"] != 1 or payload["managed_by"] != MANAGED_BY:
        raise ValueError("projection registry ownership drift")
    if payload["marker"] != MARKER:
        raise ValueError("projection marker drift")
    skills: dict[str, Path] = {}
    for item in payload["skills"]:
        if set(item) != {"name", "source"}:
            raise ValueError("projection skill entry schema drift")
        name = item["name"]
        if not isinstance(name, str) or not VALID_NAME.fullmatch(name) or name in skills:
            raise ValueError(f"invalid or duplicate skill name: {name!r}")
        source = _safe_relative(item["source"], "source")
        skills[name] = repo_root / source
    targets: dict[str, Path] = {}
    for item in payload["targets"]:
        if set(item) != {"runtime", "home_suffix"}:
            raise ValueError("projection target entry schema drift")
        runtime = item["runtime"]
        if not isinstance(runtime, str) or not VALID_NAME.fullmatch(runtime) or runtime in targets:
            raise ValueError(f"invalid or duplicate runtime: {runtime!r}")
        targets[runtime] = _safe_relative(item["home_suffix"], "target")
    if not skills or not ({"opencode", "agents", "hermes"} <= set(targets) <= {"opencode", "agents", "codex", "hermes", "claude"}):
        raise ValueError("projection denominator drift")
    return skills, targets


def _marker(name: str, runtime: str, digest: str) -> str:
    return json.dumps(
        {
            "managed_by": MANAGED_BY,
            "managed_schema": MANAGED_SCHEMA,
            "name": name,
            "runtime": runtime,
            "source_digest": digest,
        },
        indent=2,
        sort_keys=True,
    ) + "\n"


def _managed_payload(path: Path, name: str, runtime: str) -> dict[str, Any] | None:
    marker = path / MARKER
    if marker.is_symlink() or not marker.is_file():
        return None
    try:
        payload = json.loads(marker.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return None
    expected = {"managed_by", "managed_schema", "name", "runtime", "source_digest"}
    if (
        set(payload) != expected
        or payload.get("managed_by") != MANAGED_BY
        or payload.get("managed_schema") != MANAGED_SCHEMA
        or payload.get("name") != name
        or payload.get("runtime") not in {runtime, "hermes"}
        or not isinstance(payload.get("source_digest"), str)
    ):
        return None
    return payload


def _assert_safe_root(home: Path, target: Path, *, create: bool) -> None:
    if home.is_symlink() or not home.is_dir():
        raise ValueError(f"home must be a regular directory: {home}")
    current = home
    for part in target.relative_to(home).parts:
        current /= part
        if current.exists() and current.is_symlink():
            raise ValueError(f"target path contains symlink: {current}")
    if target.exists() and not target.is_dir():
        raise ValueError(f"target root is not a directory: {target}")
    if create:
        target.mkdir(mode=0o755, parents=True, exist_ok=True)


def _stage(source: Path, target_root: Path, name: str, runtime: str, digest: str) -> Path:
    stage_root = Path(tempfile.mkdtemp(prefix=f".{name}.", dir=target_root))
    stage = stage_root / name
    try:
        shutil.copytree(
            source,
            stage,
            ignore=shutil.ignore_patterns("__pycache__", "*.pyc", "*.pyo"),
        )
        (stage / MARKER).write_text(_marker(name, runtime, digest), encoding="utf-8")
        return stage
    except Exception:
        shutil.rmtree(stage_root, ignore_errors=True)
        raise


def _replace(destination: Path, staged: Path) -> None:
    previous = staged.parent / f"{destination.name}.previous"
    moved = False
    try:
        if destination.exists():
            os.replace(destination, previous)
            moved = True
        os.replace(staged, destination)
        if moved:
            shutil.rmtree(previous)
    except Exception:
        if not destination.exists() and moved and previous.exists():
            os.replace(previous, destination)
        raise
    finally:
        shutil.rmtree(staged.parent, ignore_errors=True)


def _write_manifest(path: Path, payload: dict[str, Any]) -> None:
    temporary = path.with_suffix(".tmp")
    temporary.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    os.chmod(temporary, 0o600)
    os.replace(temporary, path)


def reconcile(
    runtime: str,
    *,
    home: Path,
    registry_path: Path = REGISTRY,
    repo_root: Path = REPO,
    apply: bool,
    backup_root: Path | None = None,
    run_id: str | None = None,
) -> dict[str, object]:
    skills, targets = load_registry(registry_path, repo_root)
    if runtime not in targets:
        if runtime == "codex":
            raise ValueError(
                "codex runtime uses the shared '.agents/skills' hub; please use '--runtime agents'"
            )
        raise ValueError(f"unknown runtime: {runtime}")
    target_root = home / targets[runtime]
    _assert_safe_root(home, target_root, create=False)
    expected = {name: tree_digest(source) for name, source in skills.items()}
    drift: list[str] = []
    for name, digest in expected.items():
        destination = target_root / name
        if destination.exists() or destination.is_symlink():
            if destination.is_symlink() or not destination.is_dir():
                raise ValueError(f"refusing unmanaged target: {destination}")
            marker = _managed_payload(destination, name, runtime)
            if marker is None:
                raise ValueError(f"refusing unmanaged skill: {destination}")
            if tree_digest(destination) != digest or marker["source_digest"] != digest:
                drift.append(name)
        else:
            drift.append(name)
    if not apply or not drift:
        return {"drift": len(drift), "changed": [], "rollback_id": None}

    _assert_safe_root(home, target_root, create=True)
    run_id = run_id or f"{datetime.now(UTC).strftime('%Y%m%dT%H%M%SZ')}-{runtime}"
    if not VALID_RUN.fullmatch(run_id):
        raise ValueError("invalid rollback id")
    backup_root = backup_root or home / ".local/state/accelerate/backups/operational-skills"
    if backup_root.exists() and (backup_root.is_symlink() or not backup_root.is_dir()):
        raise ValueError("unsafe backup root")
    backup_root.mkdir(mode=0o700, parents=True, exist_ok=True)
    run_root = backup_root / run_id
    if run_root.exists() or run_root.is_symlink():
        raise ValueError(f"rollback id already exists: {run_id}")
    run_root.mkdir(mode=0o700)
    manifest: dict[str, Any] = {
        "schema_version": 1,
        "runtime": runtime,
        "run_id": run_id,
        "status": "prepared",
        "entries": [],
    }
    for name in drift:
        destination = target_root / name
        digest = expected[name]
        previous = destination.exists()
        prev_digest = None
        if previous:
            prev_digest = tree_digest(destination)
            backup_path = run_root / f"{name}.previous"
            shutil.copytree(
                destination,
                backup_path,
                ignore=shutil.ignore_patterns("__pycache__", "*.pyc", "*.pyo"),
            )
            assert_regular_tree(backup_path)
            if tree_digest(backup_path) != prev_digest:
                raise ValueError(f"backup copy integrity failed for {name}")
        entry = {
            "name": name,
            "previous": previous,
            "previous_digest": prev_digest,
            "installed_digest": digest,
        }
        manifest["entries"].append(entry)
    manifest_path = run_root / "manifest.json"
    _write_manifest(manifest_path, manifest)

    changed: list[str] = []
    try:
        for name in drift:
            staged = _stage(skills[name], target_root, name, runtime, expected[name])
            _replace(target_root / name, staged)
            changed.append(name)
        manifest["status"] = "applied"
        _write_manifest(manifest_path, manifest)
    except Exception:
        for name in reversed(changed):
            entry = next(item for item in manifest["entries"] if item["name"] == name)
            destination = target_root / name
            if destination.exists():
                shutil.rmtree(destination)
            if entry["previous"]:
                shutil.copytree(
                    run_root / f"{name}.previous",
                    destination,
                    ignore=shutil.ignore_patterns("__pycache__", "*.pyc", "*.pyo"),
                )
        manifest["status"] = "failed-rolled-back"
        _write_manifest(manifest_path, manifest)
        raise
    return {"drift": len(drift), "changed": changed, "rollback_id": run_id}


def rollback(
    runtime: str,
    run_id: str,
    *,
    home: Path,
    registry_path: Path = REGISTRY,
    repo_root: Path = REPO,
    backup_root: Path | None = None,
) -> None:
    if not VALID_RUN.fullmatch(run_id):
        raise ValueError("invalid rollback id")
    _skills, targets = load_registry(registry_path, repo_root)
    if runtime not in targets:
        if runtime == "codex":
            raise ValueError(
                "codex runtime uses the shared '.agents/skills' hub; please use '--runtime agents'"
            )
        raise ValueError(f"unknown runtime: {runtime}")
    target_root = home / targets[runtime]
    _assert_safe_root(home, target_root, create=False)
    backup_root = backup_root or home / ".local/state/accelerate/backups/operational-skills"
    run_root = backup_root / run_id
    manifest_path = run_root / "manifest.json"
    if run_root.is_symlink() or not run_root.is_dir() or manifest_path.is_symlink():
        raise ValueError("rollback record is missing or unsafe")
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if (
        manifest.get("schema_version") != 1
        or manifest.get("runtime") != runtime
        or manifest.get("run_id") != run_id
        or manifest.get("status") != "applied"
    ):
        raise ValueError("rollback manifest is not applicable")
    entries = manifest.get("entries")
    if not isinstance(entries, list):
        raise ValueError("rollback manifest entries are invalid")

    # Preflight phase: validate all destinations and all backups before any mutation
    for entry in entries:
        name = entry.get("name")
        if not isinstance(name, str) or not VALID_NAME.fullmatch(name):
            raise ValueError("rollback manifest skill name is invalid")
        destination = target_root / name
        marker = _managed_payload(destination, name, runtime)
        if marker is None or marker["source_digest"] != entry.get("installed_digest"):
            raise ValueError(f"refusing rollback after target drift: {name}")

        if entry.get("previous"):
            backup = run_root / f"{name}.previous"
            if not backup.exists() or backup.is_symlink() or not backup.is_dir():
                raise ValueError(f"missing or unsafe backup directory for {name}")
            assert_regular_tree(backup)
            expected_prev_digest = entry.get("previous_digest")
            if expected_prev_digest is not None:
                actual_prev_digest = tree_digest(backup)
                if actual_prev_digest != expected_prev_digest:
                    raise ValueError(
                        f"refusing rollback: backup for {name} has tampered digest "
                        f"(expected {expected_prev_digest}, got {actual_prev_digest})"
                    )
            if not (backup / MARKER).is_file():
                raise ValueError(f"backup for {name} is missing managed marker")

    # Execution phase: perform rollback atomically per skill
    for entry in reversed(entries):
        name = entry["name"]
        destination = target_root / name
        if entry.get("previous"):
            backup = run_root / f"{name}.previous"
            staged = _stage(backup, target_root, name, runtime, tree_digest(backup))
            shutil.copy2(backup / MARKER, staged / MARKER)
            _replace(destination, staged)
        else:
            shutil.rmtree(destination)
    manifest["status"] = "rolled-back"
    _write_manifest(manifest_path, manifest)


class OperationalSkillsArgumentParser(argparse.ArgumentParser):
    def error(self, message: str) -> None:
        if "codex" in message.lower():
            self.exit(
                2,
                "FAIL: codex runtime uses the shared '.agents/skills' hub; "
                "please use '--runtime agents'.\n",
            )
        super().error(message)


def main() -> int:
    parser = OperationalSkillsArgumentParser()
    parser.add_argument("--runtime", required=True, choices=("opencode", "agents", "hermes", "claude"))
    parser.add_argument("--home", type=Path, default=Path.home())
    parser.add_argument("--registry", type=Path, default=REGISTRY)
    parser.add_argument("--backup-root", type=Path)
    parser.add_argument("--apply", action="store_true")
    parser.add_argument("--rollback")
    args = parser.parse_args()
    try:
        if args.rollback:
            if args.apply:
                raise ValueError("--rollback and --apply are mutually exclusive")
            rollback(
                args.runtime, args.rollback, home=args.home,
                registry_path=args.registry, backup_root=args.backup_root,
            )
            print(f"PASS: operational skills rolled back: {args.rollback}")
            return 0
        result = reconcile(
            args.runtime, home=args.home, registry_path=args.registry,
            apply=args.apply, backup_root=args.backup_root,
        )
    except (OSError, ValueError, KeyError, tomllib.TOMLDecodeError, json.JSONDecodeError) as error:
        print(f"FAIL: {error}", file=sys.stderr)
        return 2
    if result["drift"] and not args.apply:
        print(f"DRIFT: {result['drift']} operational skill(s) differ for {args.runtime}")
        return 1
    if result["changed"]:
        print(
            f"PASS: operational skills applied for {args.runtime}; "
            f"rollback_id={result['rollback_id']}"
        )
    else:
        print(f"PASS: operational skills current for {args.runtime}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
