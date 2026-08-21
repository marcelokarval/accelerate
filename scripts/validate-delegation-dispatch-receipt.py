#!/usr/bin/env python3
"""Validate a delegation-dispatch receipt against the canonical contract."""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
SCHEMA_NAME = "delegation-dispatch-receipt.schema.json"
STATES = ["HARDENING", "SPEC_READY", "TASKS_READY", "ROUTE_SELECTED", "DISPATCH_REQUIRED", "DISPATCHED", "EXECUTING", "FAN_IN", "INDEPENDENT_REVIEW", "ROOT_REVIEW_OF_REVIEW", "CLOSURE"]
LUNA_FORBIDDEN_ROLES = {"architecture", "design", "coordination"}
LUNA_MECHANICAL_ROLE = "mechanical-fixer"


def fail(message: str) -> None:
    raise ValueError(message)


def resolve_schema_path() -> Path:
    source_schema = ROOT / "core/runtime-packets" / SCHEMA_NAME
    if source_schema.is_file():
        return source_schema
    runtime_schema = ROOT / "assets" / SCHEMA_NAME
    if runtime_schema.is_file():
        return runtime_schema
    fail("canonical delegation dispatch schema is unavailable in source or runtime assets")


def require(value: Any, kind: type, label: str) -> Any:
    if not isinstance(value, kind):
        fail(f"{label} must be a {kind.__name__}")
    return value


def basic_schema(receipt: dict[str, Any], schema: dict[str, Any]) -> None:
    required = set(schema["required"])
    if set(receipt) != required:
        fail("receipt keys must match canonical schema")
    if receipt["contract_version"] != "1.0" or receipt["state"] not in STATES:
        fail("unsupported contract version or state")
    artifacts = require(receipt["artifacts"], dict, "artifacts")
    if set(artifacts) != {"hardening", "spec", "task_graph"}:
        fail("artifacts must name hardening, spec, and task graph")
    for name in ("hardening", "spec", "task_graph"):
        artifact = require(artifacts.get(name), dict, f"artifacts.{name}")
        digest = artifact.get("sha256")
        if set(artifact) != {"ref", "sha256"} or not artifact["ref"] or not isinstance(digest, str) or len(digest) != 64 or any(char not in "0123456789abcdef" for char in digest):
            fail(f"artifacts.{name} requires ref and SHA-256")
    if receipt["route"] not in {"direct-fast-path", "scoped", "orchestrated"}:
        fail("unknown route")
    if not isinstance(receipt["execution_requested"], bool) or not isinstance(receipt["planned_task_owned_writes"], bool):
        fail("execution flags must be booleans")


def scopes_overlap(left: str, right: str) -> bool:
    return left == right or left.startswith(right.rstrip("/") + "/") or right.startswith(left.rstrip("/") + "/")


def is_physical(item: dict[str, Any]) -> bool:
    return item["kind"] != "root" and item["agent_id"] != "virtual" and item["call_id"] != "virtual"


def validate_assignments(receipt: dict[str, Any]) -> tuple[list[dict[str, Any]], list[dict[str, Any]], dict[str, dict[str, Any]]]:
    assignments = require(receipt["assignments"], list, "assignments")
    seen_ids: set[str] = set()
    write_scopes: list[tuple[str, str]] = []
    reviewers: dict[str, dict[str, Any]] = {}
    executors: list[dict[str, Any]] = []
    for item in assignments:
        require(item, dict, "assignment")
        required = {"assignment_id", "kind", "task_id", "dependencies", "wave", "role", "model", "effort", "fork", "agent_id", "call_id", "read_scopes", "write_scopes", "proof", "reviewer_assignment_id", "recursion", "parent_assignment_id", "delegation_reference"}
        if set(item) != required:
            fail("assignment has omitted or unknown override fields")
        assignment_id = item["assignment_id"]
        if not isinstance(assignment_id, str) or not assignment_id or assignment_id in seen_ids:
            fail("assignment IDs must be unique")
        seen_ids.add(assignment_id)
        fork = item["fork"]
        if item["kind"] not in {"executor", "reviewer", "root"} or item["model"] not in {"gpt-5.6-sol", "gpt-5.6-terra", "gpt-5.6-luna"} or item["effort"] not in {"low", "medium", "high"} or not (fork == "none" or (type(fork) is int and 1 <= fork <= 5)):
            fail("assignment has invalid kind, model, effort, or fork override")
        if not item["agent_id"] or not item["call_id"]:
            fail("physical assignments require agent and call IDs")
        if item["model"] == "gpt-5.6-luna" and item["role"] in LUNA_FORBIDDEN_ROLES:
            fail("Luna cannot own architecture or discovery")
        recursion = require(item["recursion"], dict, "recursion")
        if set(recursion) != {"delegation_allowed", "authorization"}:
            fail("recursion receipt incomplete")
        if item["model"] == "gpt-5.6-luna" and recursion["delegation_allowed"]:
            fail("Luna may not delegate")
        if item["model"] == "gpt-5.6-terra" and recursion["delegation_allowed"] and recursion["authorization"] != "nested_terra_to_luna_authorized":
            fail("nested Terra-to-Luna delegation requires authorization")
        if item["kind"] == "root" and item["write_scopes"]:
            fail("root task write is forbidden by root write lock")
        if item["kind"] == "reviewer":
            reviewers[assignment_id] = item
        if item["kind"] == "executor":
            executors.append(item)
            if not item["write_scopes"]:
                fail("executor requires a bounded write scope")
            for scope in item["write_scopes"]:
                for existing_scope, existing_id in write_scopes:
                    if scopes_overlap(scope, existing_scope):
                        fail(f"overlapping write scopes: {existing_id} and {assignment_id}")
                write_scopes.append((scope, assignment_id))
    for executor in executors:
        reviewer_id = executor["reviewer_assignment_id"]
        if reviewer_id not in reviewers:
            fail("executor lacks an independent reviewer")
        if reviewers[reviewer_id]["agent_id"] == executor["agent_id"]:
            fail("executor reviewer must be independent")
        if reviewers[reviewer_id]["call_id"] == executor["call_id"]:
            fail("executor reviewer must use a distinct physical call")
    return assignments, executors, reviewers


def validate_nested_terra_luna(assignments: list[dict[str, Any]], budget: dict[str, int]) -> None:
    by_id = {item["assignment_id"]: item for item in assignments}
    terra_parents = [item for item in assignments if item["model"] == "gpt-5.6-terra" and item["recursion"]["delegation_allowed"]]
    luna_assignments = [item for item in assignments if item["model"] == "gpt-5.6-luna"]
    luna_children = [item for item in luna_assignments if item["parent_assignment_id"] is not None or item["delegation_reference"] is not None]
    children_by_parent: dict[str, list[dict[str, Any]]] = {}
    for child in luna_children:
        parent_id = child["parent_assignment_id"]
        if parent_id is None or child["delegation_reference"] is None or parent_id not in by_id or by_id[parent_id]["model"] != "gpt-5.6-terra":
            fail("Luna assignment requires a Terra parent assignment")
        if child["kind"] != "executor" or child["role"] != LUNA_MECHANICAL_ROLE or child["effort"] != "medium" or not child["write_scopes"]:
            fail("Luna child must be a prescribed mechanical executor with scope and parent reference")
        children_by_parent.setdefault(parent_id, []).append(child)
    for parent in terra_parents:
        if parent["recursion"]["authorization"] != "nested_terra_to_luna_authorized":
            fail("nested Terra-to-Luna delegation requires authorization")
        if len(children_by_parent.get(parent["assignment_id"], [])) != 1:
            fail("authorized Terra delegation requires exactly one Luna child")
    if terra_parents:
        physical_assignments = [item for item in assignments if is_physical(item)]
        if budget["max_agents"] != 3 or budget["active_count"] != 3 or len(physical_assignments) != 3:
            fail("authorized Terra-to-Luna nesting requires an exact physical budget of three")
        for parent in terra_parents:
            child = children_by_parent[parent["assignment_id"]][0]
            reviewer_id = parent["reviewer_assignment_id"]
            if parent["kind"] != "executor" or not is_physical(parent) or not is_physical(child) or reviewer_id not in by_id or not is_physical(by_id[reviewer_id]):
                fail("authorized Terra-to-Luna nesting requires physical Terra executor, Luna child, and independent reviewer")
    for luna in luna_assignments:
        if luna["recursion"]["delegation_allowed"]:
            fail("Luna may not delegate")
        if luna in luna_children:
            continue
        if luna["role"] in {"research", "explorer"}:
            if luna["kind"] != "reviewer" or luna["effort"] != "low" or luna["write_scopes"] or luna["reviewer_assignment_id"] is not None:
                fail("direct Luna research must be a low read-only leaf")
        elif luna["role"] == LUNA_MECHANICAL_ROLE:
            if luna["kind"] != "executor" or luna["effort"] != "medium" or not luna["write_scopes"]:
                fail("direct Luna mechanical work must be a bounded medium executor")
        else:
            fail("direct Luna role is not approved")
    for item in assignments:
        if item["model"] != "gpt-5.6-luna" and (item["parent_assignment_id"] is not None or item["delegation_reference"] is not None):
            fail("only a Luna child may declare a parent delegation reference")


def validate(receipt: dict[str, Any], schema: dict[str, Any]) -> None:
    basic_schema(receipt, schema)
    capability = require(receipt["capability_proof"], dict, "capability_proof")
    if set(capability) != {"collaboration_available", "spawn_api", "checked_at"} or capability["spawn_api"] != "collaboration.spawn_agent":
        fail("capability proof is incomplete")
    budget = require(receipt["budget"], dict, "budget")
    if set(budget) != {"max_agents", "active_count"} or not all(type(budget[key]) is int for key in budget) or not 0 <= budget["max_agents"] <= 3 or not 0 <= budget["active_count"] <= budget["max_agents"]:
        fail("delegation budget must be 0..3 and cover active count")
    exceptions = require(receipt["exceptions"], list, "exceptions")
    allowed_exceptions = {"explicit_user_opt_out", "collaboration_unavailable", "spawn_failed_operator_authorized"}
    for exception in exceptions:
        if set(require(exception, dict, "exception")) != {"code", "proof", "compensation"} or exception["code"] not in allowed_exceptions or not exception["proof"] or not exception["compensation"]:
            fail("exception requires allowed code, proof, and compensation")
        if exception["code"] == "spawn_failed_operator_authorized" and "root" in exception["compensation"].lower():
            fail("spawn failure cannot silently fall back to root execution")
        if exception["code"] == "collaboration_unavailable" and capability["collaboration_available"]:
            fail("collaboration_unavailable conflicts with available collaboration capability")
    if exceptions and receipt["state"] not in {"HARDENING", "SPEC_READY", "TASKS_READY", "ROUTE_SELECTED", "DISPATCH_REQUIRED"}:
        fail("exception path must remain blocked before dispatch and cannot close or promote")
    if receipt["state"] == "TASKS_READY" and receipt["execution_requested"]:
        fail("execution cannot stop at TASKS_READY")
    route = receipt["route"]
    assignments = receipt["assignments"]
    assignments, executors, reviewers = validate_assignments(receipt)
    physical_assignments = [item for item in assignments if is_physical(item)]
    if budget["active_count"] != len(physical_assignments):
        fail("active_count must equal physical assignments")
    if route == "direct-fast-path" and (assignments or budget["max_agents"] != 0):
        fail("direct-fast-path requires zero spawn assignments")
    if route == "scoped" and (len(assignments) > 1 or budget["max_agents"] > 1):
        fail("scoped route permits at most one sidecar")
    if route == "scoped" and any(item["kind"] == "executor" or item["write_scopes"] for item in assignments):
        fail("scoped sidecars are read-only and may not implement task-owned work")
    if route == "orchestrated" and receipt["execution_requested"] and capability["collaboration_available"] and not exceptions:
        physical_executors = [item for item in executors if is_physical(item)]
        physical_reviewers = [item for item in reviewers.values() if is_physical(item)]
        if not physical_executors or not physical_reviewers:
            fail("orchestrated execution requires a physical executor and independent physical reviewer")
        if any(not is_physical(reviewers[executor["reviewer_assignment_id"]]) for executor in physical_executors):
            fail("each physical executor requires its own physical reviewer assignment")
        if budget["max_agents"] < 2:
            fail("orchestrated physical dispatch requires budget for executor and reviewer")
        if receipt["state"] in {"HARDENING", "SPEC_READY", "TASKS_READY", "ROUTE_SELECTED", "DISPATCH_REQUIRED"}:
            fail("orchestrated execution must be dispatched before task-owned writes")
    validate_nested_terra_luna(assignments, budget)
    fan_in = require(receipt["fan_in"], dict, "fan_in")
    if fan_in.get("owner") != "root" or set(fan_in.get("assignment_ids", [])) != {item["assignment_id"] for item in assignments}:
        fail("fan-in must be root-owned and name every assignment")
    lock = require(receipt["root_write_lock"], dict, "root_write_lock")
    dispatched_scopes = lock.get("dispatched_task_scopes")
    if set(lock) != {"mode", "task_owned_writes_forbidden", "dispatched_task_scopes"} or not isinstance(dispatched_scopes, list) or len(set(dispatched_scopes)) != len(dispatched_scopes) or any(not isinstance(scope, str) or not scope for scope in dispatched_scopes):
        fail("root write lock receipt is incomplete")
    if route in {"direct-fast-path", "scoped"}:
        if lock["mode"] != "root-owned" or lock["task_owned_writes_forbidden"] is not False or dispatched_scopes:
            fail("direct and scoped root-owned work must not claim an orchestrated task lock")
    else:
        assigned_scopes = [scope for executor in executors for scope in executor["write_scopes"]]
        if lock["mode"] != "orchestrated-dispatched-scope-lock" or lock["task_owned_writes_forbidden"] is not True:
            fail("orchestrated dispatch requires an enabled root lock")
        if set(dispatched_scopes) != set(assigned_scopes):
            fail("orchestrated root lock must cover exactly the dispatched executor scopes")


def main() -> int:
    try:
        if len(sys.argv) != 2:
            fail("usage: validate-delegation-dispatch-receipt.py RECEIPT.json")
        schema = json.loads(resolve_schema_path().read_text())
        receipt = json.loads(Path(sys.argv[1]).read_text())
        validate(receipt, schema)
    except (OSError, json.JSONDecodeError, ValueError) as error:
        print(f"delegation dispatch receipt invalid: {error}", file=sys.stderr)
        return 1
    print("delegation dispatch receipt passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
