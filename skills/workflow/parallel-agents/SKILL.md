---
name: parallel-agents
description: Codex-native orchestration guidance for parallelizing independent analysis, reads, and validations without assuming hidden local agent runtime.
metadata:
  category: orchestration
  origin: standalone-adapted-from-global
---

# Parallel Agents

This skill is about parallel orchestration in Codex without pretending hidden
agent infrastructure exists.

## Core Rule

Parallelize independent work. Do not invent hidden agent infrastructure.

## When to Use

- multiple reads can happen independently
- issue analysis and file discovery can run in parallel
- validations can run concurrently
- you need several perspectives before synthesis

## Do Not Use For

- dependent edits that require sequencing
- pretending custom subagents exist
- splitting a simple task into artificial complexity

## Codex-Native Parallelism

In this environment, parallelism has two safe lanes:

### 1. Parallel discovery / validation

- parallel tool calls
- independent discovery batches
- concurrent validation of unrelated artifacts

### 2. Parallel implementation

Only use this lane when tasks are already plan-backed, governance-approved, and
separated cleanly by file scope and contract surface.

If slices touch the same files, contracts, or migration boundary, fall back to
serial execution or route through `subagent-governance`.

Examples:

- read several files at once
- fetch several issues at once
- inspect config, docs, and code in parallel

## Good Pattern

1. identify independent work items
2. give each branch fresh context for its slice
3. batch them in parallel
4. gather results
5. synthesize before any write decision

## Bad Pattern

- parallelize actual edits that need shared context
- fork analysis before you know the problem
- assume agent resumes or hidden state transfer exists

## Recommended Uses

### Comprehensive Review

Parallelize:

- architecture references
- security-sensitive files
- test coverage files

Then synthesize findings.

### Issue Triage

Parallelize:

- issue fetches
- file evidence gathering
- config and route inspection

Then decide scope and blockers.

## Relationship to Other Skills

- `accelerate` decides whether orchestration is needed
- `parallel-agents` defines how to parallelize safely
- `architecture` and `linear-pm` help synthesize the results

## Verification

Parallel orchestration is correct if:

- each branch of work was truly independent
- synthesis happened before decisions
- no racey or conflicting edits were introduced by fake parallelism
