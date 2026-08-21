# Orchestrator-First Execution Gate

## Purpose

Use this gate when a run asks for executive planning, task execution, task-level
review, correction, delegated work, or final forensic confirmation.

The root session is the orchestrator and final forensic reviewer. It owns
hardening, SDD/PRD, task graph, dispatch, fan-in, integration-only repairs,
review-of-review, and closure; it does not execute task-owned scopes. After
`DISPATCH_REQUIRED`, a single-threaded exception is a blocker, not permission.

The master session also owns active agent cleanup. A returned result does not
mean the agent runtime is clean; agents that delivered and became idle must be
explicitly closed, marked complete, or recorded as intentionally retained.

## Core Rule

Execution authority, skeptical review authority, and final closure authority are
separate.

For every orchestrated execution task with collaboration available, use the
Post-Spec Delegation Dispatch Gate and its receipt before the first task-owned
write, then assign:

- `executor`: physical subagent when available, otherwise a virtual executor pass
- `skeptical reviewer`: independent physical reviewer when available, otherwise a
  virtual reviewer pass
- `orchestrator`: the master session, which integrates, reviews the review, and
  owns closure

Physical dispatch uses 2-3 bindings and explicit model/effort/fork. Virtual
agents are permitted only for `collaboration_unavailable` or
`spawn_failed_operator_authorized` (or explicit user opt-out); they never
satisfy a physical dispatch available in the host.

## Activation

This gate opens when a prompt includes any strong combination of:

- executive plan plus task ledger
- execution after planning
- subagent execution or subagent review
- side-by-side review
- final confirmation review
- correction loop or reproof

It also opens for non-trivial issue-driven execution when review isolation is a
closure condition.

## Required Evidence

Closure needs:

- `Orchestrator-First Packet`
- executor assignment for each non-trivial task
- skeptical review assignment for each non-trivial task
- review-of-review by the orchestrator
- active closure of idle agents that already returned their result, or an
  explicit retained-agent reason
- final forensic reconciliation

If virtual isolation is used, the packet must say so explicitly and carry any
residual risk.

## Closure Blockers

Do not close when:

- the executor accepted their own work
- skeptical review is missing
- skeptical review repeats executor claims without independent checks
- virtual isolation is used but not declared
- orchestrator review-of-review is missing
- agents that already returned results remain idle/open without an explicit
  close, completion marker, or retained-agent reason
- correction happened without reproof
- final forensic reconciliation is missing
