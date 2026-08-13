---
name: specification-lifecycle
description: Govern proportional specification readiness for any software or workflow mutation. Use when classifying SDD depth, drafting or checking a Spec Capsule or SDD, completing artifact dispositions and requirement traceability, deciding whether design may enter implementation, or reopening specification after scope, risk, or contract changes.
---

# Specification Lifecycle

Make the intended change, its authority, and its proof obligations explicit
before implementation. Scale the artifact, never the semantic obligation.

## Core Rule

Every mutation uses one SDD mode: `micro`, `standard`, `hierarchical`, or
`critical`. Read-only work may be `no-op`; mutating work may not use `none`.
Select the highest mode required by any observable trigger.

Accelerate root owns mode selection, artifact acceptance, exceptions, and the
implementation-entry decision. A specification specialist may draft, inspect,
and report gaps but must not accept its own artifact or close the issue.

## Boundaries

- Use `architecture` for structural alternatives, boundaries, and ADR-worthy
  decisions; this skill verifies that their disposition and authority are clear.
- Use `test-driven-development` for the change-time baseline and proof loop.
- Use `test-engineering` for pre-code test strategy and independent regression
  assessment.
- Use the active tracker skill for issue lifecycle; this skill does not mutate a
  work item.
- Do not use this as a root router or as permission to implement.

## Workflow

### 1. Establish The Authority Set

Identify the governing issue or approved exception, current design authority,
repo-local instructions, existing decisions, and forbidden sources. Separate
governing authority from supporting evidence and generated exports.

### 2. Classify Proportionally

Read [references/lifecycle-contract.md](references/lifecycle-contract.md). Record
the observed triggers and deterministic minimum mode. An override may only
raise the mode and must include a substantive reason.

If evidence is incomplete between two plausible modes, retain the higher mode
until root resolves the uncertainty.

### 3. Materialize The Artifact Chain

Create or update the mode-required Spec Capsule or SDD. Record substantive
dispositions for ADR, product design, Test Design, agents, rollout, rollback,
observability, and governing docs. Map every behavioral requirement through:

```text
requirement -> task -> planned test or justified exception -> proof locator
```

Keep planned proof distinct from observed proof. Use stable IDs and locators;
do not substitute a prose summary for traceability.

### 4. Decide Readiness

Require the design authority to be `accepted` or `implementing`, never merely
`draft` or `superseded`. Validate the Engineering Artifact Manifest at the
actual stage when the repository provides a validator.

Return `pass`, `fail`, or `blocked` with concrete missing fields. `Pass` means
the specification contract is ready for root entry evaluation; it does not
authorize implementation by itself.

### 5. Reenter When Truth Changes

Reopen specification when discovery or implementation changes observable
behavior, ownership, a boundary, risk, dependency posture, rollout, rollback,
or proof obligations. Preserve the prior decision as history, identify which
requirements and tasks are stale, and re-run Test Design and TDD entry where
affected.

Do not silently patch the design after code and call the original acceptance
current.

## Return Contract

Return a compact readiness record containing:

- issue or exception authority
- mutation and change kind
- observed triggers and deterministic minimum
- selected SDD mode and upward-override reason, if any
- design artifact ID, state, owner, acceptor, and locator
- disposition and traceability completeness
- Test Design and TDD-entry status
- reentry generation and stale artifacts, if any
- defects, residual uncertainty, and `pass | fail | blocked`
- explicit root acceptance boundary

## Verification

Before returning, verify that the artifact exists at its locator, its state is
honest, all required dispositions have scope-specific reasons, task/test IDs
resolve, and no planned evidence is labelled observed. Report missing authority
or unavailable validation as blocked, not inferred success.
