# Truth Ownership Check

## Purpose

Truth Ownership Check decides which local surface is authoritative before a run
changes behavior, architecture, contracts, validation, or workflow doctrine.

The check exists to prevent cargo-cult reuse, external catalog drift, and
implementation that silently chooses the wrong owner for product truth.

## When Required

Use this check when work involves:

- architecture or governance decisions
- backend/frontend contract boundaries
- validation authority
- transport or dependency decisions
- legacy adaptation or donor behavior
- admin/read-only surfaces
- financial, billing, payment, or security truth
- docs or workflow rules that could become doctrine

## Ownership Order

Use this order unless a repo-local document explicitly narrows it:

1. repository root instructions and `SKILL.md`
2. `README.md`
3. active core docs under `core/`
4. active adapters under `adapters/`
5. active profiles under `profiles/`
6. active planning/onboarding docs under `planning/` and `onboarding/`
7. registered local skills under `skills/`
8. historical `references/` only as provenance, not current authority

User-home catalogs and external docs are not governing authority until imported,
adapted, registered, and enforced inside this repository.

## Required Packet

Record:

- decision or behavior being governed
- candidate truth sources consulted
- selected owner
- rejected sources and why
- downstream artifacts or adapters affected
- proof that no external/user-home source is acting as hidden authority

## Blocking Conditions

Do not proceed when:

- a decision cites external material as authority without local adaptation
- two local surfaces conflict and no owner is selected
- implementation starts before ownership is resolved
- a skill reference is mandatory but absent from the local registry
- a runtime command is embedded in core where an adapter/profile should own it

## Closure Rule

Closure must name the authoritative local source used for the change. If the run
created a new authority surface, it must also update the relevant index,
registry, or integrity check.
