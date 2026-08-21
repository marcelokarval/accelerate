#!/usr/bin/env python3
"""Validate a secret-free staged Hermes delegation receipt."""
from __future__ import annotations

import json
import hashlib
import re
import sys
from pathlib import Path
from typing import Any


REPO = Path(__file__).resolve().parents[1]
MANIFEST = REPO / "adapters/runtime/hermes/hermes-delegate-task.manifest.json"


def fail(message: str) -> None:
    raise ValueError(message)


def load(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        fail(f"cannot read {path}: {error}")
    if not isinstance(value, dict):
        fail("receipt must be an object")
    return value


def nonempty(value: Any) -> bool:
    return isinstance(value, str) and bool(value.strip())


def evidence(value: Any, label: str) -> None:
    if not isinstance(value, dict) or not nonempty(value.get("locator")) or not re.fullmatch(r"[0-9a-f]{64}", str(value.get("sha256", ""))) or not re.fullmatch(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z", str(value.get("readback_at", ""))):
        fail(f"{label} requires native routing/result evidence")
    if not re.fullmatch(r"(?:hermes|pg|file)://[^\s]+", value["locator"]):
        fail(f"{label} requires an identifiable locator")


def validate(receipt: dict[str, Any], manifest: dict[str, Any]) -> None:
    if receipt.get("adapter") != manifest["adapter"]:
        fail("wrong adapter")
    policy_cap = manifest.get("policy_cap")
    if not isinstance(policy_cap, int) or not 0 <= policy_cap <= 3:
        fail("adapter policy cap must be an integer from zero through three")
    tasks = receipt.get("tasks")
    if not isinstance(tasks, list) or not tasks:
        fail("tasks are required")
    roles = {item.get("agent_role") for item in tasks if isinstance(item, dict)}
    if len(roles) != 1 or not all(nonempty(role) for role in roles):
        fail("batch requires homogeneous agent_role")
    if len(tasks) > policy_cap:
        fail("policy cap exceeded")
    if any(item.get("toolsets") != "inherited" for item in tasks):
        fail("child toolsets must be inherited")
    assignment = receipt.get("assignment")
    if not isinstance(assignment, dict) or assignment.get("role_kind") not in manifest["assignment"]["role_kind"]:
        fail("role_kind must be leaf or orchestrator")
    depth = assignment.get("depth")
    if type(depth) is not int or depth < 0:
        fail("assignment depth is invalid")
    if depth > manifest["assignment"]["max_depth"] and assignment.get("nested_root_grant") is not True:
        fail("nested delegation requires explicit root grant")
    lock = receipt.get("root_write_lock")
    if not isinstance(lock, dict) or lock.get("native") != "unsupported" or lock.get("adapter") != "prompt-contract-only":
        fail("native root-write-lock is unsupported; adapter prompt contract is required")
    execution = receipt.get("execution")
    if not isinstance(execution, dict) or execution.get("canary_phase") != "sync-first":
        fail("sync-first canary is required")
    execution_state = execution.get("execution_state")
    delivery_state = execution.get("delivery_state")
    if execution_state not in {"completed", "failed", "interrupted", "unknown"}:
        fail("native execution_state is required; adapter states must be namespaced and mapped")
    native_delivery = {"delivery_intent", "delivery_unknown", "dead_lettered", "replay_requested", "dropped", "discarded", "delivered", "pending"}
    if delivery_state not in native_delivery | {"adapter:sync_result_received"}:
        fail("native delivery_state or documented adapter sync projection is required")
    if execution_state == "unknown" or delivery_state == "delivery_unknown":
        fail("ambiguous execution or delivery state blocks closure")
    if execution.get("effective_mode") not in {"sync", "async"}:
        fail("effective execution mode is invalid")
    if execution.get("effective_mode") != "sync":
        fail("sync-first canary requires effective sync mode")
    if delivery_state != "adapter:sync_result_received":
        fail("sync-first canary requires adapter:sync_result_received")
    projection = execution.get("sync_projection")
    if not isinstance(projection, dict) or projection.get("source") != "combined_results_and_route_receipt" or projection.get("derivation") != "adapter-derived" or projection.get("reconciliation") is not True:
        fail("sync-first canary requires adapter-derived reconciliation")
    if execution_state != "completed":
        fail("non-completed execution or non-delivered result blocks closure")
    lineage = receipt.get("postgres_lineage")
    if not isinstance(lineage, dict) or lineage.get("state_backend") != "postgres" or not nonempty(lineage.get("parent_session_id")):
        fail("PostgreSQL child lineage is required")
    children = lineage.get("child_session_ids")
    if not isinstance(children, list) or len(children) != len(tasks) or not all(nonempty(item) for item in children):
        fail("PostgreSQL child lineage must cover every task")
    if len(set(children)) != len(children) or lineage["parent_session_id"] in children:
        fail("PostgreSQL child lineage requires unique PostgreSQL child IDs distinct from the parent")
    proof_class = lineage.get("proof_class")
    if proof_class not in {"static-shape", "live-postgres"}:
        fail("PostgreSQL lineage proof_class is required")
    if proof_class != "static-shape":
        fail("live-postgres proof is not allowed in static capability validation")
    routing = receipt.get("routing")
    if not isinstance(routing, dict):
        fail("requested/effective provider, model, and reasoning_effort receipt is required")
    requested, effective = routing.get("requested"), routing.get("effective")
    if not isinstance(requested, dict) or not isinstance(effective, dict):
        fail("requested/effective provider, model, and reasoning_effort receipt is required")
    policy_refs = requested.get("policy_refs")
    if not isinstance(policy_refs, dict) or any(not nonempty(requested.get(field)) for field in ("provider", "model", "reasoning_effort")):
        fail("requested provider, model, and reasoning_effort must bind to policy refs")
    for field in ("provider", "model", "reasoning_effort"):
        ref = policy_refs.get(field)
        if not isinstance(ref, dict) or not isinstance(ref.get("path"), str) or not re.fullmatch(r"[0-9a-f]{64}", str(ref.get("sha256", ""))):
            fail("policy ref path/hash is required")
        path = (REPO / ref["path"]).resolve()
        if REPO not in path.parents or not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != ref["sha256"]:
            fail("policy ref path/hash does not resolve")
    if not nonempty(effective.get("provider")) or not nonempty(effective.get("model")):
        fail("effective provider and model are required")
    effort = effective.get("reasoning_effort")
    if effort != "unknown" and not nonempty(effort):
        fail("effective reasoning_effort must be nonempty or unknown")
    evidence(routing.get("native_evidence"), "effective provider, model, and reasoning_effort")


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: validate-hermes-delegate-task.py RECEIPT.json", file=sys.stderr)
        return 2
    manifest = load(MANIFEST)
    validate(load(Path(sys.argv[1])), manifest)
    print("PASS: staged Hermes delegate_task receipt validated")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except ValueError as error:
        print(f"FAIL: {error}", file=sys.stderr)
        raise SystemExit(1)
