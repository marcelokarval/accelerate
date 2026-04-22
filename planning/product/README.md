# Product Planning

Product planning owns the product/specification artifacts before architecture or
execution planning.

Use this sublayer when actor, value, acceptance criteria, capability scope, or
PRD-lite truth is still unresolved.

## Native Artifacts

- `user-story-template.md`
- `prd-lite-template.md`

## Chain

The normal product-to-execution chain is:

1. user request
2. story framing
3. PRD-lite when the work is capability-level or epic-like
4. SDD when architecture, design, or layer ownership is unresolved
5. executive plan when sequencing, adapters, proof lanes, or rollout matter
6. task breakdown when implementation can be sliced

Do not treat product planning as implementation planning.

Product planning should make user value and acceptance clear before technical
decomposition starts.

## Minimum Artifact Rule

Use the smallest artifact that makes the next phase honest.

Not every bounded task needs a PRD-lite. Not every PRD-lite needs an SDD.
Implementation should not begin while actor, value, scope, or acceptance remain
implicit.
