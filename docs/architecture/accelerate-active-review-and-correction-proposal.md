# Accelerate Active Review And Correction Proposal

Date: 2026-04-23

## Purpose

This document translates the gap analysis in
`accelerate-active-review-and-correction-gap-analysis.md` into an improved
architecture proposal without jumping ahead to an executive implementation
plan.

The goal is not to bolt a new cosmetic QA layer onto `accelerate`.

The goal is to restore and strengthen a capability that earlier `accelerate`
behavior had in practice:

- bounded slice review
- requested-vs-implemented comparison
- self-review by the executing slice
- self-forensic review by the executing slice
- whole-branch side-by-side closure by the master

That older strength is still named throughout the local doctrine, but it is
currently too soft operationally. It no longer behaves as a hard delivery loop.

This proposal turns that older strength into an explicit, defect-driven,
domain-agnostic review-and-correction stack.

## Governing Inputs

Primary local sources:

- `docs/architecture/accelerate-active-review-and-correction-gap-analysis.md`
- `core/review/architecture.md`
- `references/review-architecture.md`
- `references/current-enforcement-surfaces.md`
- `skills/workflow/subagent-governance/SKILL.md`
- `skills/workflow/executing-plans/SKILL.md`

Compared external operational signals:

- `sistema-financeiro/skills/coding-agent/verification.md`
- `sistema-financeiro/skills/coding-agent/state.md`
- `launch-fullstack/skills/coding-agent/*`
- `sistema-financeiro/skills/agent-browser/SKILL.md`

## Reanalysis Summary

The most important correction to the previous analysis is this:

`accelerate` did not merely "never have" the right loop.

It still has the vocabulary of the stronger loop:

- self-review
- self-forensic review
- requested-vs-implemented comparison
- micro-review checkpoints
- review-of-review
- forensic closure

The real problem is that those pieces are currently distributed and too weakly
bound together.

In other words:

- the doctrine still says the right nouns
- but the runtime chain no longer enforces the right verbs

The GLM-style skill stacks win here not because they have richer theory than
`accelerate`, but because their implementation loop is harder to evade:

- inspect
- notice defect
- fix immediately
- recapture
- only then send

The improved proposal therefore should not copy GLM.

It should restore `accelerate`'s stronger comparative and forensic posture,
while adding the operational tightness of a short correction loop.

## What Was Lost

The following capabilities still exist conceptually but have softened in
practice.

### 1. Slice-level side-by-side judgment

Subagent and bounded-batch doctrine still says:

- requested vs implemented
- self-review
- self-forensic review

But this is currently too easy to satisfy with a narrative summary instead of a
true comparison artifact plus defect disposition.

### 2. Hard micro-review before next batch

The `executing-plans` doctrine says every bounded batch ends with a
micro-review checkpoint.

But the checkpoint packet is still too permissive:

- it does not force explicit defect capture
- it does not force fix vs waive vs block
- it does not force recapture after correction

### 3. Review-of-review as a serious quality control layer

The architecture says the master should review whether prior reviews were
serious enough.

That is strong doctrine, but it currently lacks a concrete structure for
judging:

- what defects the prior review should have caught
- whether those defects were captured
- whether the review merely described drift instead of closing it

### 4. Cross-domain correction discipline

The current stack distinguishes backend QA, frontend QA, browser truth, and
persistent regression well.

What it does not yet enforce strongly enough is that all of them share the same
correction semantics:

- detect
- classify
- repair
- reprobe
- compare
- only then promote

## Proposal Overview

The improved shape should be:

```text
Assigned Slice / Batch
  -> Requested-vs-Implemented Packet
  -> Self-Review
  -> Self-Forensic Review
  -> Defect Ledger Update
  -> Correction Loop
  -> Re-Proof / Re-Capture
  -> Independent Review or Master Review-Of-Review
  -> Integration Reconciliation
  -> Forensic Closure
```

This is not a frontend-only flow.

The same chain should apply to:

- frontend visual work
- backend contract or runtime work
- mixed fullstack flows
- workflow/governance mutation
- repo-structure and documentation mutation when those docs claim runtime truth

## Core Proposal

### 1. Promote Requested-Vs-Implemented To A First-Class Packet

Today this exists mostly as an expectation.

It should become a named mandatory packet for every meaningful bounded slice.

The packet should capture:

- assigned scope
- actual files/evidence touched
- requested behavior or contract
- implemented behavior or contract
- side-by-side variance
- explicit "met / partial / missed" judgment per requested item

This restores the old comparative discipline and prevents self-review from
turning into free-form prose.

### 2. Promote Self-Review Into Defect-Oriented Review

The current self-review output is too easy to phrase as:

- what changed
- what was tested
- seems okay

Instead, self-review should require:

- what changed
- what was supposed to change
- what defects were looked for
- what defects were found
- what remains open

That is a meaningful review, not merely a recap.

### 3. Promote Self-Forensic Review Into Drift-Hunting

Self-forensic review should not repeat self-review in more dramatic language.

Its distinct job should be:

- compare requested vs implemented
- compare promised proof vs actual proof
- inspect seams or boundaries likely to regress
- judge whether the slice introduced hidden drift

This is especially important for:

- ownership boundaries
- shared-vs-local implementation decisions
- UI seams
- contract edges
- migration/runtime changes

### 4. Add A Defect Ledger As The Shared Review Backbone

The single biggest missing surface is a defect ledger.

Without it:

- reviews cannot accumulate concrete evidence well
- master review-of-review remains vague
- closure cannot reliably distinguish fixed defects from described defects

The ledger should be shared across the branch and update at slice boundaries.

Minimum shape:

- defect id
- slice id
- domain
- surface
- type
- severity
- owner
- evidence
- detected in
- fixed in
- reproved in
- status: `open`, `fixed-pending-reproof`, `closed`, `waived`

### 5. Add A Correction-Before-Promotion Rule

This is the main GLM-style strength worth harvesting.

If a bounded slice finds a real defect during its own review or proof:

- do not promote the slice as complete
- correct it first when the fix is in-scope
- reprobe / recapture
- only then advance

That rule should apply generally, not only to screenshots.

Examples:

- UI screenshot reveals header/sidebar seam break
- API response reveals contract mismatch
- type-check reveals shape drift
- runtime console reveals ownership or state defect
- DB/runtime proof reveals migration inconsistency

The same policy applies:

- fix before promotion when the fix belongs to the slice

### 6. Add Explicit Waiver Semantics

Not every defect can or should be fixed in the current slice.

But the exception should be named, not hand-waved.

Every unresolved defect should require one of:

- fixed now
- intentionally deferred
- blocked by dependency
- outside assigned scope
- disproven after investigation

This makes residual risk honest instead of foggy.

### 7. Add Seam Proof As A Native Proof Form

The current proof stack is strong but too route-oriented for many failures.

The new stack should treat seam proof as a native packet class.

Examples:

- header/sidebar seam
- shell/content seam
- expanded/collapsed nav seam
- dialog/overlay/scroll seam
- table/header/filter seam
- backend/service/contract seam
- workflow/doctrine/runtime-use seam

The seam concept should extend beyond UI. It means "the place where two
authority layers meet and drift is likely."

### 8. Add Review-Of-Review Acceptance Questions

The master review-of-review should become more concrete.

At minimum it should ask:

- did the slice leave a real requested-vs-implemented packet?
- did self-review capture defects or only summarize work?
- did self-forensic review inspect likely seams?
- was the defect ledger updated honestly?
- was every open defect fixed, waived, or carried forward explicitly?
- did the proof actually correspond to the corrected state?

This is the missing operationalization of review-of-review.

## Domain-Agnostic Behavior

The improved stack should share the same logic across domains.

### Frontend

Likely defect families:

- alignment drift
- seam break
- duplicate structure
- inconsistent state sibling
- token/anatomy confusion
- component authority bypass

### Backend

Likely defect families:

- contract mismatch
- query-shape drift
- ownership gap
- validation mismatch
- runtime warning unreconciled
- wrong source-of-truth mutation

### Governance / Workflow / Docs

Likely defect families:

- workflow claim vs actual behavior
- planning artifact missing mandatory dependency
- packet shape drift
- docs say stronger enforcement than the runtime actually uses

## Proposed New Native Surfaces

The following surfaces would make this proposal executable later.

### Core review surfaces

- `core/review/requested-vs-implemented.md`
- `core/review/defect-ledger.md`
- `core/review/active-correction-loop.md`
- `core/review/review-of-review-gate.md`
- `core/review/seam-proof.md`

### Runtime packet surfaces

- `core/runtime-packets/requested-vs-implemented-packet.md`
- `core/runtime-packets/defect-ledger-packet.md`
- `core/runtime-packets/correction-loop-packet.md`
- `core/runtime-packets/seam-proof-packet.md`

### Local workspace surfaces

Potential later persistence in `.accelerate/`:

- `.accelerate/review/defect-ledger.yaml`
- `.accelerate/review/current-slice-review.md`
- `.accelerate/review/current-slice-forensics.md`
- `.accelerate/review/seam-proof.md`

## Enforcement Changes Required

### Subagent Governance

Current doctrine already says subagents must leave:

- self-review
- self-forensic review

The strengthened version should require:

- requested-vs-implemented packet
- defect ledger update
- explicit residual disposition

### Executing Plans

Current doctrine already says each bounded batch must end with a micro-review
checkpoint.

The strengthened version should require:

- defect registration
- correction-before-promotion when in-scope
- explicit waiver or carry-forward when not fixed
- proof that corresponds to the corrected state

### Review Architecture

Current doctrine already says the strongest review is side-by-side
reconciliation.

The strengthened version should require:

- side-by-side packet shape
- defect classification shape
- review-of-review acceptance questions

### QA / Proof Stack

Current doctrine already separates:

1. implementation proof
2. backend/frontend QA proof
3. browser truth
4. persistent regression proof
5. forensic closure

The strengthened version should preserve that ordering but add:

- defect capture at every lane
- correction semantics at every lane
- seam-proof expectations where route-level proof is not enough

## What This Proposal Intentionally Does Not Do

It does not propose:

- replacing `accelerate` with GLM-style skills
- treating browser automation as the authority over all other proof lanes
- making every tiny change go through heavyweight defect bureaucracy
- removing the current packet and review architecture

Instead, it restores the old `accelerate` comparative loop and hardens it with
short-cycle correction semantics.

## Decision

The improved direction should be:

- keep the current macro-governance stack
- restore old comparative review discipline as an explicit packet chain
- make defects first-class
- make correction loops first-class
- make review-of-review operational instead of rhetorical
- apply the same correction semantics across frontend, backend, and governance
  domains

## Executive Planning Boundary

The next correct artifact after this proposal is an executive plan that decides:

- rollout order
- minimal first slice
- exact file locations
- packet templates
- local workspace persistence shape
- which current docs are amended vs newly created

That executive plan should not reopen the analysis question. The analysis and
proposal are now durable.
