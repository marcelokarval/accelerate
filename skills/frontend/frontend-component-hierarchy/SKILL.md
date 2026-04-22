---
name: frontend-component-hierarchy
description: Codex-native React component hierarchy guidance for placement, import direction, extraction, and layer boundaries in the frontend codebase.
user-invocable: true
related-skills: front-react-shadcn, react-best-practices
---

# frontend-component-hierarchy

Use this skill when organizing React component placement and import direction in
the frontend codebase.

## Purpose

Keep the component tree scalable by preserving separation between primitives,
shared pieces, feature-specific components, layout shells, and route pages.

This skill is one of the primary supporting skills behind the workflow lens
`Frontend Structure Correctness`.

## Load When

Load this skill when the task touches:

- component extraction
- folder placement decisions
- import direction and architecture
- refactors that move components across layers
- any review where `Frontend Structure Correctness` is mandatory

Use this skill as the primary one when the real decision is placement or import
direction after the component/extraction decision already exists.

## Core Rules

1. Keep primitives isolated from feature-specific imports.
2. Shared components should not depend on feature components.
3. Layout components should compose the shell, not embed feature business logic.
4. Pages can depend on lower layers, but lower layers should not depend on
   pages.
5. When in doubt, choose the narrowest reusable layer that matches the
   component's real responsibility.

## Accelerate Guidance

- Active React/shadcn profiles should distinguish primitives, enhanced
  components, layout components, feature components, and route/page entries.
- Avoid creating monolithic pages that should be extracted into smaller layout
  or feature pieces.

## Review Checklist

- Is the component in the right layer?
- Are imports pointing down the hierarchy instead of up?
- Would this placement cause cross-feature coupling?

## Trigger Matrix

- primary:
  - placement decisions
  - import direction
  - layer ownership of an already-known component
- supporting only:
  - raw frontend implementation -> `front-react-shadcn`
  - `.ts` vs `.tsx` ownership -> `frontend-boundary-governance`
  - whether to extract/converge/adopt at all -> `frontend-componentization-audit`
  - shared tokens/variants/design-language work -> `tailwind-design-system`
