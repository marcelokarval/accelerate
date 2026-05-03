# Orchestrator-First Execution Gate

## Purpose

Use this gate when a run asks for executive planning, task execution, task-level
review, correction, delegated work, or final forensic confirmation.

The master session is the orchestrator and final forensic reviewer. It should not
be treated as the task executor for non-trivial work unless an explicit exception
is recorded.

The master session also owns active agent cleanup. A returned result does not
mean the agent runtime is clean; agents that delivered and became idle must be
explicitly closed, marked complete, or recorded as intentionally retained.

## Core Rule

Execution authority, skeptical review authority, and final closure authority are
separate.

For every non-trivial execution task, assign:

- `executor`: physical subagent when available, otherwise a virtual executor pass
- `skeptical reviewer`: independent physical reviewer when available, otherwise a
  virtual reviewer pass
- `orchestrator`: the master session, which integrates, reviews the review, and
  owns closure

Physical agents are preferred when available and bounded. Virtual agents are
packetized role passes that preserve authority separation when the runtime has no
promoted agent catalog.

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
