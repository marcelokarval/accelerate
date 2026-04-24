---
name: executing-plans
description: Codex-native execution skill for following a written implementation plan in bounded batches with review checkpoints and verification discipline.
metadata:
  category: orchestration
  origin: standalone-adapted-from-global
---

# Executing Plans

Use this skill when the plan already exists and the problem is no longer plan
quality, but disciplined execution.

## When to Use

- you have a written plan worth following
- the task is too large for one unstructured pass
- review checkpoints matter
- verification needs to happen batch by batch

## Core Principle

Execute in bounded batches. Do not treat a plan as a vague suggestion.

Each bounded batch must end with a micro-review checkpoint before the next
batch begins.

That checkpoint must be comparative and defect-aware, not only descriptive.

This skill executes a plan; it does not replace plan design, issue governance,
or multi-issue orchestration.

## Workflow

### 1. Read and Challenge the Plan

Before editing:

- read the plan fully once
- extract the full task list or bounded phases up front
- confirm it still matches the codebase reality
- identify gaps or contradictions

If the plan is wrong, refine the plan before execution.

### 2. Select a Batch

Default to a small bounded batch:

- first phase
- first 2-3 tasks
- smallest coherent slice

### 3. Execute

For each task in the batch:

- mark it active in your working notes if applicable
- implement only what belongs to the batch
- run the stated verification

### 4. Micro-Review Checkpoint

Before moving to the next batch:

- verify the batch result
- compare it against the plan and current code reality
- run a spec-compliance check first
- then run a broader quality/integration check
- leave a compact `requested-vs-implemented` comparison
- register any concrete defects found
- correct in-scope defects before promotion when honest to do so
- rerun proof after meaningful correction
- decide explicitly:
  - continue
  - re-plan
  - stop

Use a compact checkpoint packet with at least:

- intended scope
- files touched
- requested-vs-implemented judgment
- validation run
- spec gaps
- defects found and disposition
- quality concerns
- continue / re-plan / stop decision

Do not let execution turn into a single unbroken pass.
Do not let the checkpoint degrade into a work recap with no comparative or
defect posture.

### 5. Report

At the end of the batch:

- summarize what changed
- summarize what was verified
- summarize which defects were corrected, deferred, or disproven
- identify blockers or uncertainties before continuing

### 6. Final Integration Review

After all planned batches land, run one final integration review across the
combined result before closure.

### 7. Continue or Re-plan

Continue only if:

- the batch succeeded
- verification is acceptable
- the next batch still makes sense

Otherwise:

- update the plan
- or stop and ask for clarification when needed

## Stop Conditions

Stop execution when:

- the plan conflicts with code reality
- a blocker prevents safe progress
- verification repeatedly fails
- a hidden architectural dependency changes the sequencing

## Relationship to Other Skills

- `accelerate` should already have chosen plan execution as the right branch
- `planning-with-files` helps keep the execution state durable
- the active workflow planning skill builds the plan
- `executing-plans` follows the plan safely

Do not use this skill when the sequencing is still unknown or when the main
problem is workflow issue hygiene rather than execution discipline.

## Verification

This skill is being used correctly if:

- work is happening in bounded batches
- verification is run as you go
- each batch passes through a real micro-review checkpoint
- each checkpoint leaves requested-vs-implemented plus defect disposition
- blockers are surfaced early
- the plan remains the source of sequencing, not guesswork
