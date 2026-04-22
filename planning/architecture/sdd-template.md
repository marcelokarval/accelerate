# SDD Template

Use this template when product scope exists but the technical design is not yet
safe for implementation.

SDD is required when architecture, data ownership, transport, workflow/runtime
adapter selection, security posture, migration shape, or proof strategy is still
unclear.

## Status

- Owner:
- Date:
- Source request:
- Source PRD-lite or user story:
- Active phase: `Design`
- Related issue or artifact:

## Design Problem

State the technical design problem this SDD resolves.

## Constraints And Drivers

- Product constraints:
- Stack constraints:
- Security, privacy, or abuse constraints:
- Runtime or workflow constraints:
- Migration constraints:

## Target Architecture

- Target shape:
- Layer placement:
- Ownership model:
- Runtime behavior:
- Explicit non-goals:

## Layer Ownership

- Core:
- Workflow adapter:
- Runtime adapter:
- Stack profile:
- Agent factory:
- Overlay:
- External or project-specific layer:

## Data, Contracts, And Surfaces

- Data model or storage:
- Server-to-client contracts:
- API, Inertia, webhook, callback, or CLI surfaces:
- Validation authority:
- Backward compatibility:

## Workflow And Runtime Adapters

- Workflow backend:
- Runtime adapter:
- Browser or proof adapter:
- Issue or planning persistence:
- Current no-adapter exceptions:

## Security, Privacy, And Abuse Posture

- Trust boundaries:
- Ownership checks:
- Rate limits, replay, enumeration, or mutation risks:
- Secret handling:
- Audit or observability requirements:

## Alternatives Considered

| Option | Benefit | Cost | Decision |
| --- | --- | --- | --- |
|  |  |  |  |

## Migration And Rollout

- Migration sequence:
- Compatibility guard:
- Rollback or fallback:
- Follow-up work:

## Test And Proof Strategy

- Unit or static proof:
- Integration proof:
- Browser truth:
- Persistent regression proof:
- Forensic closure evidence:

## Acceptance To Tasks

- Architecture acceptance:
- Required implementation slices:
- Dependencies:
- Known risks:

## Handoff Decision

- Ready for executive plan: `yes | no`
- Ready for task breakdown: `yes | no`
- Issue bootstrap required: `yes | no`
- Residual design ambiguity:
