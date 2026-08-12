#!/usr/bin/env python3
"""Render the lean, bounded handoff used for a Codex collaboration spawn."""

from __future__ import annotations

import argparse
import tomllib
from pathlib import Path


parser = argparse.ArgumentParser()
parser.add_argument("topology", type=Path)
parser.add_argument("--agent", required=True)
parser.add_argument("--task-id", required=True)
parser.add_argument("--objective", required=True)
parser.add_argument("--scope", required=True)
parser.add_argument("--write-scope", required=True)
parser.add_argument("--evidence", required=True)
parser.add_argument("--context", required=True)
args = parser.parse_args()

topology = tomllib.loads(args.topology.read_text())
agent = next((item for item in topology["agents"] if item["name"] == args.agent), None)
if agent is None or agent["kind"] != "specialist":
    parser.error("--agent must name a specialist logical agent")
if agent["write_mode"] == "read-only" and args.write_scope != "read-only":
    parser.error(f"{args.agent} is read-only")

print("Spawn Packet")
print(f"- Task: {args.task_id}; objective: {args.objective}")
print(f"- Agent: {agent['name']} ({agent['role_family']}; {agent['model']}/{agent['reasoning_effort']})")
print(f"- Profile: {agent['catalog_group']}; skills: {', '.join(agent['required_skills'])}")
print(f"- Context: {args.context}")
print(f"- Scope: {args.scope}")
print(f"- Write scope: {args.write_scope}; no writes outside it.")
print(f"- Proof: {args.evidence}")
print("- Root only: issue topology, external writes, integration, review-of-review, closure.")
print("- No nested spawn; return only evidence, risks, and recommendation.")
