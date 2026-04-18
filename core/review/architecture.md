# Review Architecture

This document is the native core home of review shape, review depth, and
reconciliation logic.

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

- implementer or bounded subagent -> self-review
- implementer or bounded subagent -> self-forensic review
- backend tester -> backend QA packet
- frontend tester -> frontend QA packet
- browser-proof auditor -> browser-proof packet
- E2E regression engineer -> persistent regression packet
- master -> output review
- master -> review-of-review
- master -> integration review
- master -> closure review

## Forensic Reconciliation Model

The strongest review is a side-by-side reconciliation.

It must compare:

- requested vs implemented
- promised vs delivered
- issue scope vs actual landing
- review claim vs reality

This is not optional narrative. It is the point of forensic closure.

## Review-Of-Review

When previous reviews exist, the master should judge whether they were serious
enough and whether they missed real seams, regressions, or drift.

Do not only review the code. Review the quality of prior review claims.

## Review Profiles

Choose the review profile that matches the work:

- `fast bounded review`
- `runtime-heavy review`
- `contract-heavy review`
- `forensic integration review`
- `delegated-slice review`
- `product-critical closure review`
- `persisted-modeling review`

## Persisted-Modeling Review Rule

When the branch is reviewing backend schemas, persistent models, compiled
artifacts, DTO truth, or contract-heavy domain storage, use
`persisted-modeling review` explicitly.

That profile should not collapse into generic prose review.

## Semantic Scope Recovery

When the requested target does not exist literally, review should not stop at a
mechanical `not found` unless the task truly becomes impossible.

The reviewer should:

1. declare the missing literal target explicitly
2. look for the closest semantically adjacent target in the same repo or layer
3. explain why the adjacent target is a valid re-scope candidate
4. choose between:
   - strict literal scope
   - semantically recovered scope
   - dual scope
5. state that choice explicitly in the output

Use this rule to avoid both bad extremes:

- inventing missing structures
- staying so literal that the review becomes less useful than the user request

### Default Preference

Prefer the smallest honest semantic recovery that still answers the user's real
intent better than a narrow literal fallback.

If two plausible scopes exist, the reviewer should say so and name which one is
primary.

### Dual-Scope Preference

Prefer `dual scope` instead of a single recovered scope when all are true:

- the literal surviving target is still materially relevant to the request
- a semantically adjacent target exists and is strongly aligned with the
  user's likely intent
- reviewing only the literal target would be correct but materially less useful
- reviewing only the recovered target would risk losing a meaningful local seam
  that the user explicitly named

In that situation:

- keep the explicitly named surviving target as one review surface
- elevate the recovered adjacent target from mere comparator context to a true
  co-equal review surface
- state which surface is primary and why
- state what the secondary surface contributes that the primary one cannot

Do not hide behind comparator language when the recovered domain is actually
part of the honest answer.
