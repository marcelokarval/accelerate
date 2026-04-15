# Issue Stack

Use this module when the work mutates code, docs, workflow seeds, or runtime
governance and the issue lane must be visible as a first-class workflow stack.

## Core Rule

For mutating work, the issue stack is not optional process overhead. It is part
of the execution model.

## Stack

- `accelerate`
- `Issue Bootstrap Gate`
- `linear-pm`
- `linear-implementation-planner` when sequencing or parent/child structure is
  non-trivial
- planning artifact (`planning-with-files` or equivalent execution-ready plan)
- `executing-plans` when the execution packet is accepted
- `linear-progress-reporter` for longer runs
- `AI Review Report` before `Done`

## Flow

```text
User Request
  -> accelerate
     -> mutating?
        -> no  -> analysis path
        -> yes -> Issue Bootstrap Gate
                 -> missing issue     -> BLOCK
                 -> existing issue    -> validate with linear-pm
                 -> new issue needed  -> create with linear-pm
                      -> planning gate
                         -> missing plan -> BLOCK
                         -> plan present -> execute
                              -> QA / browser-proof / E2E
                              -> AI Review Report
                              -> Done
```

## Required Visibility

Issue-driven packets should make visible:

- governing issue
- issue lifecycle state
- metadata completeness
- next lifecycle gate
- whether planning artifact already exists
- whether the work is still blocked on issue/plan hygiene

## Subagents In Issue-Driven Work

If subagents are spawned:

- they inherit the same governing issue
- they do not invent parallel issue authority
- each subagent returns a bounded implementation/review packet
- the master remains accountable for final issue closure
