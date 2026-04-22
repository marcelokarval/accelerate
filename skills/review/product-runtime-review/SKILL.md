---
name: product-runtime-review
description: Use when implementing or reviewing a user-facing flow that can be technically correct but still poor as product, especially auth, onboarding, settings, billing, self-service, staged forms, and server-driven runtime interactions.
user-invocable: true
related-skills: active-frontend-stack, active-backend-stack, anti-abuse-review, react-best-practices
---

# product-runtime-review

Use this skill to stop a feature from closing at "works" when the runtime still
feels fragmented, misleading, or below product quality.

## Load When

Load this skill when the work touches:

- auth, onboarding, settings, billing, notifications, self-service, or support
- staged forms or multi-step verification flows
- server-driven pages where backend data, actions, and redirects shape UX
- CTAs that may lie about backend capability
- local card refresh vs full-page reload behavior
- browser/runtime regressions that are visible before they are architectural

Do not use this skill for:

- pure backend-only refactors with no user-visible surface
- design-system exploration or broad visual direction work
- performance-only work with no user-flow impact

## Core Contract

This skill answers a different question than technical correctness:

> if a real user tries to complete the goal, does the flow feel truthful,
> staged correctly, recoverable, and aligned with what the backend can
> actually do?

Never let "passes tests" stand in for that answer.

## Product Correctness Checklist

Evaluate the flow against these lenses:

### 1. Goal Integrity

- does the happy path really complete end-to-end?
- is the user goal obvious?
- is the main path singular or unnecessarily fragmented?
- do labels, headings, and CTA copy describe the real action?

### 2. Stage Integrity

- do fields appear only when their phase is active?
- are follow-up controls gated by the real prerequisite?
- does editing reset downstream verification state when it should?

### 3. Capability Honesty

- is the frontend using the backend capability that already exists?
- does the UI claim something is impossible when the backend supports it?
- are placeholders or disabled controls explicitly marked as such?

### 4. Refresh Scope

- does the action refresh only the affected card/panel/list?
- is the entire app reloading when a local fetch would be correct?
- do optimistic updates stay consistent with the server result?

### 5. Recovery and Feedback

- are validation, pending, success, and failure states visible and specific?
- can the user retry cleanly?
- are dead ends, hidden prerequisites, or unexplained disabled states present?

### 6. Surface Completeness

- is backend-ready self-service hidden from the user?
- does the current screen expose the most relevant next action?
- are users forced to hop to another place for a task that belongs here?

## Workflow

1. define the real user goal and the phase boundaries
2. identify the authoritative backend capabilities and constraints
3. reproduce the runtime flow in browser or trace it through the page contract
4. compare the user-visible behavior against the checklist above
5. classify the result:
   - exact
   - technically-correct-but-bad-product
   - blocked-by-backend
   - out-of-scope residual
6. recommend the smallest valid correction
7. ensure the forensic review reports `Product Correctness`, not just technical
   correctness

## Accelerate Usage Rules

- for frontend/runtime work, browser validation is the primary proof surface
- for server-driven UI work, inspect the page contract and the action or query
  layer that feeds it
- if the flow touches auth, OTP, session, billing, export, deletion, uploads,
  notifications, or any abuse-sensitive path, pair this skill with
  `anti-abuse-review`
- if the active workflow backend has a closure report, it must include a
  `Product Correctness` section whenever this skill applied

## Typical Smells

- happy path assumed, but not actually exercised end-to-end
- one user goal split into three unrelated forms
- verification code fields visible before a code is requested
- toast copy that contradicts backend capability
- full-page reload for a card-local action
- editable-looking controls for immutable fields
- static placeholders masquerading as shipped self-service
- disabled controls with no recovery path or explanation

## References

Use the active project docs, stack profile, or design-system contract when the
flow depends on local product rules.

## Output Discipline

Every use of this skill should produce:

- the user goal
- the runtime/product drift observed
- file-level evidence
- backend-capability evidence when relevant
- the smallest correction worth making
- whether `Product Correctness` passed or failed

## Anti-Patterns

- treating browser-visible product drift as "just polish"
- accepting a technically valid but phase-hostile flow
- assuming the backend is missing capability without checking
- turning this skill into generic PM commentary
- using this skill instead of actual runtime validation
