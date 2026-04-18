# Review Architecture

## Local Authority Status

Primary local authority lives in:

- `../core/review/architecture.md`

Use this reference for supporting doctrine and comparison depth.

If the native local file and this reference disagree, prefer the local file.

Use this module when review shape, review depth, or reconciliation logic must
be explicit.

## Review Catalog

The review system includes:

- `micro-review`
- `branch review`
- `runtime/product review`
- `integration review`
- `forensic review`
- `closure review`
- `review-of-review`

## Reviewer Matrix

Default reviewer ownership:

- implementer or subagent -> self-review
- implementer or subagent -> self-forensic review
- backend tester -> backend QA packet
- frontend tester -> frontend QA packet
- browser-proof auditor -> browser-proof packet
- E2E regression engineer -> persistent regression packet
- master -> output review
- master -> review-of-review
- master -> integration review
- master -> closure review

## Trigger Matrix

Typical triggers:

- end of a bounded batch -> `micro-review`
- branch nearing closure -> `branch review`
- subagent return -> `output review` + `review-of-review`
- multiple slices assembled -> `integration review`
- pre-closure -> `forensic review` + `closure review`

## Review Output Contract

Every review should leave:

- scope reviewed
- evidence used
- classification
- residual risk
- recommendation: `done`, `partial`, `follow-up`, or `blocked`

## Failure Classification Gate

When the work reveals a serious miss, repeated drift, or workflow weakness, the
review must classify the failure type explicitly instead of stopping at vague
commentary.

Use this bounded taxonomy:

- `missing-rule`
- `enforcement-failure`
- `routing-failure`
- `review-failure`
- `closure-failure`
- `execution-drift`

The classification should say:

- what failed
- why this class fits
- whether the correction is local or workflow-level
- what the next correct step is

## Forensic Reconciliation Model

The strongest review is a side-by-side reconciliation.

It must compare:

- requested vs implemented
- promised vs delivered
- issue scope vs actual landing
- review claim vs reality

This is not optional narrative. It is the point of forensic closure.

## Review-Of-Review

When previous reviews exist, the master must judge whether they were serious
enough and whether they missed real seams, regressions, or drift.

Do not only review the code. Review the quality of prior review claims.

## Forensic Depth Model

Use proportional depth:

- light for tiny bounded work with low risk
- medium for standard non-trivial work
- full recursive depth for cross-surface, delegated, or drift-prone work

If the work was delegated, the forensic review usually needs to inspect the
review chain itself.

## Review Profiles

Choose the review profile that matches the work:

- `fast bounded review`
- `runtime-heavy review`
- `contract-heavy review`
- `forensic integration review`
- `delegated-slice review`
- `product-critical closure review`

## Product-Critical Closure Protocol

For critical user-facing surfaces, closure must explicitly reconcile:

- job-to-be-done vs delivered flow
- backend truth model vs frontend surface coverage
- query-shape proof vs actual backend fetch behavior when the surface is
  backend-heavy or relationally aggregated
- approved wireframe or visual contract vs implemented composition
- reference ASCII vs target ASCII when premium reference extraction was part of
  the flow
- design-system language vs actual visual result
- the opening `Branch Entry Packet` vs the branch that was actually executed
- artifact sufficiency vs artifact mere presence when wireframes, matrices, or
  backend packets were required

Do not close these flows on technical correctness alone.

## Visual And Product Reconciliation

When a visual reference or approved wireframe exists, the final review must say:

- what composition was approved
- what the reference ASCII proved
- what the target ASCII proposed
- what was implemented
- what changed intentionally
- what drift remains

If the result is only a technical repair, say so and keep the issue or
follow-up chain honest.
