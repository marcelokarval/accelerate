# Software Design Document Template

Use this template for a root `hierarchical` or `critical` Software Design
Document. Use `delta-sdd-template.md` for `standard` work and a Spec Capsule for
`micro` work. `SDD` names this document, not the full Specification Lifecycle.

## Status

- ID: `SDD-<SCOPE>-<NUMBER>`
- Status: `draft | accepted | implementing | superseded`
- Mode: `hierarchical | critical`
- Owner:
- Date:
- Governing issue:
- Source request / product artifact:
- Engineering Artifact Manifest:
- Related ADR:
- Related Test Design:
- Supersedes:
- Superseded by:

Only `accepted` or `implementing` can authorize execution. Acceptance remains
root-owned.

## Problem And Current Behavior

State the technical problem and current truth without assuming the solution.

## Desired Behavior

Describe the target outcome and observable acceptance.

## Scope And Non-Goals

- In scope:
- Non-goals:

## Authority Set

- Governing authorities:
- Supporting references:
- Decision artifacts:
- Generated exports:
- Forbidden authorities:

## Requirements

- `REQ-<SCOPE>-001`:

Requirement IDs must be stable and unique.

## Constraints And Drivers

- Product and stack constraints:
- Security, privacy, and abuse constraints:
- Runtime or workflow constraints:
- Compatibility and migration constraints:
- Verification constraints:

## Current, Target, And Transition Architecture

- Current shape:
- Target shape:
- Transition sequence:
- Ownership boundaries:
- Explicit invariants:

## Layer Ownership

| Layer / surface | Owner | Responsibility | Forbidden authority |
| --- | --- | --- | --- |
|  |  |  |  |

## Contracts And Trust Boundaries

- Data or storage contracts:
- API, CLI, callback, or runtime surfaces:
- Validation authority:
- Trust boundaries:
- Ownership / authorization checks:
- Secret handling:
- Observability requirements:

## Child SDD Dispositions

Hierarchical and critical modes must disposition each potential child.

| Child ID / surface | Disposition (`included | separate | deferred | not-applicable`) | Reason | Locator when separate |
| --- | --- | --- | --- |
|  |  |  |  |

## Decision Dispositions

| Artifact | Status | Substantive reason | Locator when separate/existing |
| --- | --- | --- | --- |
| ADR |  |  |  |
| DESIGN |  |  |  |
| Test Design |  |  |  |
| Threat model |  |  |  |
| Agents |  |  |  |
| Rollout |  |  |  |
| Rollback |  |  |  |
| Observability |  |  |  |
| AGENTS/docs |  |  |  |

Critical mode requires separate ADR, threat model, Test Design, and rollback
artifacts.

## Alternatives

| Option | Benefit | Cost / risk | Decision |
| --- | --- | --- | --- |
|  |  |  |  |

## Rollout And Rollback

- Rollout sequence:
- Compatibility guard:
- Rollback trigger:
- Rollback procedure / locator:
- Stop rules:

## Traceability And Proof Strategy

- Canonical traceability locator:
- Test Design locator:
- TDD Receipt locator:
- Static / unit / integration proof:
- Runtime / browser / persistent proof:
- Correction freshness rule:
- Forensic closure evidence:

## Handoff Decision

- Ready for task breakdown: `yes | no`
- Ready for implementation: `yes | no`
- Residual design ambiguity:
- Root acceptance:
