---
name: planning-with-files
description: File-based planning skill for Codex using persistent markdown in the project workspace to track plan, findings, and progress across complex tasks.
metadata:
  category: orchestration
  origin: standalone-adapted-from-global
---

# Planning With Files

Use markdown files in the project workspace as persistent working memory for
complex tasks.

## When to Use

- multi-step implementations
- research-heavy tasks
- long-running migrations
- work that spans many reads, decisions, and edits
- tasks where context loss would be expensive

Do not use for:

- trivial questions
- tiny single-file edits

## Core Principle

Important context should live on disk, not only in the active session.

In the accelerate-root workflow, these files support non-trivial work after
classification and before or during bounded execution.

## Standard Files

Create these in the project workspace when the task is complex enough:

- `task_plan.md`
- `findings.md`
- `progress.md`

## File Roles

| File | Purpose |
|------|---------|
| `task_plan.md` | phases, decisions, next steps |
| `findings.md` | discoveries, evidence, references |
| `progress.md` | running log of actions and results |

## Workflow

### 1. Create the Plan Files

At task start:

- create the files in the workspace root or relevant subdirectory
- write the goal and phases first

### 2. Keep Findings Durable

After meaningful discovery:

- record key findings
- save file paths, risks, and conclusions

### 3. Update Progress Continuously

Use `progress.md` to track:

- what was attempted
- what succeeded
- what failed
- what remains

### 4. Re-read Before Major Decisions

Before changing approach or touching multiple files:

- revisit the plan
- confirm the current phase
- confirm the next bounded step



## Planning-Only Mode

When the user explicitly wants planning rather than execution:

- inspect with read-only commands/tools
- update only planning artifacts
- do not start implementation, commits, or external mutation
- leave one execution-ready planning artifact instead of vague notes

## Minimum Plan Artifact Schema

A plan is not complete unless it makes follow-on execution possible for a
zero-context operator.

At minimum include:

- goal
- current context and assumptions
- exact file paths likely to change
- bounded phases or tasks in execution order
- verification commands or proof expectations
- risks, tradeoffs, and open questions
- the next bounded step

When the plan is intended to shape implementation, prefer one canonical plan
artifact that can act as the execution contract instead of scattering critical
instructions across multiple scratch files.

## Task Granularity

Good plans default to small bounded tasks.

Aim for tasks that are small enough to execute and verify cleanly, rather than
large narrative phases that still require interpretation.

## Error Handling

If a path fails repeatedly:

1. record the failure
2. change the approach
3. do not repeat the same failed attempt blindly

## Recommended Dependencies

- `accelerate` for large orchestrated tasks
- `prompt-hardening` when the request still needs scoping before planning
- `linear-pm` when execution is issue-driven

## Verification

Planning with files is working correctly if:

- the current phase is always clear
- discoveries are not lost between steps
- progress can be resumed without re-discovery
- the files make bounded execution and micro-review checkpoints easier rather
  than looser
