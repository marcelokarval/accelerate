# GitHub Adapter

This directory defines the planned GitHub workflow adapter capability contract.

## Current Status

- status: planned peer adapter
- phase: standalone pre-agents
- runtime implementation: not yet implemented in this repository

The adapter docs are local architecture truth for the intended GitHub backend.
They are not proof that GitHub Issues, pull requests, comments, or status checks
are currently enforced by `accelerate` at runtime.

## Capability Contract

The GitHub adapter must satisfy the shared workflow contract through native
GitHub objects where possible:

- issue bootstrap through GitHub Issues
- issue topology through issue links, task lists, milestones, labels, projects,
  or an explicit substitute when native parent/child hierarchy is unavailable
- pull-request discovery and attachment through linked PRs, branch references,
  commits, checks, and review state
- status reporting through issue state, labels, project fields, pull-request
  state, checks, or an explicitly documented lifecycle mapping
- comment capabilities through issue comments, pull-request comments, reviews,
  or review-summary comments
- closure traceability through linked issue closure, PR merge state, final review
  report placement, and residual follow-up links

The adapter must not treat a merged pull request as sufficient closure if the
governing issue, review report, or residual-risk packet remains unresolved.

## Identity Rules

GitHub workflow identity must be stable and rehydratable:

- repository owner/name identifies the backend scope
- issue number and URL identify the governing work item
- pull-request number and URL identify the code-review artifact when present
- labels, project fields, milestones, and assignees carry metadata truth only
  after they are read back from GitHub
- actor identity for comments/reviews must distinguish human, bot, and agent
  updates when GitHub exposes that distinction

Titles and branch names are not stable governing identity by themselves.

## Metadata Rehydration

Before resumed execution, review, or closure, a GitHub adapter implementation
must be able to rebuild the workflow packet from GitHub state:

- governing issue URL, number, state, assignees, labels, milestone, and project
  placement when used
- linked pull request URL, number, branch, merge state, review state, and check
  state when used
- issue or PR comments containing handoff, AI review, closure, and residual-risk
  evidence
- hierarchy/substitute topology, including task-list references, linked issues,
  project grouping, or an explicit no-hierarchy exception
- follow-up issues linked from the final review when residual work remains

If the GitHub API, local `gh` state, or repository metadata cannot provide one
of these values, the adapter must surface the gap instead of inferring it from
local memory.

## Failure Handling

GitHub adapter failures must preserve root control-plane truth:

- missing issue bootstrap blocks issue-driven mutation unless the root recorded
  a narrow no-issue exception
- failed label, assignee, project, or milestone updates block metadata-complete
  claims
- failed PR lookup blocks PR-based closure claims but does not erase issue
  evidence already placed
- failed comment or review placement blocks `Done` claims until the final report
  is attached to a traceable substitute artifact
- API/auth/rate-limit failures must be reported as workflow failures with retry
  instructions and the last known backend state

Partial GitHub updates require a recovery packet naming which objects were
updated and which still need retry.

## Not-Yet-Implemented Limits

This repository does not yet include a GitHub adapter runtime, `gh` wrapper,
adapter selection layer, metadata rehydration command, or automated status/comment
writer.

Until those pieces are implemented, use this file as the GitHub capability
contract only. Do not claim GitHub workflow enforcement from this scaffolding.
