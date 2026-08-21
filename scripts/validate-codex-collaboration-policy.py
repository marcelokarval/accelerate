#!/usr/bin/env python3
"""Validate the bounded Codex collaboration physical-dispatch policy."""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
POLICY_PATH = ROOT / "adapters/runtime/codex-collaboration/role-policy.json"
VALID_MODELS = {"gpt-5.6-sol", "gpt-5.6-terra", "gpt-5.6-luna"}
VALID_EFFORTS = {"low", "medium", "high"}
REQUIRED_ROLES = {"architecture", "backend", "frontend", "qa-regression", "security", "governance", "data-db", "provider-boundary", "product-runtime", "other"}
PROFILE_KEYS = {"model", "reasoning_effort", "tool_policy", "skill_allowlist", "mcp_allowlist", "write_mode", "requires_write_scope", "requires_reasoning_receipt", "eligibility"}


def fail(message: str) -> None:
    raise ValueError(message)


def require_keys(value: dict[str, Any], keys: set[str], label: str) -> None:
    if set(value) != keys:
        fail(f"{label} keys must be exactly: {', '.join(sorted(keys))}")


def no_wildcard(value: Any, label: str) -> None:
    if isinstance(value, str) and "*" in value:
        fail(f"{label} contains wildcard")
    if isinstance(value, list):
        for item in value:
            no_wildcard(item, label)
    if isinstance(value, dict):
        for item in value.values():
            no_wildcard(item, label)


def validate(policy: dict[str, Any]) -> None:
    require_keys(policy, {"schema_version", "runtime", "policy_status", "authority_boundary", "binding", "routes", "profiles", "role_bindings", "nested_terra_to_luna", "exceptions", "fallback"}, "policy")
    if policy["schema_version"] != 2 or policy["runtime"] != "codex-collaboration":
        fail("policy must be codex-collaboration schema v2")
    if policy["policy_status"] != "experimental":
        fail("policy must remain experimental until host enforcement is proven")

    binding = policy["binding"]
    require_keys(binding, {"spawn_api", "model_override", "reasoning_effort_override", "fork_turns_default", "fork_turns_override", "fork_turns_all", "child_binding_inheritance", "tool_enforcement", "skill_visibility", "mcp_visibility", "logical_topology"}, "binding")
    expected_binding = {"spawn_api": "collaboration.spawn_agent", "model_override": "explicit-per-assignment", "reasoning_effort_override": "explicit-per-assignment", "fork_turns_default": "none", "fork_turns_override": "integer-1-to-5-only", "fork_turns_all": "forbidden-with-override", "child_binding_inheritance": "forbidden", "tool_enforcement": "assignment-contract-only", "skill_visibility": "on-demand-contract-only", "mcp_visibility": "on-demand-contract-only", "logical_topology": "adapters/runtime/codex/logical-agent-topology.toml"}
    if binding != expected_binding:
        fail("binding does not preserve explicit physical assignment boundaries")

    routes = policy["routes"]
    if set(routes) != {"direct-fast-path", "scoped", "orchestrated"}:
        fail("routes must be exactly direct-fast-path, scoped, orchestrated")
    if routes["direct-fast-path"] != {"delegation_budget": 0, "physical_binding_allowed": False, "physical_binding_required": False, "dispatch_receipt_required": False, "root_task_execution": "allowed"}:
        fail("direct-fast-path must have zero physical bindings")
    if routes["scoped"] != {"delegation_budget": 1, "physical_binding_allowed": True, "physical_binding_required": False, "dispatch_receipt_required": True, "sidecar_may_implement_task": False, "root_task_execution": "allowed-only-when-no-task-owned-scope-is-dispatched"}:
        fail("scoped route must be one non-implementation sidecar at most")
    if routes["orchestrated"] != {"delegation_budget": "2-3", "physical_binding_allowed": True, "physical_binding_required": True, "dispatch_receipt_required": True, "root_task_execution": "forbidden-after-dispatch-required"}:
        fail("orchestrated route requires 2-3 physical bindings and a dispatch receipt")

    profiles = policy["profiles"]
    if not isinstance(profiles, dict) or not profiles:
        fail("profiles must be a non-empty object")
    for name, profile in profiles.items():
        if not isinstance(profile, dict):
            fail(f"profile {name} must be an object")
        require_keys(profile, PROFILE_KEYS, f"profile {name}")
        if profile["model"] not in VALID_MODELS or profile["reasoning_effort"] not in VALID_EFFORTS:
            fail(f"profile {name} has unsupported model or effort")
        if not isinstance(profile["eligibility"], list) or not profile["eligibility"]:
            fail(f"profile {name} must declare non-empty eligibility")
        for field in ("tool_policy", "skill_allowlist", "mcp_allowlist"):
            if not isinstance(profile[field], list):
                fail(f"profile {name} {field} must be a list")
            no_wildcard(profile[field], f"profile {name} {field}")
        if profile["write_mode"] == "bounded-write" and profile["requires_write_scope"] is not True:
            fail(f"writer profile {name} must require a write scope")
        if profile["write_mode"] == "read-only" and profile["requires_write_scope"] is not False:
            fail(f"read-only profile {name} cannot require a write scope")
        if profile["reasoning_effort"] == "high" and profile["requires_reasoning_receipt"] is not True:
            fail(f"high profile {name} must require a reasoning receipt")
        if profile["model"] == "gpt-5.6-luna" and profile["reasoning_effort"] == "high":
            fail(f"Luna/high is not an approved profile: {name}")
    if profiles.get("high-stakes-review", {}).get("model") != "gpt-5.6-sol" or profiles["high-stakes-review"].get("reasoning_effort") != "high" or profiles["high-stakes-review"].get("write_mode") != "read-only":
        fail("high-stakes-review must be read-only Sol/high")

    bindings = policy["role_bindings"]
    if set(bindings) != REQUIRED_ROLES:
        fail("role bindings must cover exactly the normalized role families")
    for role, choices in bindings.items():
        if not isinstance(choices, list):
            fail(f"role {role} must bind to a profile list")
        if role == "other":
            if choices:
                fail("other remains a root reclassification gap")
            continue
        if not choices or any(choice not in profiles for choice in choices):
            fail(f"role {role} has an unknown or empty profile binding")
    for role in ("data-db", "provider-boundary"):
        if bindings[role] != ["implementation"]:
            fail(f"{role} must bind explicitly to Terra/medium implementation")

    nested = policy["nested_terra_to_luna"]
    expected_nested = {"default": "forbidden", "authorization": "root-authorized-only", "allowed_profile": "mechanical-fixer", "max_luna_children": 1, "global_physical_budget_exact": 3, "scope_relation": "disjoint", "terra_accountability": "required", "independent_reviewer": "required", "luna_delegation": "leaf-only"}
    if nested != expected_nested:
        fail("nested Terra-to-Luna must remain a root-authorized single mechanical leaf exception")
    if policy["exceptions"] != ["explicit_user_opt_out", "collaboration_unavailable", "spawn_failed_operator_authorized"]:
        fail("exceptions must be the closed physical-dispatch catalog")
    if policy["fallback"] != ["virtual-after-approved-exception"]:
        fail("virtual fallback requires an approved physical-dispatch exception")
    no_wildcard(policy, "policy")


def main() -> int:
    try:
        validate(json.loads(POLICY_PATH.read_text()))
    except (OSError, json.JSONDecodeError, ValueError) as error:
        print(f"codex collaboration policy invalid: {error}", file=sys.stderr)
        return 1
    print("codex collaboration policy passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
