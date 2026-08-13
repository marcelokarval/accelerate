# Lifecycle contract

## Readiness before implementation

Before creating, starting, or declaring an item ready, resolve each field as a
discovered provider value or explicit disposition with reason and evidence:

- canonical title, objective/context, bounded scope and non-goals;
- testable acceptance criteria and validation/review plan;
- project rationale, state, priority/rationale, owner or explicit unassigned;
- labels, module, cycle, dates, estimate, parent/hierarchy, dependencies, and
  blockers; and
- a non-secret `session_id`, source/handler/governor, and execution units.

Do not silently omit a field. If a separate provider operation is required,
keep the item `created-needs-rehydration` until that operation succeeds and is
read back, unless an explicit `not_applicable` or `unassigned` disposition is
valid.

## Lifecycle packets

Persist append-only packets through `plane_add_lifecycle_comment`; render with
`plane_render_lifecycle_comment` first. Every packet contains:

- phase and semantically valid state before/after;
- timezone-aware `occurred_at` and timestamp source;
- `session_id`, bounded `unit_id`, unit, requested, delivered, next action,
  owner, and non-secret `agent_context` (`agent_runtime`, model,
  reasoning effort, reasoning disclosure policy, tool surface);
- concrete surfaces, typed evidence (`test:`, `cmd:`, `api:`, `artifact:`,
  `runtime:`, `review:`, `static:`, or `provider-readback:`), decisions,
  blockers, and residuals.

Use START after readiness and before substantive work; PROGRESS for meaningful
units or decisions; BLOCKED immediately with impact and unblock condition;
REVIEW after implementation/proof freezes; FINISH only after acceptance,
review, reconciliation, and provider readback. The renderer is preflight only;
the governed comment mutation is the persisted record.

## State truth and closure

- Discover provider states and map semantic stages to their IDs; never guess a
  “Done” or “Review” state.
- Do not jump an implementation-bearing issue straight from Backlog/Ready to
  Done. Do not manufacture old START/PROGRESS packets for a retrospective
  record; publish an evidence-based REVIEW that preserves present truth.
- A Done claim requires all declared units delivered, acceptance evidence,
  blockers empty, a FINISH packet as the final lifecycle event, and fresh GET
  readback of both the work item and FINISH comment. Residuals must be explicit,
  accepted non-blocking decisions rather than hidden gaps.
- Do not publish chain-of-thought, raw prompts, transcripts, credentials, or
  logs in lifecycle content. If model metadata is unavailable, record a
  non-secret unavailable marker rather than guessing.
