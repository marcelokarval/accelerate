---
name: frontend-componentization-audit
description: Use when auditing a frontend for component reuse, duplicate convergence, adopt-vs-extract decisions, raw-markup smells, helper duplication, or shared primitive gaps.
user-invocable: true
related-skills: front-react-shadcn, frontend-component-hierarchy, react-best-practices, architecture
---

# frontend-componentization-audit

Use this skill when auditing the active frontend for component reuse, compound
opportunities, duplicate drift, and primitive-discipline issues.

## Purpose

Turn a broad frontend scan into a disciplined audit that separates:

- adopt existing
- extract new
- converge duplicate
- leave as-is

This skill is about opportunity detection and classification. It is not the
same as `frontend-component-hierarchy`, which decides placement and import
direction after a componentization decision already exists.

This skill is one of the primary supporting skills behind the workflow lens
`Frontend Structure Correctness`.

## Load When

Load this skill when the task asks for:

- componentization review
- reuse audit
- UI convergence opportunities
- `div soup`, `span soup`, or native HTML overuse review
- detection of repeated filter bars, headers, tabs, stats grids, or formatters
- deciding whether a pattern belongs in `ui`, `ui-enhanced`, `shared`, or a
  feature folder
- any review where `Frontend Structure Correctness` is mandatory

Use this skill as the primary one when the job is to classify reuse,
componentization, or duplicate convergence opportunities before implementation.

## Core Questions

For each opportunity, answer these in order:

1. does an existing component already solve this closely enough?
2. if yes, why is it not being adopted?
3. if no, is the repeated pattern semantically stable enough to extract?
4. is the problem visual UI, invisible formatting/helper logic, or layout
   structure?
5. what is the smallest refactor that improves convergence without overfitting?
6. does the source ladder justify creation, or is this really an adoption gap?

## Classification Contract

Every audit result must land in exactly one category:

### 1. Adopt Existing

Use when:

- `ui` or `ui-enhanced` already has a close solution
- local manual markup or feature-specific wrappers are replacing an existing
  project component

### 2. Extract New

Use when:

- the pattern repeats enough to justify a new component or helper
- existing catalog does not cover it closely enough
- the repeated role is stable and reusable

### 3. Converge Duplicate

Use when:

- two or more components serve the same role with local drift
- a feature-local component overlaps a global one
- a legacy wrapper still competes with the current canonical version

### 4. Leave As-Is

Use when:

- repetition is too low or too specific
- abstraction would hide more than it clarifies
- the current manual structure is justified and bounded

## Frequency Lens

Check recurrence in both directions:

- strong repetition inside one page or feature
- light repetition across several pages or domains

Do not require massive duplication in a single file before recommending a
component.

## Smell Lens

Audit for these signals:

- `div soup`
- `span soup`
- raw HTML repeating a role already covered by project layout primitives
- native `type="number"` where a specialized input is likely missing
- scattered `Intl.NumberFormat`, `toLocaleString`, or date formatting
- repeated page headers, tabs, filter bars, stats grids, or action bars
- local/global component drift for the same visual role
- legacy wrappers still being used after a newer canonical component exists

Important:

- raw `div` or `span` is not automatically wrong
- it only becomes a smell when it repeats a role already handled by a clearer
  primitive, helper, or component

## Output Discipline

Return findings as facts, not vibes.

For each recommendation, include:

- category: adopt existing / extract new / converge duplicate / leave as-is
- evidence: file paths and concrete pattern observed
- why it matters
- smallest refactor worth doing
- target layer:
  - `components/ui`
  - `components/ui-enhanced`
  - `components/shared`
  - feature-specific component folder
  - non-visual helper/formatter layer

## Operating Steps

1. scan the target area
2. inventory existing relevant components in `ui`, `ui-enhanced`, and shared
   layers
3. apply the source ladder:
   - internal catalog first
   - official shadcn/Radix patterns second
   - vetted third-party references third
   - build new only after the earlier rungs fail
4. detect repeated structures and helper smells
5. classify each opportunity
6. recommend destination layer and minimum viable refactor
7. optionally suggest high-quality external references only when the internal
   catalog clearly lacks the needed pattern

## Accelerate Guidance

- In active React/shadcn profiles, prefer existing primitives and enhanced
  components before creating new artifacts.
- Use `frontend-component-hierarchy` after identifying an opportunity to decide
  exact placement.
- Use `front-react-shadcn` to stay aligned with shadcn/Radix/Tailwind
  composition rules.
- Use `react-best-practices` to avoid extracting components that only shuffle
  complexity around.

## External Reference Policy

External references are allowed when:

- the current catalog has a real gap
- the pattern is mature and production-quality
- it can be adapted to shadcn/Radix-first project rules

Do not recommend third-party components just because they look polished.

## References

Use local component catalogs, stack profile docs, source-ladder docs, smell
catalogs, and existing code examples as needed.

## Anti-Patterns

- creating a new component before checking existing `ui` and `ui-enhanced`
- recommending extraction based on aesthetics alone
- treating every `div` as a smell
- ignoring repeated helper logic because it is not visually obvious
- proposing a global component for a pattern that is still feature-specific
- turning this skill into a giant catalog dump instead of a classification tool

## Verification

A good audit should prove that it can:

- distinguish adopt-vs-create correctly
- catch duplicate drift
- identify at least one non-visual helper opportunity when present
- leave low-value abstractions alone

## Trigger Matrix

- primary:
  - reuse audit
  - duplicate convergence
  - adopt-vs-extract decisions
  - repeated raw-markup/helper smell classification
- supporting only:
  - actual implementation -> `front-react-shadcn`
  - boundary extraction -> `frontend-boundary-governance`
  - placement/import direction -> `frontend-component-hierarchy`
  - shared tokens/variants/design language -> `tailwind-design-system`
