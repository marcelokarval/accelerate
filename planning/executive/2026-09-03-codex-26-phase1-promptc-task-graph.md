# CODEX-26 Phase 1 C14 — Prompt C Proof Task Graph

## Authority and stop boundary

This graph is governed by the Prompt-C Phase-0 reaffirmation and Phase-1
proof-only authorization. C14 is immutable. A failure is `NO-GO`, not an
implicit correction loop. `TASK-012` / Plane Done is out of scope.

## Ordered graph

```text
TASK-004 full root suite ───────┐
                                ├─> TASK-006 exit audit ─┐
TASK-005 real OpenSpec twice ───┘                         ├─> TASK-009 root review-of-review
                                                          │
TASK-007 independent tester ──────────────────────────────┤
TASK-008 independent normative reviewer ──────────────────┘
                                                                  │
                                                            TASK-010 optional one-shot Plane PROGRESS
                                                                  │
                                                            TASK-011 human GO/NO-GO packet; STOP
```

## Tasks

| Task | Owner | Preconditions | Required output |
| --- | --- | --- | --- |
| TASK-004 | Terra/medium independent tester | C14 + Prompt-C receipts | foreground `bash tests/all.sh`, exact exit, C14 pre/post hashes |
| TASK-005 | Terra/medium independent integration tester | C14 + Prompt-C receipts | two `PHASE1_REAL_OPENSPEC=1` runs, exact exits, no skip/divergence, C14 hashes |
| TASK-006 | Terra/medium governance auditor | TASK-004 PASS + TASK-005 PASS | requirement matrix; does not reject merely because upstream proof is still running |
| TASK-007 | fresh Terra/medium tester | TASK-004..006 PASS | independent full candidate reproving |
| TASK-008 | fresh Terra/medium normative reviewer | TASK-004..006 PASS | proposal/SDD/authority/C14 review |
| TASK-009 | root | TASK-007 + TASK-008 PASS | review-of-review and closure-readiness verdict |
| TASK-010 | root through governed Plane MCP | TASK-009 PASS + fresh provider read/preparation | at most one PROGRESS mutation plus fresh readback |
| TASK-011 | root + human | TASK-009 + TASK-010 disposition | formal GO/NO-GO, then stop |

## Delegation boundary

All testers and reviewers are read-only over the source candidate and may write
only their isolated disposable proof roots. They cannot mutate Plane, repair
C14, create child agents, promote, deploy, synchronize, or close work items.
Root retains receipts, fan-in, review-of-review, the optional one-shot Plane
operation, and closure judgment.
