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
- SDD artifacts
- executive plans
- task breakdowns
- architecture plans
- migration plans
- onboarding bootstrap plans
- promotion planning for future agents

Planning is not:

- the root control plane itself
- a dumping ground for temporary notes
- a session log

## Operational Rule

When non-trivial work cannot honestly jump from discovery to execution, the
root should require a planning artifact before mutation begins.

The usual chain is:

1. classify and harden the request
2. frame user value and acceptance when needed
3. produce PRD-lite when scope is capability-level or epic-like
4. produce SDD when technical ownership or architecture is unresolved
5. produce an executive plan when sequencing, adapters, proof lanes, or rollout matter
6. break the work into dependency-aware tasks
7. execute
8. prove
9. close

Use the smallest artifact that makes the next phase honest.

Not every task needs the full chain. Implementation must not start while the
artifact needed for the next safe step is missing.

## Artifact Persistence

When a planning artifact is created for a real run, persist it in the closest
native planning sublayer with a date and slug:

- user story: `product/YYYY-MM-DD-<slug>-user-story.md`
- PRD-lite: `product/YYYY-MM-DD-<slug>-prd-lite.md`
- SDD: `architecture/YYYY-MM-DD-<slug>-sdd.md`
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
5. `architecture/README.md`
6. `executive/README.md`
7. `execution/README.md`
8. `migration/README.md`
9. `onboarding/README.md`
10. `promotion/README.md`

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
