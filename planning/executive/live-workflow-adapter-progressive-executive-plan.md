# Live Workflow Adapter Progressive Executive Plan

## Purpose

Move Accelerate from strong planning/readiness artifacts toward a complete live
workflow adapter stack.

This plan explicitly rejects a permanent "minimum" endpoint. The first slice is
small only because the implementation must be sequential, testable, and honest.
Every slice must point toward the complete goal.

## Complete Goal

Accelerate should eventually support live workflow execution across local and
remote backends with:

- stable work-item identity
- issue/work-item bootstrap
- parent/child or substitute topology
- lifecycle transitions
- metadata rehydration after interruption
- review and closure report attachment
- requested-vs-implemented review traceability
- defect and correction/reproof traceability
- final forensic reconciliation attachment
- failure/recovery packets when writes fail
- backend adapters for local `.accelerate/`, Linear, GitHub PRs, GitHub Issues,
  GitHub Projects, and later Jira/Notion when contract-stable

## Sequential Path

### Phase 1: Local Work-Item Identity

Create a local `.accelerate/workflow/` adapter surface. This is the bootstrap
foundation for all later backend adapters because it gives every run a durable
work item even when no external backend exists.

Deliverables:

- local adapter contract docs under `adapters/workflow/local/`
- emitted `.accelerate/workflow/` template
- `init-local-workflow.sh`
- `create-local-work-item.sh`
- `transition-local-work-item.sh`
- `render-local-work-item.sh`
- validation and tests

### Phase 2: Review And Closure Attachment

Attach local work items to existing review/closure artifacts:

- review-ready packet
- AI review report
- closure packet
- defect ledger
- correction loop
- final forensic reconciliation

### Phase 3: Local Topology

Support parent/child and related work items locally, then make one-shot task
ledgers link to the local topology.

### Phase 4: Remote Adapter Contract Stabilization

Use the local adapter as the concrete reference implementation to tighten the
shared adapter contract before adding remote backends.

### Phase 5: Linear Adapter

Implement Linear as a remote adapter for parent/child issue topology, comments,
review state, assignment, project fields, lifecycle status, and closure comments.

### Phase 6: GitHub PR Adapter

Implement GitHub PR integration for code-review-bound workflow truth: branch,
commit, checks, requested-vs-implemented summary, AI review comments, and final
forensic PR comment.

### Phase 7: GitHub Issues/Projects Adapter

Implement repo-native issue/project lifecycle mapping after PR workflow is stable.

## Phase 1 Scope

This execution handles Phase 1 only, but the files must be shaped so Phase 2 can
extend them rather than rewrite them.

## Non-Goals For Phase 1

- Do not claim Linear/GitHub are live.
- Do not call external workflow APIs.
- Do not replace existing readiness/proof gates.
- Do not infer stable identity from titles alone.
- Do not skip local validation because remote adapters are planned later.

## Phase 1 Acceptance

Phase 1 passes only when:

- new `.accelerate/workflow/` files are emitted and validated
- a local work item can be created with stable ID and locator
- a local work item can transition lifecycle state
- the active work item can be rehydrated from local state
- timeline receives workflow events
- tests prove create, transition, render, validation, and invalid transition
  behavior
- docs describe this as the first progressive slice toward the full adapter goal

## Residual Risks

- Local YAML/JSONL parsing remains intentionally simple until a stronger local
  data model is justified.
- Remote backend semantics may require richer metadata in later phases.
- Parent/child topology is intentionally deferred to Phase 3, not ignored.
