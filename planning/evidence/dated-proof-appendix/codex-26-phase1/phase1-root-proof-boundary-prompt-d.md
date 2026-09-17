# CODEX-26 Phase 1 Root Proof Boundary — Hardened Prompt D

## Operator authorization

The operator explicitly authorized Prompt D, `TASK-014` through `TASK-027`, on
2026-09-03. This prompt authorizes a repository-local correction of the proof
harness only. It does not authorize a Plane `Done` transition, global skill
sync, user-home mutation, runtime promotion, deployment, Phase 2, or mutation
of the frozen Phase-1 implementation candidate C14.

## Objective

Correct the validation-harness defect that makes the repository-authoritative
test suite depend on ambient `~/.codex/skills` state. Preserve C14 and separate:

1. repository-source validation;
2. disposable generated-projection validation;
3. optional installed-projection audit; and
4. real projection promotion or synchronization.

## Bound authority

- Plane work item: `CODEX-26`
- Plane work-item id: `549d5c6e-9066-440c-85a6-973a33b7eefe`
- C14 file count: `23`
- C14 aggregate SHA-256:
  `cbf26086ca9af5e7d927d7ee324818af35d74d972dfcdbfcce0cd562bc3780d4`
- C14 freeze SHA-256:
  `7215486904c9fee3172ad1f53c3c3a63d4aa9ba62cea424d5bf8da60fcf72bc2`

## Non-goals

- no writes to `~/.codex`, `~/.agents`, `~/.claude`, or `~/.hermes`;
- no global skill sync or promotion;
- no mutation of the 23 C14 files;
- no OpenSpec install or update;
- no runtime projection activation;
- no Phase 2, deployment, or Plane `Done`;
- no in-place rewrite of accepted proposal v0.7.25;
- no deletion of `/tmp/codex26-task004.jRRFNp`;
- no new dependency without a distinct gate.

## Stop rules

Stop at the first evidenced `NO-GO` if C14 drifts, user-home mutation becomes
necessary, canonical tests retain live `~/.codex` dependence, generated export
is not reproducible, negative drift tests become ineffective, independent
review rejects, Plane/receipt authority is unavailable, or scope must expand.

## Delegation topology

The route is `orchestrated`. Before task-owned mutation, physically dispatch:

- `boundary-architect-reviewer`: `gpt-5.6-terra`, `medium`, `fork_turns=none`,
  read-only architecture and authority review;
- `proof-harness-implementer`: `gpt-5.6-terra`, `medium`, `fork_turns=none`,
  bounded proof-harness implementation;
- `independent-test-reviewer`: `gpt-5.6-terra`, `medium`, `fork_turns=none`,
  independent adversarial verification.

Root retains hardening, task graph, fan-in, integration-only repair,
review-of-review, Plane, the final verdict, and closure.

## Task sequence

### TASK-014 — Refresh authority and currentness

Resolve governed Plane capability; freshly read CODEX-25 and CODEX-26; bind
this prompt, Phase-0 acceptance/reaffirmation, C14, and the Prompt-C failure to
a bounded authorization permitting only this repository-local correction,
proof, review, and at most one Plane `PROGRESS` comment.

### TASK-015 — Authority and status reconciliation

Classify repository source, generated export, disposable target, installed
projection, and Plane. Record that CODEX-25 is complete, v0.7.25 is accepted,
its status header is stale presentation, accepted bytes remain immutable, and
a status index or successor proposal is a later disposition.

### TASK-016 — Independent cause review

Dispatch the read-only boundary reviewer. It must independently prove or reject
the causal chain from `tests/all.sh` through the installed-mirror fixture, the
three-file repair, hard-coded count, nine missing references, and the proposed
source-only/generated-target boundary. Implementation requires explicit
`APPROVE_SOURCE_ONLY_BOUNDARY_FIX`.

### TASK-017 — Correction SDD-lite

Freeze problem, invariants, candidate files, forbidden surfaces, before/after
behavior, Red/Green criteria, rollback, proof matrix, and a harness denominator
separate from C14.

### TASK-018 — Dispatch and Red baseline

Dispatch the bounded implementer with a validated physical receipt. Capture
pre-change hashes and an honest failing regression that demonstrates ambient
HOME dependence before implementation.

### TASK-019 — Repository-only implementation

Make the smallest complete correction: canonical tests use repo source and a
disposable generated target; expected counts are derived; missing/different/
incomplete/provenance failures remain detectable; installed-runtime audit is
explicitly opt-in and excluded from `tests/all.sh`.

### TASK-020 — Focused Green proof

Prove empty-HOME success, generated-target success, missing/different failures,
derived manifest/count behavior, installed-audit isolation, `git diff --check`,
and unchanged C14. Do not run the full suite before this gate is green.

### TASK-021 — Separate harness freeze

Create `CODEX-26-P1-ROOT-PROOF-HARNESS-R1` with changed files, hashes,
aggregate digest, tests, C14 relationship, rollback locator, and authority.
Never silently rename C14.

### TASK-022 — One global proof

Run exactly one fresh isolated `bash tests/all.sh`, recording command, cwd,
time, duration, exit, bounded output, redacted environment disposition, and
before/after C14 and harness digests. Stop at the first broken boundary.

### TASK-023 — Post-harness OpenSpec confirmation

Validate the earlier deterministic TASK-005 manifests and run one fresh
`PHASE1_REAL_OPENSPEC=1 bash tests/phase1/run.sh`. Require exit 0, 81 tests,
zero skips, deterministic manifests, and unchanged C14. A second run requires
an objective divergence or changed C14 surface.

### TASK-024 — Independent adversarial tester

Dispatch a fresh read-only tester with only the objective, SDD-lite, diff and
freeze, C14 freeze, proof outputs, authority, and non-goals. It must seek HOME
dependence, false results, disguised hard-coding, external mutation,
host-specific success, weakened drift detection, C14 mutation, promotion/proof
mixing, and missing rollback. Return `PASS` or actionable `FAIL`.

### TASK-025 — Root review-of-review

Reconcile authority, architecture review, implementation, Red/Green, global
suite, real OpenSpec, independent tester, freezes, C14, and non-goals. No
majority vote; every mandatory normative gate passes independently.

### TASK-026 — Governed Plane PROGRESS

Only after TASK-020 through TASK-025 pass, resolve Plane again, preflight one
complete `PROGRESS` lifecycle comment, perform at most one authorized append,
and read it back. Do not transition state or mark `Done`.

### TASK-027 — Formal Prompt-D gate

Emit `GO_FOR_PHASE1_CLOSURE_REVIEW` or
`NO_GO_WITH_FIRST_BROKEN_BOUNDARY`, with authority, status reconciliation, C14
and harness freezes, focused/global/OpenSpec proof, independent tester,
root review-of-review, Plane readback if applicable, limitations, known `/tmp`
residual, and still-prohibited effects. Stop here.

## Future gate, not authorized

`TASK-028` is a separate Plane `Done`/Phase-1 closure gate requiring later
explicit human authorization and current, unchanged receipts.

## Update packet

Every task update must state task id, status, completed work, evidence,
candidate/harness digests, active agents, next task, and stop condition.
