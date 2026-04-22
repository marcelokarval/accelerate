---
name: governance-audit
description: Use when the task is not implementing a feature but auditing stack adherence, dependency posture, legacy drift, transport choice, validation boundaries, or repo-wide architectural consistency against the active stack constitution.
---

# governance-audit

Use this skill when the main job is to audit whether the codebase or a subtree
still matches the active project or Accelerate stack posture.

## Read First

Read the strongest available local authority in this order:

- active project `AGENTS.md`
- active stack profile or constitution
- dependency governance docs
- API / transport governance docs
- validation governance docs
- legacy or migration policy docs when legacy adaptation is in scope

## Purpose

Turn stack review into an explicit workflow rather than an informal side effect
of implementation review.

This skill audits adherence. It does not define the stack constitution and it
does not replace architectural decision-making.

## Audit Targets

- stack adherence
- transport/surface misuse
- validation-boundary drift
- legacy adaptation drift
- banned-for-new-code dependency reinforcement
- unresolved technology creep
- codepaths that reintroduce parallel architectures

## Required Output

Produce a report with at least:

1. scope audited
2. constitutional expectations
3. findings by category
4. technology classification findings
5. residual ambiguity
6. recommended follow-ups

## Technology Classification Model

Classify findings using the official labels:

- official
- allowed-exception
- future-approved
- unresolved
- legacy-reference
- deprecating
- banned-for-new-code

## Review Questions

- Does the subtree reinforce the official current stack?
- Does it normalize exceptions into defaults?
- Does it reintroduce banned or unresolved technology without decision?
- Does it copy legacy shape instead of adapting legacy behavior?

## Boundary Against Adjacent Skills

- active stack constitution or profile
  - defines the official stack truth for the current project
- `architecture`
  - decides among valid options inside the allowed space
- `system-adr`
  - constrains the solution space with stable project invariants
