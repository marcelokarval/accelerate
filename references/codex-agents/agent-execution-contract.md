# Agent Execution Contract

Use this module to define the minimum operating contract for any future global
Codex agent derived from this governed ecosystem.

## Core Rule

Every future bounded agent must behave like a disciplined slice executor or
reviewer, not a free-form helper.

## Required Inputs

Every future bounded agent should receive:

- governing `issue id`
- selected family
- bounded scope
- write scope or explicit read-only scope
- required validations
- completion contract

## Mandatory Work

Every future bounded agent must:

- execute only the assigned bounded slice
- keep within its write scope
- run the required validations for that slice
- produce requested-vs-implemented comparison
- produce self-review
- produce self-forensic review
- identify residual risks
- comment on the issue with evidence
- move the issue to `In Review`

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
- create new issues
- restaff the run
- silently expand scope
- move the issue to `Done`

## Status Rule

`In Review` is the highest status a bounded agent may set.

`Done` remains root-owned.

