# Workflow Adapter Contract

## Purpose

This document defines the common contract all workflow adapters must satisfy in
the standalone pre-agents phase.

## Current Reality

This repository does not yet have a fully implemented native workflow backend.

So this contract currently defines:

- what a real workflow adapter must eventually satisfy
- what the root control plane is already allowed to assume
- what must not be faked before a backend is actually implemented

Until a backend is concretized, planning artifacts and architecture docs remain
the governing execution surfaces.

## Every Workflow Adapter Must Support

- issue bootstrap
- issue hierarchy or an explicit substitute model
- metadata hygiene
- lifecycle state transitions
- AI review reporting
- closure traceability

## Backend-Neutral Lifecycle Vocabulary

Accelerate core lifecycle semantics are backend-neutral:

- `shaping`
- `planned`
- `ready-for-execution`
- `in-progress`
- `ready-for-review`
- `changes-requested`
- `ready-for-closure`
- `closed`
- `blocked`

Adapters must map provider-specific state names into this vocabulary without
making their provider shape the core default.

## Capability Contract

Every concrete workflow adapter must describe its backend support for these
capability families before it can be treated as active runtime truth:

- issue/work-item creation, lookup, update, assignment, labeling, relation, and
  closure
- pull-request or merge-request discovery when the backend owns code review, or
  an explicit external-link substitute when it does not
- status/state reads and transitions that can be mapped to root lifecycle truth
- comment, note, or review-report attachment for handoff, AI review, and
  closure evidence
- metadata reads sufficient to rehydrate a run after interruption

An adapter may have native support, linked support, or no support for a given
capability. Missing support is acceptable only when the adapter states the
substitute evidence model and the control plane can still preserve traceability.

## Capability Manifest

Every concrete adapter must include a machine-readable capability manifest at:

```text
adapters/workflow/<adapter>/capabilities.yaml
```

The manifest is the shared adapter contract stabilization point. It lets the
root compare adapters without assuming that Linear, GitHub, local files, Jira,
or Notion expose the same primitives.

Required keys are defined by [Capability Schema V2](./capability-schema-v2.md).
The exact capability matrix is:

```yaml
schema_version: 2
adapter: local|linear|github-pr|github-issues|github-projects|jira|notion
status: implemented|planned|blocked
runtime_truth: local|remote|hybrid|none
substitute_evidence: <path or none>
read_lookup: native|linked|substitute|planned|blocked|none
read_lookup_command: <repo-relative command or none>
read_lookup_proof: <proof label/path or none>
create_update: native|linked|substitute|planned|blocked|none
create_update_command: <repo-relative command or none>
create_update_proof: <proof label/path or none>
review_artifact_attachment: native|linked|substitute|planned|blocked|none
review_artifact_attachment_command: <repo-relative command or none>
review_artifact_attachment_proof: <proof label/path or none>
rehydration: native|linked|substitute|planned|blocked|none
rehydration_command: <repo-relative command or none>
rehydration_proof: <proof label/path or none>
write_recovery: native|linked|substitute|planned|blocked|none
write_recovery_command: <repo-relative command or none>
write_recovery_proof: <proof label/path or none>
closure_comment: native|linked|substitute|planned|blocked|none
closure_comment_command: <repo-relative command or none>
closure_comment_proof: <proof label/path or none>
status_transition: native|linked|substitute|planned|blocked|none
status_transition_command: <repo-relative command or none>
status_transition_proof: <proof label/path or none>
production_merge_land_gate: native|linked|substitute|planned|blocked|none
production_merge_land_gate_command: <repo-relative command or none>
production_merge_land_gate_proof: <proof label/path or none>
```

Rules:
- `native`, `linked`, and `substitute` capabilities require concrete command and
  proof fields.
- Planned/blocked capabilities must not claim live proof.
- Remote native write commands must be present in
  `adapters/workflow/remote-write-registry.yaml`.
- `status: implemented` requires proof for the essential capability set; planned
  remote create/land/closure surfaces must stay `planned` until live proof exists.
- Gaps must be represented as `none`, `planned`, or `blocked`, not hidden in prose.

## Shared Concepts

Every adapter must express:

- governing issue
- lifecycle state
- parent/child or equivalent hierarchy
- labels/tags classification
- assignee / ownership
- review handoff
- final closure traceability

## Identity Rules

Workflow identity must be stable enough for a zero-context operator to resume a
run without trusting chat history.

Every adapter must define:

- canonical work-item identifier
- human-readable work-item URL or equivalent locator
- owner/assignee representation
- project, repository, milestone, board, or equivalent grouping identity
- parent/child, blocking, related, or explicit substitute relation identity
- author identity for comments, review reports, and automated updates

Do not infer identity from titles alone. Titles are descriptive metadata, not
stable execution identity.

## Metadata Rehydration

Before closure or resumed execution, an adapter must be able to rehydrate the
active workflow packet from backend state or from an explicitly named substitute
artifact.

The minimum rehydrated packet is:

- governing work item and URL/locator
- current lifecycle state
- current owner/assignee
- classification labels/tags
- parent/child or substitute topology
- linked branch, commit, pull request, or merge artifact when applicable
- latest review/closure comment or equivalent evidence attachment
- known residual risks or follow-up links recorded in the backend

If a backend cannot provide one of these fields, the adapter must mark it as an
explicit gap instead of manufacturing the value.

## Failure Handling

Adapters must fail closed when backend truth cannot be read or written.

Required failure behavior:

- missing work item blocks issue-driven mutation unless a narrow no-issue
  exception is explicit
- missing required metadata blocks active execution when the selected backend is
  enforced runtime truth
- failed status transition leaves the previous status visible and records the
  attempted transition
- failed comment/review attachment blocks `Done` claims until evidence is placed
  somewhere traceable
- backend API/auth/rate-limit failures are reported as workflow failures, not as
  successful closure with degraded confidence
- partial updates require a visible recovery packet naming what landed, what did
  not, and what must be retried

## Pre-Agents Minimum Contract

Even before a backend is fully implemented, the control plane may already rely
on these workflow concepts:

- there is a governing work item or an explicit substitute execution artifact
- the run has a visible lifecycle state
- planning exists before non-trivial mutation
- review and closure are traceable

What pre-agents must not do is fake a concrete backend API or pretend that a
workflow system is operational when it is only conceptually modeled.

## Anti-Fake-Adapter Rule

Do not claim an adapter exists just because the architecture already names it.

In the pre-agents phase:

- `linear` may exist as an adapter-specific mapping target for inherited doctrine
- `github` may exist as a peer architectural target
- neither should be treated as enforced runtime truth for this repo until the
  backend is actually implemented and adopted here

The root may still choose issue topology, lifecycle shape, and planning gates
without pretending that the adapter backend is already alive.

## Not-Yet-Implemented Limits

This contract is currently documentation, not an implemented adapter runtime.

The repository does not yet provide:

- a full shared adapter interface implementation beyond capability read/select helpers
- backend credential discovery
- automated work-item creation or transition enforcement
- automated metadata rehydration
- automated AI review placement

Until those pieces exist, adapter docs define the target capability contract and
the honest pre-agents reading model only.

## Adapter Selection Rule

Workflow adapters are siblings, not exceptions to each other.

The selection order is:

1. root control-plane laws remain fixed
2. the active repo chooses or discovers the honest workflow backend
3. the selected adapter expresses the common contract in its own backend
4. the repo may still remain root-only while that backend is absent or
   unsettled

## Adapter Reality

There is no unqualified default remote workflow backend in core. Linear, GitHub,
local files, Jira, Notion, or any later provider become active only through an
implemented selected adapter and its capability manifest.

GitHub is the first intended peer code-review adapter target; Linear remains an
adapter-specific mapping target for inherited issue-topology doctrine.

## Transition Rule

This contract becomes stricter when a real workflow backend is adopted in this
repo.

At that point, the repo should define:

- which adapter is active runtime truth
- what issue bootstrap means concretely
- what lifecycle states are canonical
- what metadata is mandatory
- how AI review reporting is attached
- what counts as real closure in that backend
