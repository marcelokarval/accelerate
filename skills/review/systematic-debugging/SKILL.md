---
name: systematic-debugging
description: Use when a bug, failure, regression, broken contract, or unexpected runtime behavior requires explicit repro, hypothesis narrowing, evidence-first diagnosis, and regression-proof closure.
metadata:
  category: review
  origin: accelerate-native
---

# Systematic Debugging

Use this skill when the work is primarily about understanding, isolating, and
correcting a bug, failure, or regression without drifting into guess-driven
patching.

## When to Use

Use this skill when the request is:

- a bug report
- a runtime failure
- a regression
- a mismatch between expected and actual behavior
- a production or staging defect that needs root-cause isolation
- a failing test or a broken contract where the failure mode is still uncertain

Do not use it for:

- straightforward implementation with no failure diagnosis needed
- purely architectural discussion with no failing behavior
- tiny typo-level fixes where root cause is already obvious and bounded

## Core Principle

Do not patch a bug from narrative confidence alone.

`systematic-debugging` exists to enforce:

- explicit repro
- explicit expected vs actual behavior
- bounded hypothesis loops
- evidence-first narrowing
- regression-proof closure

## Output Contract

The debugging result should make these things explicit:

1. failing surface
2. expected behavior
3. actual behavior
4. reproduction path
5. narrowed hypothesis set
6. root cause
7. fix boundary
8. validation and regression proof

## Workflow

### 1. Frame the Failure

Capture:

- user-visible or runtime-visible symptom
- expected behavior
- actual behavior
- affected surface or owning boundary
- whether the failure is deterministic, intermittent, or state-dependent

### 2. Reproduce Before Explaining

Produce the strongest available repro:

- browser truth for product/runtime defects
- failing test for deterministic logic
- request/response or contract proof for integration failures
- logs/traceback/query evidence for backend/runtime faults

If repro is still missing, the next step is to improve repro, not to jump to a
fix.

### 3. Bound the Failure Surface

Identify:

- owning layer
- adjacent layers that may still be implicated
- whether the failure is local, cross-boundary, or workflow-level

Do not widen the search without a reason.

### 4. Build and Shrink Hypotheses

Start with a small hypothesis set and keep narrowing it.

Questions:

- what changed recently?
- what assumptions are failing?
- what proof would falsify this hypothesis quickly?
- which branch or dependency is the most likely owner?

### 5. Gather Discriminating Evidence

Use the strongest available evidence:

- browser truth for runtime/product behavior
- code and contract inspection for ownership boundaries
- tests for deterministic logic
- logs/traces/query evidence for backend/runtime failures

Prefer evidence that rules out branches quickly over evidence that only
describes the symptom again.

### 6. Classify the Failure

Use this bounded taxonomy:

- `missing-rule`
- `enforcement-failure`
- `routing-failure`
- `review-failure`
- `closure-failure`
- `execution-drift`
- `local-implementation-defect`
- `contract-defect`
- `runtime-state-defect`

The classification must say:

- what failed
- why this class fits
- whether the correction is local or workflow-level

### 7. Apply the Smallest Correct Fix

Fix the root cause, not just the symptom, but keep the correction bounded.

If the real correction is larger than the current slice:

- land the smallest safe fix
- create an explicit follow-up for the larger debt

### 8. Validate and Freeze Regression

Closure proof should include as applicable:

- successful repro after the fix
- focused tests
- browser truth
- contract verification
- recursive scan when the bug was cross-surface or drift-prone

## Accelerate Usage Rules

- pair with `product-runtime-review` when the failure is user-facing
- pair with `anti-abuse-review` when the failing flow is sensitive
- pair with the active backend stack skill when service-layer or domain truth is
  involved
- pair with the active frontend boundary skill when UI/controller drift is
  implicated
- if the active workflow backend has a closure report, it must name:
  - expected vs actual
  - root cause
  - fix proof
  - regression proof

## Typical Smells

- patching before clear repro
- changing several layers at once without isolating the owner
- using logs as a substitute for proof of the failing user path
- fixing the symptom while the contract defect remains
- treating a workflow failure as a local bug without classification
- closure on `seems fixed` without regression proof

## References

Use local failure-classification docs, runtime packets, logs, tests, browser
truth, or stack-profile rules as needed.

## Verification

This skill is being used correctly if:

- the repro is explicit
- the hypothesis set shrinks over time
- the root cause is named
- the fix is bounded
- regression proof exists before closure
