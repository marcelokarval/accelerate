#!/usr/bin/env python3
"""Fail-closed validation for the runtime-neutral delegation semantic core."""
from __future__ import annotations
import json
import sys
from pathlib import Path
from typing import Any
from jsonschema import Draft202012Validator

REPO = Path(__file__).resolve().parents[1]
SCHEMA_PATH = REPO / "core/delegation/runtime-neutral-delegation.schema.json"
REGISTRY_PATH = REPO / "adapters/runtime/runtime-consumer-registry.json"
RUNTIMES = {"codex", "openhands", "hermes", "opencode", "openclaw", "claude"}
STATUSES = {"supported", "blocked", "export-only", "legacy-reference"}
TRANSITIONS = {"draft": {"hardened", "blocked", "cancelled"}, "hardened": {"tasks-ready", "blocked", "exception", "cancelled"}, "tasks-ready": {"dispatch-required", "executing", "blocked", "exception", "cancelled"}, "dispatch-required": {"dispatched", "blocked", "exception", "cancelled"}, "dispatched": {"executing", "blocked", "exception", "cancelled"}, "executing": {"fan-in", "blocked", "exception", "cancelled", "superseded"}, "fan-in": {"independent-review", "root-review-of-review", "blocked", "exception", "superseded"}, "independent-review": {"root-review-of-review", "blocked", "rejected", "exception"}, "root-review-of-review": {"promotion-pending", "completed", "blocked", "rejected", "exception"}, "promotion-pending": {"promoted", "rejected", "blocked", "exception"}, "promoted": {"completed", "superseded"}, "exception": {"hardened", "tasks-ready", "dispatch-required", "executing", "fan-in", "blocked", "rejected", "cancelled"}, "blocked": {"hardened", "tasks-ready", "exception", "rejected", "cancelled", "superseded"}, "rejected": set(), "cancelled": set(), "superseded": set(), "completed": set()}

def fail(message: str) -> None: raise ValueError(message)
def load(path: Path) -> Any:
    try: return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error: fail(f"cannot read {path}: {error}")
def schema_validate(payload: dict[str, Any], schema: dict[str, Any]) -> None:
    errors = sorted(Draft202012Validator(schema).iter_errors(payload), key=str)
    if errors: fail(f"schema violation: {errors[0].message}")
def cycle(graph: dict[str, set[str]], name: str) -> None:
    visited: set[str] = set(); active: set[str] = set()
    def visit(node: str) -> None:
        if node in active: fail(f"cyclic {name}: {node}")
        if node in visited: return
        active.add(node)
        for target in graph[node]: visit(target)
        active.remove(node); visited.add(node)
    for node in graph: visit(node)

def validate_run(payload: dict[str, Any], schema: dict[str, Any]) -> None:
    schema_validate(payload, schema)
    policy, budget, capacity = payload["policy"], payload["budget"], payload["policy"]["runtime_capacity"]
    if (capacity["telemetry"] == "unknown" and capacity["value"] is not None) or (capacity["telemetry"] == "observed" and capacity["value"] is None): fail("runtime telemetry value does not match its declared telemetry state")
    if not budget["reserved_slots"] <= budget["requested_slots"] <= policy["effective_cap"] <= policy["policy_cap"]: fail("capacity order must be reserved_slots <= requested_slots <= effective_cap <= policy_cap")
    if capacity["value"] is not None and policy["policy_cap"] > capacity["value"]: fail("policy_cap exceeds observed runtime_capacity")
    assignments = payload["assignments"]
    if policy["enforcement_level"] == "unsupported" and (policy["effective_cap"] or assignments or budget["requested_slots"] or budget["reserved_slots"]): fail("unsupported enforcement requires zero caps, zero budget, and no assignments")
    non_root = [item for item in assignments if item["kind"] != "root"]
    if len(non_root) > budget["reserved_slots"]: fail("non-root assignment count exceeds reserved_slots")
    history = payload["state"]["history"]
    if history[-1] != payload["state"]["current"]: fail("state.current must equal the final history state")
    for earlier, later in zip(history, history[1:]):
        if later not in TRANSITIONS[earlier]: fail(f"invalid state transition: {earlier} -> {later}")
    ids = {item["assignment_id"] for item in assignments}
    if len(ids) != len(assignments): fail("assignment_id values must be unique")
    by_id = {item["assignment_id"]: item for item in assignments}
    roots = [item for item in assignments if item["kind"] == "root"]
    if assignments and (len(roots) != 1 or roots[0]["parent_assignment_id"] is not None): fail("assigned work requires exactly one parentless root assignment")
    root_id = roots[0]["assignment_id"] if roots else None
    if root_id != payload["root_ownership"]["nested_delegation_authorizer_assignment_id"]: fail("root ownership must identify the root assignment as nested-delegation authorizer")
    deps: dict[str, set[str]] = {}; parents: dict[str, set[str]] = {}
    for item in assignments:
        identifier, parent = item["assignment_id"], item["parent_assignment_id"]
        deps[identifier] = set(item["dependencies"]); parents[identifier] = set() if parent is None else {parent}
        if not deps[identifier] <= ids: fail("assignment dependency references an unknown assignment")
        if parent is not None and parent not in ids: fail("assignment parent references an unknown assignment")
        if item["kind"] == "root" and parent is not None: fail("root assignment cannot have a parent")
        if item["kind"] != "root" and parent is None: fail("non-root assignment requires a parent assignment")
    cycle(deps, "dependency graph"); cycle(parents, "parent graph")
    def depth(item: dict[str, Any]) -> int: return 0 if item["parent_assignment_id"] is None else 1 + depth(by_id[item["parent_assignment_id"]])
    for item in non_root:
        if depth(item) > policy["max_assignment_depth"]: fail("assignment depth exceeds policy max_assignment_depth")
        parent = by_id[item["parent_assignment_id"]]
        if parent["kind"] != "root":
            grant = parent["nested_delegation_grant"]
            if grant["state"] != "granted" or grant["authorized_by_assignment_id"] != root_id: fail("nested assignment requires a root-authorized parent grant")
    for item in assignments:
        grant = item["nested_delegation_grant"]
        if grant["state"] == "granted" and grant["authorized_by_assignment_id"] != root_id: fail("nested delegation grant must be authorized by the root assignment")
    fan_in = payload["fan_in"]
    if assignments:
        if fan_in["owner_assignment_id"] not in ids or not set(fan_in["required_assignment_ids"]) <= ids: fail("fan_in references an unknown assignment")
    elif fan_in["owner_assignment_id"] is not None or fan_in["required_assignment_ids"]: fail("empty assignment set requires empty fan_in with null owner")
    exceptions = payload["exceptions"]
    if payload["state"]["current"] == "exception" and not any(item["state"] == "open" for item in exceptions): fail("exception state requires an open exception record")
    if payload["state"]["current"] == "completed":
        if payload["run"]["execution_requested"] and not assignments: fail("completed execution run requires assignments")
        if any(item["state"] != "completed" or item["outcome"] != "succeeded" for item in assignments): fail("completed run requires every assignment state completed and outcome succeeded")
        if fan_in["state"] != "complete": fail("completed run requires complete fan_in")
        review = payload["review"]
        if review["state"] not in {"passed", "not-required"} or (review["independent_required"] and review["state"] != "passed"): fail("completed run requires review state passed or not-required")
        if any(item["state"] == "open" for item in exceptions): fail("completed run cannot retain open exceptions")
        promotion = payload["promotion"]
        if promotion["state"] != "approved" or not promotion["proof"]["verified"] or not promotion["rollback"]["verified"]: fail("completed run requires approved promotion with verified proof and rollback")
        for value in (promotion["proof"], promotion["rollback"]):
            if not (REPO / value["reference"]).is_file(): fail("completed promotion proof and rollback references must exist")

def string(item: dict[str, Any], field: str) -> str:
    value = item.get(field)
    if not isinstance(value, str) or not value.strip(): fail(f"registry {item.get('runtime', '<unknown>')} has invalid {field}")
    return value
def validate_registry(registry: dict[str, Any]) -> None:
    consumers = registry.get("consumers")
    if not isinstance(consumers, list): fail("registry consumers must be an array")
    names = [item.get("runtime") for item in consumers if isinstance(item, dict)]
    if set(names) != RUNTIMES or len(names) != len(RUNTIMES): fail("registry runtime denominator drift")
    fields = {"runtime", "status", "source_authority", "projection", "loader", "native_primitive", "adapter", "proof", "install", "rollback"}
    for item in consumers:
        if not isinstance(item, dict) or not fields <= set(item): fail("registry entry missing lifecycle fields")
        for field in fields - {"runtime", "status", "projection"}: string(item, field)
        if item["status"] not in STATUSES: fail(f"registry has invalid status: {item['runtime']}")
        projection = item["projection"]
        if not isinstance(projection, dict) or set(projection) != {"mode", "path", "behavior_change"}: fail(f"registry projection is incomplete: {item['runtime']}")
        for value in projection.values():
            if not isinstance(value, str) or not value.strip(): fail(f"registry projection has invalid field: {item['runtime']}")
        for path in (item["source_authority"], item["adapter"], projection["path"]):
            if path != "none" and not (REPO / path).exists(): fail(f"registry path does not exist: {item['runtime']}")
        static_only = "registry validation only" in item["proof"].lower()
        if item["status"] == "supported":
            if static_only or projection["mode"] != "reference-adapter" or projection["behavior_change"] != "none" or not item["proof"].startswith("tests/"): fail(f"supported registry entry has no callability-safe reference proof: {item['runtime']}")
        elif item["status"] == "export-only":
            if projection["mode"] != "future-export" or "no semantic-core loader" not in item["loader"]: fail(f"export-only registry entry is inconsistent: {item['runtime']}")
        elif item["status"] == "legacy-reference":
            allowed_modes = {"reference-only"}
            if item["runtime"] == "opencode": allowed_modes.add("generated-export")
            if projection["mode"] not in allowed_modes or item["loader"] != "none": fail(f"legacy-reference registry entry is inconsistent: {item['runtime']}")
        elif projection["mode"] != "none" or item["adapter"] != "none" or item["loader"] != "none": fail(f"blocked registry entry is inconsistent: {item['runtime']}")
        if item["runtime"] == "openhands" and item["status"] != "export-only": fail("openhands remains export-only until separately proven")

def main() -> int:
    args = sys.argv[1:]; registry_path = REGISTRY_PATH
    if args[:1] == ["--registry"]:
        if len(args) < 3: fail("--registry requires REGISTRY.json and RUN.json")
        registry_path, args = Path(args[1]), args[2:]
    if not args: fail("usage: validate-runtime-delegation-semantics.py [--registry REGISTRY.json] RUN.json")
    schema = load(SCHEMA_PATH); validate_registry(load(registry_path))
    for argument in args: validate_run(load(Path(argument)), schema)
    print(f"PASS: runtime-neutral delegation semantics validated ({len(args)} run(s))"); return 0
if __name__ == "__main__":
    try: raise SystemExit(main())
    except ValueError as error: print(f"FAIL: {error}", file=sys.stderr); raise SystemExit(1)
