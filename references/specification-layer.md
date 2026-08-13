# Specification Layer

Use this supporting module when work needs a proportional pre-implementation
contract. Native authority lives in `planning/specification/` and the control
plane gates linked below.

## Stable Terminology

- **Specification Lifecycle**: the process from intent and requirements through
  accepted design, task/test mapping, implementation, proof, and reconciliation.
- **Software Design Document**: the technical design artifact abbreviated as
  `SDD`. It is never the name of the lifecycle.
- **Source Verification**: evidence gathering about external sources, versions,
  provenance, and uncertainty. It informs but cannot accept a design.
- **TEST-DESIGN.md**: the pre-code testing strategy and dimension matrix.
- **TDD Receipt**: the observed baseline, implementation, correction, and
  reproof history. It is not Test Design.
- **DESIGN.md**: product UI, interaction, information architecture, or
  design-system authority.
- **ADR**: a durable architecture decision, alternatives, consequences, and
  reversal conditions.

Do not use the same acronym or artifact to mean more than one item above.

## Native Templates And Gates

- `../planning/specification/README.md`
- `../planning/specification/engineering-artifact-manifest-template.json`
- `../planning/specification/spec-capsule-template.md`
- `../planning/specification/traceability-template.md`
- `../planning/architecture/delta-sdd-template.md`
- `../planning/architecture/sdd-template.md`
- `../planning/architecture/adr-template.md`
- `../planning/design/design-disposition-template.md`
- `../planning/testing/test-design-template.md`
- `../planning/testing/tdd-receipt-template.md`
- `../core/control-plane/specification-entry-gate.md`
- `../core/control-plane/sdd-mode-gate.md`
- `../core/control-plane/decision-artifact-gate.md`
- `../core/control-plane/test-design-gate.md`
- `../core/control-plane/tdd-entry-gate.md`

## Proportional Materialization

Every mutation uses one semantic mode:

1. `micro`: a non-empty Spec Capsule;
2. `standard`: an accepted delta Software Design Document;
3. `hierarchical`: an accepted root Software Design Document with explicit
   child dispositions;
4. `critical`: the root document plus separate ADR, threat model, Test Design,
   and rollback artifacts.

Mutation mode `none` is invalid. Direct-fast-path mutation stays small through
`micro`; it does not bypass specification or issue bootstrap.

## Lifecycle

```text
request / governing issue
  -> Specification Entry Gate
  -> deterministic SDD mode
  -> draft artifacts
  -> root acceptance
  -> explicit decisions and traceability
  -> Test Design
  -> TDD / repro / characterization / semantic baseline
  -> implementation
  -> proof and correction
  -> execution-to-spec reconciliation
  -> root closure
```

`draft` artifacts cannot authorize implementation. The execution authority must
be `accepted` or `implementing`, and acceptance remains root-owned.

## Engineering Artifact Manifest

The JSON manifest is the machine-readable index, not a replacement for the
linked artifacts. It records:

- classification triggers, selected mode, and accepted design locator;
- all dispositions and reasons;
- stable requirement, task, test, and proof locators;
- the distinct Test Design and TDD Receipt state;
- correction generation and proof generation.

Validate it at the relevant stage. Implementation rejects planned proof,
duplicate IDs, incomplete Test Design dimensions, a change-kind/TDD mismatch,
and proof older than a correction.

## Traceability And Feedback

Every behavioral requirement follows:

```text
REQ -> task -> test or justified exception -> proof locator
```

Planned proof remains labelled `planned`. A command that has not run is not
observed proof. Any correction invalidates stale proof for its affected scope
and requires a new proof generation before promotion.

Re-enter specification when execution reveals missing acceptance, ambiguous
behavior, hidden dependencies, under-classified risk, or work that belongs in a
separate issue. Correct the governing artifact before pushing uncertainty into
implementation or review.

## Product Framing And Implementation Design

User stories and PRD-lite remain appropriate when actor, value, scope, or
capability acceptance are still unclear. Task breakdown remains appropriate
when an accepted specification needs dependency-aware execution slices. These
artifacts complement the Specification Lifecycle; they do not replace the
Engineering Artifact Manifest or accepted technical design.
