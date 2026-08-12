#!/usr/bin/env python3
"""Validate the bounded Codex collaboration role-routing policy."""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
POLICY_PATH = ROOT / "adapters/runtime/codex-collaboration/role-policy.json"
VALID_MODELS = {"gpt-5.6-sol", "gpt-5.6-terra", "gpt-5.6-luna"}
VALID_EFFORTS = {"low", "medium", "high"}
REQUIRED_ROLES = {
    "architecture",
    "backend",
    "frontend",
    "qa-regression",
    "security",
    "governance",
    "provider-boundary",
    "product-runtime",
    "other",
}
WRITER_MODE = "bounded-write"


def fail(message: str) -> None:
    raise ValueError(message)


def require_keys(value: dict[str, Any], keys: set[str], label: str) -> None:
    missing = keys - set(value)
    if missing:
        fail(f"{label} missing keys: {', '.join(sorted(missing))}")


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
    require_keys(
        policy,
        {"schema_version", "runtime", "policy_status", "authority_boundary", "binding", "routes", "profiles", "role_bindings", "fallback"},
        "policy",
    )
    if policy["schema_version"] != 1:
        fail("unsupported schema_version")
    if policy["runtime"] != "codex-collaboration":
        fail("runtime must be codex-collaboration")
    if policy["policy_status"] != "experimental":
        fail("policy must remain experimental until host enforcement is proven")

    binding = policy["binding"]
    if not isinstance(binding, dict):
        fail("binding must be an object")
    require_keys(
        binding,
        {"spawn_api", "model_override", "reasoning_effort_override", "tool_enforcement", "skill_visibility", "mcp_visibility"},
        "binding",
    )
    if binding["spawn_api"] != "collaboration.spawn_agent":
        fail("unsupported spawn API")
    if binding["model_override"] != "explicit-per-assignment":
        fail("model overrides must be explicit per assignment")
    if binding["tool_enforcement"] != "assignment-contract-only":
        fail("tool enforcement must remain assignment-contract-only")

    routes = policy["routes"]
    if set(routes) != {"direct-fast-path", "scoped", "orchestrated"}:
        fail("routes must be exactly direct-fast-path, scoped, orchestrated")
    direct = routes["direct-fast-path"]
    if direct["delegation_budget"] != 0 or direct["physical_binding_allowed"] is not False:
        fail("direct-fast-path must prohibit physical bindings")
    scoped = routes["scoped"]
    if scoped["delegation_budget"] != 1 or scoped["physical_binding_allowed"] is not True:
        fail("scoped must allow exactly one bounded physical binding")
    orchestrated = routes["orchestrated"]
    if orchestrated["delegation_budget"] != "2-3" or orchestrated["physical_binding_allowed"] is not True:
        fail("orchestrated must allow two to three bounded physical bindings")
    for name, route in routes.items():
        require_keys(route, {"delegation_budget", "physical_binding_allowed"}, f"route {name}")

    profiles = policy["profiles"]
    if not isinstance(profiles, dict) or not profiles:
        fail("profiles must be a non-empty object")
    for name, profile in profiles.items():
        if not isinstance(profile, dict):
            fail(f"profile {name} must be an object")
        require_keys(
            profile,
            {"model", "reasoning_effort", "tool_policy", "skill_allowlist", "mcp_allowlist", "write_mode", "requires_write_scope", "requires_reasoning_receipt", "eligibility"},
            f"profile {name}",
        )
        if profile["model"] not in VALID_MODELS or profile["reasoning_effort"] not in VALID_EFFORTS:
            fail(f"profile {name} has unsupported model or effort")
        for field in ("tool_policy", "skill_allowlist", "mcp_allowlist"):
            if not isinstance(profile[field], list):
                fail(f"profile {name} {field} must be a list")
            no_wildcard(profile[field], f"profile {name} {field}")
        if not isinstance(profile["eligibility"], list) or not profile["eligibility"]:
            fail(f"profile {name} must declare non-empty eligibility")
        if profile["write_mode"] == WRITER_MODE and profile["requires_write_scope"] is not True:
            fail(f"writer profile {name} must require a write scope")
        if profile["write_mode"] == "read-only" and profile["requires_write_scope"] is not False:
            fail(f"read-only profile {name} cannot require a write scope")
        if profile["reasoning_effort"] == "high" and profile["requires_reasoning_receipt"] is not True:
            fail(f"high profile {name} must require a reasoning receipt")
        if profile["model"] == "gpt-5.6-luna" and profile["reasoning_effort"] == "high":
            fail(f"Luna/high is not an approved profile: {name}")

    high_stakes = profiles.get("high-stakes-review")
    if not high_stakes or high_stakes["model"] != "gpt-5.6-sol" or high_stakes["reasoning_effort"] != "high":
        fail("high-stakes-review must be Sol/high")
    if high_stakes["write_mode"] != "read-only":
        fail("high-stakes-review must remain read-only")

    bindings = policy["role_bindings"]
    if set(bindings) != REQUIRED_ROLES:
        fail("role bindings must cover exactly the normalized role families")
    for role, choices in bindings.items():
        if not isinstance(choices, list):
            fail(f"role {role} must bind to a profile list")
        if role in {"other", "provider-boundary"}:
            if choices:
                fail(f"{role} must remain root-owned or virtual until reclassified")
            continue
        if not choices:
            fail(f"role {role} must bind to at least one profile")
        for choice in choices:
            if choice not in profiles:
                fail(f"role {role} references unknown profile {choice}")

    if not isinstance(policy["fallback"], list) or "virtual-subagent-packets" not in policy["fallback"]:
        fail("fallback must include virtual-subagent-packets")
    if "root-direct-fast-path" in policy["fallback"]:
        fail("sidecar unavailability must not downgrade a route to direct-fast-path")
    no_wildcard(policy, "policy")


def main() -> int:
    try:
        policy = json.loads(POLICY_PATH.read_text())
        validate(policy)
    except (OSError, json.JSONDecodeError, ValueError) as error:
        print(f"codex collaboration policy invalid: {error}", file=sys.stderr)
        return 1
    print("codex collaboration policy passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
