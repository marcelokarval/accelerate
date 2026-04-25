# Linear Adapter

This directory defines the Linear workflow adapter capability contract.

## Current Status

- status: default-shaped workflow doctrine
- phase: standalone pre-agents
- runtime implementation: not yet implemented as a native adapter in this
  repository

Linear remains the strongest inherited workflow shape, but this repository does
not yet provide an enforced Linear backend runtime. Until the adapter is fully
rehomed, inherited Linear-shaped doctrine lives primarily in:

- `references/linear-execution.md`
- `references/issue-stack.md`
- `references/workflow-catalog.md`

Those files are supporting doctrine. This adapter contract is the intended local
adapter surface for future implementation.

## Capability Contract

The Linear adapter must satisfy the shared workflow contract through Linear
objects and explicit external links where Linear does not own the artifact:

- issue bootstrap through Linear issues
- issue topology through parent/child issues, blocking relations, related
  relations, projects, cycles, labels, and priorities as applicable
- status reporting through Linear workflow states mapped to root lifecycle truth
- comment capabilities through Linear comments or equivalent issue activity used
  for handoff, AI review, closure, and residual-risk evidence
- pull-request or merge evidence through linked branch, commit, repository, or
  pull-request metadata because Linear is not the code-review backend
- closure traceability through final issue status, AI review placement,
  parent/child reconciliation, and linked follow-up issues

The adapter must not treat a Linear issue moved to `Done` as sufficient closure
if implementation proof, review evidence, or residual follow-up linkage is
missing.

## Identity Rules

Linear workflow identity must be stable and rehydratable:

- Linear issue identifier and URL identify the governing work item
- team, project, cycle, and parent issue identify the execution container when
  present
- assignee, labels, priority, and workflow state are metadata truth only after
  they are read back from Linear
- child issue identifiers, dependency edges, and related links must not be
  conflated with each other
- comment author identity must distinguish human and agent updates when Linear
  exposes that distinction

Issue titles are not stable governing identity by themselves.

## Metadata Rehydration

Before resumed execution, review, or closure, a Linear adapter implementation
must be able to rebuild the workflow packet from Linear state:

- governing issue URL, identifier, status, assignee, labels, priority, team,
  project, and cycle when used
- parent/child topology and blocking/related edges as separate relation types
- linked branch, commit, repository, or pull request metadata when code-review
  evidence lives outside Linear
- latest handoff, progress, AI review, closure, and residual-risk comments
- follow-up issues created for out-of-scope residual work

If Linear cannot provide one of these values, the adapter must expose the gap or
name the substitute artifact instead of manufacturing backend truth.

## Failure Handling

Linear adapter failures must preserve root control-plane truth:

- missing issue bootstrap blocks issue-driven mutation unless the root recorded
  a narrow no-issue exception
- missing assignee, project, labels, parent/child relation, or lifecycle state
  blocks metadata-complete claims when Linear is the active enforced backend
- failed status transitions leave the previous status visible and record the
  attempted transition
- failed comment placement blocks `Done` claims until the AI review or closure
  report lands in a traceable substitute artifact
- API/auth/rate-limit failures must be reported as workflow failures with retry
  instructions and the last known Linear state

Partial Linear updates require a recovery packet naming which issue fields or
comments landed and which still need retry.

## Not-Yet-Implemented Limits

This repository does not yet include a native Linear adapter runtime, adapter
selection layer, metadata rehydration command, or automated Linear issue/comment
writer.

Until those pieces are implemented, use this file as the Linear capability
contract and use the references above for supporting inherited doctrine. Do not
claim native Linear enforcement from this scaffolding.
