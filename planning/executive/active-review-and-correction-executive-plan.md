# Active Review And Correction Executive Plan

## Purpose

This executive plan turns the active review and correction analysis into a
bounded rollout plan for the standalone `accelerate` product.

It governs the next architectural hardening slice after:

- [accelerate-active-review-and-correction-gap-analysis.md](/home/marcelo-karval/Backup/Projetos/accelerate/docs/architecture/accelerate-active-review-and-correction-gap-analysis.md)
- [accelerate-active-review-and-correction-proposal.md](/home/marcelo-karval/Backup/Projetos/accelerate/docs/architecture/accelerate-active-review-and-correction-proposal.md)

## Governing Scenario

`accelerate` already has strong macro-governance for review, QA lanes,
subagent discipline, premium design-system application, and closure packets.

The current missing layer is the active correction chain between:

- proof generation
- slice review
- master review-of-review
- real promotion / closure

The target outcome is a defect-driven workflow where review cannot remain
purely descriptive or cosmetic.

## Source Artifacts

- source story:
  - restore and harden the older `accelerate` comparative review loop so it
    behaves as an explicit operational chain again
- PRD-lite equivalent:
  - `docs/architecture/accelerate-active-review-and-correction-gap-analysis.md`
- SDD equivalent:
  - `docs/architecture/accelerate-active-review-and-correction-proposal.md`
- task-breakdown authority:
  - this executive plan

## Artifact Sufficiency Decision

Artifact sufficiency is `accepted for executive rollout planning`.

Reason:

- the gap is already captured durably
- the proposal already names the missing native surfaces
- the remaining uncertainty is rollout order and smallest safe implementation
  slice, not problem framing

No new discovery artifact is required before bounded implementation begins.

## Selected Workflow Adapter / Current No-Adapter Reality

Current reality remains:

- standalone pre-agents repository
- no implemented workflow backend is authoritative here yet
- architecture docs and executive plans remain the governing mutation artifacts

## Selected Stack Profile

- standalone `accelerate` control-plane / workflow-governance product

## Selected Runtime Adapters

The rollout must preserve and integrate with current runtime doctrine:

- packeted root workflow
- Chrome DevTools-first browser truth
- Playwright as persistent regression proof after flow truth stabilizes
- `.accelerate/` local workspace doctrine when project-local persistence is in
  scope

## Selected Docs Posture

Native local docs remain authoritative.

Expected mutation homes:

- `core/review/`
- `core/runtime-packets/`
- `core/control-plane/`
- `skills/workflow/`
- `references/`
- `planning/executive/`

Supporting architecture docs live in:

- `docs/architecture/`

## Recommended Adjacent Skills

- `accelerate`
- `executing-plans`
- `subagent-governance`
- `apply-design-system-contract` when visual/contract-driven UI work is part of
  the branch
- `product-runtime-review` when user-facing runtime correctness is active
- `systematic-debugging` when the branch is driven by a live defect or drift

## Recommended Future Agent Candidates

No new future agent candidate is required to start this rollout.

The first hardening slice should stay root-owned until the packet shapes and
defect semantics become native.

After that, bounded specialized roles may become appropriate, such as:

- `defect triage reviewer`
- `seam-proof auditor`
- `review-of-review checker`

## Non-Goals

This plan does not:

- replace the current review architecture
- invert Chrome DevTools vs Playwright proof ordering
- copy the GLM stack or platform-specific skills directly
- force heavyweight forensic ceremony on every tiny bounded change
- make the review stack UI-only

## Required Product Rules

The rollout must preserve these rules:

1. defects are first-class review outputs
2. correction-before-promotion applies when the defect is inside the active
   slice
3. recapture / reprobe is required after meaningful correction
4. design-system premium artifacts are active authority and comparison sources,
   not decorative references
5. screenshots and temporary proof captures belong in `project-root/.tmp/`,
   not `/tmp`
6. the same correction semantics apply across frontend, backend, runtime, and
   workflow/governance domains

## Rollout Order

### Phase 1: Native Review Surface Hardening

Add the core doctrine surfaces that make the chain explicit.

Target additions:

- `core/review/requested-vs-implemented.md`
- `core/review/defect-ledger.md`
- `core/review/active-correction-loop.md`
- `core/review/review-of-review-gate.md`
- `core/review/seam-proof.md`

Acceptance:

- each surface has a bounded purpose
- overlap is minimized
- the chain from slice review to correction to closure is explicit

### Phase 2: Runtime Packet Hardening

Add packet shapes that make the new doctrine executable during real runs.

Target additions:

- `core/runtime-packets/requested-vs-implemented-packet.md`
- `core/runtime-packets/defect-ledger-packet.md`
- `core/runtime-packets/correction-loop-packet.md`
- `core/runtime-packets/seam-proof-packet.md`

Acceptance:

- packet fields support bounded slices, subagents, and root-owned work
- packet shapes are compatible with existing branch entry / runtime delta /
  QA-proof / closure packet doctrine

### Phase 3: Control-Plane Enforcement Integration

Wire the new surfaces into the current enforcement layer.

Expected mutation homes:

- `core/control-plane/branch-enforcement-matrix.md`
- `core/control-plane/quick-invocation-map.md`
- `core/control-plane/root-laws.md`
- `core/review/architecture.md`
- `references/review-architecture.md`
- `references/current-enforcement-surfaces.md`

Acceptance:

- active correction is triggered by the right branch classes
- review-of-review is more operational than rhetorical
- micro-review checkpoints cannot pass on summary language alone

### Phase 4: Workflow Skill Integration

Harden the execution skills that currently carry the soft version of this loop.

Expected mutation homes:

- `skills/workflow/executing-plans/SKILL.md`
- `skills/workflow/subagent-governance/SKILL.md`

Acceptance:

- every bounded batch leaves requested-vs-implemented plus defect disposition
- every subagent return leaves requested-vs-implemented plus defect disposition
- correction-before-promotion and recapture semantics are explicit

### Phase 5: Premium / Contract-Driven UI Integration

Make the design-system and premium lane use the new review chain explicitly.

Expected mutation homes:

- `core/review/design-system-contract-application.md`
- `core/review/premium-interface-production.md`
- `skills/design-system/apply-design-system-contract/SKILL.md`

Required enforcement:

- contract and premium artifacts must be listed in requested-vs-implemented
- visual defects against those authorities must enter the defect ledger
- seam proof is required for shell/layout-sensitive work
- temporary screenshots and captures live under `.tmp/`

Acceptance:

- premium review can no longer remain moodboard-level
- implementation review must say what drift was found, corrected, reproved, or
  explicitly deferred

### Phase 6: Local Workspace Persistence

Evaluate whether the new defect/correction surfaces should persist into
`.accelerate/`.

Candidate later additions:

- `.accelerate/review/defect-ledger.yaml`
- `.accelerate/review/current-slice-review.md`
- `.accelerate/review/current-slice-forensics.md`
- `.accelerate/review/seam-proof.md`

Acceptance:

- persistence stays small and useful
- it does not duplicate temporary capture material from `.tmp/`

## Smallest Safe First Slice

The smallest safe implementation slice is:

1. create the five `core/review/` doctrine files
2. update `core/review/architecture.md`
3. update `skills/workflow/executing-plans/SKILL.md`
4. update `skills/workflow/subagent-governance/SKILL.md`

Reason:

- this restores the missing operational chain at the doctrine level first
- it hardens both root-owned and delegated execution
- it does not yet require packet-template proliferation or local-workspace
  persistence changes

## Task Breakdown Readiness

Task breakdown is `ready`.

A later implementation task breakdown should separate work into:

1. doctrine surfaces
2. packet surfaces
3. control-plane wiring
4. skill integration
5. premium/design-system integration
6. `.accelerate/` persistence decision

## Proof Lane Expectations

The implementation rollout should leave explicit proof in this order:

1. doc-to-doc consistency proof
2. packet-shape consistency proof
3. skill invocation / branch-enforcement consistency proof
4. visual/design-system branch proof that the premium lane now uses defect and
   recapture semantics
5. forensic closure proof

Where temporary evidence is needed, it should live in:

- `project-root/.tmp/`

not:

- `/tmp`

## Residual Risks / Open Decisions

- exact packet field size must avoid making bounded runs too verbose
- seam taxonomy must be broad enough for backend/runtime seams, not only UI
- local-workspace persistence may be useful but should not be decided before
  the doctrine and packet surfaces stabilize
- branch-enforcement should stay proportional; tiny bounded edits must not be
  forced into heavyweight defect management unnecessarily

## Next Bounded Slice

Implement `Phase 1` only:

- create the native `core/review/` surfaces
- harden `core/review/architecture.md`
- stop there and rerun a bounded review of the doctrine shape before moving to
  packet templates and control-plane wiring
