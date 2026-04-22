---
name: linear-workflow-orchestrator
description: Codex-native orchestration skill for dependency-aware multi-issue Linear workflows, sequencing, and critical-path planning.
user-invocable: true
related-skills: linear-pm, linear-implementation-planner, linear-progress-reporter, architecture
---

# linear-workflow-orchestrator

Use this skill for multi-issue or multi-phase Linear workflows that need
orchestrated sequencing rather than a single issue body.

## Purpose

Provide a higher-level workflow lens on top of `linear-pm` and
`linear-implementation-planner`.

This skill is for multi-issue sequencing, not for writing a better single issue
body or following one already-approved implementation plan.

## Load When

Load this skill when the task touches:

- dependency chains across issues
- epic-to-issue rollout
- coordinated multi-issue execution
- sequence planning for releases or sprints

## Core Rules

1. Start from issue dependencies and execution order.
2. Distinguish orchestration concerns from individual issue quality.
3. Keep the workflow visible: what blocks what, what can run in parallel, what
   is the critical path.
4. Use structured summaries rather than vague coordination notes.

## Accelerate Guidance

- This skill complements `linear-pm`; it does not replace it.
- Use it when the question is about workflow shape, sequencing, or dependency
  coordination across multiple issues.

## Boundary Against Adjacent Skills

- `linear-pm`
  - owns issue quality, metadata, parent/child hygiene, and lifecycle
- `linear-implementation-planner`
  - owns the execution shape inside one issue or one bounded slice
- `executing-plans`
  - owns disciplined execution once the plan is already accepted

## Review Checklist

- Is the workflow dependency-aware?
- Is the critical path explicit?
- Are parallelizable tracks clearly separated?
