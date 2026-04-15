# Specification Layer

Use this module when the work is not yet ready for safe implementation because
the specification is still weak, incomplete, or incorrectly scoped.

## Explicit Aliases

This layer already covers the workflow language often described as:

- `SDD` / `Spec Driven Development`
- `RPI` / `Research -> Plan -> Implement`

Use those names as aliases over the existing model rather than as a separate
workflow.

### Alias Mapping

- `SDD`
  - use the existing `Spec -> Design -> Plan -> Implement -> Verify -> Release or Follow-up` overlay
- `RPI`
  - treat `Research` as the combined discovery work in `Frame` plus `Load`
  - keep `Plan` as the explicit bounded execution shape
  - keep `Implement` as `Execute`

## Story Framing Gate

Activate this gate when actor, goal, value, or narrative acceptance are still
implicit.

Minimum output:

- actor
- goal
- value
- problem or pain being solved
- narrative acceptance criteria

If these are not explicit enough, do not move directly into implementation.

## PRD-lite Branch

Use PRD-lite when the work is capability-level, epic-like, or too underdefined
for safe execution.

Minimum PRD-lite output:

- problem statement
- objectives
- scope
- non-goals
- functional requirements
- non-functional constraints
- risks and dependencies
- success signals

PRD-lite is not a heavy product document. It is the minimum bounded spec that
lets implementation proceed honestly.

## SDLC Meta-Model Overlay

When the work is non-trivial, treat the workflow through these phases:

1. Spec
2. Design
3. Plan
4. Implement
5. Verify
6. Release or Follow-up

The active phase should be obvious in commentary and in the current batch.

Map the overlay explicitly to the operational `accelerate` phases:

| SDLC overlay | Operational phase |
| --- | --- |
| `Spec` | `Frame` |
| `Design` | `Load` + `Classify` |
| `Plan` | `Plan` |
| `Implement` | `Execute` |
| `Verify` | `Gate` + `Final Forensic Review` |
| `Release or Follow-up` | `Deliver` |

This mapping should stay visible when the active phase is named, especially
when the run moves back into specification after evidence reveals that the
current execution shape is unsafe.

## Implementation Design

Use this stage when the specification exists but the execution shape is still
too vague.

Minimum output:

- slices
- TODOs by slice
- dependency order
- rollout order
- acceptance per slice

Do not let a valid specification collapse into a shapeless implementation blob.

## Spec Feedback Loop

Re-enter the specification when implementation or runtime evidence reveals:

- missing acceptance criteria
- ambiguous behavior
- hidden dependencies
- underdefined edge cases
- scope that should split into follow-up issues

When this happens, fix the spec first instead of silently pushing ambiguity
downstream into code or review.

## Product Planner Layer

Use this layer when the real problem is decomposition.

Questions to answer:

- is this a capability, story, task, bug, or cleanup?
- what is the smallest valuable slice?
- what belongs now versus follow-up?
- what should be parent work versus child work?

The goal is to keep implementation bounded without losing product intent.
