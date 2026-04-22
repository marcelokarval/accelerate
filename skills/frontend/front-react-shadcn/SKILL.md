---
name: front-react-shadcn
description: Use when the active frontend stack is React with TypeScript, shadcn/ui or Radix-style primitives, Tailwind, route/page composition, and project i18n conventions.
user-invocable: true
related-skills: inertia-patterns, i18n-patterns, security-patterns, frontend-component-hierarchy, frontend-componentization-audit, product-runtime-review, tailwind-patterns
---

# front-react-shadcn

Use this skill for implementation work in an active React + shadcn/Radix +
Tailwind stack profile.

## Purpose

This is the mandatory frontend stack skill when the active project profile uses
React, TypeScript, shadcn/ui or Radix-style primitives, and Tailwind. It exists
to keep work aligned with:

- React + TypeScript strict mode
- route/page and layout composition patterns from the active stack
- shadcn/ui or Radix-style composition
- Tailwind CSS
- project i18n and validation conventions
- the project source ladder for reusable UI patterns
- production-ready runtime behavior with real data

It is also a primary implementation skill behind the workflow lens
`Frontend Structure Correctness`.

## Load When

Load this skill when the task touches:

- active frontend source files
- React components, hooks, pages, layouts, forms, tables, modals, dropdowns
- shadcn/ui primitives in `@/components/ui/*`
- enhanced components in `@/components/ui-enhanced/*`
- frontend navigation, page composition, persistent layouts
- any frontend implementation where `Frontend Structure Correctness` is
  mandatory

This skill should usually be combined with:

- `inertia-patterns` for page/data/navigation work
- `i18n-patterns` for user-facing strings
- `security-patterns` when access, IDs, or mutations are sensitive

Use this skill as the primary one when the job is concrete implementation in the
active React/shadcn/Tailwind stack. Do not use it as the primary skill when the
main question is boundary governance, component placement, componentization
audit, or shared token/variant design.

## Operating Lens

- shadcn/ui primitives and composition first
- persistent layout composition over local wrappers
- strict TypeScript boundaries
- no contamination from unrelated UI systems
- single responsibility across pages, compounds, hooks, and field components
- source ladder before invention
- real-data readiness before visual closure

## Context Minimum

Before editing, identify:

- the exact frontend area being changed
- the target page, layout, or component
- the expected interaction and translation scope
- known routing or layout dependencies

## Core Rules

1. Use existing project primitives and compounds first:
   - `@/components/ui/*`
   - `@/components/ui-enhanced/*`
   - owner-neutral helpers in `shared/`
   - existing feature compounds when the role is still feature-owned
2. If the internal catalog has a real gap, follow the source ladder:
   - official shadcn/Radix pattern first
   - vetted third-party pattern second
   - build a new component from project primitives only as the last step
3. Do not import unrelated UI systems into the active frontend stack.
4. Use `cn()` from `@/lib/utils` for class merging.
5. Use `cva()` when variant logic is substantial.
6. Prefer semantic HTML for layout structure and shadcn/ui for interaction
   primitives.
7. All user-facing text must go through `t()` with an English fallback.
8. Prefer persistent layout composition over local wrapper duplication.
9. Keep component files under the active project's file-size and ownership
   limits.
10. Reusable components that sit under Radix `asChild` or similar composition
    points must correctly forward refs and props.
11. Avoid `God component`, `God page`, and `God hook` patterns; split UI shell,
   state orchestration, formatting, and field behavior by responsibility.
12. Do not close a user-facing surface on mock-only assumptions. The surface
    must be ready for null, empty, loading, long-string, overflow, and
    permission-driven states.
13. Treat repeated raw markup as a smell when it is re-implementing a known
    reusable role. Avoid `div soup`, `span soup`, and feature-local clones of
    stable shared patterns.

## Frontend Decisions For The Active Project

### Components

- `components/ui/` is for generic primitives and wrappers.
- `components/ui-enhanced/` is for project-specific composites.
- `components/layout/` is for shell, sidebar, header, menus, and layout helpers.
- `shared/` is for owner-neutral non-visual helpers, contracts, and browser
  utilities. Do not hide UI composition there.
- `pages/` or route entries are for entry screens, not generic reusable widgets.
- pages should compose data flow and screen structure, not absorb reusable field,
  formatter, and interaction logic
- hooks should encapsulate one stateful concern, not become hidden controllers
- compounds may orchestrate UI regions, but should not absorb unrelated domain
  rules or low-level formatting helpers

### Source Ladder

Before creating a new component or interaction pattern, prove this sequence:

1. internal `ui/`, `ui-enhanced/`, shared helpers, or existing feature
   compounds do not already solve the role closely enough
2. official shadcn/Radix patterns do not cover the gap cleanly
3. vetted third-party references would not solve the gap more safely than a
   local adaptation
4. only then build a new project component from existing primitives

Do not jump straight from "I need this role" to "create a new component."

### Real Data Readiness

Assume the surface will receive real runtime data, not neat demo fixtures.

Before closure, verify at least:

- null, empty, and loading states
- long translated strings
- real list density, wrapping, and overflow
- actions disappearing because backend truth or permissions remove them
- graceful behavior under partial or delayed props

### Styling

- Use existing CSS variables and semantic tokens before inventing new values.
- Follow documented z-index and layering rules in `docs/architecture/ui-layers.md`.
- Avoid one-off visual patterns if the design system already covers the use case.

### Forms

- For simple server-driven forms, align with backend validation and existing
  form patterns in the codebase.
- For more complex local form composition, follow the current stack used in the
  app rather than importing a parallel form architecture ad hoc.

### Navigation

- Use the active stack's navigation primitives rather than raw anchors for app
  routing when client navigation semantics matter.
- Preserve shell composition when adding sub-layouts.
- Do not let internal section sidebars replace the private shell.
- When a change introduces or restructures visible navigation, a route family,
  a private hub/sidebar entry, or a public capability page, update the
  corresponding navigation/docs in the same batch or leave a blocking follow-up.

## Review Checklist

- Are imports aligned with `@/components/ui/*` and project utilities?
- Are strings translated?
- Was the source ladder followed before a new component or external pattern was introduced?
- Is the changed surface ready for real runtime data instead of only static mocks?
- Is layout composition consistent with folder hierarchy and existing shell?
- Are interactive wrappers forwarding refs where required?
- Is the component small enough, or should part of it be extracted?
- Did this change preserve clear responsibility boundaries instead of extending a
  `God-*` UI structure?
- Did the change update sidebar/navigation/public docs when discoverability changed?

## Trigger Matrix

- primary:
  - concrete implementation in the active frontend stack
  - component/page/layout coding in the active stack
- supporting only:
  - `.ts` vs `.tsx` ownership -> `frontend-boundary-governance`
  - placement/import direction -> `frontend-component-hierarchy`
  - reuse/extract/converge audit or source-ladder proof ->
    `frontend-componentization-audit`
  - shared tokens/variants/design-language work -> `tailwind-design-system`
  - runtime/user-goal-sensitive closure -> `product-runtime-review`
  - user-facing copy and locale proof -> `i18n-patterns`

## Handoff And Escalation

- hand off to the active backend or server-prop skill when page naming, props,
  or backend page behavior is the real blocker
- hand off to the active test stack only when regression work becomes the
  primary deliverable
- hand off back to `accelerate` if the work expands into a cross-domain rollout

## References

- active frontend `components/`
- active frontend route/page directory
- active frontend `lib/` or utilities directory
- active UI-layer and design-system docs
