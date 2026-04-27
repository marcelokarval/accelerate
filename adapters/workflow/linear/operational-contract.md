# Linear Operational Contract

## Purpose

This document defines the safe implementation sequence for the Linear workflow
adapter.

Linear is the first remote workflow adapter target, but it must not become
runtime truth until read, write, failure, and recovery behavior are tested.

## Phase 5A: Read And Rehydrate First

The first safe Linear implementation slice is read-only:

- discover Linear authentication posture without printing secrets
- fetch a named Linear issue by identifier or URL
- rehydrate a workflow packet from Linear issue state
- map Linear state to Accelerate lifecycle state
- expose missing metadata as explicit gaps
- write the rehydrated packet to a local substitute artifact under
  `.accelerate/workflow/linear-rehydration.md`

This phase may not create, update, comment, transition, assign, label, or close
Linear issues.

## Phase 5B: Bootstrap And Topology Writes

After read/rehydration is tested:

- create governing issue
- create or link parent/child topology
- set required labels/project/team/cycle metadata when configured
- record partial-write recovery packets on failure

## Phase 5C: Review And Closure Attachments

After bootstrap/topology writes are tested:

- attach review-ready packet comments
- attach AI review comments
- attach defect/correction/reproof comments
- attach final forensic reconciliation comments
- transition issue status only after proof gates pass

## Mapping Contract

Linear issue fields map to Accelerate workflow truth as follows:

| Accelerate Field | Linear Source | Required Behavior |
| --- | --- | --- |
| work item ID | issue identifier and UUID | preserve both when available |
| locator | issue URL | required for rehydration |
| title | issue title | descriptive only, not identity |
| lifecycle state | Linear workflow state | map explicitly, never infer from title |
| owner | assignee | gap if missing and required by active policy |
| parent | parent issue | separate from blocking/related |
| children | child issues | separate from blocking/related |
| related | related links/relations | do not conflate with child topology |
| review attachment | comments/activity | required before claiming review posted |
| closure attachment | final comment/status | required before claiming Linear closure |

## Lifecycle Mapping

Initial mapping must be configurable, but default mapping is:

| Linear State Shape | Accelerate Lifecycle |
| --- | --- |
| backlog/triage/todo | `planned` |
| ready | `ready` |
| started/in progress | `in_progress` |
| in review/review | `review` |
| validating/closing | `closure` |
| done/completed | `done` |
| blocked | `blocked` |
| canceled/cancelled | `cancelled` |

Unknown states must produce a gap, not a guessed lifecycle value.

## Failure Rules

- API/auth/rate-limit failure blocks Linear runtime truth claims.
- Failed read blocks rehydration.
- Failed write leaves previous Linear state visible and records recovery action.
- Failed comment attachment blocks review/closure-posted claims.
- Partial writes require `.accelerate/workflow/linear-recovery.md` or an
  equivalent traceable recovery artifact.

## Runtime Claim Boundary

`capabilities.yaml` must remain `status: planned` until the adapter has tested
commands for read/rehydration and at least one safe write class. Read-only
rehydration alone is not enough to claim full implementation.
## Read Probe

`onboarding/local-workspace/probe-linear-adapter.sh` is a read/probe helper. It
checks local state and auth presence only. It does not create, update, comment on,
or transition Linear issues, and does not make the Linear adapter implemented.

`read-linear-adapter.sh` can read issue metadata through the Linear GraphQL API.
`attach-linear-artifact.sh` can attach a local artifact as a Linear comment when
`LINEAR_API_KEY` is provided. These commands are executable helpers, but the
adapter remains `planned` until live read/write behavior is tested and adopted as
workflow truth.

## MCP Live Test Evidence

On 2026-04-27, Linear's remote MCP server was configured in the global OpenCode
config as `linear` using `https://mcp.linear.app/mcp` and authenticated through
`opencode mcp auth linear`.

Read live test:

- `opencode mcp list` reported `linear connected`
- an OpenCode run invoked `linear_get_user` and `linear_list_issues`
- the authenticated user was `marcelokarval@gmail.com`
- returned issues were assigned to project `Prop4You`

Write live test:

- created temporary issue `P4Y-1270`
- project: `Prop4You`
- assignee: `marcelokarval@gmail.com`
- comment write succeeded with body `Accelerate Linear MCP live attach validation: non-sensitive temporary test comment.`
- issue was transitioned to canceled status after the test

This proves OpenCode-hosted Linear MCP read/write capability. It does not prove
the GraphQL helper scripts, which still require `LINEAR_API_KEY`; therefore the
GraphQL helpers remain secondary.

## Implemented MCP Helper Set

The implemented Linear adapter path is MCP-hosted through OpenCode global auth:

- read: `read-linear-mcp-adapter.sh`
- create: `create-linear-mcp-issue.sh`
- attach review/closure artifact: `attach-linear-mcp-artifact.sh`
- recovery packet: `write-linear-mcp-recovery.sh`

The older GraphQL helpers remain available for environments that provide
`LINEAR_API_KEY`, but they are not the primary implemented path.
