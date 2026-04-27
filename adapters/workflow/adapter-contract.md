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

Required keys:

```yaml
schema_version: 1
adapter: local|linear|github-pr|github-issues|github-projects|jira|notion
status: implemented|planned|blocked
identity: native|linked|substitute|none
work_item_create: native|linked|substitute|planned|blocked|none
work_item_lookup: native|linked|substitute|planned|blocked|none
work_item_update: native|linked|substitute|planned|blocked|none
lifecycle_transition: native|linked|substitute|planned|blocked|none
topology: native|linked|substitute|planned|blocked|none
review_attachment: native|linked|substitute|planned|blocked|none
closure_attachment: native|linked|substitute|planned|blocked|none
metadata_rehydration: native|linked|substitute|planned|blocked|none
failure_recovery: native|linked|substitute|planned|blocked|none
external_api: native|linked|substitute|planned|blocked|none
substitute_evidence: <path or none>
runtime_truth: local|remote|hybrid|none
```

Rules:

- `status: implemented` requires at least substitute identity, lifecycle, topology,
  review/closure attachment, metadata rehydration, and failure recovery.
- `external_api: none` is valid for the local adapter only when
  `runtime_truth: local` and `substitute_evidence` points to concrete local files.
- A remote adapter must not claim `implemented` until its API read/write behavior
  is tested.
- Gaps must be represented as `none` or `blocked`, not hidden in prose.

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

- `linear` may exist as the current default-shaped doctrine
- `github` may exist as a peer architectural target
- neither should be treated as enforced runtime truth for this repo until the
  backend is actually implemented and adopted here

The root may still choose issue topology, lifecycle shape, and planning gates
without pretending that the adapter backend is already alive.

## Not-Yet-Implemented Limits

This contract is currently documentation, not an implemented adapter runtime.

The repository does not yet provide:

- a native adapter selection command
- a shared adapter interface implementation
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

The current default backend is still Linear-shaped, but the contract is not
Linear-only.

GitHub is the first intended peer adapter.

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
