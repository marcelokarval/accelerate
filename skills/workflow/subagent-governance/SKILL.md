---
name: subagent-governance
description: Codex-native multi-agent governance. Use when planning or executing work with multiple subagents, parallel slices, nested delegation risk, review aggregation, write-scope boundaries, or master-level revalidation of subagent outputs.
---

# subagent-governance

Use this skill when work is distributed across multiple subagents or when the
orchestrator must decide whether parallel delegation is safe.

## Purpose

Keep multi-agent execution powerful without letting recursive delegation,
ownership drift, or fragmented review make the final result untrustworthy.

## Core Rules

1. The master/orchestrator owns the global plan and final closure.
2. Subagents receive bounded scopes, not open-ended mission authority.
3. Subagents do not spawn further subagents by default.
4. Any nested delegation requires explicit master-level approval.
5. Every subagent must perform self-review and self-forensic review for its own slice.
6. The master must revalidate the combined result, not just collect child summaries.
7. Parallelism is a budgeted decision, not a reflex.

The subagent loop must remain comparative and defect-aware, not summary-only.

## Required Decisions Before Spawning

Decide explicitly:

- why this slice should be delegated
- whether the slice is implement, audit, review, or integration work
- the write scope or read-only scope
- the completion contract
- whether the subagent may request escalation instead of spawning another subagent

Every spawn should carry a bounded handoff packet containing:

- objective
- full task text, not summary shorthand
- repo/workspace context
- exact write scope and forbidden scope
- required validation
- escalation path
- expected completion format

## Allowed Roles

- implementer
- reviewer
- forensic reviewer
- auditor
- integration checker
- planner support

## Default Recursion Policy

- master may spawn subagents
- subagents may not spawn other subagents by default
- any exception must be explicitly authorized by the master because uncontrolled recursion creates cost, ambiguity, and closure risk

## Completion Contract

Each subagent should return at least:

- assigned scope
- files/evidence touched
- what was implemented or audited
- requested-vs-implemented comparison
- validation performed
- verdict against the original spec or assigned task text
- self-review
- self-forensic review
- defects found and disposition
- residual risks
- recommendation: done / partial / follow-up

For implementation slices, review ordering should be:

1. implementer output + requested-vs-implemented
2. self-review
3. self-forensic review
4. defect disposition and reproof when meaningful defects were corrected
5. spec-compliance review
6. code-quality / forensic review
7. master integration review

Do not let implementer self-review substitute for independent review.
Do not let requested-vs-implemented degrade into a vague recap of work.

## Master Aggregation Rule

The master must produce a final integrated judgment that includes:

- slice map
- ownership map
- cross-slice contract check
- review of subagent reviews
- review of requested-vs-implemented and defect disposition quality
- forensic review of the combined result
- final done / partial / follow-up judgment

## Parallelism Rule

Prefer parallelism only when slices are meaningfully separable. Do not parallelize work that is tightly coupled by:

- the same files
- the same contracts
- the same migration boundary
- the same unresolved architecture decision

## Review Questions

- Was delegation actually justified?
- Were nested spawns prevented or explicitly approved?
- Did every subagent operate inside a bounded scope?
- Did every subagent leave requested-vs-implemented plus defect disposition?
- Did the master revalidate the whole instead of trusting child summaries?
