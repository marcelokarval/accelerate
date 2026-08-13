# Issue-Driven Mutation Stack

## Purpose

This document is the native core contract for mutation-time issue discipline in
the pre-agents phase.

## Core Rule

When work mutates code, docs, workflow seeds, or runtime governance, the issue
stack is mandatory unless a narrow no-issue exception is explicitly approved.

For mutating work, the issue stack is not optional process overhead. It is part
of the execution model.

## Stack

1. `accelerate`
2. `Local Workspace Entry Gate` when a governed target repository is in scope
3. `Prompt Hardening Gate` when the request is ambiguous, multi-phase,
   governance-heavy, or not execution-ready yet
4. `Issue Bootstrap Gate`
5. `Specification Entry Gate`
6. `SDD Mode Gate` with an accepted or implementing design authority
7. `Decision Artifact Gate`, `Test Design Gate`, and `TDD Entry Gate`
8. validated Engineering Artifact Manifest with complete traceability
9. active workflow adapter when implemented/available, otherwise native planning
   artifacts and runtime packets
10. adapter-specific planner when a remote adapter is active and sequencing or
   hierarchy is non-trivial
11. proportional planning artifact
12. `executing-plans` when the execution packet is accepted
13. adapter-specific progress reporter for longer runs when a remote adapter is
   active
14. proof stack, correction invalidation, and fresh reproof
15. local review / closure preparation when `.accelerate/` local status is active
16. `AI Review Report`
17. root closure mode

## Flow

```text
User Request
  -> accelerate
     -> mutating?
        -> no  -> analysis path
        -> yes -> execution-ready?
                 -> governed target repo?
                    -> yes -> Local Workspace Entry Gate
                            -> missing/reentry required -> BLOCK
                            -> local state ready -> continue
                    -> no  -> continue
                 -> no  -> Prompt Hardening Gate
                         -> execution-ready artifact missing -> BLOCK
                         -> shaped request ready -> Issue Bootstrap Gate
                 -> yes -> Issue Bootstrap Gate
                           -> missing issue     -> BLOCK
                           -> existing/new issue -> validate or create through the active adapter/local authority
                                -> Specification Entry Gate
                                   -> missing/invalid manifest -> BLOCK
                                   -> draft/underclassified design -> BLOCK
                                   -> accepted proportional design
                                -> planning gate
                                   -> missing plan -> BLOCK
                                   -> plan present -> execute
                                        -> proof stack
                                        -> local review / closure prep when active
                                        -> AI Review Report
                                        -> Done
```

## Execution Rule

Mutation must not jump directly from request to implementation.

Issue bootstrap alone does not authorize implementation. Every mutation must
also pass the Specification Entry Gate. Direct-fast-path mutation remains
issue-driven and uses a micro Spec Capsule plus compact Engineering Artifact
Manifest; `none` is not a mutation mode.

If issue bootstrap succeeded but no post-bootstrap planning artifact exists for
non-trivial work, execution is still blocked.

If a governed target repository is in scope, local workspace entry happens
before issue bootstrap:

- absent local workspace when init is required -> BLOCK
- stale local workspace when reentry is required -> BLOCK
- structural drift requiring reonboarding -> BLOCK until reconciled

If the request is mutating but still needs shaping, the run must not look like
execution with blockers attached. It should look like shaping-first lane
selection:

- `Prompt Hardening`
- then `Issue Bootstrap`
- then planning
- only then execution framing

Do not open with execution language and retrofit issue hygiene later.

## Required Visibility

Issue-driven runtime packets must make visible:

- local workspace status / action when target repo governance is in scope
- governing issue
- issue lifecycle state
- metadata completeness
- next lifecycle gate
- whether the planning artifact already exists
- whether the run is still blocked on issue/plan hygiene
- whether the slice is still in shaping-first mode before execution
- whether `Prompt Hardening Gate` was satisfied or is still blocking entry
- SDD mode and accepted/implementing design locator
- Engineering Artifact Manifest locator and validation stage
- decision, Test Design, and TDD entry dispositions
- correction generation versus proof generation
- whether `prepare-review.sh` or `prepare-closure.sh` is now the canonical next step

## Subagents In Issue-Driven Work

If subagents are spawned:

- they inherit the same governing issue
- they do not invent parallel issue authority
- each subagent returns a bounded implementation or review packet
- the master remains accountable for final issue closure

## Backend-Neutral Lifecycle

The core issue stack is backend-neutral. Accelerate owns the lifecycle semantics;
workflow adapters map those semantics into their own providers only after they
are implemented and selected.

Minimum lifecycle vocabulary:

- `shaping`
- `planned`
- `ready-for-execution`
- `in-progress`
- `ready-for-review`
- `changes-requested`
- `ready-for-closure`
- `closed`
- `blocked`

Provider names such as Linear workflow states, GitHub issue states, pull-request
review states, Jira statuses, or local `.accelerate/` fields are adapter
mappings. They are not core defaults.

If no remote workflow adapter is implemented and selected, native planning
artifacts and local runtime packets are the substitute execution record.
