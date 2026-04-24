# Accelerate Active Review And Correction Gap Analysis

Date: 2026-04-23

## Purpose

This document persists the current analysis of a workflow weakness in the
standalone `accelerate` product before any executive implementation plan is
written.

The observed weakness is not the absence of review, QA, or browser proof in
the abstract. The weakness is that the current local stack is still too loose
at the point where real defects are detected, classified, assigned, corrected,
and re-proved.

That looseness allows review to remain partially descriptive or cosmetic even
when the branch already has:

- planning
- browser-proof lanes
- runtime packets
- handoff and closure packets
- design-system contracts
- premium implementation artifacts

The immediate trigger was a real implementation miss in product-facing UI:

- a shell/header mutation landed
- the header/sidebar seam drifted in expanded and collapsed states
- the broader workflow did not stop early enough on that layout defect

This artifact records why that happened and what doctrinal strengthening is now
required.

## Runtime Packet

- `active branch`: architecture / workflow hardening
- `phase`: analysis before executive planning
- `issue stack`: pre-adapter / no-backend exception; durable architecture doc
  is the governing artifact for this slice
- `single-threaded exception`: this analysis stayed root-owned because the
  current bottleneck is workflow judgment, not an independent implementation
  shard
- `proof lane`: side-by-side repository comparison and local doctrine
  reconciliation
- `closure blocker`: no executive plan should be written until this gap is
  captured durably

## Scope

This analysis is intentionally broader than frontend polish.

The required correction must apply whenever the AI assumes execution
responsibility for real engineering work, including:

- frontend implementation
- backend implementation
- cross-layer feature work
- runtime and infra mutation
- documentation mutation when it claims behavioral truth
- review-only branches

The new doctrine must prevent review from collapsing into:

- visual commentary without defect closure
- backend claims without runtime reconciliation
- test claims without ownership-aware failure classification
- implementation summaries that skip the active correction loop

## Compared Inputs

External skill stacks inspected:

- `/home/marcelo-karval/Backup/Projetos/nextjs/launch-fullstack/skills`
- `/home/marcelo-karval/Backup/Projetos/nextjs/sistema-financeiro/skills`

Most relevant compared surfaces:

- `agent-browser`
- `ui-ux-pro-max`
- `coding-agent`
- `coding-agent/planning.md`
- `coding-agent/verification.md`
- `auto-target-tracker`

Local `accelerate` authorities reconciled during this analysis:

- `core/review/architecture.md`
- `references/review-architecture.md`
- `references/qa-proof-stack.md`
- `planning/executive/html-design-system-premium-enforcement-regression.md`

## What The External Stacks Actually Do Better

The inspected GLM-oriented stacks do not appear to win because of a single
secret tool or a magic model. No direct authoritative evidence of
`openclaw` or `paperclip` as the decisive differentiator was found in the
inspected skill directories.

The stronger signal is operational:

### 1. Short verification loops

The external browser and coding skills repeatedly enforce a loop closer to:

```text
observe -> mutate -> capture -> inspect -> fix -> recapture -> only then deliver
```

This is materially different from a looser pattern of:

```text
plan -> implement -> run proof late -> maybe notice residual drift
```

### 2. Fix-before-send discipline

The strongest external verification instruction is not merely "test it". It is
effectively:

- if the screenshot or runtime capture shows a problem
- fix the code
- recapture
- do not send the result as complete before the visible problem is reconciled

### 3. Browser as an active sensor, not only a closure proof

The external browser skills treat browsing as a structured interaction loop,
not only as the final evidentiary screenshot step.

The main value is:

- route opening
- snapshot
- interaction
- post-interaction snapshot
- screenshot
- repeated inspection across states

### 4. Step outputs that are testable per batch

The compared planning material is stronger than a generic task list because it
expects each step to produce something concretely checkable before the next
batch proceeds.

## Local Accelerate Strengths

The current local `accelerate` stack is already strong on macro-governance:

- root classification
- issue and planning discipline
- review architecture
- QA lane separation
- browser truth before persistent Playwright
- `.accelerate/` local workspace continuity
- review packets, bundles, and handoff summary
- premium design-system contract enforcement

This analysis does not invalidate those gains.

The problem is more specific: the current architecture is stronger at
explaining and governing work than at forcing the smallest corrective loop
inside the work itself.

## Gap Classification

This should now be classified as a combined:

- `enforcement-failure`
- `review-failure`

Why that classification fits:

- the workflow had enough review surfaces to notice drift
- but did not enforce defect-class registration and active recapture strongly
  enough
- therefore defects could remain residual too late in the branch
- and review could sound serious while still being too passive in practice

This is not primarily:

- `missing-rule`, because substantial review doctrine already exists
- `closure-failure` alone, because the gap begins before closure
- `routing-failure`, because the correct general lane was chosen

## Current Local Weaknesses

### 1. Browser proof is still too late and too coarse

The current proof ordering is correct:

1. implementation proof
2. backend/frontend QA proof
3. browser truth
4. persistent regression proof
5. forensic closure

But for defect-prone work the browser lane is still often used too much as:

- route-level proof
- screenshot evidence
- closure support

and not enough as:

- implementation-time defect sensor
- state-by-state seam inspection
- correction trigger before promotion

### 2. Review lacks a mandatory defect ledger

The current review architecture requires evidence, classification, residual
risk, and recommendation.

That is necessary, but it is not yet a full defect-management contract.

What is still missing:

- explicit defect object
- owner assignment for each defect
- defect type taxonomy
- severity and blocking behavior
- explicit corrected / not-corrected status
- mandatory recapture after fix

Without that structure, review can remain articulate but insufficiently
operational.

### 3. The workflow still under-models seams

Route-level screenshots are not enough for many failures.

Critical defects often live in seams such as:

- header vs sidebar
- shell vs content lane
- collapsed vs expanded navigation
- modal vs overlay vs scroll lock
- table header vs filter row vs sticky container
- page shell vs embedded support / drawer / popover

These seams are where product-facing drift often appears first.

The current stack recognizes product-critical surfaces, but it does not yet
enforce seam-specific proof as a first-class packet type.

### 4. Implementation review is still too easy to localize cosmetically

The current system does not yet force strong enough questions such as:

- was the correct ownership layer mutated first?
- should this have landed in a shared primitive or compound instead of a page?
- did the change introduce duplicate local styling or structure?
- did one state improve while a sibling state regressed?
- does the implementation bypass an existing authority surface?

Without those questions, the review can approve a visually improved result that
still increases structural drift.

### 5. Active correction is implied, not governed

Today the system can say:

- defect found
- corrected later
- retested

But the branch does not yet have a named workflow that mandates:

```text
detect -> classify -> assign -> fix -> recapture -> compare -> close
```

That absence is the core reason the review effect can still feel too cosmetic.

## Why This Must Apply Beyond Frontend

The same failure mode exists in backend and other domains even when the surface
is not visual.

Equivalent backend examples:

- query-shape drift found during proof but not registered as a blocking defect
- auth/ownership miss treated as a residual note instead of an assigned fix
- migration/runtime warning observed without recapture after correction
- contract review noticing DTO mismatch but not enforcing source-owner repair

Equivalent runtime/infra examples:

- operational warning noticed but not classified and tracked as a bounded
  correction item
- environment or wrapper drift acknowledged without a fresh proof pass after
  the fix

Therefore the needed change is not "more UI polish".

The needed change is a domain-agnostic active correction doctrine with
domain-specific proof companions.

## Required New Doctrine

The local architecture now needs a stronger review and correction layer that is
mandatory whenever the AI is executing meaningful work, not only when the task
explicitly says "review".

At minimum, the doctrine must include the following concepts.

### 1. Defect Ledger

Every meaningful review or proof lane should be able to emit explicit defects.

A defect record should capture:

- `id`
- `domain`
- `surface`
- `defect type`
- `severity`
- `blocking status`
- `owner`
- `evidence`
- `expected authority layer`
- `fix status`
- `recapture status`

### 2. Active Correction Loop

The workflow must stop treating correction as an optional follow-on.

The named loop should be:

```text
capture
  -> inspect
  -> register defects
  -> assign owner
  -> fix
  -> recapture
  -> compare
  -> only then promote
```

### 3. Seam Proof

For defect-prone implementation work, proof must cover critical seams rather
than only full-route screenshots or single test summaries.

### 4. Implementation Review Gate

Before review/closure promotion, the branch should answer:

- was the correct owner layer mutated?
- was shared-first discipline respected?
- did the fix remove or add duplication?
- did sibling states remain aligned?
- does any residual defect still block promotion?

### 5. Domain-Specific Proof With Shared Review Semantics

Frontend, backend, and runtime work should not share identical evidence, but
they should share the same correction semantics:

- detect
- classify
- fix
- recapture
- compare
- promote or block

## Candidate New Native Surfaces

This analysis intentionally stops short of an executive plan, but the likely
native surfaces are already clear enough to name.

Potential additions:

- `core/review/defect-ledger.md`
- `core/review/active-correction-loop.md`
- `core/review/implementation-review-gate.md`
- `core/review/seam-proof-packet.md`
- `core/runtime-packets/defect-packet-templates.md`
- `core/review/domain-defect-taxonomy.md`

Potential companion references:

- `references/defect-ledger.md`
- `references/active-correction-loop.md`
- `references/implementation-review-gate.md`

Potential local-workspace implication:

- `.accelerate/status/` or `.accelerate/review/` may later persist active
  defects and closure disposition

## Example Defect Families

The taxonomy should not be UI-only, but the current motivating examples are
useful.

Frontend-oriented defect families:

- `alignment-drift`
- `spacing-drift`
- `shell-seam-break`
- `duplicate-visual-block`
- `theme-parity-gap`
- `overflow-or-clipping`
- `state-mismatch`
- `authority-bypass`

Backend-oriented defect families:

- `ownership-gap`
- `query-shape-drift`
- `contract-mismatch`
- `migration-proof-gap`
- `runtime-warning-unreconciled`
- `service-boundary-bypass`

Cross-domain defect families:

- `review-claim-vs-reality`
- `proof-gap`
- `wrong-owner-fix`
- `residual-blocker-hidden`

## Non-Goals

This analysis does not recommend:

- turning `accelerate` into a copy of the GLM stack
- collapsing Chrome DevTools-first proof ordering into broad browser automation
- replacing local doctrine with remote platform-specific skills
- making every tiny bounded task carry heavyweight forensic ceremony
- treating style commentary as equivalent to defect closure

## Decision

The local `accelerate` product should now treat active review and active
correction as a missing architecture layer between:

- proof generation
- review commentary
- real closure

That layer must be:

- explicit
- defect-oriented
- owner-aware
- recapture-driven
- applicable across frontend, backend, and runtime domains

## Next Step Boundary

The correct next step after this document is not direct implementation.

The correct next step is to write an executive plan that translates this
analysis into bounded native surfaces, enforcement points, and rollout order.

That executive plan should use this analysis as the governing source artifact
for the gap, rather than rediscovering the problem from scratch.
