# Post-Spec Delegation Dispatch Gate

## Purpose

Make execution dispatch auditable after hardening, specification, and task graph
readiness. The canonical machine receipt is
[`delegation-dispatch-receipt.schema.json`](../runtime-packets/delegation-dispatch-receipt.schema.json).

## State Machine

`HARDENING` → `SPEC_READY` → `TASKS_READY` → `ROUTE_SELECTED` →
`DISPATCH_REQUIRED` → `DISPATCHED` → `EXECUTING` → `FAN_IN` →
`INDEPENDENT_REVIEW` → `ROOT_REVIEW_OF_REVIEW` → `CLOSURE`.

Planning-only may stop at `TASKS_READY`. An execution request must select a
route and carry artifact refs plus SHA-256 hashes for hardening, spec, and task
graph before dispatch.

## Dispatch Rules

- `direct-fast-path`: zero spawns.
- `scoped`: zero or one read-only sidecar; the root may retain its bounded
  task-owned implementation, which the sidecar cannot hide or perform.
- `orchestrated` with execution requested and collaboration available: record a
  physical executor/reviewer dispatch before the first task-owned write.

Assignments require explicit role, model, effort, bounded fork (`none` or JSON
integer `1`–`5`, never `all`),
physical agent and call IDs, read/write scopes, proof, dependencies/wave,
reviewer, and recursion authorization. An executor needs an independent
reviewer. In `orchestrated` work after dispatch, root task writes into assigned
executor scopes are prohibited; the root only owns fan-in, review-of-review,
and closure. This lock does not prohibit route-qualified direct or scoped
root-owned work. Executor write scopes must not overlap.

Luna cannot own architecture, design, or coordination and cannot delegate. A
direct root Luna/low `research` or `explorer` lane is read-only with no parent
reference; a direct root Luna/medium `mechanical-fixer` has a prescribed bounded
write scope and reviewer. Terra may
delegate to exactly one Luna child only with `nested_terra_to_luna_authorized`.
That child must be a scoped `mechanical-fixer`, name its parent assignment and
delegation reference, and retain its own independent reviewer. The active count
must equal the physical assignment count; both it and the route maximum may
never exceed three. The orchestrated receipt lock must cover exactly the
executor scopes dispatched to physical workers.

## Exceptions

Only these explicit receipt exceptions are valid: `explicit_user_opt_out`,
`collaboration_unavailable`, and `spawn_failed_operator_authorized`. Each needs
a code, evidence, and compensating control. A spawn failure may not silently
fall back to root execution. Virtual packets or single-threaded prose do not
satisfy physical dispatch when collaboration is available.
