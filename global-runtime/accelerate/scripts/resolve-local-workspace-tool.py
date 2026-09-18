#!/usr/bin/env python3
"""Resolve source-owned Accelerate local-workspace tools safely."""

from __future__ import annotations

import argparse
import json
import os
import pwd
import re
import stat
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

ALLOWED_TOOLS = {
    "bootstrap-or-reentry.sh",
    "classify-project.sh",
    "detect-signals.sh",
    "emit-v2.sh",
    "validate-v2.sh",
}
TRUST_MANIFEST = "assets/local-workspace-source-trust.json"
COMMIT_PATTERN = re.compile(r"[0-9a-f]{40}")


@dataclass(frozen=True)
class TrustedSource:
    root: Path
    commit: str
    origin: str


def is_regular_nonsymlinked_file(path: Path) -> bool:
    try:
        resolved = path.resolve(strict=True)
        metadata = path.lstat()
    except (OSError, RuntimeError):
        return False
    return stat.S_ISREG(metadata.st_mode) and resolved == path.absolute()


def load_trusted_sources() -> list[TrustedSource]:
    script = Path(__file__).absolute()
    try:
        resolved_script = script.resolve(strict=True)
    except (OSError, RuntimeError) as error:
        raise ValueError(f"resolver path is unavailable: {error}") from error
    if script.is_symlink() or resolved_script != script:
        raise ValueError("resolver path must not contain symlinked components")

    manifest = script.parent.parent / TRUST_MANIFEST
    try:
        resolved_manifest = manifest.resolve(strict=True)
    except (OSError, RuntimeError) as error:
        raise ValueError(f"trusted-source manifest is unavailable: {error}") from error
    if (
        not manifest.is_file()
        or manifest.is_symlink()
        or resolved_manifest != manifest.absolute()
    ):
        raise ValueError("trusted-source manifest must be a regular non-symlinked file")

    try:
        payload = json.loads(manifest.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise ValueError(f"trusted-source manifest is invalid: {error}") from error
    if payload.get("schema_version") != 1:
        raise ValueError("trusted-source manifest schema_version must be 1")
    entries = payload.get("trusted_sources")
    if not isinstance(entries, list) or not entries:
        raise ValueError("trusted-source manifest must contain trusted_sources")

    user_home = Path(pwd.getpwuid(os.getuid()).pw_dir).resolve(strict=True)
    sources: list[TrustedSource] = []
    seen: set[Path] = set()
    for entry in entries:
        if not isinstance(entry, dict):
            raise ValueError("trusted-source entries must be objects")
        raw_path = entry.get("path")
        commit = entry.get("commit")
        origin = entry.get("origin")
        if (
            not isinstance(raw_path, str)
            or not raw_path
            or not isinstance(commit, str)
            or not commit
            or not isinstance(origin, str)
            or not origin
        ):
            raise ValueError("trusted-source path, commit, and origin must be strings")
        if not COMMIT_PATTERN.fullmatch(commit):
            raise ValueError("trusted-source commit must be a lowercase 40-character Git id")
        expanded = raw_path.replace("${USER_HOME}", str(user_home))
        root = Path(expanded)
        if not root.is_absolute() or "${" in expanded:
            raise ValueError("trusted-source path must resolve to an absolute path")
        root = root.absolute()
        if root in seen:
            raise ValueError(f"duplicate trusted-source path: {root}")
        seen.add(root)
        sources.append(TrustedSource(root=root, commit=commit, origin=origin))
    return sources


def select_trusted_sources(
    explicit: str | None, sources: list[TrustedSource]
) -> list[TrustedSource]:
    requested = explicit or os.environ.get("ACCELERATE_SOURCE_ROOT")
    if not requested:
        return sources
    requested_root = Path(requested).expanduser().absolute()
    selected = [source for source in sources if source.root == requested_root]
    if not selected:
        raise ValueError(f"source root is not present in the trusted manifest: {requested_root}")
    return selected


def resolve_source_root(source: TrustedSource) -> Path | None:
    candidate = source.root
    if not candidate.is_dir() or candidate.is_symlink():
        return None
    try:
        resolved_candidate = candidate.resolve(strict=True)
    except (OSError, RuntimeError):
        return None
    if resolved_candidate != candidate.absolute():
        return None
    identity_files = (
        candidate / "AGENTS.md",
        candidate / "SKILL.md",
        candidate / "global-runtime/accelerate/SKILL.md",
    )
    if not all(is_regular_nonsymlinked_file(path) for path in identity_files):
        return None
    try:
        completed = subprocess.run(
            ["git", "-C", str(candidate), "rev-parse", "--show-toplevel"],
            check=True,
            capture_output=True,
            text=True,
            timeout=10,
        )
        origin = subprocess.run(
            ["git", "-C", str(candidate), "remote", "get-url", "origin"],
            check=True,
            capture_output=True,
            text=True,
            timeout=10,
        ).stdout.strip()
        head = subprocess.run(
            ["git", "-C", str(candidate), "rev-parse", "HEAD"],
            check=True,
            capture_output=True,
            text=True,
            timeout=10,
        ).stdout.strip()
    except (OSError, subprocess.SubprocessError):
        return None
    if origin != source.origin or head != source.commit:
        return None
    try:
        root = Path(completed.stdout.strip()).resolve(strict=True)
    except (OSError, RuntimeError):
        return None
    return root if root == resolved_candidate else None


def tracked_tool_matches_head(root: Path, tool: Path) -> bool:
    try:
        metadata = tool.lstat()
    except OSError:
        return False
    if not stat.S_ISREG(metadata.st_mode) or stat.S_IMODE(metadata.st_mode) != 0o755:
        return False
    relative = tool.relative_to(root).as_posix()
    try:
        tree = subprocess.run(
            ["git", "-C", str(root), "ls-tree", "HEAD", "--", relative],
            check=True,
            capture_output=True,
            text=True,
            timeout=10,
        ).stdout.split()
        head_blob = subprocess.run(
            ["git", "-C", str(root), "rev-parse", f"HEAD:{relative}"],
            check=True,
            capture_output=True,
            text=True,
            timeout=10,
        ).stdout.strip()
        working_blob = subprocess.run(
            ["git", "-C", str(root), "hash-object", str(tool)],
            check=True,
            capture_output=True,
            text=True,
            timeout=10,
        ).stdout.strip()
    except (OSError, subprocess.SubprocessError, ValueError):
        return False
    return len(tree) == 4 and tree[0] == "100755" and head_blob == working_blob


def resolve_tool(tool_name: str, explicit_root: str | None) -> Path:
    if tool_name not in ALLOWED_TOOLS:
        allowed = ", ".join(sorted(ALLOWED_TOOLS))
        raise ValueError(f"unsupported local-workspace tool: {tool_name}; allowed: {allowed}")

    trusted_sources = select_trusted_sources(explicit_root, load_trusted_sources())
    checked: list[str] = []
    for source in trusted_sources:
        checked.append(str(source.root))
        root = resolve_source_root(source)
        if root is None:
            continue
        tool = root / "onboarding/local-workspace" / tool_name
        try:
            tool_has_symlinked_component = tool.resolve(strict=True) != tool.absolute()
        except OSError:
            continue
        if (
            is_regular_nonsymlinked_file(tool)
            and not tool_has_symlinked_component
            and tracked_tool_matches_head(root, tool)
        ):
            return tool.resolve(strict=True)

    checked_text = ", ".join(checked)
    raise FileNotFoundError(
        "authoritative Accelerate source checkout was not resolved; "
        "set ACCELERATE_SOURCE_ROOT or pass --source-root. "
        f"Checked: {checked_text}"
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Resolve an allowlisted local-workspace command from the authoritative "
            "Accelerate source checkout; the installed runtime skill does not own "
            "the onboarding implementation."
        )
    )
    parser.add_argument("tool", help="allowlisted local-workspace tool filename")
    parser.add_argument(
        "--source-root",
        help="explicit authoritative Accelerate repository root",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        print(resolve_tool(args.tool, args.source_root))
    except (FileNotFoundError, ValueError) as error:
        print(f"resolve-local-workspace-tool: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
