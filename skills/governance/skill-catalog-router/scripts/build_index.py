#!/usr/bin/env python3
"""Build and verify the current repo-owned governed skill route index."""

from __future__ import annotations

import argparse
import hashlib
import os
import re
import stat
import tempfile
from pathlib import Path


SKILL_ID = re.compile(r"[a-z0-9][a-z0-9-]*\Z")


def frontmatter(path: Path) -> tuple[str, str]:
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---\n") or "\n---\n" not in text[4:]:
        raise ValueError(f"missing YAML frontmatter: {path}")
    block = text.split("\n---\n", 1)[0][4:]
    values: dict[str, str] = {}
    lines = block.splitlines()
    index = 0
    while index < len(lines):
        line = lines[index]
        if ":" not in line or line[:1].isspace():
            index += 1
            continue
        key, raw = line.split(":", 1)
        value = raw.strip()
        if value in {"|", "|-", ">", ">-"}:
            chunks: list[str] = []
            index += 1
            while index < len(lines) and (not lines[index] or lines[index][:1].isspace()):
                if lines[index].strip():
                    chunks.append(lines[index].strip())
                index += 1
            values[key] = " ".join(chunks)
            continue
        values[key] = value.strip("'\"")
        index += 1
    return values.get("name", ""), " ".join(values.get("description", "").split())


def source_files(repo_root: Path) -> list[Path]:
    candidates = sorted((repo_root / "skills").glob("*/*/SKILL.md"))
    candidates.append(repo_root / "global-runtime/accelerate/SKILL.md")
    return candidates


def build(repo_root: Path) -> str:
    root = repo_root.resolve(strict=True)
    rows: list[tuple[str, str, str, str, str]] = []
    seen: set[str] = set()
    for candidate in source_files(root):
        if not candidate.is_file():
            raise ValueError(f"missing or non-regular skill source: {candidate}")
        resolved = candidate.resolve(strict=True)
        try:
            relative = resolved.relative_to(root)
        except ValueError as error:
            raise ValueError(f"skill source escapes repository: {candidate}") from error
        name, description = frontmatter(resolved)
        expected_name = "accelerate" if relative.as_posix() == "global-runtime/accelerate/SKILL.md" else resolved.parent.name
        if not SKILL_ID.fullmatch(name) or name != expected_name:
            raise ValueError(f"invalid or mismatched skill id {name!r}: {relative}")
        if name in seen:
            raise ValueError(f"duplicate governed skill id: {name}")
        seen.add(name)
        runtime = Path.home() / ".codex" / "skills" / name / "SKILL.md"
        digest = hashlib.sha256(resolved.read_bytes()).hexdigest()
        rows.append((name, relative.as_posix(), str(runtime), digest, description))
    rows.sort(key=lambda row: row[0])
    return "".join("\t".join(row) + "\n" for row in rows)


def validate_index_destination(
    repo_root: Path, index: Path, *, require_existing: bool
) -> Path:
    """Return a canonical lexical destination after rejecting path indirection."""
    candidate = Path(os.path.abspath(index))
    try:
        relative = candidate.relative_to(repo_root)
    except ValueError as error:
        raise ValueError(f"router index destination is outside repository: {candidate}") from error
    if not relative.parts:
        raise ValueError(f"router index destination is not a file path: {candidate}")

    current = repo_root
    for component in relative.parts[:-1]:
        current /= component
        metadata = current.lstat()
        if stat.S_ISLNK(metadata.st_mode):
            raise ValueError(f"router index parent must not be a symlink: {current}")
        if not stat.S_ISDIR(metadata.st_mode):
            raise ValueError(f"router index parent is not a directory: {current}")

    resolved_parent = candidate.parent.resolve(strict=True)
    try:
        resolved_parent.relative_to(repo_root)
    except ValueError as error:
        raise ValueError(
            f"router index parent resolves outside repository: {candidate.parent}"
        ) from error

    try:
        metadata = candidate.lstat()
    except FileNotFoundError:
        if require_existing:
            raise ValueError(f"stale or missing router index: {candidate}") from None
        return candidate

    if stat.S_ISLNK(metadata.st_mode):
        raise ValueError(f"router index destination must not be a symlink: {candidate}")
    if not stat.S_ISREG(metadata.st_mode):
        raise ValueError(f"router index destination is not a regular file: {candidate}")
    resolved = candidate.resolve(strict=True)
    try:
        resolved.relative_to(repo_root)
    except ValueError as error:
        raise ValueError(
            f"router index destination resolves outside repository: {candidate}"
        ) from error
    return candidate


def atomic_write_index(repo_root: Path, index: Path, content: str) -> None:
    """Write a complete sibling file and atomically replace the validated index."""
    destination = validate_index_destination(repo_root, index, require_existing=False)
    existing_mode = destination.stat().st_mode & 0o777 if destination.exists() else 0o644
    descriptor, temporary_name = tempfile.mkstemp(
        dir=destination.parent,
        prefix=f".{destination.name}.",
        suffix=".tmp",
    )
    temporary = Path(temporary_name)
    try:
        os.fchmod(descriptor, existing_mode)
        with os.fdopen(descriptor, "wb") as stream:
            descriptor = -1
            stream.write(content.encode("utf-8"))
            stream.flush()
            os.fsync(stream.fileno())
        metadata = temporary.lstat()
        if stat.S_ISLNK(metadata.st_mode) or not stat.S_ISREG(metadata.st_mode):
            raise ValueError(f"temporary router index is not a regular file: {temporary}")
        validate_index_destination(repo_root, destination, require_existing=False)
        os.replace(temporary, destination)
    finally:
        if descriptor >= 0:
            os.close(descriptor)
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", type=Path, required=True)
    parser.add_argument("--index", type=Path)
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--check", action="store_true")
    action.add_argument("--write", action="store_true")
    args = parser.parse_args()
    repo_root = args.repo_root.resolve(strict=True)
    index = args.index or repo_root / "skills/governance/skill-catalog-router/references/index.tsv"
    try:
        content = build(repo_root)
        if args.check:
            destination = validate_index_destination(
                repo_root, index, require_existing=True
            )
            if destination.read_text(encoding="utf-8") != content:
                raise ValueError(f"stale or missing router index: {index}")
        else:
            atomic_write_index(repo_root, index, content)
    except (OSError, UnicodeError, ValueError) as error:
        parser.error(str(error))
    print(f"skill catalog router index passed: rows={content.count(chr(10))}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
