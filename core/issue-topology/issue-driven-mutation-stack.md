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
2. `Prompt Hardening Gate` when the request is ambiguous, multi-phase,
   governance-heavy, or not execution-ready yet
3. `Issue Bootstrap Gate`
4. active workflow adapter
5. `linear-implementation-planner` when sequencing or hierarchy is non-trivial
6. planning artifact
7. `executing-plans` when the execution packet is accepted
8. `linear-progress-reporter` for longer runs
9. proof stack
10. `AI Review Report`
11. root closure mode

## Flow

```text
User Request
  -> accelerate
     -> mutating?
        -> no  -> analysis path
        -> yes -> execution-ready?
                 -> no  -> Prompt Hardening Gate
                         -> execution-ready artifact missing -> BLOCK
                         -> shaped request ready -> Issue Bootstrap Gate
                 -> yes -> Issue Bootstrap Gate
                           -> missing issue     -> BLOCK
                           -> existing issue    -> validate with active workflow adapter
                           -> new issue needed  -> create with active workflow adapter
                                -> planning gate
                                   -> missing plan -> BLOCK
                                   -> plan present -> execute
                                        -> proof stack
                                        -> AI Review Report
                                        -> Done
```

## Execution Rule

Mutation must not jump directly from request to implementation.

If issue bootstrap succeeded but no post-bootstrap planning artifact exists for
non-trivial work, execution is still blocked.

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

- governing issue
- issue lifecycle state
- metadata completeness
- next lifecycle gate
- whether the planning artifact already exists
- whether the run is still blocked on issue/plan hygiene
- whether the slice is still in shaping-first mode before execution
- whether `Prompt Hardening Gate` was satisfied or is still blocking entry

## Subagents In Issue-Driven Work

If subagents are spawned:

- they inherit the same governing issue
- they do not invent parallel issue authority
- each subagent returns a bounded implementation or review packet
- the master remains accountable for final issue closure

## Current Default Adapter

The current default workflow backend is still Linear-shaped.

That remains a distribution fact, not a permanent law of the core.
