# Linear Execution

Use this module when the active workflow backend is Linear.

It is the current default workflow-backend reference, not the universal law of
the standalone platform.

## Bootstrap Authority

Engineering mutation must not start before issue bootstrap is complete.

Bootstrap is complete only when one of these is true:

- the run is attached to an existing execution-ready governing issue
- a new governing issue or parent/child package was created and revalidated
  before implementation
- the user explicitly approved a narrow no-issue exception and the run made
  that exception visible

If code, workflow seeds, or living docs were already being changed before this
state existed, classify it as workflow failure rather than mere metadata drift.

## Metadata Completeness

Before active execution:

- assignee is correct
- project linkage is correct
- labels are correct
- priority is set when relevant
- status matches real execution state

Do not start real implementation with incomplete issue metadata.

Do not start real implementation when the governing issue does not exist yet.

Labels are blocking metadata, not optional decoration.

An issue is not metadata-complete if:

- labels are empty
- labels are invalid under a mutually exclusive label group
- labels are technically present but too generic to express the issue home

## Label Selection Fallback

When the preferred label set conflicts under Linear's label-group rules:

1. keep the narrowest valid label that still reflects the issue home
2. prefer a smaller valid set over a richer invalid set
3. stop retrying the invalid pair
4. leave the valid fallback visible before active execution begins

## Lifecycle Integrity

Issue-driven execution must keep the lifecycle truthful:

- `Backlog`
  - captured, not execution-ready
- `Todo`
  - execution-ready, but active implementation has not started yet
- `In Progress`
  - real implementation is underway
- `In Review`
  - implementation is complete, but real review/verification gates remain
- `Done`
  - implementation, verification, and execution review are complete

Do not allow a materially executed issue to jump from `Todo` or `Backlog`
straight to `Done`.

If active execution happened, `In Progress` is mandatory.

If review/verification remained after implementation, `In Review` is mandatory.

If implementation started before issue bootstrap was complete, the review must
record that explicitly as a lifecycle and routing failure, even for work later
classified as trivial bounded.

## Parent / Child Relation Hygiene

When the user asks for a parent with children:

1. create or identify the parent first
2. verify the tool supports `parentId` if there is any doubt
3. create each child with explicit `parentId`
4. confirm the children became real sub-issues
5. only then add `relatedTo`, `blocks`, or `blockedBy` if execution
   dependencies also matter

Dependency edges never substitute for hierarchy.

## AI Review Alignment

Issue-driven work closes through `AI Review Report`, not through narrative
confidence.

The review must reconcile:

- requested vs implemented
- promised vs delivered
- issue scope vs actual landing
- review claim vs reality

## Parent Closure Discipline

When child slices land under a parent:

- state whether the parent is closer to consolidation
- keep the parent open when it is still not truly review-ready
- do not close a parent just because several children exist

## Review-Time Recheck

Before `Done`, recheck at minimum:

- current status matches actual lifecycle truth
- the issue did enter `In Progress` if real work happened
- the issue did enter `In Review` when a real review gate remained
- lifecycle notes are not being replaced by retrospective narrative
- labels are still present and valid
- assignee and project are still correct
- parent/child hierarchy still matches the executed package

## Follow-Up Discipline

When the review finds real out-of-scope residual work:

- create a follow-up issue
- link it explicitly
- reference it in the AI Review

Do not silently absorb residual risk into a bounded child issue.

When recurring metadata drift or lifecycle collapse is suspected across a date
window or execution package, use the repo protocol in
`docs/architecture/linear-hygiene-audit-protocol.md` so the next correction
package starts from normalized evidence instead of rediscovery.
