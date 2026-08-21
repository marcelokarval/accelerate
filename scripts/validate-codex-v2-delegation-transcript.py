#!/usr/bin/env python3
"""Fail-closed validation for Codex V2 delegation transcript evidence.

Evidence tiers are deliberately distinct: canonical fixtures exercise parser
logic; raw ``codex exec --json`` is only live evidence when every required
event can be observed. This parser is not a runtime write firewall.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any


MODELS = {"gpt-5.6-sol", "gpt-5.6-terra", "gpt-5.6-luna"}
ROUTES = {"direct-fast-path", "scoped", "orchestrated"}


def fail(message: str) -> None:
    raise ValueError(message)


def load_records(path: Path) -> list[dict[str, Any]]:
    try:
        lines = [line for line in path.read_text().splitlines() if line.strip()]
    except OSError as error:
        fail(f"cannot read transcript: {error}")
    if not lines:
        fail("empty transcript")
    records: list[dict[str, Any]] = []
    for number, line in enumerate(lines, 1):
        try:
            value = json.loads(line)
        except json.JSONDecodeError as error:
            fail(f"line {number}: invalid JSONL ({error.msg})")
        if not isinstance(value, dict):
            fail(f"line {number}: JSONL item must be an object")
        if value.get("type") == "delegation_canary_envelope":
            enclosed = value.get("events")
            if not isinstance(enclosed, list) or not all(isinstance(event, dict) for event in enclosed):
                fail(f"line {number}: canonical envelope requires object events")
            for event in enclosed:
                event = dict(event)
                event["__canonical_evidence_tier"] = value.get("evidence_tier")
                event["__canonical_origin"] = value.get("origin")
                records.append(event)
        else:
            records.append(value)
    return records


def canonical_events(records: list[dict[str, Any]]) -> list[dict[str, Any]] | None:
    if all(record.get("type") == "delegation_canary_event" and record.get("version") == 1 for record in records):
        return records
    return None


def raw_item(record: dict[str, Any]) -> dict[str, Any] | None:
    """Support archive response_item and codex-exec item.completed envelopes."""
    if record.get("type") == "response_item" and isinstance(record.get("payload"), dict):
        return record["payload"]
    if record.get("type") in {"item.started", "item.completed"} and isinstance(record.get("item"), dict):
        return record["item"]
    if record.get("type") in {"function_call", "function_call_output", "custom_tool_call", "custom_tool_call_output"}:
        return record
    return None


def parse_object(value: Any) -> dict[str, Any]:
    if isinstance(value, dict):
        return value
    if not isinstance(value, str):
        return {}
    try:
        parsed = json.loads(value)
    except json.JSONDecodeError:
        return {}
    return parsed if isinstance(parsed, dict) else {}


def call_name(item: dict[str, Any]) -> str:
    return str(item.get("name") or item.get("tool_name") or item.get("call") or "").split(".")[-1]


def bounded_fork(value: Any) -> bool:
    if value == "none":
        return True
    if isinstance(value, bool):
        return False
    if isinstance(value, int):
        return 1 <= value <= 5
    return isinstance(value, str) and value.isdigit() and 1 <= int(value) <= 5


def raw_codex_calls(records: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """Extract structured tool envelopes only; prompt/message text is never read."""
    outputs: dict[str, dict[str, Any]] = {}
    calls: list[dict[str, Any]] = []
    supported = False
    for index, record in enumerate(records):
        item = raw_item(record)
        if not item:
            continue
        kind = item.get("type")
        if kind in {"function_call", "custom_tool_call"}:
            supported = True
            calls.append({"index": index, "name": call_name(item), "call_id": item.get("call_id"), "args": parse_object(item.get("arguments") or item.get("input"))})
        elif kind in {"function_call_output", "custom_tool_call_output"}:
            supported = True
            call_id = item.get("call_id")
            if isinstance(call_id, str):
                outputs[call_id] = parse_object(item.get("output") or item.get("result"))
    standard_envelope = any(record.get("type") in {"thread.started", "turn.started", "turn.completed", "item.started", "item.completed"} for record in records)
    if not supported and not standard_envelope:
        fail("unsupported raw Codex JSONL envelope: expected standard Codex event or tool envelope")
    for call in calls:
        call["output"] = outputs.get(call["call_id"], {})
    return calls


def validate_live(records: list[dict[str, Any]], expected_route: str | None, task_scopes: list[str], requested_model: str | None, requested_effort: str | None) -> tuple[str, dict[str, Any]]:
    if expected_route not in {"orchestrated", "luna-leaf"}:
        fail("live validation requires trusted --expected-route orchestrated or luna-leaf")
    if requested_model not in MODELS or requested_effort not in {"low", "medium", "high"}:
        fail("live validation requires trusted requested root model and reasoning effort")
    if expected_route == "orchestrated" and (requested_model not in {"gpt-5.6-sol", "gpt-5.6-terra"} or requested_effort != "medium"):
        fail("orchestrated live canary requires requested Sol/medium or Terra/medium root")
    if expected_route == "luna-leaf" and (requested_model != "gpt-5.6-luna" or requested_effort != "low"):
        fail("Luna leaf canary requires requested gpt-5.6-luna/low root")
    calls = raw_codex_calls(records)
    writes = [call for call in calls if call["name"] in {"apply_patch", "exec_command", "write_stdin"}]
    spawns = [call for call in calls if call["name"] == "spawn_agent"]
    if expected_route == "luna-leaf":
        event_types = {str(record.get("type", "")) for record in records}
        if "turn.completed" not in event_types:
            fail("Luna leaf canary requires a completed raw Codex turn")
        if any(event_type == "error" or event_type.endswith(".failed") or event_type.endswith(".error") for event_type in event_types):
            fail("Luna leaf canary rejects failed/error raw Codex turns")
        if spawns or writes:
            fail("Luna leaf canary must reopen without delegation or implementation mutation")
        return "luna-leaf-reopen-no-mutation", {"spawn_overrides": [], "root_tool_calls": len(calls)}
    if len(spawns) < 2:
        fail("raw live evidence requires executor and reviewer spawn calls")
    executor = next((call for call in spawns if "executor" in str(call["args"].get("task_name", "")).lower()), None)
    reviewer = next((call for call in spawns if "review" in str(call["args"].get("task_name", "")).lower()), None)
    if not executor or not reviewer or executor is reviewer:
        fail("raw live task names must identify independent executor and reviewer")
    for label, call in (("executor", executor), ("reviewer", reviewer)):
        args = call["args"]
        if not call["call_id"] or args.get("model") not in MODELS or args.get("reasoning_effort") not in {"low", "medium", "high"} or not bounded_fork(args.get("fork_turns")):
            fail(f"raw live {label} spawn lacks explicit model, reasoning_effort, or bounded fork_turns")
    if executor["call_id"] == reviewer["call_id"] or executor["args"].get("task_name") == reviewer["args"].get("task_name"):
        fail("raw live executor/reviewer spawn call IDs and task names must be distinct")
    first_write = min((call["index"] for call in writes), default=None)
    if first_write is not None and (executor["index"] >= first_write or reviewer["index"] >= first_write):
        fail("both physical spawns must precede any root write tool")
    if any(scope in json.dumps(call["args"], sort_keys=True) for scope in task_scopes for call in writes):
        fail("root write tool targeted the child-owned canary task scope")
    fail("raw live completion/reviewer ordering proof unsupported without API-faithful mailbox/final-status envelopes")


def require_event(event: dict[str, Any], name: str, index: int) -> None:
    if event.get("event") != name:
        fail(f"event {index + 1}: expected {name}")


def scope_overlaps(left: str, right: str) -> bool:
    left, right = left.rstrip("/"), right.rstrip("/")
    return left == right or left.startswith(right + "/") or right.startswith(left + "/")


def validate_spawn(event: dict[str, Any], index: int) -> None:
    required = {"role", "agent_id", "call_id", "task_id", "model", "reasoning_effort", "fork_turns", "write_scopes"}
    missing = sorted(field for field in required if field not in event or event[field] in (None, ""))
    if missing:
        fail(f"spawn at event {index + 1} missing override/evidence fields: {', '.join(missing)}")
    if event["model"] not in MODELS or event["reasoning_effort"] not in {"low", "medium", "high"}:
        fail(f"spawn at event {index + 1} has unsupported model or reasoning effort")
    if not bounded_fork(event["fork_turns"]):
        fail(f"spawn at event {index + 1} must set bounded fork_turns: none or 1..5")
    if not isinstance(event["write_scopes"], list) or not all(isinstance(scope, str) and scope for scope in event["write_scopes"]):
        fail(f"spawn at event {index + 1} has invalid write scopes")
    if event["agent_id"] == "virtual" or event["call_id"] == "virtual":
        fail("virtual-only delegation is not physical dispatch evidence")


def validate(events: list[dict[str, Any]], tier: str) -> str:
    if not events:
        fail("no delegation evidence events found")
    for event in events:
        if not isinstance(event, dict) or event.get("type") != "delegation_canary_event" or event.get("version") != 1:
            fail("unsupported transcript event envelope")
    tasks = [index for index, event in enumerate(events) if event.get("event") == "tasks_ready"]
    if not tasks:
        fail("TASKS_READY route marker is missing")
    route_events = [(index, event) for index, event in enumerate(events) if event.get("event") == "route_selected"]
    route = next((event.get("route") for event in events if event.get("event") == "tasks_ready"), None)
    if route_events:
        route = route_events[-1][1].get("route")
    if route not in ROUTES:
        fail("route marker must name direct-fast-path, scoped, or orchestrated")
    spawns = [(index, event) for index, event in enumerate(events) if event.get("event") == "spawn_agent"]
    writes = [(index, event) for index, event in enumerate(events) if event.get("event") == "implementation_write"]
    opt_out = [event for event in events if event.get("event") == "explicit_opt_out" and isinstance(event.get("receipt"), str) and event["receipt"].strip()]
    if len(events) == 1 and events[0].get("event") == "tasks_ready":
        return "planning-only"
    if opt_out:
        if spawns or writes:
            fail("explicit opt-out receipt cannot conceal dispatch or task writes")
        return "explicit-opt-out"
    if route == "direct-fast-path":
        if spawns:
            fail("direct-fast-path must have zero spawn events")
        return "direct-fast-path"
    if route == "scoped":
        if len(spawns) > 1:
            fail("scoped route permits at most one sidecar")
        for index, spawn in spawns:
            validate_spawn(spawn, index)
        return "scoped"
    if not route_events or route_events[0][0] < tasks[0]:
        fail("orchestrated route marker must follow TASKS_READY")
    if not spawns:
        fail("orchestrated execution has no physical spawn")
    for index, spawn in spawns:
        validate_spawn(spawn, index)
    executors = [(index, event) for index, event in spawns if event.get("role") == "executor"]
    reviewers = [(index, event) for index, event in spawns if event.get("role") == "reviewer"]
    if not executors:
        fail("orchestrated execution requires an executor spawn")
    if not reviewers:
        fail("orchestrated execution requires an independent reviewer spawn")
    first_write = min((index for index, _ in writes), default=None)
    for index, _ in spawns:
        if index <= route_events[0][0] or (first_write is not None and index >= first_write):
            fail("all required spawn events must occur after route selection and before first task write")
    executor_ids = {event["agent_id"] for _, event in executors}
    reviewer_ids = {event["agent_id"] for _, event in reviewers}
    if executor_ids & reviewer_ids or len(executor_ids) != len(executors) or len(reviewer_ids) != len(reviewers):
        fail("executor and reviewer IDs must be distinct and independent")
    scopes: list[tuple[str, str]] = []
    for _, executor in executors:
        if not executor["write_scopes"]:
            fail("executor requires a bounded task-owned write scope")
        for scope in executor["write_scopes"]:
            if any(scope_overlaps(scope, existing) for existing, _ in scopes):
                fail("executor task write scopes must be disjoint")
            scopes.append((scope, executor["agent_id"]))
    if any(reviewer["write_scopes"] for _, reviewer in reviewers):
        fail("reviewer scope must be read-only and disjoint from implementation ownership")
    if not writes:
        fail("orchestrated transcript has no task-owned implementation write")
    for index, write in writes:
        actor, scope = write.get("actor_id"), write.get("scope")
        if not isinstance(scope, str) or not scope:
            fail(f"write at event {index + 1} has no scope")
        owner = next((agent for owned_scope, agent in scopes if scope_overlaps(scope, owned_scope)), None)
        if actor == "root" and owner:
            fail("root wrote a task-owned implementation scope")
        if actor not in executor_ids or actor != owner:
            fail("first task-owned implementation write must belong to its executor")
    returns = {event.get("agent_id"): index for index, event in enumerate(events) if event.get("event") == "agent_return"}
    if not executor_ids <= returns.keys():
        fail("executor return is missing")
    if not reviewer_ids <= returns.keys():
        fail("reviewer return is missing")
    if min(returns[reviewer] for reviewer in reviewer_ids) <= max(returns[executor] for executor in executor_ids):
        fail("reviewer evidence must return after executor return")
    review = [index for index, event in enumerate(events) if event.get("event") == "root_review_of_review" and event.get("actor_id") == "root"]
    closure = [index for index, event in enumerate(events) if event.get("event") == "closure_marker" and event.get("actor_id") == "root"]
    if not review or not closure or review[-1] <= max(returns.values()) or closure[-1] <= review[-1]:
        fail("root review-of-review and subsequent closure marker are required")
    return "orchestrated"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--tier", choices=("auto", "static", "fixture", "live"), default="auto")
    parser.add_argument("--expected-route", choices=("orchestrated", "luna-leaf"))
    parser.add_argument("--task-scope", action="append", default=[])
    parser.add_argument("--requested-root-model")
    parser.add_argument("--requested-root-effort")
    parser.add_argument("transcript", type=Path)
    args = parser.parse_args()
    try:
        records = load_records(args.transcript)
        events = canonical_events(records)
        source = "canonical" if events is not None else "raw-codex-jsonl"
        if args.tier == "live":
            if events is not None:
                fail("canonical/self-labeled transcripts are fixture evidence and can never be live evidence")
            verdict, observed = validate_live(records, args.expected_route, args.task_scope, args.requested_root_model, args.requested_root_effort)
        elif events is None:
            fail("fixture/static validation requires canonical fixture events")
        if args.tier == "fixture" and source != "canonical":
            fail("fixture tier requires canonical fixture events")
        if args.tier != "live":
            verdict = validate(events, args.tier)
    except ValueError as error:
        print(f"codex v2 delegation transcript invalid: {error}", file=sys.stderr)
        return 1
    result = {"status": "passed", "evidence_tier": args.tier, "source": source, "verdict": verdict}
    if args.tier == "live":
        result["requested_by_harness"] = {"model": args.requested_root_model, "reasoning_effort": args.requested_root_effort}
        result["observed_in_runtime"] = observed
    print(json.dumps(result, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
