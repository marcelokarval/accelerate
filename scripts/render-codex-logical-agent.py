#!/usr/bin/env python3
"""Render one logical Codex agent as an additive native config profile."""

from __future__ import annotations

import argparse
import tomllib
from pathlib import Path


def skill_path(source: dict[str, object], group: dict[str, object], skill_id: str) -> str:
    parts = [str(source["base_path"])]
    if prefix := group.get("path_prefix"):
        parts.append(str(prefix))
    parts.extend([skill_id, "SKILL.md"])
    return "/".join(parts)


parser = argparse.ArgumentParser()
parser.add_argument("topology", type=Path)
parser.add_argument("catalog", type=Path)
parser.add_argument("--agent", required=True)
parser.add_argument("--output", type=Path, required=True)
args = parser.parse_args()

topology = tomllib.loads(args.topology.read_text())
catalog = tomllib.loads(args.catalog.read_text())
agent = next((item for item in topology["agents"] if item["name"] == args.agent), None)
if agent is None:
    parser.error(f"unknown logical agent: {args.agent}")
sources = {source["id"]: source for source in catalog["sources"]}
group = next((item for item in catalog["groups"] if item["id"] == agent["catalog_group"]), None)
if group is None:
    parser.error(f"unknown catalog group: {agent['catalog_group']}")
source = sources[group["source"]]

lines = [
    "# Generated from the governed logical-agent topology. Do not edit by hand.",
    f'# logical_agent = "{agent["name"]}"',
    'model = "' + agent["model"] + '"',
    'model_reasoning_effort = "' + agent["reasoning_effort"] + '"',
    "[skills]",
    "config = [",
]
lines.extend(f'  {{ path = "{skill_path(source, group, skill_id)}", enabled = true }},' for skill_id in group["skill_ids"])
lines.append("]")
args.output.write_text("\n".join(lines) + "\n")
