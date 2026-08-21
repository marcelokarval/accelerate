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
parser.add_argument("--fork-turns", default="none")
parser.add_argument("--nested-luna-child", action="store_true")
parser.add_argument("--parent-task-id")
parser.add_argument("--parent-reference")
parser.add_argument("--parent-write-scope")
parser.add_argument("--root-authorization")
parser.add_argument("--global-physical-budget", type=int)
parser.add_argument("--terra-accountability")
args = parser.parse_args()

topology = tomllib.loads(args.topology.read_text())
agent = next((item for item in topology["agents"] if item["name"] == args.agent), None)
if agent is None or agent["kind"] != "specialist":
    parser.error("--agent must name a specialist logical agent")
if agent["write_mode"] == "read-only" and args.write_scope != "read-only":
    parser.error(f"{args.agent} is read-only")
fork_turns = args.fork_turns
if fork_turns not in {"none", "1", "2", "3", "4", "5"}:
    parser.error("--fork-turns must be none or an integer from 1 to 5; all is forbidden with an override")


def scopes_overlap(left: str, right: str) -> bool:
    return left == right or left.startswith(right.rstrip("/") + "/") or right.startswith(left.rstrip("/") + "/")


if args.nested_luna_child:
    required = {
        "--parent-task-id": args.parent_task_id,
        "--parent-reference": args.parent_reference,
        "--parent-write-scope": args.parent_write_scope,
        "--root-authorization": args.root_authorization,
        "--global-physical-budget": args.global_physical_budget,
        "--terra-accountability": args.terra_accountability,
    }
    missing = [flag for flag, value in required.items() if value in (None, "")]
    if missing:
        parser.error(f"--nested-luna-child requires {', '.join(missing)}")
    if agent["model"] != "gpt-5.6-terra" or agent["reasoning_effort"] != "medium":
        parser.error("--nested-luna-child requires a Terra/medium parent")
    if fork_turns != "none":
        parser.error("a nested Luna child must use fork_turns = none")
    if args.root_authorization != "root-authorized-only":
        parser.error("nested Luna requires root-authorized-only authorization")
    if args.terra_accountability != "required":
        parser.error("nested Luna requires Terra accountability = required")
    if args.global_physical_budget != 3:
        parser.error("nested Luna global physical budget must be exactly 3: Terra parent, Luna child, and independent reviewer")
    if scopes_overlap(args.parent_write_scope, args.write_scope):
        parser.error("nested Luna child write scope must be disjoint from the Terra parent")

print("Spawn Packet")
print(f"- Task: {args.task_id}; objective: {args.objective}")
if args.nested_luna_child:
    print(f"- Child supplement under Terra parent {agent['name']}: luna-mechanical (mechanical-fixer; gpt-5.6-luna/medium).")
    print(f"- Parent: {agent['name']}; task {args.parent_task_id}; reference {args.parent_reference}; Terra accountability required.")
else:
    print(f"- Agent: {agent['name']} ({agent['role_family']}; {agent['model']}/{agent['reasoning_effort']})")
    print(f"- Profile: {agent['catalog_group']}; skills: {', '.join(agent['required_skills'])}")
print(f"- Context: {args.context}")
print(f"- Scope: {args.scope}")
print(f"- Write scope: {args.write_scope}; no writes outside it.")
print(f"- Proof: {args.evidence}")
binding = "- Physical binding: model override gpt-5.6-luna/medium; fork_turns = none" if args.nested_luna_child else f"- Physical binding: model override {agent['model']}/{agent['reasoning_effort']}; fork_turns = {fork_turns}"
if not args.nested_luna_child and agent["model"] == "gpt-5.6-luna":
    binding += "; Luna is a leaf"
print(binding + ".")
if args.nested_luna_child:
    print("- Nested exception: root-authorized-only; global physical budget = 3 (Terra parent, Luna child, independent reviewer); scopes disjoint; Luna is a leaf.")
    print("- Root only: issue topology, external writes, integration, review-of-review, closure; child returns only evidence, risks, and recommendation.")
else:
    print("- Root only: issue topology, external writes, integration, review-of-review, closure.")
    print("- No nested spawn; return only evidence, risks, and recommendation.")
