# Test Design Gate

## Purpose

Use this gate after the design authority is accepted and before implementation.
It converts requirements and risk into a proportional, reviewable proof plan.

## Rule

Mutating work must have an accepted Test Design or an explicit governing
artifact that contains the complete Test Design contract. Small work may keep
the design compact; no work may silently omit a required dimension.

Use `planning/testing/test-design-template.md` for the canonical fields.

## Required Inputs

- accepted Spec Capsule or SDD and stable requirement IDs
- change kind and selected TDD / proof mode
- task mapping and ownership boundaries
- risk, compatibility, migration, and rollback constraints
- available test levels, fixtures, runtimes, and authorized providers

If the design authority is only `draft`, return to specification/design rather
than planning proof for implementation.

## Required Dimension Gate

Disposition every dimension as `covered` or `not-applicable`:

- happy behavior
- negative behavior
- boundary values or transitions
- permission or ownership
- concurrency or idempotency
- failure or recovery
- fixtures or test data
- observability or diagnostics
- lowest effective test level

`Not applicable`, `none`, or an empty field is insufficient without a
scope-specific reason. A dimension may be covered at more than one level when
the risk crosses boundaries, but broad test volume is not a substitute for the
lowest effective level.

## Traceability Gate

For every behavioral requirement, record:

```text
requirement -> task -> planned test or justified exception -> planned proof locator
```

Keep planned and observed proof distinct. Before implementation, observed proof
may correctly be `pending`; it may not be presented as already executed.

## Level Selection

Select the lowest level that exercises the real owner and failure mechanism:

- static or semantic validation for document, schema, config, or policy truth
- unit/component proof for local deterministic behavior
- integration/contract proof for boundaries, persistence, or providers
- browser truth for user-visible runtime behavior
- persistent end-to-end proof only after the runtime path is stable

Document why a lower level is insufficient and why any higher level is needed.
Do not impose a universal coverage percentage, test count, or end-to-end suite.

## Mode And Independence

Select feature Red/Green/Refactor, bug repro, refactor characterization,
docs/governance semantic validation, or the appropriate migration, security,
UI, or external-provider contract. Do not fabricate Red proof to make an
inapplicable mode resemble feature TDD.

Name the test/fixture writer and the independent regression reviewer before
acceptance. A test-only writer may self-review but loses independent review
authority over the tests and fixtures they authored.

## Gate Decision

The root records:

- accepted Test Design locator
- selected mode and lowest effective level
- complete dimension dispositions
- traceability status
- fixture/isolation posture
- independent reviewer
- residual exceptions and owner
- decision: `pass | fail | blocked`

## Failure Conditions

Fail or block when:

- the design authority is unaccepted
- a required dimension is missing or has an empty/generic exception
- a behavioral requirement lacks a task, test/exception, or proof locator
- planned proof masquerades as observed proof
- the selected level cannot exercise the real risk owner
- a feature skips observed Red without an explicit non-feature mode
- a non-feature mode fabricates Red instead of its honest baseline
- the test/fixture writer is also the only acceptance reviewer
