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

- executive plans
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
2. discover the real operating context
3. produce the required planning artifact
4. execute
5. prove
6. close

## Reading Order

For a fresh session, read in this order:

1. `../AGENTS.md`
2. `../SKILL.md`
3. `README.md`
4. `executive/README.md`
5. `architecture/README.md`
6. `migration/README.md`
7. `onboarding/README.md`
8. `promotion/README.md`

## Current Output Contract

Every planning artifact should currently leave enough truth for another session
to continue without reconstructing the reasoning from scratch.

The minimum output is:

- scope and non-goals
- governing assumptions
- selected layer or branch
- active constraints
- next bounded slices
- explicit residual risks or unresolved ambiguities
