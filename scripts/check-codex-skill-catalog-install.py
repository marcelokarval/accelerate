#!/usr/bin/env python3
"""Verify exact managed global skill overrides and every catalog profile."""

from __future__ import annotations

import argparse
import subprocess
import tempfile
import tomllib
from pathlib import Path
from typing import Any


def managed_catalog_states(catalog: dict[str, Any]) -> dict[str, bool]:
    sources = {str(source["id"]): source for source in catalog["sources"]}
    states: dict[str, bool] = {}
    for group in catalog["groups"]:
        if group["classification"] == "host-injected":
            continue
        source = sources[str(group["source"])]
        parts = [str(source["base_path"])]
        if group.get("path_prefix"):
            parts.append(str(group["path_prefix"]))
        for skill_id in group["skill_ids"]:
            path = "/".join([*parts, str(skill_id), "SKILL.md"])
            if path in states:
                raise SystemExit(f"catalog has duplicate managed path: {path}")
            states[path] = bool(group["enabled_by_default"])
    return states


parser = argparse.ArgumentParser()
parser.add_argument("catalog", type=Path)
parser.add_argument("--codex-home", type=Path, required=True)
parser.add_argument("--logical-topology", type=Path)
args = parser.parse_args()

catalog_path = args.catalog.resolve()
home = args.codex_home.resolve()
base_config = home / "config.toml"
if not base_config.is_file():
    raise SystemExit(f"global Codex config is missing: {base_config}")
base = tomllib.loads(base_config.read_text())
catalog = tomllib.loads(catalog_path.read_text())
managed = managed_catalog_states(catalog)
actual: dict[str, bool] = {}
for entry in base.get("skills", {}).get("config", []):
    if not isinstance(entry, dict) or not isinstance(entry.get("path"), str):
        raise SystemExit("every skills.config entry must be a path-bearing table")
    path = entry["path"]
    if path not in managed:
        continue
    if set(entry) != {"path", "enabled"} or type(entry.get("enabled")) is not bool:
        raise SystemExit(f"managed skill override has an invalid shape: {path}")
    if path in actual:
        raise SystemExit(f"managed skill override is duplicated: {path}")
    actual[path] = entry["enabled"]
expected = {path: False for path, enabled in managed.items() if not enabled}
if actual != expected:
    missing = sorted(set(expected) - set(actual))
    extra = sorted(set(actual) - set(expected))
    wrong = sorted(path for path in set(actual) & set(expected) if actual[path] != expected[path])
    raise SystemExit(f"global managed skill overrides are stale: missing={missing}, extra={extra}, wrong={wrong}")

renderer = Path(__file__).with_name("render-codex-skill-profile.py")
profiles = [
    str(group["profile"])
    for group in catalog["groups"]
    if group.get("profile") and group.get("public_profile") is True
]
hidden_profiles = {
    str(group["profile"])
    for group in catalog["groups"]
    if group.get("profile") and group.get("public_profile") is False
}
logical_profiles: set[str] = set()
if args.logical_topology:
    topology = tomllib.loads(args.logical_topology.read_text())
    logical_profiles = {
        str(agent["name"])
        for agent in topology.get("agents", [])
        if isinstance(agent, dict) and agent.get("kind") == "specialist"
    }
for hidden in sorted(hidden_profiles - logical_profiles):
    target = home / f"{hidden}.config.toml"
    if target.exists():
        raise SystemExit(f"hidden raw catalog profile is still installed: {target}")
with tempfile.TemporaryDirectory(prefix="codex-skill-catalog-check-") as temporary:
    stage = Path(temporary)
    for profile in profiles:
        expected_profile = stage / f"{profile}.config.toml"
        target = home / expected_profile.name
        if not target.is_file():
            raise SystemExit(f"catalog profile is not installed: {target}")
        subprocess.run(
            ["python3", str(renderer), str(catalog_path), "--mode", "profile", "--profile", profile, "--output", str(expected_profile)],
            check=True,
        )
        if target.read_bytes() != expected_profile.read_bytes():
            raise SystemExit(f"catalog profile is stale or manually edited: {target}")
print(base_config)
