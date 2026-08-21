# Delegation Dispatch Gate

Use after hardening/spec/task readiness and before task-owned execution. Read
the canonical [receipt schema](../core/runtime-packets/delegation-dispatch-receipt.schema.json)
and validate it with `scripts/validate-delegation-dispatch-receipt.py`.

The machine is `HARDENING → SPEC_READY → TASKS_READY → ROUTE_SELECTED →
DISPATCH_REQUIRED → DISPATCHED → EXECUTING → FAN_IN → INDEPENDENT_REVIEW →
ROOT_REVIEW_OF_REVIEW → CLOSURE`; planning-only may end at `TASKS_READY`.

Direct uses zero spawns; scoped uses zero or one sidecar without concealing a
planned implementation; orchestrated execution with collaboration available
needs physical dispatch before the first task-owned write. Receipts bind every
assignment to explicit model/effort/fork (`none` or integer `1`–`5`), agent/call
IDs, scopes, proof, reviewer, recursion, budget, parent/reference for a nested
Terra-to-Luna handoff, and root write lock. An orchestrated physical receipt
needs a physical executor and that executor's independent physical reviewer.
Direct root Luna is limited to low read-only `research`/`explorer` or medium
bounded `mechanical-fixer`; only a Luna record with parent/reference fields is
a nested Terra child.
Only the three exception
codes defined in the schema are valid; virtual text cannot replace a required
physical dispatch.
