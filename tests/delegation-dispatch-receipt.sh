#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'delegation-dispatch-receipt failed: %s\n' "$1" >&2
  exit 1
}

validator="scripts/validate-delegation-dispatch-receipt.py"
fixtures="tests/fixtures/delegation-dispatch"

[ -f "$validator" ] || fail "missing $validator"
[ -f "core/runtime-packets/delegation-dispatch-receipt.schema.json" ] || fail 'missing canonical schema'

python3 "$validator" "$fixtures/valid-orchestrated.json"
python3 "$validator" "$fixtures/valid-scoped-root-owned-sidecar.json"

stage_root="$(mktemp -d)"
trap 'rm -rf "$stage_root"' EXIT
mkdir -p "$stage_root/assets" "$stage_root/scripts"
cp "core/runtime-packets/delegation-dispatch-receipt.schema.json" "$stage_root/assets/delegation-dispatch-receipt.schema.json"
cp "$validator" "$stage_root/scripts/validate-delegation-dispatch-receipt.py"
python3 "$stage_root/scripts/validate-delegation-dispatch-receipt.py" "$fixtures/valid-orchestrated.json"

for fixture in "$fixtures"/invalid-*.json; do
  if python3 "$validator" "$fixture" >/dev/null 2>&1; then
    fail "validator accepted invalid fixture $(basename "$fixture")"
  fi
done

python3 - "$validator" "$fixtures/valid-orchestrated.json" <<'PY'
import copy
import json
import subprocess
import sys
import tempfile
from pathlib import Path

validator = Path(sys.argv[1])
base = json.loads(Path(sys.argv[2]).read_text())

def reject(label, mutate):
    value = copy.deepcopy(base)
    mutate(value)
    with tempfile.NamedTemporaryFile(mode="w", suffix=".json") as handle:
        json.dump(value, handle)
        handle.flush()
        if subprocess.run([sys.executable, str(validator), handle.name], capture_output=True).returncode == 0:
            raise SystemExit(f"validator accepted invalid semantic case: {label}")

def accept(label, mutate):
    value = copy.deepcopy(base)
    mutate(value)
    with tempfile.NamedTemporaryFile(mode="w", suffix=".json") as handle:
        json.dump(value, handle)
        handle.flush()
        if subprocess.run([sys.executable, str(validator), handle.name], capture_output=True).returncode != 0:
            raise SystemExit(f"validator rejected valid case: {label}")

def nested_terra_luna(value):
    parent = value["assignments"][0]
    parent["recursion"].update(delegation_allowed=True, authorization="nested_terra_to_luna_authorized")
    child = copy.deepcopy(parent)
    child.update(assignment_id="luna-child", task_id="LUNA-1", model="gpt-5.6-luna", role="mechanical-fixer", agent_id="agent-luna", call_id="call-luna", write_scopes=["core/control-plane/luna-mechanical.md"], parent_assignment_id="assign-exec", delegation_reference="assign-exec:call-exec->luna-child")
    child["recursion"].update(delegation_allowed=False, authorization=None)
    value["assignments"].insert(1, child)
    value["budget"].update(max_agents=3, active_count=3)
    value["fan_in"].update(assignment_ids=["assign-exec", "luna-child", "assign-review"])
    value["root_write_lock"].update(dispatched_task_scopes=["core/control-plane/new-contract.md", "core/control-plane/luna-mechanical.md"])

def two_luna_children_within_budget(value):
    parent = value["assignments"][0]
    parent.update(kind="reviewer", agent_id="virtual", call_id="virtual", write_scopes=[], reviewer_assignment_id=None)
    parent["recursion"].update(delegation_allowed=True, authorization="nested_terra_to_luna_authorized")
    for identifier, scope in (("luna-one", "core/luna-one.md"), ("luna-two", "core/luna-two.md")):
        child = copy.deepcopy(parent)
        child.update(assignment_id=identifier, kind="executor", task_id=identifier, model="gpt-5.6-luna", role="mechanical-fixer", agent_id=f"agent-{identifier}", call_id=f"call-{identifier}", write_scopes=[scope], reviewer_assignment_id="assign-review", parent_assignment_id="assign-exec", delegation_reference=f"assign-exec->{identifier}")
        child["recursion"].update(delegation_allowed=False, authorization=None)
        value["assignments"].insert(-1, child)
    value["budget"].update(max_agents=3, active_count=3)
    value["fan_in"].update(assignment_ids=["assign-exec", "luna-one", "luna-two", "assign-review"])

def non_mechanical_luna_child(value):
    nested_terra_luna(value)
    value["assignments"][1].update(role="governance")

def nested_terra_luna_wrong_budget(value):
    nested_terra_luna(value)
    value["budget"].update(max_agents=2, active_count=2)

def direct_luna_research(value):
    executor = value["assignments"][0]
    executor.update(model="gpt-5.6-luna", effort="low", role="research", kind="reviewer", write_scopes=[], reviewer_assignment_id=None, parent_assignment_id=None, delegation_reference=None)
    value.update(route="scoped", execution_requested=True, planned_task_owned_writes=False, assignments=[executor], budget={"max_agents": 1, "active_count": 1}, fan_in={"owner": "root", "assignment_ids": ["assign-exec"]}, root_write_lock={"mode": "root-owned", "task_owned_writes_forbidden": False, "dispatched_task_scopes": []})

def direct_luna_mechanical(value):
    executor = value["assignments"][0]
    executor.update(model="gpt-5.6-luna", effort="medium", role="mechanical-fixer", write_scopes=["core/control-plane/luna-direct.md"], parent_assignment_id=None, delegation_reference=None)
    value["root_write_lock"].update(dispatched_task_scopes=["core/control-plane/luna-direct.md"])

def luna_research_write(value):
    direct_luna_research(value)
    value["assignments"][0].update(write_scopes=["core/control-plane/not-allowed.md"])

def orphan_nested_luna(value):
    direct_luna_mechanical(value)
    value["assignments"][0].update(parent_assignment_id="missing-terra", delegation_reference="missing-terra->luna")

reject("omitted-model", lambda value: value["assignments"][0].pop("model"))
reject("fork-all", lambda value: value["assignments"][0].update(fork="all"))
reject("fork-arbitrary", lambda value: value["assignments"][0].update(fork="unbounded"))
reject("executor-without-reviewer", lambda value: value["assignments"][0].update(reviewer_assignment_id=None))
reject("root-task-write", lambda value: value["assignments"][0].update(kind="root", reviewer_assignment_id=None))
reject("luna-architecture", lambda value: value["assignments"][0].update(model="gpt-5.6-luna", role="architecture"))
reject("luna-delegating", lambda value: value["assignments"][0]["recursion"].update(delegation_allowed=True))
reject("terra-luna-unauthorized", lambda value: value["assignments"][0]["recursion"].update(delegation_allowed=True, authorization=None))
reject("budget-over-three", lambda value: value["budget"].update(max_agents=4))
reject("exception-without-proof", lambda value: value["exceptions"].append({"code": "explicit_user_opt_out", "proof": "", "compensation": "review"}))
reject("spawn-failure-root-fallback", lambda value: value["exceptions"].append({"code": "spawn_failed_operator_authorized", "proof": "call failed", "compensation": "root executes"}))
reject("orchestrated-no-physical", lambda value: [item.update(agent_id="virtual", call_id="virtual") for item in value["assignments"]])
reject("reviewer-only", lambda value: value.update(assignments=[value["assignments"][1]], budget={"max_agents": 3, "active_count": 1}, fan_in={"owner": "root", "assignment_ids": ["assign-review"]}))
reject("virtual-reviewer", lambda value: value["assignments"][1].update(agent_id="virtual", call_id="virtual"))
reject("active-count-mismatch", lambda value: value["budget"].update(active_count=1))
reject("terra-authorized-without-luna-child", lambda value: value["assignments"][0]["recursion"].update(delegation_allowed=True, authorization="nested_terra_to_luna_authorized"))
reject("two-luna-children", lambda value: (value["assignments"][0]["recursion"].update(delegation_allowed=True, authorization="nested_terra_to_luna_authorized"), value["assignments"].insert(1, {**copy.deepcopy(value["assignments"][0]), "assignment_id": "luna-one", "task_id": "LUNA-1", "model": "gpt-5.6-luna", "role": "mechanical-fixer", "agent_id": "luna-one", "call_id": "luna-call-one", "write_scopes": ["core/a.md"]}), value["assignments"].insert(2, {**copy.deepcopy(value["assignments"][0]), "assignment_id": "luna-two", "task_id": "LUNA-2", "model": "gpt-5.6-luna", "role": "mechanical-fixer", "agent_id": "luna-two", "call_id": "luna-call-two", "write_scopes": ["core/b.md"]}), value["budget"].update(max_agents=3, active_count=3), value["fan_in"].update(assignment_ids=["assign-exec", "luna-one", "luna-two", "assign-review"])))
reject("non-mechanical-luna-child", lambda value: (value["assignments"][0]["recursion"].update(delegation_allowed=True, authorization="nested_terra_to_luna_authorized"), value["assignments"].insert(1, {**copy.deepcopy(value["assignments"][0]), "assignment_id": "luna-child", "task_id": "LUNA-1", "model": "gpt-5.6-luna", "role": "governance", "agent_id": "luna-child", "call_id": "luna-call", "write_scopes": ["core/a.md"]}), value["budget"].update(max_agents=3, active_count=3), value["fan_in"].update(assignment_ids=["assign-exec", "luna-child", "assign-review"])))
reject("two-luna-children-within-budget", two_luna_children_within_budget)
reject("non-mechanical-luna-child-linked", non_mechanical_luna_child)
reject("authorized-terra-luna-requires-exact-physical-budget-three", nested_terra_luna_wrong_budget)
reject("orchestrated-root-owned-lock", lambda value: value["root_write_lock"].update(mode="root-owned", task_owned_writes_forbidden=False, dispatched_task_scopes=[]))
reject("orchestrated-incomplete-dispatched-scope-lock", lambda value: value["root_write_lock"].update(dispatched_task_scopes=[]))
reject("luna-research-write", luna_research_write)
reject("orphan-nested-luna", orphan_nested_luna)
reject("direct-spawn", lambda value: value.update(route="direct-fast-path"))
accept("scoped-root-owned-implementation", lambda value: value.update(route="scoped", assignments=[], budget={"max_agents": 1, "active_count": 0}, fan_in={"owner": "root", "assignment_ids": []}, root_write_lock={"mode": "root-owned", "task_owned_writes_forbidden": False, "dispatched_task_scopes": []}))
reject("overlap", lambda value: value["assignments"].insert(1, {**copy.deepcopy(value["assignments"][0]), "assignment_id": "second-exec", "task_id": "TASK-2", "agent_id": "agent-second", "call_id": "call-second", "reviewer_assignment_id": "assign-review", "write_scopes": ["core/control-plane"]}) )
accept("bounded-integer-fork", lambda value: value["assignments"][0].update(fork=1))
accept("authorized-single-terra-luna-child", nested_terra_luna)
accept("direct-luna-low-research", direct_luna_research)
accept("direct-luna-medium-mechanical", direct_luna_mechanical)
accept("planning-only", lambda value: value.update(state="TASKS_READY", route="direct-fast-path", execution_requested=False, planned_task_owned_writes=False, budget={"max_agents": 0, "active_count": 0}, assignments=[], fan_in={"owner": "root", "assignment_ids": []}, root_write_lock={"mode": "root-owned", "task_owned_writes_forbidden": False, "dispatched_task_scopes": []}))
PY

printf 'delegation dispatch receipt contract passed\n'
