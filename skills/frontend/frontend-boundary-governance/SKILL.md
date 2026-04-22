---
name: frontend-boundary-governance
description: Use when frontend work needs a strict boundary between backend truth, non-visual TypeScript modules, and visual TSX surfaces, especially for page-controller drift, view-model extraction, copy leakage, and no-regression refactors.
metadata:
  category: frontend-governance
  origin: accelerate-native
---

# Frontend Boundary Governance

Use this skill when frontend work needs a clear and enforceable separation
between:

- backend truth
- frontend non-visual `.ts`
- frontend visual `.tsx`

This skill can be used directly, or loaded by `accelerate` when structural
frontend work, product-critical surfaces, or page/controller drift are in play.

## Purpose

This skill exists to prevent a recurring failure mode:

- backend stays source-of-truth, but frontend boundaries blur
- pages become mini-controllers
- hooks or helpers start emitting final user-facing copy
- `types.ts` and `utils.tsx` mix semantic roles
- refactors become risky because deterministic logic and rendering are tangled

The goal is not to make the frontend thin at any cost. The goal is to make the
boundary explicit and testable.

## Load When

Load this skill when the task involves any of the following:

- new page or major page refactor
- structural frontend refactor
- product-critical or premium user-facing surface
- drift between backend contract and frontend usage
- page state, predicates, mapping, and rendering all living together
- uncertainty about what belongs in `.ts` versus `.tsx`
- extraction work that must preserve behavior first

Use this skill as the primary one when the job is boundary correction or safe
extraction. Do not use it as the primary skill for simple stack implementation,
placement/import direction only, or shared visual token work.

## Core Boundary Model

Use this baseline:

### Backend

The backend owns:

- domain truth
- ownership and authorization
- final validation
- eligibility rules
- action permissions
- identifiers and links
- page contracts / prop contracts

### Frontend `.ts`

Use `.ts` for:

- UX validation that does not replace backend authority
- selectors and predicates
- deterministic view-model mapping
- pure formatters
- type contracts
- stable config and status maps
- orchestration hooks that expose shape, state, and actions

### Frontend `.tsx`

Use `.tsx` for:

- composition
- rendering
- event wiring
- layout hierarchy
- visual states
- binding user actions to already-defined actions and state

`.tsx` may coordinate UI state, but it should not quietly become the product
controller for the whole surface.

## Hard Rules

1. Do not let frontend code become the canonical owner of backend rules.
2. Do not serialize backend truth into frontend copy if the UI owns i18n.
3. Do not let page files carry mapping, predicates, copy, async flow, and
   rendering all at once.
4. Do not put presentation helpers inside `types.ts`.
5. Do not let hooks return final user-facing copy when they can return flags,
   codes, enums, or shapes.
6. Do not use `lib/*.tsx` or `utils.tsx` as a semantic junk drawer.
7. User-facing copy should remain a `.tsx` + i18n concern unless a stable
   translation key is the actual contract.
8. Structural frontend work must stay ready for real backend truth and runtime
   density; do not close on mock-only controller assumptions.

## Smells

Treat these as real frontend-governance smells:

- `page-controller-drift`
- `copy-leakage-from-ts`
- `types-file-with-presentation-helpers`
- `hook-returning-final-copy`
- `semantic-file-drift`
- `backend-truth-rebuilt-in-frontend`
- `mock-only-surface-logic`

## Immediate Questions

Before editing, answer:

1. What is the backend source-of-truth here?
2. What UX validation is legitimate on the frontend?
3. What deterministic logic belongs in `.ts`?
4. What visual composition belongs in `.tsx`?
5. Is the page currently acting like a controller?
6. Can the extraction preserve behavior before changing architecture further?
7. Is any runtime behavior still only valid for mock/static data?

## Default Protocol

1. identify the backend truth-owner and contract
2. classify current frontend logic into:
   - contract
   - selector / predicate
   - formatter
   - config
   - orchestration hook
   - visual component
3. move deterministic logic first
4. keep behavior stable with tests and browser truth
5. reduce page scope only after extraction is safe

## Required Output

Produce a boundary matrix with:

- concern
- current file
- current layer
- target layer
- move or keep
- regression risk

When extracting, also produce:

- preserved behavior checkpoints
- tests to keep green
- browser-truth checkpoints
- i18n/runtime checkpoints when the surface is user-facing

## Artifact Sufficiency Check

For boundary work, do not stop at proving that a matrix or extraction plan
exists. The artifact must be deep enough to drive a safe refactor.

At minimum, verify:

- the boundary matrix covers every concern that currently mixes truth,
  deterministic logic, and presentation
- the target layer is explicit for each concern, not implied
- copy leakage and page-controller drift are called out directly when present
- the no-regression extraction order is explicit enough to preserve behavior
- the checkpoints are concrete enough to prove functionality was not silently
  dropped during extraction

## References

Read the local references, stack profile, and existing code examples that match
the job. Prefer current project evidence over generic examples.

## Relationship To Other Skills

Use this skill with:

- `frontend-component-hierarchy`
  - for placement and import direction
- `server-prop-governance`
  - for server-driven page contract truth
- `validation-governance`
  - for backend-vs-frontend validation authority
- `product-runtime-review`
  - when the surface is user-facing and product-sensitive
- `front-react-shadcn`
  - when implementation still needs stack-specific UI guidance

## Trigger Matrix

- primary:
  - `.ts` vs `.tsx` ownership
  - page-controller drift
  - copy leakage from `.ts`
  - no-regression extraction of deterministic logic
- supporting only:
  - raw implementation in active React/shadcn stack -> `front-react-shadcn`
  - placement/import direction -> `frontend-component-hierarchy`
  - reuse/extract/converge audit -> `frontend-componentization-audit`
  - shared tokens/variants/design language -> `tailwind-design-system`

## Accelerate Notes

- Some existing project slices may model the boundary well enough to reuse as
  examples.
- Some slices may be controller-heavy and should be treated as extraction
  targets, not patterns to imitate.
- The backend remains source-of-truth even when frontend UX validation is
  helpful and legitimate.
