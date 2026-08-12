#!/usr/bin/env python3
"""Validate the explicit logical-agent topology for Codex collaboration."""

from __future__ import annotations

import json
import sys
import tomllib
from pathlib import Path
from typing import Any


REQUIRED_NAMES = {"orchestrator", "python-backend", "nextjs-frontend", "research", "reviewer", "qa"}
ROOT_EXCLUSIVE = {"issue topology", "external writes", "integration", "review-of-review", "closure"}
ROOT_SKILLS = {"accelerate", "prompt-hardening", "plane", "subagent-governance", "skill-catalog-router", "verification-before-completion"}
SPECIALIST_KEYS = {"name", "kind", "role_family", "catalog_group", "collaboration_profile", "model", "reasoning_effort", "write_mode", "external_writes", "closure_authority", "required_skills"}
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
        if topology.get("schema_version") != 1 or topology.get("topology_identity") != "codex-logical-agent-topology":
            fail("invalid topology identity")
        if topology.get("spawn_packet_limit") != 10:
            fail("spawn_packet_limit must be 10")
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
                if not ROOT_SKILLS <= set(skills):
                    fail("orchestrator is missing mandatory root skills")
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
