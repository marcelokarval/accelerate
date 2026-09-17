# CODEX-26 Phase 1 Exit Revalidation — Prompt B Task Graph

## Execution boundary

Operator authorization: `esta autorizado explicitamente o Prompt B`.

This graph may advance through `TASK-011`. `TASK-012` is a separate lifecycle
gate and remains forbidden until the operator gives a distinct GO after reading
the `TASK-011` decision.

## Task ledger

| Task | Owner | Effect | Depends on | Terminal result |
| --- | --- | --- | --- | --- |
| TASK-001 | root | materialize bounded successor authority | operator GO | ACTIVE or NO-GO |
| TASK-002 | integrations/ops diagnostic | read-only Plane MCP handshake diagnosis | TASK-001 | SAFE-RETRY or BLOCKED |
| TASK-003 | root | freeze complete Phase-1 candidate denominator | TASK-001 | FROZEN or NO-GO |
| TASK-004 | independent tester | run full root suite in isolated copy with captured exit | TASK-003 | PASS or NO-GO |
| TASK-005 | independent integration tester | run real OpenSpec lane twice in disposable copies | TASK-003 | PASS-DETERMINISTIC or NO-GO |
| TASK-006 | independent governance reviewer | audit Phase-1 exit requirements and artifacts | TASK-003 | PASS or NO-GO |
| TASK-007 | fresh independent tester | reprove frozen candidate without creator context | TASK-004..006 | PASS or NO-GO |
| TASK-008 | fresh normative reviewer | compare frozen candidate with proposal and independent oracle | TASK-004..006 | PASS or NO-GO |
| TASK-009 | root | review-of-review and closure-readiness verdict | TASK-007..008 | CLOSURE_READY or NO-GO |
| TASK-010 | root via governed Plane adapter | one PROGRESS attempt plus readback, only if TASK-002 says safe | TASK-009 | CONFIRMED or BLOCKED/AMBIGUOUS |
| TASK-011 | root + human | present formal GO/NO-GO packet and stop | TASK-009..010 | AWAITING_HUMAN_GO |
| TASK-012 | root via governed Plane adapter | transition CODEX-26 to Done | separate post-TASK-011 human GO | out of current authority |
| TASK-013 | root | Phase-2 planning only | TASK-012 | out of current execution scope |

## Concurrency and ownership

```text
ROOT: TASK-001 + TASK-003 + fan-in + TASK-009..011
  |
  +-- TASK-002 integrations/ops diagnostic (read-only)
  |
  +-- after freeze:
      +-- TASK-004 isolated root-suite tester
      +-- TASK-005 disposable real-OpenSpec tester
      +-- TASK-006 independent exit-requirements auditor
  |
  +-- after first proof fan-in:
      +-- TASK-007 fresh independent tester
      +-- TASK-008 fresh independent normative reviewer
```

No child has Plane mutation, repository mutation, lifecycle closure, promotion,
deployment, global-sync, or nested-spawn authority. Root does not repair a
failed candidate under this authorization.

## Frozen stop conditions

Stop immediately on authority failure/expiry, hash drift, any test failure,
OpenSpec divergence, independent rejection, ambiguous Plane result, new P0,
required implementation change, or scope expansion. Such a stop is `NO-GO`,
not permission for an implicit correction loop.
