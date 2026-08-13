# Planning

Planning is a first-class layer of the standalone `accelerate` platform.

Its job is to turn discovery, architectural judgment, and agent-factory
reasoning into explicit execution-ready artifacts.

This layer exists because `executive planning` is part of the product strategy,
not just a habit from previous sessions.

## Current Stage

In the current `standalone pre-agents` phase, planning is already a native
layer even though not every plan type is backed by a live workflow adapter yet.

That means planning must already be able to:

- frame user stories and PRD-lite artifacts
- define the role of executive plans
- distinguish PRD, SDD, migration, onboarding, and promotion planning
- provide reusable templates for later sessions
- act as the handoff boundary between discovery and execution

It must not pretend that it already has:

- enforced issue persistence for every plan
- automatic promotion workflows
- a complete native rewrite of all inherited planning doctrine

## What Planning Owns

This layer owns the explicit artifacts that shape work before execution:

- user stories
- PRD-lite artifacts
- proportional Software Design Documents (`micro`, `standard`, `hierarchical`,
  or `critical`)
- Engineering Artifact Manifests and requirement traceability
- ADR and DESIGN dispositions
- Test Design and TDD Receipt artifacts as distinct testing surfaces
- executive plans
- task breakdowns
- architecture plans
- migration plans
- onboarding bootstrap plans
- promotion planning for future agents
- non-sensitive evidence appendices when manifests need durable proof locators

Planning is not:

- the root control plane itself
- a dumping ground for temporary notes
- a session log

## Operational Rule

When non-trivial work cannot honestly jump from discovery to execution, the
root should require a planning artifact before mutation begins.

Every mutation first enters the Specification Lifecycle. The usual chain is:

1. classify and harden the request
2. attach the governing issue or explicit narrow exception
3. select `micro`, `standard`, `hierarchical`, or `critical` SDD mode
4. materialize the Engineering Artifact Manifest and accepted design authority
5. disposition ADR, DESIGN, Test Design, agents, rollout, rollback,
   observability, and AGENTS/docs
6. map stable requirements to tasks, tests or justified exceptions, and proof
7. produce larger product or executive planning artifacts when needed
8. execute through the appropriate TDD, repro, characterization, or semantic baseline
9. prove, correct, invalidate stale proof, and reprove
10. reconcile execution to specification and close

Use the smallest proportional artifact that makes the next phase honest. A
direct-fast-path mutation uses a non-empty micro Spec Capsule; it does not use
mode `none` or skip issue bootstrap.

Not every task needs the full chain. Implementation must not start while the
artifact needed for the next safe step is missing.

## Artifact Persistence

When a planning artifact is created for a real run, persist it in the closest
native planning sublayer with a date and slug:

- user story: `product/YYYY-MM-DD-<slug>-user-story.md`
- PRD-lite: `product/YYYY-MM-DD-<slug>-prd-lite.md`
- SDD: `architecture/YYYY-MM-DD-<slug>-sdd.md`
- delta SDD: `architecture/YYYY-MM-DD-<slug>-delta-sdd.md`
- ADR: `architecture/YYYY-MM-DD-<slug>-adr.md`
- Engineering Artifact Manifest:
  `specification/YYYY-MM-DD-<slug>-engineering-artifact-manifest.json`
- traceability: `specification/YYYY-MM-DD-<slug>-traceability.md`
- DESIGN disposition: `design/YYYY-MM-DD-<slug>-design.md`
- Test Design: `testing/YYYY-MM-DD-<slug>-test-design.md`
- TDD Receipt: `testing/YYYY-MM-DD-<slug>-tdd-receipt.md`
- task breakdown: `execution/YYYY-MM-DD-<slug>-task-breakdown.md`
- executive plan: `executive/YYYY-MM-DD-<slug>-executive-plan.md`

Templates stay generic. Run artifacts should name their source request, upstream
artifact chain, active phase, proof expectations, and unresolved blockers.

## Reading Order

For a fresh session, read in this order:

1. `../AGENTS.md`
2. `../SKILL.md`
3. `README.md`
4. `product/README.md`
5. `specification/README.md`
6. `architecture/README.md`
7. `design/README.md`
8. `testing/README.md`
9. `executive/README.md`
10. `execution/README.md`
11. `migration/README.md`
12. `onboarding/README.md`
13. `promotion/README.md`

## Current Output Contract

Every planning artifact should currently leave enough truth for another session
to continue without reconstructing the reasoning from scratch.

The minimum output is:

- scope and non-goals
- actor, value, and acceptance when product framing is active
- governing assumptions
- selected layer or branch
- active constraints
- next bounded slices
- proof lane expectations
- explicit residual risks or unresolved ambiguities

When a governed target repository already has `.accelerate/`, planning should
also keep the local readiness dashboard and current checkpoint coherent with
the chosen governing artifact.
