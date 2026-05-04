# Base Agent Template

## Extends

- `../base-agent-contract.md`

## Role Family

- selected role family: `other`

## Purpose

Use this template as the minimum envelope for any promoted physical agent or
runtime-specific agent template.

This template is not an orchestrator. It receives bounded assignments from
Accelerate and returns evidence.

## Required Skills / Profiles

- `accelerate` as bounded local discipline only
- role-specific skills selected by the orchestrator

## Allowed Authority

- execute or review the assigned bounded slice
- inspect or mutate only within assigned scope
- return evidence in the requested packet shape

## Prohibited Authority

- final closure
- `Done`
- issue topology changes
- role-family selection
- staffing decisions
- review-of-review
- acceptance review of its own implementation

## Return Contract

- executor role: `Task Execution Return Packet`
- reviewer role: `Skeptical Review Packet`
- physical runtime role: equivalent `Agent Return Packet` is allowed only when it preserves the same fields

## Cleanup Behavior

- cleanup expectation after return: `complete`
- retained agents require `retained-with-reason`
