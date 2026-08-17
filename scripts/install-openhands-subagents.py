#!/usr/bin/env python3
"""Materialize repo-governed native OpenHands subagent definitions."""

from __future__ import annotations

import argparse
import json
import os
import re
import stat
import tempfile
import tomllib
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
PARITY = REPO / "adapters/runtime/model-lanes/cross-runtime-agent-parity.toml"
MANAGED_MARKER = 'managed_by: "accelerate"'
MANAGED_SCHEMA = "managed_schema: 1"
VALID_NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")


def load_registry(path: Path = PARITY) -> dict[str, dict]:
    with path.open("rb") as stream:
        registry = tomllib.load(stream)["openhands_subagent_registry"]
    result: dict[str, dict] = {}
    for agent in registry["agents"]:
        name = agent["name"]
        if not VALID_NAME.fullmatch(name):
            raise ValueError(f"invalid OpenHands subagent name: {name!r}")
        if name in result:
            raise ValueError(f"duplicate OpenHands subagent name: {name}")
        result[name] = agent
    return result


def _quoted(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def _system_prompt(agent: dict) -> str:
    name = agent["name"]
    description = agent["description"]
    write_mode = agent["write_mode"]
    boundary = (
        "Operate read-only. Do not create, edit, delete, install, restart, or make "
        "external writes."
        if write_mode == "read-only"
        else "Mutate only the files and local state explicitly assigned by the parent."
    )
    return f"""You are the {name} bounded OpenHands subagent.

Mission: {description}

{boundary}

Do not delegate or spawn another agent. Do not broaden scope, perform external
writes, claim integration, or claim final closure. Return a concise packet with
the assigned scope, files or evidence touched, validation performed, defects,
self-review, self-forensic review, residual risks, and recommendation to the
parent orchestrator.
"""


def render_agent(agent: dict) -> str:
    tools = "\n".join(f"  - {_quoted(tool)}" for tool in agent["tools"])
    return (
        "---\n"
        f"name: {_quoted(agent['name'])}\n"
        f"description: {_quoted(agent['description'])}\n"
        f"model: {_quoted(agent['model'])}\n"
        "tools:\n"
        f"{tools}\n"
        f"permission_mode: {_quoted(agent['permission_mode'])}\n"
        f"max_iteration_per_run: {agent['max_iteration_per_run']}\n"
        f"max_budget_per_run: {agent['max_budget_per_run']}\n"
        f"write_mode: {_quoted(agent['write_mode'])}\n"
        f"{MANAGED_MARKER}\n"
        f"{MANAGED_SCHEMA}\n"
        "recursive_delegation: false\n"
        "---\n\n"
        f"{_system_prompt(agent)}"
    )


def _write_atomic(path: Path, rendered: str) -> None:
    mode = path.stat().st_mode & 0o777 if path.exists() else 0o644
    descriptor, temporary_name = tempfile.mkstemp(
        prefix=f".{path.name}.", suffix=".tmp", dir=path.parent
    )
    temporary = Path(temporary_name)
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8") as stream:
            stream.write(rendered)
            stream.flush()
            os.fsync(stream.fileno())
        temporary.chmod(mode)
        os.replace(temporary, path)
    finally:
        if temporary.exists():
            temporary.unlink()


def _is_managed(rendered: str) -> bool:
    if not rendered.startswith("---\n"):
        return False
    end = rendered.find("\n---\n", 4)
    if end < 0:
        return False
    frontmatter_lines = set(rendered[4:end].splitlines())
    return MANAGED_MARKER in frontmatter_lines and MANAGED_SCHEMA in frontmatter_lines


def _is_legacy_managed(rendered: str) -> bool:
    """Recognize only this materializer's pre-schema frontmatter for migration."""
    if not rendered.startswith("---\n"):
        return False
    end = rendered.find("\n---\n", 4)
    if end < 0:
        return False
    frontmatter_lines = set(rendered[4:end].splitlines())
    return (
        MANAGED_MARKER in frontmatter_lines
        and "recursive_delegation: false" in frontmatter_lines
        and any(line.startswith('write_mode: "') for line in frontmatter_lines)
        and MANAGED_SCHEMA not in frontmatter_lines
    )


def _validate_target_dir(target_dir: Path) -> None:
    if target_dir.is_symlink():
        raise ValueError(f"refusing symlinked target directory: {target_dir}")
    if target_dir.exists() and not target_dir.is_dir():
        raise ValueError(f"target is not a directory: {target_dir}")


def reconcile(target_dir: Path, expected: dict[str, dict], *, apply: bool) -> int:
    _validate_target_dir(target_dir)
    if apply:
        target_dir.mkdir(parents=True, exist_ok=True)
    elif not target_dir.is_dir():
        return len(expected)

    drift = 0
    expected_paths: set[Path] = set()
    for name, agent in sorted(expected.items()):
        if not VALID_NAME.fullmatch(name):
            raise ValueError(f"invalid OpenHands subagent name: {name!r}")
        path = target_dir / f"{name}.md"
        expected_paths.add(path)
        rendered = render_agent(agent)
        if path.is_symlink():
            raise ValueError(f"refusing non-regular agent path: {path}")
        if path.exists():
            mode = path.lstat().st_mode
            if stat.S_ISLNK(mode) or not stat.S_ISREG(mode):
                raise ValueError(f"refusing non-regular agent path: {path}")
            current = path.read_text(encoding="utf-8")
            if current == rendered:
                continue
            if not (_is_managed(current) or _is_legacy_managed(current)):
                raise ValueError(f"refusing to overwrite unmanaged agent: {path}")
        drift += 1
        if apply:
            _write_atomic(path, rendered)

    if target_dir.is_dir():
        for path in sorted(target_dir.glob("*.md")):
            if path in expected_paths:
                continue
            mode = path.lstat().st_mode
            if stat.S_ISLNK(mode) or not stat.S_ISREG(mode):
                raise ValueError(f"refusing non-regular agent path: {path}")
            if not _is_managed(path.read_text(encoding="utf-8")):
                continue
            drift += 1
            if apply:
                path.unlink()

    return 0 if apply else drift


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--target-dir", type=Path, default=Path.home() / ".agents/agents"
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
        print(f"FAIL: OpenHands subagent registry drift: {drift} definition(s)")
        return 1
    action = "applied" if args.apply else "verified"
    print(f"PASS: OpenHands subagent registry {action}: {len(expected)} definition(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
