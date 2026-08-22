#!/usr/bin/env python3
"""Safely reconcile the Accelerate prompt bootstrap in a DSH agent preset."""

from __future__ import annotations

import argparse
import os
import re
import shutil
import sys
import tempfile
from datetime import UTC, datetime
from pathlib import Path


SOURCE = Path(__file__).with_name("code-orchestrated-bootstrap.md")
START = "# accelerate-dsh-bootstrap:begin"
END = "# accelerate-dsh-bootstrap:end"
SOURCE_START = "<!-- accelerate-dsh-bootstrap:begin -->"
SOURCE_END = "<!-- accelerate-dsh-bootstrap:end -->"
TIMESTAMP = re.compile(r"^\d{8}T\d{6}Z$")


def _regular_file(path: Path, label: str) -> None:
    if path.is_symlink() or not path.is_file():
        raise ValueError(f"{label} must be a regular file: {path}")


def _source_body() -> list[str]:
    _regular_file(SOURCE, "bootstrap source")
    content = SOURCE.read_text(encoding="utf-8")
    if content.count(SOURCE_START) != 1 or content.count(SOURCE_END) != 1:
        raise ValueError("bootstrap source markers are malformed")
    body = content.split(SOURCE_START, 1)[1].split(SOURCE_END, 1)[0].strip()
    if not body:
        raise ValueError("bootstrap source is empty")
    return body.splitlines()


def _managed_block() -> str:
    lines = [START, *_source_body(), END]
    return "\n".join(f"      {line}" if line else "" for line in lines) + "\n"


def _validate_preset(preset_dir: Path) -> tuple[Path, str]:
    if preset_dir.is_symlink() or not preset_dir.is_dir():
        raise ValueError(f"preset directory must be a regular directory: {preset_dir}")
    metadata = preset_dir / "preset.yml"
    target = preset_dir / "agent.cordis.yml"
    _regular_file(metadata, "preset.yml")
    _regular_file(target, "agent.cordis.yml")
    text = target.read_text(encoding="utf-8")
    if text.count("- id: persona\n") != 1:
        raise ValueError("expected exactly one persona row")
    persona_start = text.index("- id: persona\n")
    persona_end = text.find("\n- id:", persona_start + 1)
    if persona_end < 0:
        persona_end = len(text)
    persona = text[persona_start:persona_end]
    if persona.count("    text: >-\n") != 1:
        raise ValueError("expected exactly one persona text folded scalar")
    return target, text


def _render(text: str) -> str:
    start_count = text.count(START)
    end_count = text.count(END)
    if start_count != end_count or start_count > 1:
        raise ValueError("managed bootstrap markers are malformed or duplicated")
    block = _managed_block()
    if start_count:
        start = text.index(START)
        start = text.rfind("\n", 0, start) + 1
        end_marker = text.index(END, start)
        end = text.find("\n", end_marker)
        end = len(text) if end < 0 else end + 1
        return text[:start] + block + text[end:]

    persona_start = text.index("- id: persona\n")
    persona_end = text.find("\n- id:", persona_start + 1)
    if persona_end < 0:
        persona_end = len(text)
    prefix = text[:persona_end].rstrip("\n") + "\n"
    suffix = text[persona_end:]
    return prefix + block + suffix


def _atomic_write(path: Path, content: bytes) -> None:
    descriptor, temporary = tempfile.mkstemp(prefix=".accelerate-dsh-", dir=path.parent)
    try:
        os.write(descriptor, content)
        os.fsync(descriptor)
        os.close(descriptor)
        descriptor = -1
        os.chmod(temporary, path.stat().st_mode & 0o777)
        os.replace(temporary, path)
    finally:
        if descriptor >= 0:
            os.close(descriptor)
        if os.path.exists(temporary):
            os.unlink(temporary)


def reconcile(
    preset_dir: Path,
    *,
    apply: bool,
    timestamp: str | None = None,
) -> dict[str, object]:
    target, current = _validate_preset(preset_dir)
    rendered = _render(current)
    drift = rendered != current
    result: dict[str, object] = {"drift": drift, "changed": False, "backup": None}
    if not drift or not apply:
        return result

    timestamp = timestamp or datetime.now(UTC).strftime("%Y%m%dT%H%M%SZ")
    if not TIMESTAMP.fullmatch(timestamp):
        raise ValueError("invalid backup timestamp")
    backup_dir = preset_dir / ".accelerate-backups"
    if backup_dir.exists() and (backup_dir.is_symlink() or not backup_dir.is_dir()):
        raise ValueError("backup root is unsafe")
    backup_dir.mkdir(mode=0o700, exist_ok=True)
    backup = backup_dir / f"agent.cordis.yml.{timestamp}.bak"
    if backup.exists() or backup.is_symlink():
        raise ValueError(f"backup already exists: {backup}")
    shutil.copy2(target, backup, follow_symlinks=False)
    os.chmod(backup, 0o600)
    try:
        _atomic_write(target, rendered.encode("utf-8"))
    except Exception:
        _atomic_write(target, backup.read_bytes())
        raise
    result.update({"changed": True, "backup": str(backup)})
    return result


def rollback(preset_dir: Path, backup: Path) -> None:
    target, _current = _validate_preset(preset_dir)
    backup_root = (preset_dir / ".accelerate-backups").resolve()
    _regular_file(backup, "backup")
    resolved = backup.resolve()
    if resolved.parent != backup_root or not resolved.name.startswith("agent.cordis.yml."):
        raise ValueError("backup is outside the managed backup root")
    _atomic_write(target, resolved.read_bytes())


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--preset-dir", type=Path, required=True)
    parser.add_argument("--apply", action="store_true")
    parser.add_argument("--rollback", type=Path)
    args = parser.parse_args()
    try:
        if args.rollback:
            if args.apply:
                raise ValueError("--rollback and --apply are mutually exclusive")
            rollback(args.preset_dir, args.rollback)
            print(f"PASS: restored DSH preset backup {args.rollback}")
            return 0
        result = reconcile(args.preset_dir, apply=args.apply)
    except (OSError, ValueError) as error:
        print(f"FAIL: {error}", file=sys.stderr)
        return 2
    if result["drift"] and not args.apply:
        print("DRIFT: DSH code-orchestrated Accelerate bootstrap differs")
        return 1
    if result["changed"]:
        print(f"PASS: DSH Accelerate bootstrap applied; backup={result['backup']}")
    else:
        print("PASS: DSH Accelerate bootstrap is current")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
