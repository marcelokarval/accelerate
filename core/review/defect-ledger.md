# Defect Ledger

## Purpose

This surface defines how concrete defects are captured and carried through the
review chain.

The ledger exists because articulate review without explicit defect tracking
still allows drift to survive too long.

## Rule

When a meaningful slice or proof lane finds a real defect, the branch should
not leave it as vague commentary.

The defect should be registered with enough structure to answer:

- what is wrong
- where it lives
- who owns the fix
- whether it blocks promotion
- whether it was reproved after correction

## Minimum Defect Shape

Each defect should capture at least:

- `id`
- `slice`
- `domain`
- `surface`
- `type`
- `severity`
- `blocking`
- `owner`
- `evidence`
- `detected_in`
- `fixed_in`
- `reproved_in`
- `status`

Recommended statuses:

- `open`
- `fixed-pending-reproof`
- `closed`
- `waived`

## Domain-Agnostic Use

This is not a UI-only surface.

Frontend examples:

- `alignment-drift`
- `shell-seam-break`
- `theme-parity-gap`
- `authority-bypass`

Backend examples:

- `contract-mismatch`
- `ownership-gap`
- `query-shape-drift`
- `runtime-warning-unreconciled`

Workflow / docs examples:

- `claim-vs-runtime-drift`
- `packet-shape-miss`
- `review-failure`

## Blocking Rule

If the defect is inside the slice scope and materially affects correctness,
promotion should normally block until one of these is true:

- fixed and reproved
- explicitly deferred with honest residual risk
- explicitly blocked by dependency
- disproven after investigation

Do not use "noticed for later" as a substitute for disposition.

## Relationship To Review

The ledger does not replace review text.

It makes the review operational.

- `self-review` should mention defects found
- `self-forensic review` should judge whether likely defects were missed
- `review-of-review` should inspect whether serious defects were captured or
  glossed over

## Design-System / Premium Use

For design-system or premium branches, defects against the active visual
authority should enter the ledger explicitly.

Examples:

- contract drift
- premium seam break
- token/anatomy confusion
- page-first owner bypass

Temporary screenshots or captures supporting the defect should live under the
project root `.tmp/` tree.
