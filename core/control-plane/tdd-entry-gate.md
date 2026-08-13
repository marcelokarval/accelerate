# TDD Entry And Fresh-Proof Gate

## Purpose

Use this gate before implementation and again after every correction. It selects
the honest test/proof mode, preserves baseline evidence, and prevents stale
proof from authorizing review or closure.

## Entry Rule

Implementation may start only when:

- the governing design is accepted or implementing
- Test Design passed `test-design-gate.md`
- requirements map to tasks and planned tests or justified exceptions
- the baseline mode, command/action, fixture, and evidence locator are named
- the mode-required pre-change baseline is observed, or honestly dispositioned
  when the selected mode has no executable baseline
- the independent reviewer is named

Create a `planning/testing/tdd-receipt-template.md` receipt for the bounded
change. Do not use an unexecuted plan as observed evidence.

## Change-Kind Mode Matrix

- feature -> observed Red, minimal Green, then Refactor with fresh reproof
- bug -> failing repro before correction, then focused regression proof
- refactor -> characterization baseline before mutation and after refactor
- docs or governance -> semantic validator with valid and invalid fixtures
- migration -> forward, compatibility, data-integrity, and rollback contract
- security -> trust-boundary and abuse/negative proof with safe-PoC disposition
- UI -> focused behavior/QA, interactive browser truth, then persistent regression
- external provider -> contract or sandbox fixture, failure handling, idempotency, and authorized provider readback
- hybrid -> declare each constituent mode and satisfy every applicable contract

Do not fabricate Red proof for characterization, docs/governance, migration,
security, UI, or external-provider work. Do not call a test written after the
implementation TDD. Preserve it as regression evidence and record the missing
Red honestly.

## Baseline Integrity

For an observed Red or failing repro, record:

- exact command/action, fixture/scenario, and time
- expected failure and actual failure
- exit/runtime result and evidence locator
- why the failure proves missing or broken behavior rather than a typo,
  environment error, or unrelated defect

If a feature test passes immediately, correct the test/design or record that
the behavior already exists. If it errors for an unrelated reason, fix the
test harness and rerun before implementation.

For characterization and semantic contracts, record current valid/invalid
behavior without relabelling it Red. For UI or provider modes, distinguish
fixture/sandbox evidence from live browser or provider readback.

## Correction Generation And Reproof

Start with `correction_generation = 0` and `proof_generation = 0`.

Treat the first implementation after the baseline as correction generation 1.
Each later material correction increments the generation again.

After every material correction:

1. increment `correction_generation`
2. mark all earlier evidence as stale proof
3. rerun every proof lane affected by the correction
4. record new observed locators at the current `proof_generation`
5. require `proof_generation == correction_generation` before promotion

A correction requires reproof even when the prior test or capture is recent.
Timestamp freshness alone cannot overcome a generation mismatch. If the
correction changes the contract or risk, return to Test Design before reproof.

## Proof Ordering

Keep proof in this order:

1. implementation proof
2. backend/frontend QA proof when applicable
3. interactive browser truth when runtime/UI is in scope
4. persistent regression proof after the path is stable
5. independent forensic closure review

Later proof does not waive a missing earlier lane. Give substantive
not-applicable reasons for lanes outside the change boundary.

## Writer / Reviewer Independence

- implementation owners may self-review but cannot accept their own result
- a test-only writer loses independent review authority over authored tests,
  fixtures, or oracles
- assign a different reviewer for Test Design adequacy and post-code regression
  proof
- if independence is unavailable, report `blocked` or `pending`; do not weaken
  the verdict to make closure possible

## Exit Decision

The receipt may advance to independent review only when:

- the selected mode has its honest baseline evidence
- focused correction proof is observed
- broader affected regressions are observed or substantively not applicable
- proof generation matches correction generation
- planned and observed proof remain distinguishable
- stale evidence is excluded from the verdict
- writer/reviewer independence is satisfied

## Failure Labels

- `baseline-not-observed`
- `fabricated-red`
- `test-after-labelled-tdd`
- `wrong-change-kind-mode`
- `stale-proof-after-correction`
- `proof-generation-mismatch`
- `browser-truth-skipped`
- `persistent-proof-before-browser-truth`
- `test-writer-self-accepted`
- `planned-proof-presented-as-observed`
