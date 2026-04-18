# Parity Decision: Current Enforcement Surfaces

## Purpose

This artifact is the explicit `parity-replacement-gate` packet for the
`current enforcement surfaces` surface.

It records the first focused enforcement-inventory benchmark run after the
near-parity promotion queue moved into Tier 2.

## Surface Under Judgment

- local native surface:
  - `core/risk/enforcement-surfaces.md`
- legacy comparison surface:
  - legacy/global `current-enforcement-surfaces` behavior under the same
    benchmark contract

## Why This Surface Matters

This surface governs whether the runtime can:

- name the right backend/frontend/runtime/governance obligations
- reject closure when billing/self-service enforcement is under-run
- distinguish generic “blocked” from concrete branch-specific violations
- apply harvested hard rules like:
  - `no duplicate Stripe truth outside dj-stripe`
  - `no backend-owned localized copy in props`
  - backend validation authority over frontend-only validation
  - `anti-abuse` on billing/self-service

## Native Authority Proof

The local primary written authority now lives in:

- `core/risk/enforcement-surfaces.md`

The surface remains tracked in:

- `docs/architecture/accelerate-legacy-to-local-gap-matrix.md`
- `planning/executive/near-parity-promotion-queue.md`

## Benchmark Or Run Evidence

### Benchmark Shape

- focused enforcement-inventory benchmark
- target request: billing self-service flow with:
  - duplicated Stripe subscription status in an app-owned model
  - localized backend-owned copy in props
  - frontend-led validation posture
  - no anti-abuse review
  - no browser truth
  - no AI Review
- judged on:
  - closure harshness
  - enforcement-surface specificity
  - correctness of Stripe/copy/validation/abuse judgments
  - branch-specific blocker fidelity

### Local Output Signal

The local side chose:

- non-trivial `product-critical user surface` + `issue-driven delivery`
- explicit `query / contract-sensitive backend`
- explicit `copy / locale boundary`
- explicit provider-truth risk

Strong points:

- blocked closure immediately
- named the strongest harvested concrete violations directly:
  - `no duplicate Stripe truth outside dj-stripe`
  - `no backend-owned localized copy in props`
  - backend validation authority failure
  - missing `anti-abuse-review`
  - missing browser truth
  - missing `AI Review`
- used the native enforcement language more directly than the legacy side
- kept the first corrective step centered on truth ownership before cosmetic or
  narrative closure work

### Legacy Output Signal

The legacy side chose:

- non-trivial, issue-driven, product-critical billing branch
- blocked closure correctly
- named the major violations correctly

Strong points:

- strong skill bundle and closure harshness
- clear proof that “looks correct locally” is not acceptable closure evidence

Residual weakness versus local:

- it was slightly more generic in how it expressed the enforcement inventory
- it relied more on a broad product-critical bundle and less on the sharper
  native clauses that the local inventory now makes first-class

### Comparative Judgment

Winner for this focused enforcement-surface benchmark:

- `local`, by small margin

Reason:

- both sides blocked closure correctly
- the local side applied the harvested enforcement clauses more explicitly and
  more concretely to the billing/self-service scenario
- this benchmark rewarded concrete enforcement naming, not just general
  “blocked product-critical branch” posture

## Residual Gap Statement

Residual gap:

- no material operational deficit was exposed in this benchmark slice

The remaining caution is only portfolio-wide:

- more billing/self-service or other trust-sensitive reruns would still be
  useful
- but this surface no longer appears to lag the legacy in practical doctrine

## Replacement Risk

Low for this surface.

If it regresses, the likely failure mode would be:

- collapsing back to generic blocked-language without naming the concrete
  enforcement violations

That is a runtime-regression risk, not a current authority gap.

## Decision Proposal

- verdict: `local ahead`

Effect:

- the local enforcement inventory becomes the clearer primary authority for
  this surface
- the legacy remains supporting doctrine and comparison material, not the
  stronger operational distribution

## Next Correction

No doctrinal correction is required before replacement for this surface.

The next useful proof would be:

- another trust-sensitive rerun in a different category such as auth, export,
  or upload
- to prove the same concrete-enforcement sharpness travels beyond the billing
  slice
