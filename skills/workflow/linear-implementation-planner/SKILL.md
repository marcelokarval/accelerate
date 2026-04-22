---
name: linear-implementation-planner
description: Use when Linear is the active workflow backend and issue scope or architectural decisions must become a dependency-aware implementation sequence.
metadata:
  category: orchestration
  origin: standalone-adapted-from-global
---

# Linear Implementation Planner

Use this skill to convert issue scope into an executable implementation plan.

## When to Use

- issue is too large to execute directly
- work must be sequenced across blockers
- implementation needs phases or parallel tracks
- you need to derive tasks from decisions and acceptance criteria

## Core Principle

A good implementation plan reduces uncertainty before edits start.

This skill owns execution sequencing inside the issue, not issue governance or
the execution itself.

## Inputs

This skill works best when you already have:

- a Linear issue with good scope
- known blockers and dependencies
- architectural context

If the issue is still vague, use `linear-pm` and `architecture` first.

If Linear is not the active workflow backend, use the selected workflow adapter's
planning skill instead.

## Planning Workflow

### 1. Read Scope

Extract:

- actual problem
- explicit scope
- non-goals
- acceptance criteria
- blockers and downstream impact

### 2. Identify Execution Units

Break work into:

- setup or foundational work
- main implementation slices
- verification and cleanup

### 3. Map Dependencies

Identify:

- what must happen first
- what can run in parallel
- what is blocked externally
- what downstream work this issue unlocks

### 4. Produce the Plan

The plan should be concrete enough to execute, but not so detailed that it
duplicates code-level work.

Recommended structure:

1. phase or batch name
2. goal
3. files or areas affected
4. blockers
5. verification

## What This Skill Avoids

- fake precision on estimates
- planning work that ignores real blockers
- giant one-batch execution for risky cross-stack tasks

## Relationship to Other Skills

- `linear-pm` defines the issue and governance
- `linear-implementation-planner` turns that into execution structure
- `executing-plans` is used once the plan is good enough to follow

Do not use this skill when the issue is still structurally weak or when the
real question is only multi-issue dependency orchestration.

## Verification

A plan created with this skill is acceptable if:

- dependencies are explicit
- the first actionable batch is clear
- verification exists for each major phase
- the sequence matches the real risk of the task
