#!/usr/bin/env python3
"""Validate the bounded Codex collaboration role-routing policy."""

from __future__ import annotations

import json
import argparse
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
POLICY_PATH = ROOT / "adapters/runtime/codex-collaboration/role-policy.json"
VALID_MODELS = {"gpt-5.6-sol", "gpt-5.6-terra", "gpt-5.6-luna"}
VALID_EFFORTS = {"low", "medium", "high"}
REQUIRED_ROLES = {
    "architecture",
    "research",
    "backend",
    "frontend",
    "data",
    "integrations-ops",
    "qa-regression",
    "security",
    "governance",
    "provider-boundary",
    "product-runtime",
    "other",
}
WRITER_MODE = "bounded-write"
VALID_RETURN_CONTRACTS = {
    "Agent Return Packet",
    "Skeptical Review Packet",
    "Task Execution Return Packet",
}
REQUIRED_RETURN_FIELDS = {
    "self_review",
    "self_forensic_review",
    "residual_risks",
    "root_closure_boundary",
}
QUALITY_REVIEW_RETURN_FIELDS = {
    "requested_vs_implemented",
    "evidence",
    "defects",
}
PROFILE_RETURN_REQUIREMENTS = {
    "explorer": ("Agent Return Packet", {"paths_and_lines", "answer", "gaps"}),
    "librarian": ("Agent Return Packet", {"sources", "source_version", "official_vs_community", "conclusion", "uncertainty"}),
    "architecture-review": ("Skeptical Review Packet", {"options", "tradeoffs", "recommendation", "uncertainty"}),
    "implementation": ("Task Execution Return Packet", {"files_changed", "behavior", "validations", "skipped_checks"}),
    "mechanical-fixer": ("Task Execution Return Packet", {"files_changed", "behavior", "validations", "skipped_checks"}),
    "product-runtime-review": ("Skeptical Review Packet", {"evidence", "findings", "severity", "blockers"}),
    "governance-audit": ("Skeptical Review Packet", {"evidence", "findings", "severity", "blockers"}),
    "high-stakes-review": ("Skeptical Review Packet", {"evidence", "findings", "severity", "blockers"}),
    "specification-review": (
        "Skeptical Review Packet",
        QUALITY_REVIEW_RETURN_FIELDS
        | {"specification_coverage", "traceability_gaps", "disposition_gaps"},
    ),
    "code-review": (
        "Skeptical Review Packet",
        QUALITY_REVIEW_RETURN_FIELDS
        | {"findings", "severity", "spec_compliance", "minimality_assessment"},
    ),
    "test-strategy": (
        "Skeptical Review Packet",
        QUALITY_REVIEW_RETURN_FIELDS
        | {"test_design", "regression_proof", "independence_status", "test_level_rationale"},
    ),
    "security-review": (
        "Skeptical Review Packet",
        QUALITY_REVIEW_RETURN_FIELDS
        | {
            "trust_boundaries",
            "threat_model",
            "supply_chain_provenance",
            "exploitability",
            "negative_proof",
        },
    ),
    "web-performance-review": (
        "Skeptical Review Packet",
        QUALITY_REVIEW_RETURN_FIELDS
        | {"metric_sources", "measurements", "unmeasured_areas", "findings"},
    ),
}
SPECIALIST_ROLE_BINDINGS = {
    "specification-review": "architecture",
    "code-review": "governance",
    "test-strategy": "qa-regression",
    "security-review": "security",
    "web-performance-review": "product-runtime",
}
READ_ONLY_FORBIDDEN_TOOLS = {
    "apply-patch",
    "write-source",
    "provider-write",
    "external-write",
    "tracker-write",
}
PROFILE_CAPABILITY_CONTRACTS = {
    "explorer": {
        "tool_policy": ["read-source", "search-local"],
        "skill_allowlist": [],
        "mcp_allowlist": [],
        "eligibility": ["bounded local discovery with no implementation or global design judgment"],
    },
    "librarian": {
        "tool_policy": ["search-official-docs", "read-source"],
        "skill_allowlist": ["openai-docs"],
        "mcp_allowlist": ["context7"],
        "eligibility": ["bounded current documentation or source research with a citation return"],
    },
    "architecture-review": {
        "tool_policy": ["read-source", "search-official-docs", "run-read-only-analysis"],
        "skill_allowlist": ["architecture", "governance-audit"],
        "mcp_allowlist": [],
        "eligibility": ["architecture or dependency judgment with a bounded evidence request"],
    },
    "implementation": {
        "tool_policy": ["read-source", "apply-patch", "run-focused-validation"],
        "skill_allowlist": ["validation-governance"],
        "mcp_allowlist": [],
        "eligibility": ["bounded implementation after surface, owner, write scope, and proof are known"],
    },
    "mechanical-fixer": {
        "tool_policy": ["read-source", "apply-patch", "run-focused-validation"],
        "skill_allowlist": [],
        "mcp_allowlist": [],
        "eligibility": ["known target and prescribed behavior with no discovery, architecture, or design judgment"],
    },
    "product-runtime-review": {
        "tool_policy": ["read-source", "run-focused-validation", "browser-proof"],
        "skill_allowlist": ["product-runtime-review"],
        "mcp_allowlist": [],
        "eligibility": ["bounded runtime or browser proof independent of implementation"],
    },
    "governance-audit": {
        "tool_policy": ["read-source", "run-focused-validation"],
        "skill_allowlist": ["governance-audit"],
        "mcp_allowlist": [],
        "eligibility": ["bounded workflow or policy audit with no provider mutation"],
    },
    "high-stakes-review": {
        "tool_policy": ["read-source", "run-focused-validation", "search-official-docs"],
        "skill_allowlist": ["security-patterns", "anti-abuse-review"],
        "mcp_allowlist": [],
        "eligibility": ["objective high-risk trigger", "valid reasoning decision receipt", "independent skeptical review"],
    },
    "specification-review": {
        "tool_policy": ["read-source", "run-read-only-analysis", "run-focused-validation"],
        "skill_allowlist": ["specification-lifecycle", "architecture", "source-verification"],
        "mcp_allowlist": [],
        "eligibility": ["bounded specification drafting or audit without implementation or acceptance authority"],
    },
    "code-review": {
        "tool_policy": ["read-source", "run-read-only-analysis", "run-focused-validation"],
        "skill_allowlist": ["code-audit", "requesting-code-review", "solution-minimalism"],
        "mcp_allowlist": [],
        "eligibility": ["independent bounded review of code, documentation, configuration, or workflow changes"],
    },
    "test-strategy": {
        "tool_policy": ["read-source", "run-read-only-analysis", "run-focused-validation"],
        "skill_allowlist": ["test-engineering", "test-driven-development"],
        "mcp_allowlist": [],
        "eligibility": ["read-only test design or independent regression proof; test writing requires a separate executor assignment"],
    },
    "security-review": {
        "tool_policy": ["read-source", "run-read-only-analysis", "run-focused-validation"],
        "skill_allowlist": ["security-patterns", "anti-abuse-review", "source-verification"],
        "mcp_allowlist": [],
        "eligibility": ["independent bounded threat, hostile-path, exploitability, or supply-chain review"],
    },
    "web-performance-review": {
        "tool_policy": ["read-source", "run-read-only-analysis", "run-focused-validation", "browser-proof"],
        "skill_allowlist": ["web-performance-review", "product-runtime-review"],
        "mcp_allowlist": [],
        "eligibility": ["bounded source-labelled static, lab, field, or trace performance review"],
    },
}
PROFILE_RUNTIME_CONTRACTS = {
    "explorer": ("gpt-5.6-luna", "low", False, "read-only", False),
    "librarian": ("gpt-5.6-luna", "low", False, "read-only", False),
    "architecture-review": ("gpt-5.6-terra", "medium", False, "read-only", False),
    "implementation": ("gpt-5.6-terra", "medium", False, "bounded-write", True),
    "mechanical-fixer": ("gpt-5.6-luna", "medium", False, "bounded-write", True),
    "product-runtime-review": ("gpt-5.6-terra", "medium", False, "read-only", False),
    "governance-audit": ("gpt-5.6-terra", "medium", False, "read-only", False),
    "high-stakes-review": ("gpt-5.6-sol", "high", True, "read-only", False),
    "specification-review": ("gpt-5.6-terra", "medium", False, "read-only", False),
    "code-review": ("gpt-5.6-terra", "medium", False, "read-only", False),
    "test-strategy": ("gpt-5.6-terra", "medium", False, "read-only", False),
    "security-review": ("gpt-5.6-terra", "medium", False, "read-only", False),
    "web-performance-review": ("gpt-5.6-terra", "medium", False, "read-only", False),
}
EXPECTED_ROLE_BINDINGS = {
    "architecture": ["architecture-review", "high-stakes-review", "specification-review"],
    "research": ["explorer", "librarian"],
    "backend": ["implementation", "mechanical-fixer"],
    "frontend": ["implementation", "mechanical-fixer"],
    "data": ["implementation"],
    "integrations-ops": ["implementation"],
    "qa-regression": ["product-runtime-review", "test-strategy"],
    "security": ["high-stakes-review", "security-review"],
    "governance": ["governance-audit", "code-review"],
    "provider-boundary": [],
    "product-runtime": ["product-runtime-review", "web-performance-review"],
    "other": [],
}


def fail(message: str) -> None:
    raise ValueError(message)


def require_keys(value: dict[str, Any], keys: set[str], label: str) -> None:
    missing = keys - set(value)
    if missing:
        fail(f"{label} missing keys: {', '.join(sorted(missing))}")
    unexpected = set(value) - keys
    if unexpected:
        fail(f"{label} has unsupported keys: {', '.join(sorted(unexpected))}")


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
    if not isinstance(policy, dict):
        fail("policy must be an object")
    require_keys(
        policy,
        {"schema_version", "runtime", "policy_status", "authority_boundary", "binding", "routes", "session_lifecycle", "profiles", "role_bindings", "fallback"},
        "policy",
    )
    if type(policy["schema_version"]) is not int or policy["schema_version"] != 1:
        fail("unsupported schema_version")
    if policy["runtime"] != "codex-collaboration":
        fail("runtime must be codex-collaboration")
    if policy["policy_status"] != "experimental":
        fail("policy must remain experimental until host enforcement is proven")
    if policy["authority_boundary"] != "subordinate-to-accelerate":
        fail("authority boundary must remain subordinate to accelerate")

    binding = policy["binding"]
    if not isinstance(binding, dict):
        fail("binding must be an object")
    require_keys(
        binding,
        {"spawn_api", "model_override", "reasoning_effort_override", "tool_enforcement", "skill_visibility", "mcp_visibility", "logical_topology"},
        "binding",
    )
    if binding["spawn_api"] != "collaboration.spawn_agent":
        fail("unsupported spawn API")
    if binding["model_override"] != "explicit-per-assignment":
        fail("model overrides must be explicit per assignment")
    if binding["reasoning_effort_override"] != "explicit-per-assignment":
        fail("reasoning effort overrides must be explicit per assignment")
    if binding["tool_enforcement"] != "assignment-contract-only":
        fail("tool enforcement must remain assignment-contract-only")
    if binding["skill_visibility"] != "on-demand-contract-only":
        fail("skill visibility must remain on-demand and assignment-bound")
    if binding["mcp_visibility"] != "on-demand-contract-only":
        fail("MCP visibility must remain on-demand and assignment-bound")
    if binding["logical_topology"] != "adapters/runtime/codex/logical-agent-topology.toml":
        fail("logical topology binding is invalid")

    routes = policy["routes"]
    if not isinstance(routes, dict):
        fail("routes must be an object")
    if set(routes) != {"direct-fast-path", "scoped", "orchestrated"}:
        fail("routes must be exactly direct-fast-path, scoped, orchestrated")
    for name, route in routes.items():
        if not isinstance(route, dict):
            fail(f"route {name} must be an object")
        require_keys(route, {"delegation_budget", "physical_binding_allowed"}, f"route {name}")
    direct = routes["direct-fast-path"]
    if (
        type(direct["delegation_budget"]) is not int
        or direct["delegation_budget"] != 0
        or type(direct["physical_binding_allowed"]) is not bool
        or direct["physical_binding_allowed"] is not False
    ):
        fail("direct-fast-path must prohibit physical bindings")
    scoped = routes["scoped"]
    if (
        type(scoped["delegation_budget"]) is not int
        or scoped["delegation_budget"] != 1
        or type(scoped["physical_binding_allowed"]) is not bool
        or scoped["physical_binding_allowed"] is not True
    ):
        fail("scoped must allow exactly one bounded physical binding")
    orchestrated = routes["orchestrated"]
    if (
        type(orchestrated["delegation_budget"]) is not str
        or orchestrated["delegation_budget"] != "2-3"
        or type(orchestrated["physical_binding_allowed"]) is not bool
        or orchestrated["physical_binding_allowed"] is not True
    ):
        fail("orchestrated must allow two to three bounded physical bindings")
    session_lifecycle = policy["session_lifecycle"]
    if not isinstance(session_lifecycle, dict):
        fail("session_lifecycle must be an object")
    expected_lifecycle = {
        "reuse_relevant_agent_context": True,
        "duplicate_active_lane": "forbidden",
        "interrupt_semantics": "stop-not-rollback",
        "interrupted_writer_reconciliation": "root-required-before-replacement-or-next-writer",
    }
    if (
        type(session_lifecycle.get("reuse_relevant_agent_context")) is not bool
        or any(
            type(session_lifecycle.get(field)) is not str
            for field in (
                "duplicate_active_lane",
                "interrupt_semantics",
                "interrupted_writer_reconciliation",
            )
        )
        or session_lifecycle != expected_lifecycle
    ):
        fail("session_lifecycle must preserve reuse, non-duplication, stop-not-rollback, and root reconciliation")

    profiles = policy["profiles"]
    if not isinstance(profiles, dict) or not profiles:
        fail("profiles must be a non-empty object")
    if set(profiles) != set(PROFILE_RETURN_REQUIREMENTS):
        fail("profiles must match the governed collaboration profile set")
    for name, profile in profiles.items():
        if not isinstance(profile, dict):
            fail(f"profile {name} must be an object")
        require_keys(
            profile,
            {"model", "reasoning_effort", "tool_policy", "skill_allowlist", "mcp_allowlist", "write_mode", "requires_write_scope", "requires_reasoning_receipt", "return_contract", "return_fields", "eligibility"},
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
        if (
            type(profile["requires_reasoning_receipt"]) is not bool
            or type(profile["requires_write_scope"]) is not bool
        ):
            fail(f"profile {name} boolean controls must use exact JSON booleans")
        expected_capabilities = PROFILE_CAPABILITY_CONTRACTS[name]
        for field, expected in expected_capabilities.items():
            if profile[field] != expected:
                fail(f"profile {name} {field} does not match its governed positive contract")
        expected_runtime = PROFILE_RUNTIME_CONTRACTS[name]
        actual_runtime = (
            profile["model"],
            profile["reasoning_effort"],
            profile["requires_reasoning_receipt"],
            profile["write_mode"],
            profile["requires_write_scope"],
        )
        if actual_runtime != expected_runtime:
            fail(f"profile {name} runtime posture does not match its governed positive contract")
        if profile["return_contract"] not in VALID_RETURN_CONTRACTS:
            fail(f"profile {name} has an unsupported return contract")
        return_fields = profile["return_fields"]
        if not isinstance(return_fields, list) or not return_fields or len(return_fields) != len(set(return_fields)):
            fail(f"profile {name} must declare unique return fields")
        if not REQUIRED_RETURN_FIELDS <= set(return_fields):
            fail(f"profile {name} is missing required return fields")
        no_wildcard(return_fields, f"profile {name} return_fields")
        expected_contract, specific_fields = PROFILE_RETURN_REQUIREMENTS[name]
        if profile["return_contract"] != expected_contract:
            fail(f"profile {name} must use {expected_contract}")
        if set(return_fields) != REQUIRED_RETURN_FIELDS | specific_fields:
            fail(f"profile {name} return fields do not match its governed role contract")
        if profile["write_mode"] not in {"read-only", WRITER_MODE}:
            fail(f"profile {name} has unsupported write mode")
        if profile["write_mode"] == WRITER_MODE and profile["requires_write_scope"] is not True:
            fail(f"writer profile {name} must require a write scope")
        if profile["write_mode"] == "read-only" and profile["requires_write_scope"] is not False:
            fail(f"read-only profile {name} cannot require a write scope")
        if profile["write_mode"] == "read-only" and READ_ONLY_FORBIDDEN_TOOLS & set(profile["tool_policy"]):
            fail(f"read-only profile {name} cannot declare write-capable tools")
        if name in SPECIALIST_ROLE_BINDINGS:
            if profile["write_mode"] != "read-only" or profile["requires_write_scope"] is not False:
                fail(f"quality specialist profile {name} must remain fail-closed read-only")
            if profile["mcp_allowlist"]:
                fail(f"quality specialist profile {name} cannot declare remote MCP access")
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
    if bindings != EXPECTED_ROLE_BINDINGS:
        fail("role bindings must exactly match the governed family-to-profile contract")
    if bindings.get("research") != ["explorer", "librarian"]:
        fail("research must bind exactly explorer and librarian")
    bound_profiles: set[str] = set()
    for role, choices in bindings.items():
        if not isinstance(choices, list):
            fail(f"role {role} must bind to a profile list")
        if role in {"other", "provider-boundary"}:
            if choices:
                fail(f"{role} must remain root-owned or virtual until reclassified")
            continue
        if not choices:
            fail(f"role {role} must bind to at least one profile")
        if len(choices) != len(set(choices)):
            fail(f"role {role} contains duplicate profile bindings")
        for choice in choices:
            if choice not in profiles:
                fail(f"role {role} references unknown profile {choice}")
            bound_profiles.add(choice)
            if role != "research" and choice in {"explorer", "librarian"}:
                fail(f"research profile {choice} cannot bind to role {role}")

    for profile_name, expected_role in SPECIALIST_ROLE_BINDINGS.items():
        if profile_name not in bindings[expected_role]:
            fail(f"profile {profile_name} must bind to role {expected_role}")
        for role, choices in bindings.items():
            if role != expected_role and profile_name in choices:
                fail(f"profile {profile_name} cannot bind to role {role}")

    unbound_profiles = set(profiles) - bound_profiles
    if unbound_profiles:
        fail(f"unbound profiles: {', '.join(sorted(unbound_profiles))}")

    if policy["fallback"] != ["scoped-root-only", "virtual-subagent-packets"]:
        fail("fallback must remain exactly scoped-root-only then virtual-subagent-packets")
    no_wildcard(policy, "policy")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Validate a Codex collaboration policy.")
    parser.add_argument("policy", nargs="?", type=Path, default=POLICY_PATH)
    args = parser.parse_args(argv)
    try:
        policy = json.loads(args.policy.read_text())
        validate(policy)
    except (OSError, json.JSONDecodeError, ValueError, TypeError, KeyError, AttributeError) as error:
        print(f"codex collaboration policy invalid: {error}", file=sys.stderr)
        return 1
    print("codex collaboration policy passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
