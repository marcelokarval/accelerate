#!/usr/bin/env python3
"""Fail-closed validation for source-only task graph and heartbeat receipts."""
from __future__ import annotations

import json
import hashlib
import unicodedata
import sys
from datetime import datetime, timedelta
from pathlib import Path
from typing import Any

from jsonschema import Draft202012Validator, FormatChecker


REPO = Path(__file__).resolve().parents[1]
GRAPH_SCHEMA = REPO / "assets/schemas/task-graph-v1.schema.json"
HEARTBEAT_SCHEMA = REPO / "assets/schemas/development-heartbeat-v1.schema.json"


def fail(message: str) -> None:
    raise ValueError(message)


def reject_duplicates(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for key, value in pairs:
        if key in result:
            fail(f"duplicate key: {key}")
        result[key] = value
    return result


def load(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"), object_pairs_hook=reject_duplicates)
    except (OSError, json.JSONDecodeError, ValueError) as error:
        fail(f"cannot read JSON {path}: {error}")
    if not isinstance(value, dict):
        fail(f"JSON document must be an object: {path}")
    return value


def schema_validate(value: dict[str, Any], schema_path: Path, label: str) -> None:
    schema = load(schema_path)
    errors = sorted(Draft202012Validator(schema, format_checker=FormatChecker()).iter_errors(value), key=lambda error: list(error.absolute_path))
    if errors:
        location = ".".join(str(part) for part in errors[0].absolute_path) or "root"
        fail(f"{label} schema invalid at {location}: {errors[0].message}")


def overlaps(left: str, right: str) -> bool:
    return left == right or left.startswith(right + "/") or right.startswith(left + "/")


def canonical_repo_path(path: str) -> str:
    if not path or path.startswith("/") or "\\" in path or path.endswith("/") or any(unicodedata.category(char) == "Cc" for char in path):
        fail(f"noncanonical repository path: {path!r}")
    segments = path.split("/")
    if any(segment in {"", ".", ".."} for segment in segments):
        fail(f"noncanonical repository path: {path!r}")
    return "/".join(segments)


def reachable(start: str, target: str, by_id: dict[str, dict[str, Any]]) -> bool:
    todo = list(by_id[start]["depends_on"])
    seen: set[str] = set()
    while todo:
        node_id = todo.pop()
        if node_id == target:
            return True
        if node_id not in seen:
            seen.add(node_id)
            todo.extend(by_id[node_id]["depends_on"])
    return False


def validate_graph(graph: dict[str, Any]) -> None:
    schema_validate(graph, GRAPH_SCHEMA, "task graph")
    nodes = graph["nodes"]
    by_id = {node["node_id"]: node for node in nodes}
    if len(by_id) != len(nodes):
        fail("duplicate node ID")
    semantic_ids = [node["semantic_id"] for node in nodes]
    if len(set(semantic_ids)) != len(semantic_ids):
        fail("duplicate semantic ID")
    assignment_ids = [node["assignment_id"] for node in nodes]
    if len(set(assignment_ids)) != len(assignment_ids):
        fail("duplicate graph assignment ID")
    for node in nodes:
        for dependency in node["depends_on"]:
            if dependency not in by_id:
                fail(f"dangling dependency: {dependency}")
    for node_id in by_id:
        if reachable(node_id, node_id, by_id):
            fail(f"cycle at node: {node_id}")
    for index, left in enumerate(nodes):
        for right in nodes[index + 1:]:
            left_scopes = [canonical_repo_path(scope) for scope in left["write_scopes"]]
            right_scopes = [canonical_repo_path(scope) for scope in right["write_scopes"]]
            if any(overlaps(a, b) for a in left_scopes for b in right_scopes):
                if not (reachable(left["node_id"], right["node_id"], by_id) or reachable(right["node_id"], left["node_id"], by_id)):
                    fail(f"overlapping write scopes require serialization: {left['node_id']} and {right['node_id']}")
    dirty_paths = [canonical_repo_path(path) for field in ("staged_paths", "unstaged_paths", "untracked_paths") for path in graph["baseline"]["git_snapshot"][field]]
    for path in dirty_paths:
        for node in nodes:
            if any(overlaps(path, canonical_repo_path(scope)) for scope in node["write_scopes"]):
                fail(f"baseline dirty path overlaps node write scope: {path} and {node['node_id']}")


def parse_instant(value: str, label: str) -> datetime:
    try:
        instant = datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError as error:
        fail(f"invalid {label}: {error}")
    if instant.tzinfo is None:
        fail(f"{label} must include a timezone")
    return instant


def validate_heartbeat(graph: dict[str, Any], heartbeat: dict[str, Any], now: datetime, heartbeat_path: Path) -> None:
    schema_validate(heartbeat, HEARTBEAT_SCHEMA, "heartbeat")
    if heartbeat["graph_id"] != graph["graph_id"]:
        fail("graph ID mismatch")
    if heartbeat["graph_baseline"] != graph["baseline"]:
        fail("baseline mismatch")
    if heartbeat["sequence"] <= heartbeat["previous_sequence"]:
        fail("regressive heartbeat sequence")
    if heartbeat["observed_graph_state"] != graph["state"]:
        fail("state mismatch")
    observed_at = parse_instant(heartbeat["observed_at"], "observed_at")
    expires_at = parse_instant(heartbeat["expires_at"], "expires_at")
    if expires_at < observed_at or expires_at - observed_at > timedelta(minutes=15):
        fail("heartbeat expiry must be within a 15-minute observed window")
    if now < observed_at:
        fail("now is before observed_at")
    if now > expires_at:
        fail("heartbeat expired")
    nodes_by_id = {node["node_id"]: node for node in graph["nodes"]}
    if heartbeat["subject"]["node_id"] not in nodes_by_id:
        fail("subject node does not exist in graph")
    node = nodes_by_id[heartbeat["subject"]["node_id"]]
    if heartbeat["subject"]["assignment_id"] != node["assignment_id"]:
        fail("subject assignment does not match selected graph node")
    if heartbeat["subject"]["candidate_sha256"] != node["candidate_sha256"]:
        fail("subject candidate does not match selected graph node")
    receipt = heartbeat["subject"]["dispatch_receipt"]
    locator = canonical_repo_path(receipt["locator"])
    receipt_base = heartbeat_path.parent.resolve()
    receipt_path = receipt_base / locator
    component = receipt_base
    for segment in locator.split("/"):
        component /= segment
        if component.is_symlink():
            fail("dispatch receipt locator contains a symlink component")
    resolved_receipt = receipt_path.resolve()
    try:
        resolved_receipt.relative_to(receipt_base)
    except ValueError:
        fail("dispatch receipt locator escapes heartbeat parent")
    if receipt_path.is_symlink() or not receipt_path.is_file():
        fail("dispatch receipt must be a regular non-symlink file")
    if hashlib.sha256(receipt_path.read_bytes()).hexdigest() != receipt["sha256"]:
        fail("dispatch receipt digest mismatch")
    for field in ("assignment_id", "agent_id", "call_id", "observed_fence_token"):
        if not heartbeat["subject"][field]:
            fail(f"subject {field} must identify a physical observation")
    trigger_ids = {trigger["trigger_id"] for trigger in heartbeat["triggers"]}
    if len(trigger_ids) != len(heartbeat["triggers"]):
        fail("duplicate heartbeat trigger ID")
    reanalysis = heartbeat["reanalysis"]
    if set(reanalysis["trigger_ids"]) != trigger_ids:
        fail("reanalysis trigger IDs must exactly match observed triggers")
    git_changed = heartbeat["observed_repository_snapshot"] != graph["baseline"]["git_snapshot"]
    operation = heartbeat["observed_repository_snapshot"]["operation_state"]
    operational_git_state = operation["kind"] != "none" or bool(operation["conflict_paths"])
    git_triggered = any(trigger["kind"] == "git-change" for trigger in heartbeat["triggers"])
    if (git_changed or operational_git_state) and not git_triggered:
        fail("git-change trigger required for changed repository snapshot or operation state")
    if git_triggered and not git_changed and not operational_git_state:
        fail("unjustified git-change trigger without snapshot delta or operation state")
    conflict_paths = [canonical_repo_path(path) for path in operation["conflict_paths"]]
    conflict_touches_write_scope = any(overlaps(path, canonical_repo_path(scope)) for path in conflict_paths for node in graph["nodes"] for scope in node["write_scopes"])
    if conflict_touches_write_scope and graph["state"] != "BLOCKED":
        fail("conflict path overlapping a node write scope requires BLOCKED graph state")
    reanalysis_required_state = graph["state"] in {"STALE_REANALYSIS_REQUIRED", "BLOCKED"}
    if bool(trigger_ids) != (reanalysis["status"] == "required") or reanalysis_required_state != (reanalysis["status"] == "required"):
        fail("reanalysis status is stale or inconsistent with observations")
    if graph["state"] in {"SUPERSEDED", "CANCELLED"} and trigger_ids:
        fail("terminal graph heartbeat cannot claim a new reanalysis trigger")


def main() -> int:
    try:
        if len(sys.argv) != 4:
            fail("usage: validate-task-graph-heartbeat.py TASK_GRAPH.json HEARTBEAT.json NOW_ISO8601")
        graph = load(Path(sys.argv[1]))
        heartbeat_path = Path(sys.argv[2])
        heartbeat = load(heartbeat_path)
        validate_graph(graph)
        validate_heartbeat(graph, heartbeat, parse_instant(sys.argv[3], "NOW_ISO8601"), heartbeat_path)
    except (OSError, ValueError) as error:
        print(f"task graph heartbeat invalid: {error}", file=sys.stderr)
        return 1
    print("task graph heartbeat passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
