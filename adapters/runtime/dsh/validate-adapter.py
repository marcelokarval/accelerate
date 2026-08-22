#!/usr/bin/env python3
"""Validate the fail-closed DSH runtime adapter and its registrations."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import NoReturn


REPO = Path(__file__).resolve().parents[3]
POLICY = REPO / "adapters/runtime/dsh/adapter-policy.json"
BOOTSTRAP = "adapters/runtime/dsh/code-orchestrated-bootstrap.md"
REQUIRED_ROOT = ["hardening", "fan-in", "integration", "review-of-review", "closure"]
EXPECTED_TOOLS = {
    "reasoning": {"tool": "subagent_reasoning", "model_alias": "auto/best-reasoning"},
    "research": {"tool": "subagent_fast", "model_alias": "auto/best-fast"},
    "implementation": {"tool": "subagent", "model_alias": "auto/best-coding"},
    "independent_lanes": {"tool": "workflow", "model_alias": "auto/best-coding"},
}


def fail(message: str) -> NoReturn:
    raise ValueError(message)


def validate(policy_path: Path = POLICY) -> None:
    policy = json.loads(policy_path.read_text(encoding="utf-8"))
    required = {
        "schema_version", "runtime", "status", "enforcement", "loader",
        "root_model_alias", "max_concurrent_children", "tools", "root_retained",
        "route_policy", "failure_policy", "proof_invalidation", "native_plugin",
    }
    if set(policy) != required or policy["schema_version"] != 1:
        fail("DSH policy schema drift")
    if (policy["runtime"], policy["status"], policy["enforcement"]) != (
        "dsh", "supported", "prompt-enforced"
    ):
        fail("DSH runtime status or enforcement drift")
    if policy["loader"] != "code-orchestrated-preset":
        fail("DSH loader drift")
    if policy["root_model_alias"] != "auto/best-coding":
        fail("DSH root alias drift")
    if policy["max_concurrent_children"] != 4:
        fail("DSH concurrency ceiling drift")
    if policy["tools"] != EXPECTED_TOOLS:
        fail("DSH native tool or alias mapping drift")
    if policy["root_retained"] != REQUIRED_ROOT:
        fail("DSH root-retained duties drift")
    routes = policy["route_policy"]
    if set(routes) != {"conversational/no-op", "trivial-bounded", "non-trivial"}:
        fail("DSH route policy is incomplete")
    if routes["conversational/no-op"] != {"routes": ["direct"], "delegation": "forbidden"}:
        fail("DSH no-op route is not fail-closed")
    failures = policy["failure_policy"]
    required_failures = {
        "missing_accelerate", "reasoning_child_failure", "required_dispatch_failure",
        "runtime_policy_disagreement", "unknown_tool_or_child",
    }
    if set(failures) != required_failures or failures["missing_accelerate"] != "blocked":
        fail("DSH failure policy is incomplete")
    if policy["proof_invalidation"] != "material-mutation":
        fail("DSH proof invalidation drift")
    if policy["native_plugin"] != {
        "status": "planned", "role": "future-executor-receipt-gate", "classifier": False
    }:
        fail("native plugin must remain planned and non-classifying")

    bootstrap = json.loads(
        (REPO / "adapters/runtime/cross-runtime-bootstrap-manifest.json").read_text(encoding="utf-8")
    )["runtimes"].get("dsh")
    if bootstrap != {
        "status": "supported", "apply_eligible": True,
        "loader": "code-orchestrated-preset", "projection": BOOTSTRAP,
    }:
        fail("DSH bootstrap manifest drift")
    registry = json.loads(
        (REPO / "adapters/runtime/runtime-consumer-registry.json").read_text(encoding="utf-8")
    )
    consumer = next((item for item in registry["consumers"] if item.get("runtime") == "dsh"), None)
    if consumer is None:
        fail("DSH runtime consumer registration missing")
    if consumer["status"] != "supported" or consumer["loader"] != "code-orchestrated-preset":
        fail("DSH runtime consumer registration drift")
    for path in (BOOTSTRAP, consumer["adapter"], consumer["projection"]["path"]):
        if not (REPO / path).exists():
            fail(f"DSH registered path does not exist: {path}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--policy", type=Path, default=POLICY)
    args = parser.parse_args()
    try:
        validate(args.policy)
    except (OSError, ValueError, KeyError, json.JSONDecodeError) as error:
        print(f"FAIL: {error}", file=sys.stderr)
        return 1
    print("PASS: DSH runtime adapter validated")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
