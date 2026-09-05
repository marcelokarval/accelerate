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

## Normative Correction Addendum: Root-Dependent Correction Origin

This addendum is authoritative where it is more specific than the earlier
proposal. It does not change either existing PASS lane or either embedded
rubric: their content remains an input to the corrected candidate and must be
rerecorded against that candidate rather than inherited.

### Closed states and legal root transitions

The root state enum is closed:
`{DRAFT,FROZEN,APPLYING,FAN_IN,REVIEWING,CORRECTING,LIFECYCLE_RECONCILING,CLOSED,BLOCKED,CANCELLED}`.
The relevant legal transitions are
`FAN_IN->CORRECTING`, `REVIEWING->CORRECTING`,
`LIFECYCLE_RECONCILING->CORRECTING`, `CORRECTING->APPLYING`, and
`APPLYING->FAN_IN`. A root is terminal in `CLOSED`, `BLOCKED`, or `CANCELLED`;
no terminal root is reopened. In particular, a correction requested after
`CLOSED` is rejected and must create a successor root run, linked to the closed
root by a `root_successor_receipt` that names the terminal root, correction
reason, and operator disposition.

### Unified correction-origin transaction

Recoverable proof failure and required reviewer FAIL use one serializable,
root-run scheduler-ledger transaction keyed by
`correction_key=loop_id+root_run_id`. It CAS-checks the current child,
root revision, fencing token, correction capacity, and the currently frozen
root child set. A loser of that CAS is `REJECTED` and has no effect.

When the corrected child is already represented by a current
`root_review_candidate_manifest`, or any later root evidence is bound to that
child, the transaction performs the following all-or-none effects:

1. CAS the root from `FAN_IN`, `REVIEWING`, or
   `LIFECYCLE_RECONCILING` to `CORRECTING` as applicable.
2. Mark the current root manifest superseded and invalidate every candidate-
   bound global-proof receipt, whole-change review and quorum receipt, derived
   G7 receipt, closure-eligibility result, and unconsumed
   `operator_closure_receipt` bound to that manifest.
3. Mark the predecessor node `REPLACED`, invalidate its proof and review
   evidence, consume the correction key/counters, and create exactly one child
   successor with its replacement assignment, lease, and fence.

The root transition, manifest supersession, root-dependent invalidations,
predecessor invalidation, ledger consumption, and successor creation commit
together or roll back together. No partial child or root invalidation is
legal. If no root manifest exists yet, the dependent-root invalidation set is
empty, but this is still the same serializable transaction and still creates
the exact one child successor while invalidating predecessor node evidence.

After successor acceptance, the root must advance
`CORRECTING->APPLYING->FAN_IN`, freeze a new
`root_review_candidate_manifest` over the complete current child set, and
rerun candidate-bound global proof plus whole-change review/quorum before a new
G7 may be derived. Old global proof, whole-change review/quorum, G7, closure
eligibility, or closure receipt can never satisfy the new candidate.

Late proof, review, receipt, outbox, or reconciliation evidence is accepted
only as forensic evidence if its root-manifest/child candidate and current CAS
revision still match. Otherwise reconciliation writes a stale-evidence receipt
without lifecycle advance or external effect. `LIFECYCLE_RECONCILING` may take
the correction transition above before `CLOSED`; its unconsumed closure receipt
is invalidated in the same transaction. Once `CLOSED` is committed, only the
successor-root path is legal.

### Acceptance fixture closure

Each fixture uses the closed assertion grammar
`{code,result_state,revision_effect,forbidden_effect,receipt_digests}`. The
table IDs are unique and exhaustive for this proposal. The two pre-existing
PASS-lane fixtures and their embedded rubrics
remain unchanged; this addendum adds only the correction-origin cases below.

| ID | Fixture addition / preserved lane |
| --- | --- |
| A01 | binding and lifecycle lane (preserved) |
| A02 | authority lane (preserved) |
| A03 | durable-store lane (preserved) |
| A04 | candidate-manifest lane (preserved) |
| A05 | state, root-manifest, G7, and closure lane; additions below |
| A06 | runtime lease/fence lane (preserved) |
| A07 | scheduler-ledger race and rollback lane; additions below |
| A08 | independent-review lane (preserved) |
| A09 | boundary-proof lane (preserved) |
| A10 | reconciliation lane (preserved) |
| A11 | source/target parity lane (preserved) |

The state, root-manifest, G7, and closure fixture assertions are:

`review-correction-full-path={ACCEPTED,REPLACED,changed,no_inherited_gate_evidence,predecessor+successor+invalidation+transition}`;
`post-fanin-child-correction-accepted={ACCEPTED,CORRECTING,changed,no_inherited_gate_evidence,predecessor+successor+invalidation+transition+root-manifest+global-proof+whole-change-quorum+closure}`;
`concurrent-root-invalidation-race-loser={REJECTED,CONFLICT,unchanged,no_root_or_child_invalidation,predecessor+root-manifest}`;
`root-correction-transaction-rollback={REJECTED,ROLLED_BACK,unchanged,no_partial_root_or_child_invalidation,predecessor+root-manifest+ledger}`; and
`closed-root-correction-reject={REJECTED,TERMINAL,unchanged,no_in_place_correction,predecessor+transition}`.

The accepted post-fanin assertion requires receipts for the root transition,
superseded root manifest, invalidated global proof, invalidated whole-change
quorum/reviews, invalidated derived G7, invalidated closure eligibility,
invalidated unconsumed closure receipt, predecessor invalidation, and one
successor. The closed-root assertion additionally requires a separate
successor-root receipt before any resumed work.

The scheduler-ledger race and rollback fixture assertions are:

`root-correction-race-one-winner={ACCEPTED,REPLACED,changed,no_second_root_or_child_successor,ledger+predecessor+successor+invalidation+transition}`;
`root-correction-race-loser={REJECTED,CONFLICT,unchanged,no_root_or_child_invalidation,ledger+predecessor}`; and
`root-correction-rollback-reject={REJECTED,ROLLED_BACK,unchanged,no_partial_root_or_child_invalidation,ledger+predecessor+root-manifest}`.

### Digest-token registry extension

The exact shorthand registry is closed and includes every token used above:
`predecessor->predecessor_digest`, `successor->successor_digest`,
`invalidation->invalidation_digest`, `transition->transition_digest`,
`root-manifest->root_review_candidate_manifest_digest`,
`global-proof->global_proof_digest`,
`whole-change-quorum->whole_change_quorum_digest`,
`closure->operator_closure_digest`, and `ledger->budget_ledger_digest`.
The root-dependent invalidation receipt is represented by the registered
`invalidation` token; it is not an unregistered alias. For the two exact
closed-root and race effects, `no_in_place_correction`,
`no_root_or_child_invalidation`, `no_partial_root_or_child_invalidation`, and
`no_second_root_or_child_successor` are closed forbidden-effect tokens. No
fixture may introduce a digest shorthand, result-state, or forbidden-effect
token outside this registry and table.
