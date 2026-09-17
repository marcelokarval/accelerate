# CODEX-26 Phase 1 Closure Review — Prompt G Task Graph

## Task ledger

| Task | Owner | Effect | Depends on | Terminal result |
| --- | --- | --- | --- | --- |
| TASK-G01 | root | fresh HCOM/model/current-authority preflight | operator GO | PASS or NO-GO |
| TASK-G02 | root | persist and freeze Prompt G plus task graph | G01 | TASKS_READY or NO-GO |
| TASK-G03 | root | physically spawn Agy High implementer and Terra Medium reviewer | G02 | DISPATCHED or NO-GO |
| TASK-G04 | Agy High | reconcile local `.accelerate/` closure projection and run canonical prepare-closure | G03 | CANDIDATE or BLOCKED |
| TASK-G05 | Agy High | run focused proof, self-review, and implementation return artifact | G04 | IMPLEMENTER_PASS or FAIL |
| TASK-G06 | root | inspect changes, revalidate frozen inputs, and freeze closure candidate | G05 | FROZEN or NO-GO |
| TASK-G07 | Terra Medium | independent review of exact frozen candidate and proof | G06 | REVIEW_PASS or REVIEW_FAIL |
| TASK-G08 | root -> Agy -> Terra | bounded correction loop, at most four generations | G07 fail | SUCCESSOR_PASS or NO-GO |
| TASK-G09 | root | review-of-review and forensic closure-readiness judgment | G07/G08 pass | SUPPORTED or NO-GO |
| TASK-G10 | root via governed Plane MCP | fresh readback; optional REVIEW/PROGRESS comment only | G09 | RECONCILED or NO-GO |
| TASK-G11 | root | emit final closure-review packet and stop | G09..G10 | GO_FOR_OPERATOR_PHASE1_CLOSURE or NO-GO |

## Ownership and sequence

```text
root hardening/task graph
          |
          v
 Agy 3.8 Flash High (write-bounded)
          |
          v
 root candidate freeze
          |
          v
 Codex Terra Medium (read-only independent review)
          |
          v
 root review-of-review
    | defect                    | pass
    +----> Agy -> freeze -> Terra   +----> Plane readback -> G11
```

Root never delegates issue authority, final acceptance, Plane mutation,
promotion, or closure. Children cannot spawn. A reviewer cannot repair the
candidate it reviews.

## Stop conditions

- C14, R1, Prompt-F F09, or Prompt-F proof-freeze drift;
- mutation outside the Agy write allowlist;
- source/control mutation that invalidates accepted Prompt-F proof;
- canonical closure command failure;
- stale C13 authority remaining in current closure artifacts;
- reviewer identity/independence failure;
- material finding after four correction generations;
- Plane ambiguity that cannot be reconciled read-only;
- any request to transition state, publish FINISH/Done, or enter Phase 2.
