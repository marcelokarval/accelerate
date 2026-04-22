---
name: linear-progress-reporter
description: Codex-native progress-reporting skill for Linear execution summaries, blocker reporting, and structured status communication.
user-invocable: true
related-skills: linear-pm, linear-implementation-planner, linear-workflow-orchestrator
---

# linear-progress-reporter

Use this skill for status reporting, progress summaries, blocker reporting, and
execution visibility in Linear-driven work.

## Purpose

Provide structured progress reporting that is useful to humans and consistent
with issue-based execution.

## Load When

Load this skill when the task touches:

- progress summaries
- execution reporting
- blocker updates
- milestone or sprint visibility
- issue comments that summarize delivery state

## Core Rules

1. Report progress against concrete scope, not vague impressions.
2. Separate completed work, in-progress work, blockers, and next steps.
3. Keep dependency status explicit when it matters.
4. Prefer concise structured reporting over long narrative status dumps.

## Accelerate Guidance

- Use this skill for Linear comments, milestone summaries, or stakeholder-facing
  engineering updates.
- Pair it with `linear-pm` when status must reflect acceptance criteria and
  execution order.

## Review Checklist

- Is the report tied to concrete scope?
- Are blockers explicit?
- Is the next action clear?
