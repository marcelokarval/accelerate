#!/usr/bin/env python3
"""Render one fail-closed Codex collaboration assignment packet."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
import tomllib
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_CATALOG = ROOT / "adapters/runtime/codex/skill-catalog-manifest.toml"
DEFAULT_POLICY = ROOT / "adapters/runtime/codex-collaboration/role-policy.json"
POLICY_VALIDATOR = ROOT / "scripts/validate-codex-collaboration-policy.py"
TOPOLOGY_VALIDATOR = ROOT / "scripts/validate-codex-logical-agent-topology.py"
RECEIPT_VALIDATOR = ROOT / "global-runtime/accelerate/scripts/validate_reasoning_receipt.py"


def load_toml(path: Path, parser: argparse.ArgumentParser) -> dict[str, Any]:
    try:
        return tomllib.loads(path.read_text(encoding="utf-8"))
    except (OSError, tomllib.TOMLDecodeError) as error:
        parser.error(f"invalid topology: {error}")


def load_json(path: Path, parser: argparse.ArgumentParser, label: str) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        parser.error(f"invalid {label}: {error}")
    if not isinstance(value, dict):
        parser.error(f"invalid {label}: root must be an object")
    return value


def joined(values: list[str]) -> str:
    return ", ".join(values) if values else "none"


def unique(values: list[str]) -> list[str]:
    return list(dict.fromkeys(values))


def require_single_line(
    parser: argparse.ArgumentParser,
    label: str,
    value: str | None,
) -> None:
    if value is not None and (not value.strip() or "\n" in value or "\r" in value):
        parser.error(f"{label} must be a non-empty single-line value")


def validate_reasoning_receipt(
    receipt_arg: str,
    route: str,
    parser: argparse.ArgumentParser,
) -> None:
    receipt_path = Path(receipt_arg).expanduser()
    expected_mode = "single" if route == "scoped" else "parallel"
    result = subprocess.run(
        [
            sys.executable,
            str(RECEIPT_VALIDATOR),
            str(receipt_path),
            "--expected-mode",
            expected_mode,
            "--expected-kind",
            "final-decision",
        ],
        cwd=Path.cwd(),
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        detail = " ".join((result.stdout + result.stderr).split())
        parser.error(f"invalid reasoning receipt: {detail}")
    receipt = load_json(receipt_path, parser, "reasoning receipt")
    if receipt.get("selected_effort") != "high":
        parser.error("reasoning receipt must select high effort")


def validate_collaboration_policy(
    policy_path: Path,
    parser: argparse.ArgumentParser,
) -> None:
    result = subprocess.run(
        [sys.executable, str(POLICY_VALIDATOR), str(policy_path)],
        cwd=Path.cwd(),
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        detail = " ".join((result.stdout + result.stderr).split())
        parser.error(f"collaboration policy is invalid: {detail}")


def validate_logical_topology(
    topology_path: Path,
    catalog_path: Path,
    policy_path: Path,
    parser: argparse.ArgumentParser,
) -> None:
    result = subprocess.run(
        [
            sys.executable,
            str(TOPOLOGY_VALIDATOR),
            str(topology_path),
            str(catalog_path),
            str(policy_path),
        ],
        cwd=Path.cwd(),
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        detail = " ".join((result.stdout + result.stderr).split())
        parser.error(f"logical topology is invalid: {detail}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("topology", type=Path)
    parser.add_argument("--catalog", type=Path, default=DEFAULT_CATALOG)
    parser.add_argument("--policy", type=Path, default=DEFAULT_POLICY)
    parser.add_argument("--route", required=True, choices=["direct-fast-path", "scoped", "orchestrated"])
    parser.add_argument("--agent")
    parser.add_argument("--role-family")
    parser.add_argument("--profile")
    parser.add_argument("--task-id", required=True)
    parser.add_argument("--objective", required=True)
    parser.add_argument("--scope", required=True)
    parser.add_argument("--write-scope", required=True)
    parser.add_argument("--evidence", required=True)
    parser.add_argument("--validation-owner", required=True)
    parser.add_argument("--context", required=True)
    parser.add_argument("--reasoning-receipt")
    args = parser.parse_args()

    for label, value in (
        ("logical agent", args.agent),
        ("role family", args.role_family),
        ("collaboration profile", args.profile),
        ("task id", args.task_id),
        ("objective", args.objective),
        ("scope", args.scope),
        ("write scope", args.write_scope),
        ("evidence", args.evidence),
        ("validation owner", args.validation_owner),
        ("context", args.context),
        ("reasoning receipt", args.reasoning_receipt),
    ):
        require_single_line(parser, label, value)
    if "*" in args.scope:
        parser.error("scope cannot contain a wildcard")
    if "*" in args.write_scope:
        parser.error("write scope cannot contain a wildcard")

    validate_collaboration_policy(args.policy, parser)
    validate_logical_topology(args.topology, args.catalog, args.policy, parser)
    topology = load_toml(args.topology, parser)
    policy = load_json(args.policy, parser, "collaboration policy")
    routes = policy.get("routes", {})
    route = routes.get(args.route)
    if not isinstance(route, dict):
        parser.error(f"unknown policy route {args.route}")
    if args.route == "direct-fast-path" or route.get("physical_binding_allowed") is not True:
        parser.error("direct-fast-path cannot bind a subagent")

    agents = topology.get("agents", [])
    logical_agent = None
    if args.agent:
        logical_agent = next(
            (
                item
                for item in agents
                if isinstance(item, dict)
                and item.get("name") == args.agent
                and item.get("kind") == "specialist"
            ),
            None,
        )
        if logical_agent is None:
            parser.error("--agent must name a specialist logical agent")
        logical_role = logical_agent["role_family"]
        if args.role_family and args.role_family != logical_role:
            parser.error(f"logical agent {args.agent} belongs to {logical_role}, not {args.role_family}")
        role_family = logical_role
        logical_profile = logical_agent["collaboration_profile"]
        if args.profile and args.profile != logical_profile:
            parser.error(f"logical agent {args.agent} requires profile {logical_profile}, not {args.profile}")
        profile_name = logical_profile
    else:
        if not args.role_family or not args.profile:
            parser.error("provide --agent or both --role-family and --profile")
        role_family = args.role_family
        profile_name = args.profile

    profiles = policy.get("profiles", {})
    profile = profiles.get(profile_name)
    if not isinstance(profile, dict):
        parser.error(f"unknown collaboration profile {profile_name}")
    bindings = policy.get("role_bindings", {})
    if profile_name not in bindings.get(role_family, []):
        parser.error(f"profile {profile_name} is not bound to role {role_family}")

    if logical_agent:
        for field in ("model", "reasoning_effort", "write_mode"):
            if logical_agent.get(field) != profile.get(field):
                parser.error(f"logical agent {args.agent} does not match profile {profile_name} {field}")

    write_mode = profile.get("write_mode")
    if write_mode == "read-only" and args.write_scope != "read-only":
        parser.error(f"profile {profile_name} is read-only")
    if write_mode == "bounded-write" and args.write_scope == "read-only":
        parser.error(f"writer profile {profile_name} requires a bounded write scope")

    if profile.get("requires_reasoning_receipt") is True:
        if not args.reasoning_receipt:
            parser.error(f"profile {profile_name} requires --reasoning-receipt")
        validate_reasoning_receipt(args.reasoning_receipt, args.route, parser)

    logical_skills = logical_agent.get("required_skills", []) if logical_agent else []
    assignment_skills = unique([*logical_skills, *profile.get("skill_allowlist", [])])
    logical_description = (
        f"{logical_agent['name']}/{logical_agent['catalog_group']}"
        if logical_agent
        else "none"
    )
    receipt = args.reasoning_receipt or "not-required"

    print("Spawn Packet")
    print(f"- Task: {args.task_id}; objective: {args.objective}")
    print(f"- Route={args.route}; role={role_family}; profile={profile_name}; model={profile['model']}; effort={profile['reasoning_effort']}")
    print(f"- Logical skill profile={logical_description} (routing metadata only; not injected into native spawn).")
    print(f"- Assignment contracts: skills={joined(assignment_skills)}; tools={joined(profile.get('tool_policy', []))}; MCPs={joined(profile.get('mcp_allowlist', []))}; enforcement=assignment-contract-only.")
    print(f"- Context={args.context}; scope={args.scope}; write scope={args.write_scope}; no writes outside it.")
    print(f"- Proof={args.evidence}; validation owner={args.validation_owner}; reasoning receipt={receipt}.")
    print(f"- Return={profile['return_contract']}; required fields={joined(profile['return_fields'])}.")
    print("- Root only: issue topology, external writes, integration, review-of-review, closure.")
    print("- Lifecycle: reuse relevant context; no duplicate active lane; interruption is not rollback; reconcile partial shared changes before replacement; no nested spawn.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
