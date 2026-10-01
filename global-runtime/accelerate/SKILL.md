---
name: accelerate
description: Classify and prepare requests before ASDS; handle conversations and trivial work directly, and hand non-trivial work to spec-driven-superpowers.
metadata:
  category: routing
  origin: standalone-global-runtime
  version: 1.0.0
---
# Accelerate

Accelerate is the entry classifier and preparation layer. This portable entry is self-contained; it does not require the product checkout or create project state when loaded.

## Responsibilities

Accelerate identifies the objective, intended project, constraints, relevant risks, and authorizations already granted. Preserve user instructions and project rules. Ask only for information needed to proceed; do not repeat authorization questions.

- Conversation: answer directly without activating ASDS or creating artifacts.
- Trivial work: perform a known, bounded, reversible, low-risk adjustment directly with relevant verification. No mandatory issue, workspace, planning packet, delegation, or ASDS workflow.
- Non-trivial work: transfer the prepared request to `spec-driven-superpowers` (ASDS). Ambiguity, material risk, or cross-surface coordination may make a short request non-trivial; file count alone does not.

An explicit request to use ASDS routes to ASDS even for a small task. An explicit request to use ASDS independently does not require Accelerate. Do not recursively classify a task already handed to ASDS or a worker assignment owned by its coordinator.

## Handoff

Pass the objective, project, scope, constraints, risks, existing authorization, and useful evidence or specialist references. Carry this context in the existing conversation; no handoff file is required. Mark the workflow owner as ASDS and preserve that owner on follow-ups until the task ends or the user changes scope.

ASDS decides its activation depth and owns specification, planning, tasks, execution strategy, delegation, review, integration, and completion. Non-trivial does not automatically mean OpenSpec initialization. Preserve ASDS refusal and prior-authorization behavior. Accelerate must not create a duplicate task ledger, force workers, impose issue bootstrap, or run a second closure gate.

Load ASDS through the harness's available skill mechanism. Availability of this Accelerate bundle is not evidence that ASDS is installed or loaded. If ASDS is unavailable, report that specific limitation and continue independent useful work; do not claim a handoff occurred or silently substitute the retired Accelerate orchestration workflow. Respect explicit user instructions about proceeding without ASDS.

## Tools and specialist knowledge

The harness owns tool execution and permissions. Specialist skills, adapters, reasoning helpers, and validation utilities are optional resources selected for the task. Loading one must not reactivate Accelerate orchestration. Existing `.accelerate/` data may be consulted as context; do not initialize or duplicate it as workflow state.

On ASDS completion, present its result, evidence, and pending work faithfully. Do not re-plan or reopen approval merely to produce the final response. Tests and static validation establish only what they exercised; do not claim model or runtime execution without evidence.
