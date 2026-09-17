# CODEX-26 Phase 1 Proof Continuation — Prompt E

## Authorization

The operator explicitly instructed `Prossiga para o Prompt E` on 2026-09-03.
This authorizes a proof-only continuation from the Prompt-D TASK-022
environmental NO-GO. It does not authorize source correction, global sync,
user-home mutation, runtime promotion, deployment, Phase 2, proposal rewrite,
or Plane `Done`.

## Objective

Re-run the global proof exactly once with the normal current Python/HOME
environment, while relying on the already-proven repo-only disposable mirror
fixtures for authority isolation. If it passes, run one real-OpenSpec
confirmation, freeze proof evidence, obtain independent adversarial review,
perform root review-of-review, optionally append one governed Plane `PROGRESS`
comment, and stop at the formal Phase-1 closure-review gate.

## Frozen inputs

- C14: 23 files; aggregate
  `cbf26086ca9af5e7d927d7ee324818af35d74d972dfcdbfcce0cd562bc3780d4`.
- Proof Harness R1: 5 files; aggregate
  `aa9551f4b2f33fe382b043059034fe1b107e50ee8b99c5975869bdc67e5eaeed`.
- Harness freeze SHA-256:
  `23ec174a784f5a0570419086cbccda39f9b08f8dd780889b0e30e449c0a73ecb`.

Any mismatch stops the sequence.

## Task graph

### TASK-E01 — Authority/currentness

Resolve Plane, read CODEX-26, prove normal Python can import pytest, verify C14
and R1 freezes, and persist Prompt-E authority.

### TASK-E02 — Physical proof dispatch

Dispatch a fresh Terra/medium proof runner with `fork_turns=none` and bind the
existing independent Terra/medium tester. Neither may edit source, Plane, or
user-home. Root retains fan-in, review-of-review, Plane, and closure.

### TASK-E03 — Corrected global proof

Run exactly once, in foreground, without overriding HOME:

```bash
/usr/bin/time -p bash tests/all.sh
```

Record timestamps, exit, duration, decisive output, and post-run C14/R1
integrity. Stop immediately on failure; no retry or correction is authorized.

### TASK-E04 — Real OpenSpec confirmation

Only after TASK-E03 PASS, run exactly once:

```bash
PHASE1_REAL_OPENSPEC=1 bash tests/phase1/run.sh
```

Require exit 0, 81 tests, zero skips, deterministic receipt manifests, and
unchanged C14/R1.

### TASK-E05 — Proof freeze

Persist exact TASK-E03/E04 evidence and bind it to unchanged C14 and R1.

### TASK-E06 — Independent adversarial tester

Provide the independent tester only the objective, SDD-lite, frozen diff/input
hashes, proof outputs, authority, and non-goals. Require `PASS` or actionable
`FAIL` for HOME dependence, false results, hardcoding, external mutation,
host-specific assumptions, weakened drift detection, C14 drift, proof/promotion
mixing, and rollback gaps.

### TASK-E07 — Root review-of-review

Inspect source/diff directly and reconcile all frozen evidence and the
independent review. Every mandatory gate must pass individually.

### TASK-E08 — Governed Plane PROGRESS

Only after TASK-E03..E07 PASS, preflight and append at most one complete
`PROGRESS` lifecycle comment to CODEX-26, then perform fresh readback. Do not
transition the issue state.

### TASK-E09 — Formal gate

Emit exactly one:

- `GO_FOR_PHASE1_CLOSURE_REVIEW`; or
- `NO_GO_WITH_FIRST_BROKEN_BOUNDARY`.

Stop. Plane `Done` remains a later, separately authorized TASK-E10.

## Stop rules

Stop on freeze drift, invalid/expired authority, global proof failure,
OpenSpec failure, independent-review failure, provider ambiguity, or any need
for source/runtime/user-home mutation.
