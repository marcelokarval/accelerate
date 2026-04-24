# UX/UI Fullstack Surface

## Purpose

Use this module when the real quality question crosses backend truth, frontend
state modeling, runtime behavior, and UX/UI execution.

This is the native Accelerate answer to practical UX/UI fullstack review loops:
keep the useful browser-driven, screenshot-backed, fix-before-promotion behavior
without importing runtime-specific or installer-heavy external skill doctrine.

## Activation Trigger

Activate this module when a task includes or implies any of these:

- a user-facing flow whose UI depends on backend states, flags, redirects, or
  server props
- a UI that compiles but may still be poor UX
- a backend fix that changes visible state, action availability, copy, or trust
  posture
- a frontend change where loading, empty, error, auth, permission, or blocked
  states are closure-relevant
- fullstack product work where browser truth, not code review alone, determines
  whether the slice is acceptable

Use `product-critical-surfaces.md` when user harm or critical recovery flows are
in scope. Use `premium-interface-production.md` when perceived quality or visual
direction is itself a material outcome.

## Branch Contract

The branch is not generic frontend work and not generic backend work.

It must name:

- backend truth owner
- frontend state owner
- UX/UI surface owner
- runtime proof owner
- closure owner

The root still owns closure. A UX/UI fullstack packet is proof input, not final
authority.

## Required Surface Map

Before closure, produce a compact map of:

- routes, pages, or components changed
- backend endpoints, server props, presenters, or redirects involved
- user-visible states affected
- primary action and secondary/escape actions
- copy/trust changes
- validation and error behavior
- browser/runtime evidence target

If the task cannot name these, it is not ready to claim UX/UI fullstack closure.

## State Coverage

Cover the states that matter for the branch:

- default/success
- loading/pending
- empty/no data
- error/retry
- auth/session expired
- permission/role denied
- blocked/delinquent/recovery state
- mobile and desktop layout when responsive behavior is relevant

Do not claim broad UX/UI coverage from a single happy-path screenshot.

## Fullstack Proof Order

Use this order:

1. backend contract proof
2. frontend state/render proof
3. browser/runtime proof
4. UX/UI quality judgment
5. defect registration and corrected-state proof when defects were fixed

Backend proof without browser truth is incomplete for user-facing work.
Browser proof without backend state explanation is also incomplete.

## UX/UI Quality Checks

Review the result for:

- clear dominant user job
- visible state explanation
- primary CTA dominance
- safe secondary and escape actions
- copy that explains consequence, recovery, or trust posture
- hierarchy that avoids card soup and flat equivalence
- density appropriate to the user job
- visual affordances that match actual click/action behavior
- mobile usability when mobile is supported

## Closure Blockers

Do not close when any of these remain true:

- backend truth is too thin for the UI state
- frontend state is invented, stale, or disconnected from backend truth
- only the happy path was shown while error/empty/blocked states matter
- the primary action is visually or semantically unclear
- runtime proof lacks console/network/state evidence
- a fixed UX/UI defect was not reproved in corrected state
- screenshots are stored outside the governed project `.tmp/` tree without an
  explicit exception

## Relationship To Other Modules

- `product-critical-surfaces.md` escalates this branch when user harm is high.
- `premium-interface-production.md` escalates this branch when perceived quality
  is a deliverable.
- `design-system-contract-application.md` governs artifact-driven visual law.
- `../runtime-packets/browser-proof-packet.md` carries runtime evidence.
- `../runtime-packets/ux-ui-fullstack-surface-packet.md` carries the fullstack
  reconciliation packet.
