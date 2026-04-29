# Agent Return Contract

## Purpose

Use this contract for every promoted or candidate bounded agent return.

An agent return is evidence for the orchestrator. It is not final acceptance.

## Required Return Fields

Every bounded agent must return:

- agent family and role
- assigned task/slice id
- assigned scope
- actual scope touched
- write scope used, or read-only confirmation
- files/surfaces inspected or changed
- evidence roots
- validations/proof run
- requested-vs-implemented comparison
- self-review
- self-forensic review
- defects found and disposition suggestion
- residual risks
- recommendation: `done`, `partial`, `follow-up`, or `blocked`
- explicit statement that final closure is root-owned

## Executor vs Reviewer Returns

Implementation agents must not return acceptance review for their own work.

Reviewer agents must not implement corrections in the same return unless the root
explicitly reassigns them as executor for a bounded correction. If that happens,
they lose reviewer independence for that task and a new reviewer is required.

## Return Packet

Use the `Agent Return Packet` in `core/runtime-packets/templates.md` or provide
equivalent fields.

## Root Handling Rule

The orchestrator must classify each return as:

- `accepted-for-integration`
- `needs-review`
- `needs-correction`
- `conflicts-with-other-return`
- `rejected-out-of-scope`
- `blocked`

The orchestrator must perform review-of-review before closure.

## Closure Blockers

Do not accept an agent return when:

- assigned scope is missing
- actual scope exceeds assigned scope
- evidence roots are missing
- validations are omitted without blocker
- residual risks are hidden
- recommendation says `done` but requested-vs-implemented is partial
- agent claims final closure authority

## Failure Labels

- `agent-return-without-scope`
- `agent-scope-expanded-silently`
- `agent-return-without-evidence`
- `agent-return-without-residual-risk`
- `agent-done-contradicts-comparison`
- `agent-return-claims-closure`
