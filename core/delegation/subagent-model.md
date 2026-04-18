# Subagent Model

## Purpose

Use this module when deciding whether delegation should happen and how it must
be governed.

## Core Rule

Subagents are bounded collaborators. They do not replace the master
orchestrator.

The master always owns:

- the global plan
- integration correctness
- final review
- final forensic closure

## Safe Role Catalog

Useful subagent shapes:

- implementation worker
- decomposition or planner sidecar
- governance auditor
- runtime or browser reviewer
- verification sidecar

## Persona-To-Subagent Mapping

Safe defaults:

- master-only
  - `Master Integrator`
  - `Closure / Forensic Reviewer`
  - `Delivery PM`
- delegate-possible
  - `Implementation Designer`
  - `Runtime/Product Reviewer`
  - `Governance Auditor`
- master-preferred
  - `Specification PM`
  - `Product Planner`

## Spawn Criteria

For non-trivial work, prefer bounded delegation when it creates honest value.

Root-only execution remains legitimate when delegation would add more
integration cost than execution clarity.

Default expectation:

- if there is an independent implementation slice with clear bounded value ->
  spawn an implementation worker
- if there is no safe implementation split but there is clear proof/review value
  -> spawn a review, browser, governance, or verification sidecar
- if neither shape is honest -> keep the run root-owned and emit an explicit
  `single-threaded exception`

Prefer bounded delegation when all are true:

- the subtask is bounded and explicit
- there is meaningful parallel value
- the write scope is clear or read-only
- the master is not blocked on immediate local action
- the integration burden is lower than the expected gain

## Non-Spawn Criteria

Do not spawn when:

- the task is on the critical path right now
- the scope is vague
- the output would mostly duplicate master reasoning
- the work is too small to justify coordination overhead
- the task requires global judgment the master cannot delegate

If these conditions block all delegation on a non-trivial run, emit an explicit
`single-threaded exception` in the runtime packet.

## Output Contract

Every subagent must return:

- scope handled
- files changed or surfaces inspected
- evidence used
- tests or verification run
- self-review
- self-forensic review
- unresolved risks

## Review Hierarchy

1. subagent executes
2. subagent self-reviews
3. subagent self-forensic-reviews
4. master reviews the returned slice
5. master reviews the subagent review quality
6. master integrates the combined result
7. master performs final forensic closure

## Master Integration Protocol

When multiple outputs come back, the master must check:

- complementarity
- conflict
- overlap
- hidden scope drift
- local correctness vs global correctness

Never trust subagent-local success as proof of integrated correctness.

## Parallelism Budget

Use explicit budgets:

- `0` subagents for trivial bounded work, root-only execution by honest fit, or
  explicit single-threaded exception
- `1` subagent for a single meaningful sidecar
- `2-3` subagents for independent bounded slices

More than this requires strong justification because integration cost rises
quickly.

## Operational Hand-Off

Use `subagent-governance` as the concrete policy skill when the question is how
to shape bounded subagent packets, review ordering, or master-level
integration.

Use `parallel-agents` when the decision is whether concurrency is actually safe
before any write-bearing delegation begins.
