---
name: test-driven-development
description: Drive a software, configuration, documentation, workflow, migration, security, UI, or provider change from an honest pre-change baseline through correction and fresh proof. Use when selecting Red/Green/Refactor or a mode-appropriate alternative, capturing a failing repro or characterization, preventing fabricated Red claims, or invalidating and rerunning proof after a material correction.
---

# Test-Driven Development

Make evidence lead the change. TDD here means an honest change-time baseline and
fresh proof, not forcing every change to imitate a failing unit test.

## Core Rule

Select the proof mode from the change kind before implementation. Observe the
required baseline, implement the smallest complete correction, and reprove at
the current correction generation. Never relabel a test written after code as
pre-change Red.

## Boundaries

- `specification-lifecycle` owns accepted requirements and entry readiness.
- Test Design owns coverage dimensions, levels, fixtures, and independent review.
- `systematic-debugging` owns diagnosis when the cause of a failure is unknown.
- `test-engineering` owns independent test strategy and post-code regression
  assessment; this skill owns the implementer's change-time loop.
- This skill does not authorize issue closure, git publication, or provider writes.

## Workflow

### 1. Select The Honest Mode

Read [references/proof-modes.md](references/proof-modes.md). Declare the change
kind, constituent modes for a hybrid, lowest effective proof level, fixture, and
independent reviewer. Return to Test Design if risk or coverage is unresolved.

### 2. Observe The Baseline Before Mutation

Record exact command or action, fixture/scenario, expected result, actual result,
exit/runtime status, timestamp, and stable evidence locator. Establish that a
failure demonstrates missing/broken behavior instead of a typo, harness error,
or unrelated defect.

For feature work, require observed Red. For bugs, require a failing repro. For
refactors, preserve a passing characterization baseline. Use semantic valid and
invalid fixtures for docs/governance. Use the mode-specific contract for
migrations, security, UI, providers, and hybrids.

If implementation already exists, label new tests regression evidence and state
that pre-change Red was not observed.

### 3. Implement The Minimum Complete Green

Change only the bounded behavior needed to satisfy the accepted contract. Green
must include applicable safety, compatibility, observability, rollback, and
failure handling; passing a narrow assertion does not excuse an incomplete
solution.

### 4. Refactor Only After Green

Improve clarity and remove accidental complexity without changing the accepted
behavior. Preserve the characterization or contract and rerun focused proof
after every material refactor.

### 5. Advance Generations And Reprove

Start at correction generation 0 and proof generation 0. Each material
correction increments the correction generation and makes earlier affected proof
stale. Promotion requires fresh affected proof with:

```text
proof_generation == correction_generation
```

Follow [references/fresh-proof-contract.md](references/fresh-proof-contract.md)
for proof ordering, independence, and receipt fields.

## Failure Labels

Use precise labels instead of weakening the verdict:

- `baseline-not-observed`
- `fabricated-red`
- `test-after-labelled-tdd`
- `wrong-change-kind-mode`
- `stale-proof-after-correction`
- `proof-generation-mismatch`
- `test-writer-not-independent`
- `browser-truth-skipped`
- `provider-readback-missing`

## Return Contract

Return the change kind and proof mode, baseline evidence, correction/proof
generations, focused and affected regression results, stale evidence excluded,
reviewer independence, defects, residual risks, and `pass | fail | blocked`.
State explicitly that root owns promotion and closure.

## Verification

Before returning success, inspect the actual command output and evidence
locator, verify that the baseline predates mutation, confirm every applicable
proof lane ran in order, and prove generation equality. A planned test or recent
but stale result is not completion evidence.
