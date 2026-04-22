---
name: architecture
description: Use when software work requires architectural judgment about structure, ownership, trade-offs, boundaries, migration, or ADR-worthy decisions rather than direct implementation only.
metadata:
  category: review
  origin: accelerate-native
---

# Architecture

Use this skill when the task requires architectural judgment rather than only
implementation.

## When to Use

- selecting patterns or structure
- evaluating trade-offs
- deciding where code should live
- resolving ambiguous ownership between layers
- documenting or validating an architectural direction

## Core Principle

Requirements drive architecture. Trade-offs justify decisions. Simpler valid
solutions win by default.

This skill decides. It does not define the constitution and it does not act as
the audit layer that checks adherence after the fact.

## Workflow

### 1. Discover Context

Clarify:

- business goal
- affected layers
- operational constraints
- migration or compatibility constraints
- what is already established in project docs

### 2. Identify Decision Surface

Ask what is actually being decided:

- architecture pattern
- file ownership
- routing model
- service boundary
- data flow
- UI composition
- rollout strategy

### 3. Evaluate Trade-Offs

At minimum, compare:

- simplest viable option
- current/project-native option
- more flexible but costlier option

Evaluate:

- complexity
- maintainability
- consistency with project rules
- migration cost
- verification burden

### 4. Record the Decision

For any non-trivial decision, capture:

- context
- decision
- rationale
- trade-offs
- consequences

Use project docs under `docs/architecture/` whenever the decision deserves a
stable record.

## Accelerate Biases

Prefer decisions that preserve:

- clear ownership boundaries
- stack-profile adherence
- simple valid architecture before flexible complexity
- explicit security boundaries
- low surprise for future contributors

## Do Not Use This Skill To

- justify avoidable complexity
- skip project conventions
- invent new architecture when a documented pattern already exists

## Recommended Dependencies

- `system-adr`
- stack skills relevant to the affected layer

## Boundary Against Adjacent Skills

- `system-adr`
  - constrains the allowed solution space with stable invariants
- active stack constitution or profile
  - defines official stack posture for the current project
- `governance-audit`
  - audits whether a subtree still adheres to those rules

## Verification

Before finalizing an architectural decision:

- confirm the real problem is architectural
- confirm simpler alternatives were considered
- confirm the chosen approach aligns with project conventions
- confirm consequences are explicit
