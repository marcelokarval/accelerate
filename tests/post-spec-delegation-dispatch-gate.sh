#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'post-spec-delegation-dispatch-gate failed: %s\n' "$1" >&2
  exit 1
}

for path in core/control-plane/post-spec-delegation-dispatch-gate.md references/delegation-dispatch-gate.md; do
  [ -f "$path" ] || fail "missing $path"
done

for state in HARDENING SPEC_READY TASKS_READY ROUTE_SELECTED DISPATCH_REQUIRED DISPATCHED EXECUTING FAN_IN INDEPENDENT_REVIEW ROOT_REVIEW_OF_REVIEW CLOSURE; do
  rg -F "$state" core/control-plane/post-spec-delegation-dispatch-gate.md >/dev/null || fail "missing state $state"
done

rg -F 'Planning-only may stop at `TASKS_READY`' core/control-plane/post-spec-delegation-dispatch-gate.md >/dev/null || fail 'planning-only stop missing'
rg -F 'before the first task-owned write' core/control-plane/post-spec-delegation-dispatch-gate.md >/dev/null || fail 'physical dispatch write barrier missing'
rg -F 'explicit_user_opt_out' core/control-plane/post-spec-delegation-dispatch-gate.md >/dev/null || fail 'exception catalog missing'
rg -F 'In `orchestrated` work after dispatch, root task writes into assigned' core/control-plane/post-spec-delegation-dispatch-gate.md >/dev/null || fail 'route-aware root lock missing'
rg -F 'root-owned work' core/control-plane/post-spec-delegation-dispatch-gate.md >/dev/null || fail 'scoped root ownership missing'

printf 'post-spec delegation dispatch gate contract passed\n'
