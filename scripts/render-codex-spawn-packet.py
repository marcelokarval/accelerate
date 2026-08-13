#!/usr/bin/env python3
"""Render one fail-closed Codex collaboration assignment packet."""

from __future__ import annotations

import argparse
import hashlib
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
ROUTE_INDEX = ROOT / "skills/governance/skill-catalog-router/references/index.tsv"


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


def resolve_skill_routes(
    skill_ids: list[str],
    catalog: dict[str, Any],
    parser: argparse.ArgumentParser,
) -> list[tuple[str, Path, str]]:
    indexed: dict[str, tuple[Path, str]] = {}
    try:
        for line_number, line in enumerate(ROUTE_INDEX.read_text(encoding="utf-8").splitlines(), 1):
            fields = line.split("\t")
            if len(fields) != 5:
                parser.error(f"malformed repo-owned skill route at index line {line_number}")
            skill_id, _source_path, runtime_path, digest, _description = fields
            if skill_id in indexed:
                parser.error(f"duplicate repo-owned skill route: {skill_id}")
            if len(digest) != 64 or any(character not in "0123456789abcdef" for character in digest):
                parser.error(f"invalid repo-owned skill digest: {skill_id}")
            indexed[skill_id] = (Path(runtime_path), digest)
    except (OSError, UnicodeError) as error:
        parser.error(f"repo-owned skill route index is unavailable: {error}")
    sources = {
        str(source.get("id")): source
        for source in catalog.get("sources", [])
        if isinstance(source, dict)
    }
    routes: dict[str, tuple[Path, str]] = {}
    for group in catalog.get("groups", []):
        if not isinstance(group, dict):
            continue
        source = sources.get(str(group.get("source")))
        if source is None:
            parser.error(f"skill group {group.get('id')} has an unknown source")
        base = Path(str(source.get("base_path", "")))
        if not base.is_absolute():
            parser.error(f"skill source {group.get('source')} is not absolute")
        prefix = str(group.get("path_prefix", "")).strip()
        for raw_skill_id in group.get("skill_ids", []):
            skill_id = f"{group.get('identifier_prefix', '')}{raw_skill_id}"
            candidate = base / prefix / str(raw_skill_id) / "SKILL.md" if prefix else base / str(raw_skill_id) / "SKILL.md"
            if skill_id in routes:
                parser.error(f"skill route is duplicated: {skill_id}")
            if skill_id not in skill_ids:
                routes[skill_id] = (candidate, "")
                continue
            try:
                resolved_base = base.resolve(strict=True)
                resolved = candidate.resolve(strict=True)
                resolved.relative_to(resolved_base)
            except (FileNotFoundError, OSError, ValueError):
                parser.error(f"skill route is missing or escapes its source: {skill_id} -> {candidate}")
            if resolved != candidate or not resolved.is_file():
                parser.error(f"skill route must be a regular non-symlink file: {skill_id} -> {candidate}")
            digest = hashlib.sha256(resolved.read_bytes()).hexdigest()
            if source.get("classification") == "managed-global":
                expected = indexed.get(skill_id)
                if expected is None:
                    parser.error(f"managed skill route is absent from the repo-owned index: {skill_id}")
                expected_path, expected_digest = expected
                if candidate != expected_path or digest != expected_digest:
                    parser.error(f"managed skill route is stale or mismatched: {skill_id} -> {candidate}")
            routes[skill_id] = (resolved, digest)
    missing = [skill_id for skill_id in skill_ids if skill_id not in routes]
    if missing:
        parser.error(f"assignment skills have no catalog route: {', '.join(missing)}")
    return [(skill_id, *routes[skill_id]) for skill_id in skill_ids]


def rendered_skill_routes(routes: list[tuple[str, Path, str]]) -> str:
    if not routes:
        return "none"
    return " ".join(
        f"skill={skill_id}; path={path}; sha256={digest};"
        for skill_id, path, digest in routes
    )


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
    catalog = load_toml(args.catalog, parser)
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
    skill_routes = resolve_skill_routes(assignment_skills, catalog, parser)
    logical_description = (
        f"{logical_agent['name']}/{logical_agent['catalog_group']}"
        if logical_agent
        else "none"
    )
    receipt = args.reasoning_receipt or "not-required"

    packet = [
        "Spawn Packet",
        f"- Task: {args.task_id}; objective: {args.objective}",
        f"- Route={args.route}; role={role_family}; profile={profile_name}; model={profile['model']}; effort={profile['reasoning_effort']}",
        f"- Assignment contracts: logical skill profile={logical_description} (routing metadata only; not injected into native spawn); skills={joined(assignment_skills)}; tools={joined(profile.get('tool_policy', []))}; MCPs={joined(profile.get('mcp_allowlist', []))}; enforcement=assignment-contract-only; routes={rendered_skill_routes(skill_routes)}",
        f"- Context={args.context}; scope={args.scope}; write scope={args.write_scope}; no writes outside it; proof={args.evidence}; validation owner={args.validation_owner}; reasoning receipt={receipt}.",
        f"- Return={profile['return_contract']}; required fields={joined(profile['return_fields'])}.",
        "- Root only: issue topology, external writes, integration, review-of-review, closure.",
        "- Lifecycle: reuse relevant context; no duplicate active lane; interruption is not rollback; reconcile partial shared changes before replacement; no nested spawn.",
    ]
    limit = topology["spawn_packet_limit"]
    if len(packet) > limit:
        parser.error(f"complete Spawn Packet requires {len(packet)} lines but limit is {limit}")
    print("\n".join(packet))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
