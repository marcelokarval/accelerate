# CODEX-26 Phase 1 Dogfood Closure Correction — Prompt H Task Graph

## Task ledger

| Task | Owner | Effect | Depends on | Terminal result |
| --- | --- | --- | --- | --- |
| TASK-H01 | root | semantic, authority, dirty-worktree, model and Plane preflight | operator authorization | PASS or NO-GO |
| TASK-H02 | root | observe Red and freeze Prompt H, authority, baseline, graph and assignments | H01 | TASKS_READY or NO-GO |
| TASK-H03 | root | physically dispatch Agy High implementer and Terra Medium reviewer | H02 | DISPATCHED or NO-GO |
| TASK-H04 | Agy High | add/strengthen focused tests and record honest Red | H03 | TEST_RED or BLOCKED |
| TASK-H05 | Agy High | implement profile-aware dogfood closure and authority binding | H04 | GREEN_CANDIDATE or BLOCKED |
| TASK-H06 | Agy High | update local projection, run focused/affected/global proof, self-review and cleanup | H05 | IMPLEMENTER_PASS or BLOCKED |
| TASK-H07 | root | inspect exact diff/evidence, enforce scope, and freeze candidate | H06 | FROZEN or NO-GO |
| TASK-H08 | Terra Medium | independently review the exact frozen candidate | H07 | REVIEW_PASS or REVIEW_FAIL |
| TASK-H09 | root -> Agy -> Terra | bounded correction/reproof loop, maximum four material generations | H08 fail | SUCCESSOR_PASS or NO-GO |
| TASK-H10 | root | review-of-review, final focused reproduction, global-proof reconciliation | H08/H09 pass | SUPPORTED or NO-GO |
| TASK-H11 | root via governed Plane MCP | fresh readback and optional PROGRESS/REVIEW comment only | H10 | RECONCILED or NO-GO |
| TASK-H12 | root | final closure-review packet, agent cleanup, and stop | H10..H11 | GO_FOR_OPERATOR_PHASE1_CLOSURE or NO-GO |

## Critical path

```text
H01 -> H02 -> H03 -> H04 RED -> H05 GREEN -> H06 PROOF/CLEANUP
                                           |
                                           v
                                      H07 FREEZE
                                           |
                                           v
                                      H08 TERRA
                                      /        \
                                  FAIL          PASS
                                   |              |
                                   v              v
                            H09 AGY->FREEZE->TERRA H10 ROOT
                                                   |
                                                   v
                                             H11 PLANE READ
                                                   |
                                                   v
                                                  H12
```

## Frozen denominator

- profile-aware canonical closure entrypoint;
- dogfood-specific closure preparation without full-V2 fabrication;
- stable non-circular authority receipt and digest binding;
- dogfood subset validator;
- dogfood contract test and negative probes;
- successor-aware Phase-1 currentness validator and unit tests;
- current `.accelerate` projection and generated handoff/review artifacts;
- full-V2 compatibility proof;
- one final global suite after the last material correction;
- immutable Prompt-G/Prompt-F/C14/R1 preservation proof.

## Stop conditions

- mutation outside Agy allowlist;
- overwrite of unrelated dirty-worktree content;
- circular authority oracle or self-validating candidate;
- weakened false-acceptance, false-closure, secret, generated-path, or
  remote-call negative proof;
- full-V2 behavior regression;
- frozen historical evidence drift;
- wrong model, effort, reviewer identity, or moving-candidate review;
- material finding after four correction generations;
- Plane transition, Phase 2, runtime sync, deploy, release, commit, push, merge,
  or branch rewrite.
