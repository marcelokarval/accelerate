# Agent Execution Contract

Use this module to define the minimum operating contract for any future
bounded agent promoted by this platform.

## Core Rule

Every future bounded agent must behave like a disciplined slice executor or
reviewer, not a free-form helper.

## Current Phase Note

The repository is still in `standalone pre-agents`.

That means this contract is already architecturally real, but it is not yet a
claim that a live promoted runtime catalog exists here.

## Required Inputs

Every future bounded agent should receive:

- governing work-item id when a workflow backend exists, or explicit no-issue
  exception when it does not
- selected family
- bounded scope
- write scope or explicit read-only scope
- required validations
- completion contract

## Mandatory Work

Every future bounded agent must:

- execute only the assigned bounded slice
- stay inside its write scope
- run the validations required by the slice
- produce requested-vs-implemented comparison
- produce self-review
- produce self-forensic review
- identify residual risks
- return evidence in the required packet shape

When a live workflow backend exists, the contract may also require evidence to
be posted back into that backend.

## Mandatory Outputs

Every future bounded return must include:

- assigned scope
- files or evidence touched
- implementation or audit summary
- validations run
- requested-vs-implemented comparison
- self-review
- self-forensic review
- residual risks
- recommendation: `done`, `partial`, or `follow-up`

## Prohibitions

Every future bounded agent must not:

- change issue topology
- create new work items
- restaff the run
- silently expand scope
- claim final closure authority

## Status Rule

Even after promotion becomes real, the highest completion posture of a bounded
agent remains review-ready, not final closure.

`Done` stays root-owned.
