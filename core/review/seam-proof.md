# Seam Proof

## Purpose

This surface defines proof for the places where authority layers meet and drift
is likely.

Route-level screenshots or broad runtime summaries are often too coarse for
these failures.

## Definition

A seam is the join between two layers, states, or authorities where a defect is
likely to appear first.

Examples:

- header vs sidebar
- shell vs content lane
- expanded vs collapsed navigation
- modal vs overlay vs scroll-lock
- table header vs filter row vs sticky container
- backend service vs contract serializer
- workflow doctrine vs runtime packet behavior

## Rule

When the likely defect lives at a seam, the proof should focus on that seam
instead of pretending a full-route capture is enough.

## Expected Outputs

Seam proof should identify:

- seam under inspection
- states compared
- authority layers involved
- evidence used
- defect found or absence of defect
- residual uncertainty

## Domain-Agnostic Use

Frontend seams often use screenshots, browser inspection, or state captures.

Backend seams may use:

- request/response output
- service/contract comparison
- query-shape comparison
- auth/ownership checks

Governance seams may use:

- packet comparisons
- docs-vs-runtime behavior checks

## Temporary Evidence Location

When seam proof requires temporary captures, store them under the governed
project root `.tmp/` tree rather than `/tmp`.

Examples:

- `.tmp/seam-proof/header-sidebar/`
- `.tmp/seam-proof/backend-contract/`

## Relationship To Premium / Product-Critical Work

Seam proof is especially important when:

- shell structure changes
- premium direction is being implemented
- product-critical surfaces have multiple sibling states
- the likely regression is positional, comparative, or boundary-driven
