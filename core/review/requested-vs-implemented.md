# Requested Vs Implemented

## Purpose

This surface defines the mandatory side-by-side comparison for any meaningful
bounded slice.

The packet exists to prevent review from collapsing into a recap of activity.

Every serious slice should leave a compact answer to:

- what was requested
- what was actually implemented or audited
- what matched
- what partially matched
- what was missed

## Rule

Do not let `self-review` or `closure review` substitute for this comparison.

`Requested-vs-implemented` is the minimum comparative backbone for:

- bounded root-owned batches
- delegated implementation slices
- delegated audit slices
- contract-heavy review branches
- design-system and premium UI slices

## Minimum Contents

Every packet should identify:

- assigned scope
- actual scope touched
- files or evidence touched
- authoritative contract or comparison source
- requested items
- implemented items
- `met / partial / missed` judgment per requested item
- explicit variance notes where the result differs from the ask

## Comparison Sources

Choose the authority that makes the judgment honest.

Common authorities:

- plan or executive artifact
- issue scope
- design-system contract
- premium direction artifact
- backend truth model
- runtime proof expectation
- previously promised packet or review claim

If no authority was available, say so explicitly instead of inventing one.

## Relationship To Other Review Surfaces

- `self-review`
  - what the slice believes it achieved and what defects it saw
- `self-forensic review`
  - whether drift, seam failures, or hidden misses remain
- `requested-vs-implemented`
  - whether the slice actually satisfied the assigned target

These are adjacent surfaces, not duplicates.

## Promotion Rule

Do not promote a slice on "looks good" language alone when the comparison still
shows `partial` or `missed` items without explicit disposition.

Those items must be:

- corrected in-scope
- explicitly deferred
- explicitly blocked
- explicitly disproven after investigation

## Design-System / Premium Use

When a branch is governed by `docs/reference/design-system*` artifacts,
`requested-vs-implemented` should compare against:

- `design-system.contract.md`
- the active premium direction artifact
- the current rollout or sprint artifact when one exists

This keeps premium work tied to authority instead of moodboard judgment.
