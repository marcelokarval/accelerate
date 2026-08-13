#!/usr/bin/env python3
"""Fail closed when an installed logical profile is missing or stale."""

from __future__ import annotations

import argparse
import subprocess
import tempfile
import tomllib
from pathlib import Path


parser = argparse.ArgumentParser()
parser.add_argument("topology", type=Path)
parser.add_argument("catalog", type=Path)
parser.add_argument("--codex-home", type=Path, required=True)
parser.add_argument("--agent", required=True)
args = parser.parse_args()


def run_checked(command: list[str], label: str) -> None:
    """Run a governed helper without leaking a Python traceback on rejection."""
    try:
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as error:
        raise SystemExit(f"{label} failed with exit {error.returncode}") from None


def managed_catalog_states(catalog: dict[str, object]) -> dict[str, bool]:
    sources = {str(source["id"]): source for source in catalog["sources"]}
    states: dict[str, bool] = {}
    for group in catalog["groups"]:
        if group["classification"] == "host-injected":
            continue
        source = sources[str(group["source"])]
        prefix = [str(source["base_path"])]
        if group.get("path_prefix"):
            prefix.append(str(group["path_prefix"]))
        for skill_id in group["skill_ids"]:
            path = "/".join([*prefix, str(skill_id), "SKILL.md"])
            if path in states:
                raise SystemExit(f"catalog has duplicate managed path: {path}")
            states[path] = bool(group["enabled_by_default"])
    return states


def effective_states(base_document: dict[str, object], managed_paths: set[str]) -> dict[str, bool]:
    states: dict[str, bool] = {}
    for entry in base_document.get("skills", {}).get("config", []):
        if not isinstance(entry, dict) or "path" not in entry or "enabled" not in entry:
            continue
        path = str(entry["path"])
        if path not in managed_paths:
            continue
        enabled = bool(entry["enabled"])
        if path in states and states[path] != enabled:
            raise SystemExit(f"global catalog has conflicting entries: {path}")
        states[path] = enabled
    return states


def require_orchestrator_default(base_document: dict[str, object], home: Path, orchestrator: dict[str, object]) -> None:
    if base_document.get("model") != orchestrator["model"]:
        raise SystemExit("default Codex model does not match the orchestrator")
    if base_document.get("model_reasoning_effort") != orchestrator["reasoning_effort"]:
        raise SystemExit("default Codex reasoning effort does not match the orchestrator")
    profile = home / "orchestrator.config.toml"
    if profile.exists():
        raise SystemExit(f"orchestrator must not be an additive profile: {profile}")


topology = tomllib.loads(args.topology.read_text())
validator = Path(__file__).with_name("validate-codex-logical-agent-topology.py")
source_root = Path(__file__).resolve().parents[1]
policy = source_root / "adapters/runtime/codex-collaboration/role-policy.json"
run_checked(
    ["python3", str(validator), str(args.topology), str(args.catalog), str(policy)],
    "logical agent topology validation",
)
if args.agent not in {str(agent["name"]) for agent in topology["agents"]}:
    parser.error(f"unknown logical agent: {args.agent}")
agent = next(agent for agent in topology["agents"] if agent["name"] == args.agent)
target = args.codex_home / f"{args.agent}.config.toml"
if agent["kind"] == "specialist":
    if not target.is_file():
        raise SystemExit(f"logical profile is not installed: {target}")
    tomllib.loads(target.read_text())
renderer = Path(__file__).with_name("render-codex-logical-agent.py")
catalog_renderer = Path(__file__).with_name("render-codex-skill-profile.py")
catalog_checker = Path(__file__).with_name("check-codex-skill-catalog-install.py")
base_config = args.codex_home / "config.toml"
if not base_config.is_file():
    raise SystemExit(f"global catalog base is not installed: {base_config}")
base_document = tomllib.loads(base_config.read_text())
run_checked(
    [
        "python3", str(catalog_checker), str(args.catalog),
        "--codex-home", str(args.codex_home),
        "--logical-topology", str(args.topology),
    ],
    "Codex skill catalog install check",
)
with tempfile.TemporaryDirectory(prefix="codex-logical-agent-check-") as temporary:
    expected = Path(temporary) / target.name
    expected_base = Path(temporary) / "config.toml"
    run_checked(
        ["python3", str(catalog_renderer), str(args.catalog), "--mode", "global", "--output", str(expected_base)],
        "Codex skill catalog render",
    )
    catalog = tomllib.loads(args.catalog.read_text())
    expected_states = managed_catalog_states(catalog)
    actual_states = effective_states(base_document, set(expected_states))
    if any(actual_states.get(path, True) != expected for path, expected in expected_states.items()):
        raise SystemExit(f"global catalog base is stale or incomplete: {base_config}")
    orchestrator = next(agent for agent in topology["agents"] if agent["kind"] == "root-orchestrator")
    require_orchestrator_default(base_document, args.codex_home, orchestrator)
    if agent["kind"] == "root-orchestrator":
        print(base_config)
        raise SystemExit(0)
    run_checked(
        ["python3", str(renderer), str(args.topology), str(args.catalog), "--agent", args.agent, "--output", str(expected)],
        "logical agent render",
    )
    if target.read_bytes() != expected.read_bytes():
        raise SystemExit(f"logical profile is stale or manually edited: {target}")
print(target)
