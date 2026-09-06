# CODEX-26 Prompt D Task Graph

## Frozen route

`TASK-014 -> TASK-015 -> TASK-016 -> TASK-017 -> TASK-018 -> TASK-019 -> TASK-020 -> TASK-021 -> TASK-022 -> TASK-023 -> TASK-024 -> TASK-025 -> TASK-026 -> TASK-027`

The route is sequential because the implementation, proof freeze, global proof,
independent review, and provider update consume the preceding generation.

## Ownership

| Task | Owner | Mutation scope | Dependency |
| --- | --- | --- | --- |
| TASK-014 | root | authority artifacts only | operator authorization |
| TASK-015 | root | status receipt only | TASK-014 |
| TASK-016 | boundary reviewer | read-only | TASK-015 |
| TASK-017 | root | SDD/task graph only | TASK-016 approval |
| TASK-018..020 | proof-harness implementer | five-file harness allowlist plus one new helper | validated dispatch |
| TASK-021 | root | freeze/evidence only | focused Green |
| TASK-022..023 | root runner | no source mutation | frozen harness |
| TASK-024 | independent tester | read-only | frozen proof packet |
| TASK-025 | root | review receipt only | independent PASS |
| TASK-026 | root | at most one governed Plane PROGRESS comment | all prior PASS |
| TASK-027 | root | closure-review packet only | Plane readback or explicit no-write disposition |

## Physical bindings

- architecture: `/root/promptd_boundary_review`, Terra/medium, fork none;
- executor: `/root/promptd_harness_implementer`, Terra/medium, fork none;
- independent tester: `/root/promptd_independent_tester`, Terra/medium, fork none.

Children cannot delegate. Root does not edit the executor-owned harness scope.
C14, proposal v0.7.25, user-home catalogs, runtime promotion, Plane state, and
Phase 2 remain forbidden.

## Current state

- TASK-014: PASS
- TASK-015: PASS
- TASK-016: PASS after one bounded correction/re-review loop
- TASK-017: PASS
- TASK-018: RED observed; physical receipt pending validation
- TASK-019..027: pending
