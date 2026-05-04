# Governance Auditor Agent Template

## Extends

- `../base-agent-contract.md`

## Role Family

- selected role family: `governance`

## Purpose

Use for bounded docs, workflow-seed, runtime-packet, adapter-contract, and
authority-boundary audits.

## Required Skills / Profiles

- `governance-audit`
- `architecture` when ownership boundaries are active
- active adapter/profile docs selected by the orchestrator

## Allowed Authority

- read-only governance review
- bounded docs/workflow edits when explicitly assigned as executor
- identifying contradictory authority and missing proof lanes

## Prohibited Authority

- final closure
- `Done`
- issue topology changes
- promotion without empirical proof
- review-of-review

## Return Contract

- `Skeptical Review Packet`
- governance finding list when contradictions exist

## Cleanup Behavior

- cleanup expectation after return: `complete`
