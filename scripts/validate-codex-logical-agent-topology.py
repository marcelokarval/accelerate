#!/usr/bin/env python3
"""Validate the explicit logical-agent topology for Codex collaboration."""

from __future__ import annotations

import json
import sys
import tomllib
from pathlib import Path
from typing import Any


REQUIRED_NAMES = {"orchestrator", "python-backend", "nextjs-frontend", "research", "reviewer", "qa", "data-db", "integrations-ops"}
EXPECTED_ROLE_FAMILIES = {
    "orchestrator": "root",
    "python-backend": "backend",
    "nextjs-frontend": "frontend",
    "research": "research",
    "reviewer": "governance",
    "qa": "qa-regression",
    "data-db": "data",
    "integrations-ops": "integrations-ops",
}
ROOT_EXCLUSIVE = {"issue topology", "external writes", "integration", "review-of-review", "closure"}
ROOT_SKILLS = {
    "accelerate", "plane", "prompt-hardening", "skill-catalog-router",
    "subagent-governance", "specification-lifecycle",
    "test-driven-development", "verification-before-completion",
}
TOPOLOGY_KEYS = {
    "schema_version", "topology_identity", "authority", "spawn_packet_limit",
    "root_exclusive_authority", "omo_slim_reference", "omo_slim_provenance",
    "omo_slim_builtin_roles", "agents",
}
OMO_SLIM_ROLES = ("orchestrator", "oracle", "librarian", "explorer", "designer", "fixer", "observer", "council")
OMO_SLIM_ROLE_SET = set(OMO_SLIM_ROLES)
OMO_SLIM_MAPPING = {
    "orchestrator": ("orchestrator", ["council"], "adapted-absorbed"),
    "python-backend": ("fixer", [], "adapted-specialized"),
    "nextjs-frontend": ("fixer", ["designer"], "adapted-partial"),
    "research": ("librarian", ["explorer"], "adapted-composite"),
    "reviewer": ("oracle", ["council"], "adapted-composite"),
    "qa": ("observer", ["oracle"], "adapted-partial"),
    "data-db": ("fixer", [], "adapted-specialized"),
    "integrations-ops": ("fixer", [], "adapted-specialized"),
}
OMO_KEYS = {"omo_slim_primary_role", "omo_slim_secondary_roles", "omo_slim_equivalence", "omo_slim_adaptation"}
SPECIALIST_KEYS = {"name", "kind", "role_family", "catalog_group", "collaboration_profile", "model", "reasoning_effort", "write_mode", "external_writes", "closure_authority", "required_skills"} | OMO_KEYS
ROOT_KEYS = SPECIALIST_KEYS - {"collaboration_profile"}


def fail(message: str) -> None:
    raise ValueError(message)


def contains_wildcard(value: Any) -> bool:
    if isinstance(value, str):
        return "*" in value
    if isinstance(value, list):
        return any(contains_wildcard(item) for item in value)
    if isinstance(value, dict):
        return any(contains_wildcard(item) for item in value.values())
    return False


def main() -> int:
    if len(sys.argv) != 4:
        print("usage: validate-codex-logical-agent-topology.py TOPOLOGY CATALOG POLICY", file=sys.stderr)
        return 2
    try:
        topology = tomllib.loads(Path(sys.argv[1]).read_text())
        catalog = tomllib.loads(Path(sys.argv[2]).read_text())
        policy = json.loads(Path(sys.argv[3]).read_text())
        if set(topology) != TOPOLOGY_KEYS:
            fail("topology has invalid fields")
        if topology.get("schema_version") != 2 or topology.get("topology_identity") != "codex-logical-agent-topology":
            fail("invalid topology identity")
        if topology.get("omo_slim_reference") != "https://github.com/alvinunreal/oh-my-opencode-slim":
            fail("invalid OMO-Slim provenance source")
        if topology.get("omo_slim_provenance") != "adapted-influence-not-runtime-authority":
            fail("OMO-Slim provenance must not become runtime authority")
        if topology.get("omo_slim_builtin_roles") != list(OMO_SLIM_ROLES):
            fail("OMO-Slim built-in role denominator is incomplete")
        packet_limit = topology.get("spawn_packet_limit")
        if type(packet_limit) is not int or not 8 <= packet_limit <= 20:
            fail("spawn_packet_limit must be an integer between 8 and 20")
        if set(topology.get("root_exclusive_authority", [])) != ROOT_EXCLUSIVE:
            fail("root_exclusive_authority is incomplete")
        if contains_wildcard(topology):
            fail("topology contains wildcard")
        groups = {group.get("id"): group for group in catalog.get("groups", []) if isinstance(group, dict)}
        profiles = policy.get("profiles", {})
        bindings = policy.get("role_bindings", {})
        agents = topology.get("agents")
        if not isinstance(agents, list) or len(agents) != len(REQUIRED_NAMES):
            fail("topology must declare exactly the required logical agents")
        names = {agent.get("name") for agent in agents if isinstance(agent, dict)}
        if names != REQUIRED_NAMES:
            fail("logical agent names are missing or duplicated")
        roots = []
        for agent in agents:
            if not isinstance(agent, dict):
                fail("agent must be an object")
            is_root = agent.get("kind") == "root-orchestrator"
            expected = ROOT_KEYS if is_root else SPECIALIST_KEYS
            if set(agent) != expected:
                fail(f"agent {agent.get('name')} has invalid fields")
            if agent.get("catalog_group") not in groups:
                fail(f"agent {agent.get('name')} references unknown catalog group")
            if agent.get("role_family") != EXPECTED_ROLE_FAMILIES.get(agent.get("name")):
                fail(f"agent {agent.get('name')} has an invalid normalized role family")
            expected_omo = OMO_SLIM_MAPPING.get(agent.get("name"))
            actual_omo = (
                agent.get("omo_slim_primary_role"),
                agent.get("omo_slim_secondary_roles"),
                agent.get("omo_slim_equivalence"),
            )
            if actual_omo != expected_omo:
                fail(f"agent {agent.get('name')} has an invalid OMO-Slim mapping")
            primary = agent.get("omo_slim_primary_role")
            secondary = agent.get("omo_slim_secondary_roles")
            if (
                primary not in OMO_SLIM_ROLE_SET
                or not isinstance(secondary, list)
                or len(secondary) != len(set(secondary))
                or primary in secondary
                or not set(secondary) <= OMO_SLIM_ROLE_SET
            ):
                fail(f"agent {agent.get('name')} has invalid OMO-Slim roles")
            adaptation = agent.get("omo_slim_adaptation")
            if not isinstance(adaptation, str) or "\n" in adaptation or len(adaptation.split()) < 5:
                fail(f"agent {agent.get('name')} lacks a substantive OMO-Slim adaptation")
            skills = agent.get("required_skills")
            active_core = set(groups["root-core"].get("skill_ids", []))
            eligible_skills = set(groups[agent["catalog_group"]].get("skill_ids", []))
            if not is_root:
                eligible_skills |= active_core
            if not isinstance(skills, list) or not skills or not set(skills) <= eligible_skills:
                fail(f"agent {agent.get('name')} has skills outside its catalog and root core")
            if is_root:
                roots.append(agent)
                if agent.get("name") != "orchestrator" or agent.get("role_family") != "root":
                    fail("orchestrator root identity is invalid")
                if agent.get("model") != "gpt-5.6-sol" or agent.get("reasoning_effort") != "medium":
                    fail("orchestrator must be Sol/medium")
                if agent.get("write_mode") != "root-only" or agent.get("external_writes") is not True or agent.get("closure_authority") is not True:
                    fail("orchestrator authority is invalid")
                if set(skills) != ROOT_SKILLS:
                    fail("orchestrator skills must equal the compact root contract")
                continue
            if agent.get("external_writes") is not False or agent.get("closure_authority") is not False:
                fail(f"specialist {agent.get('name')} exceeds root authority")
            profile_name = agent.get("collaboration_profile")
            profile = profiles.get(profile_name)
            if not isinstance(profile, dict):
                fail(f"agent {agent.get('name')} references unknown collaboration profile")
            if agent.get("model") != profile.get("model") or agent.get("reasoning_effort") != profile.get("reasoning_effort"):
                fail(f"agent {agent.get('name')} must match its collaboration profile model and effort")
            if agent.get("write_mode") != profile.get("write_mode"):
                fail(f"agent {agent.get('name')} must match its collaboration profile write mode")
            if profile_name not in bindings.get(agent.get("role_family"), []):
                fail(f"agent {agent.get('name')} is not bound to its role family")
        if len(roots) != 1:
            fail("exactly one root orchestrator is required")
    except (OSError, tomllib.TOMLDecodeError, json.JSONDecodeError, ValueError) as error:
        print(f"codex logical agent topology invalid: {error}", file=sys.stderr)
        return 1
    print("codex logical agent topology passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
