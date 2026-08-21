#!/usr/bin/env python3
"""Materialize repo-governed native OpenHands subagent definitions."""

from __future__ import annotations

import argparse
import json
import os
import re
import hashlib
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
    names = [agent["name"] for agent in registry["agents"]]
    if len(names) != len(set(names)):
        duplicate = next(name for name in names if names.count(name) > 1)
        raise ValueError(f"duplicate OpenHands subagent name: {duplicate}")
    for agent in registry["agents"]:
        name = agent["name"]
        if not VALID_NAME.fullmatch(name):
            raise ValueError(f"invalid OpenHands subagent name: {name!r}")
        if agent.get("binding_state", "available") == "binding_unavailable":
            continue
        if agent.get("binding_state", "available") != "available":
            raise ValueError(f"invalid OpenHands child binding state: {name}")
        if "model" not in agent:
            raise ValueError(f"available OpenHands child lacks model: {name}")
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
    review_contract = ""
    if agent.get("review_posture") == "adversarial-evidence":
        review_contract = """
Review posture: adversarial evidence. Assume the delivery may be incomplete or
incorrect until disproven. Actively search for counterexamples, missing
acceptance criteria, unsupported claims, contradictory evidence, untested
failure paths, regressions, security risks, and operational hazards. Do not
accept a green test, a child status, or an implementation summary as proof of
correctness by itself. Classify each finding as confirmed, likely, or unproven;
cite the evidence and the smallest next proof. If you find no defect, describe
what you challenged and the remaining uncertainty instead of issuing a generic
approval.
"""
    return f"""You are the {name} bounded OpenHands subagent.

Mission: {description}

{boundary}
{review_contract}

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


def _quarantine_receipt(quarantine_dir: Path, entries: list[dict]) -> None:
    receipt = quarantine_dir / "receipt.json"
    if receipt.exists():
        raise ValueError(f"quarantine receipt already exists: {receipt}")
    targets = {str(Path(entry["original"]).parent) for entry in entries}
    if len(targets) != 1:
        raise ValueError("quarantine entries do not share a target directory")
    _write_atomic(
        receipt,
        json.dumps({"target_dir": targets.pop(), "entries": entries}, indent=2) + "\n",
    )


def _quarantine(path: Path, quarantine_dir: Path, entries: list[dict]) -> None:
    if quarantine_dir.is_symlink():
        raise ValueError(f"refusing symlinked quarantine directory: {quarantine_dir}")
    quarantine_dir.mkdir(parents=True, exist_ok=True)
    destination = quarantine_dir / path.name
    if destination.exists() or destination.is_symlink():
        raise ValueError(f"quarantine collision: {destination}")
    rendered = path.read_bytes()
    os.replace(path, destination)
    entries.append(
        {
            "original": str(path),
            "quarantined": str(destination),
            "sha256": hashlib.sha256(rendered).hexdigest(),
        }
    )


def rollback_quarantine(quarantine_dir: Path) -> int:
    receipt_path = quarantine_dir / "receipt.json"
    if quarantine_dir.is_symlink() or not receipt_path.is_file():
        raise ValueError(f"invalid quarantine receipt: {receipt_path}")
    receipt = json.loads(receipt_path.read_text(encoding="utf-8"))
    if not isinstance(receipt, dict) or set(receipt) != {"target_dir", "entries"}:
        raise ValueError("invalid quarantine receipt schema")
    target_dir = Path(receipt["target_dir"])
    if target_dir.is_symlink() or not target_dir.is_dir():
        raise ValueError(f"invalid rollback target directory: {target_dir}")
    entries = receipt.get("entries", [])
    if not isinstance(entries, list) or not entries:
        raise ValueError("invalid quarantine receipt entries")
    plan: list[tuple[Path, Path]] = []
    originals: set[Path] = set()
    quarantined_paths: set[Path] = set()
    for entry in entries:
        if not isinstance(entry, dict) or set(entry) != {"original", "quarantined", "sha256"}:
            raise ValueError("invalid quarantine receipt entry")
        if not all(isinstance(entry[key], str) for key in entry):
            raise ValueError("invalid quarantine receipt entry values")
        original = Path(entry["original"])
        quarantined = Path(entry["quarantined"])
        if original.parent != target_dir:
            raise ValueError(f"rollback target escape: {original}")
        if quarantined.parent != quarantine_dir:
            raise ValueError(f"quarantine path escape: {quarantined}")
        if original.name != quarantined.name:
            raise ValueError(f"quarantine ownership mismatch: {quarantined}")
        if original in originals or quarantined in quarantined_paths:
            raise ValueError("duplicate quarantine receipt path")
        originals.add(original)
        quarantined_paths.add(quarantined)
        if quarantined.is_symlink() or not quarantined.is_file():
            raise ValueError(f"missing quarantined agent: {quarantined}")
        if original.exists() or original.is_symlink():
            raise ValueError(f"rollback collision: {original}")
        if hashlib.sha256(quarantined.read_bytes()).hexdigest() != entry["sha256"]:
            raise ValueError(f"quarantine integrity mismatch: {quarantined}")
        plan.append((quarantined, original))

    # All validation precedes every move: a late bad receipt entry cannot leave
    # an earlier managed definition restored while the remainder is stranded.
    for quarantined, original in plan:
        os.replace(quarantined, original)
    receipt_path.unlink()
    quarantine_dir.rmdir()
    return len(plan)


def reconcile(
    target_dir: Path,
    expected: dict[str, dict],
    *,
    apply: bool,
    quarantine_dir: Path | None = None,
) -> int:
    _validate_target_dir(target_dir)
    if apply:
        target_dir.mkdir(parents=True, exist_ok=True)
    elif not target_dir.is_dir():
        return len(expected)

    drift = 0
    quarantined: list[dict] = []
    if apply and quarantine_dir is not None and quarantine_dir.exists():
        raise ValueError(f"quarantine collision: {quarantine_dir}")
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
            rendered = path.read_text(encoding="utf-8")
            if not (_is_managed(rendered) or _is_legacy_managed(rendered)):
                continue
            drift += 1
            if apply:
                if quarantine_dir is None:
                    raise ValueError("managed cleanup requires a quarantine directory")
                _quarantine(path, quarantine_dir, quarantined)

    if apply and quarantined:
        _quarantine_receipt(quarantine_dir, quarantined)

    return 0 if apply else drift


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--target-dir", type=Path, default=Path.home() / ".agents/agents"
    )
    parser.add_argument("--apply", action="store_true")
    parser.add_argument("--quarantine-dir", type=Path)
    parser.add_argument("--rollback-quarantine", type=Path)
    args = parser.parse_args()
    try:
        if args.rollback_quarantine:
            print(f"PASS: restored {rollback_quarantine(args.rollback_quarantine)} OpenHands subagent definition(s)")
            return 0
        expected = load_registry()
        quarantine_dir = args.quarantine_dir
        if args.apply and quarantine_dir is None:
            raise ValueError("--apply requires --quarantine-dir for recoverable cleanup")
        drift = reconcile(
            args.target_dir, expected, apply=args.apply, quarantine_dir=quarantine_dir
        )
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
