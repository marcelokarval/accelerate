---
name: react-best-practices
description: Codex-native React quality and performance guidance focused on readable rendering, pragmatic optimization, and project-aligned modern patterns.
user-invocable: true
related-skills: front-react-shadcn, typescript-pro, frontend-component-hierarchy
---

# react-best-practices

Use this skill for React code quality, rendering discipline, and pragmatic
performance choices.

## Purpose

Provide a React quality lens that is grounded in the real application rather
than generic optimization cargo culting.

This skill supports `Frontend Structure Correctness` when structural drift
shows up as oversized components, weak rendering boundaries, or avoidable local
complexity.

## Load When

Load this skill when the task touches:

- component performance
- rendering behavior
- state management choices
- expensive lists or interaction-heavy views
- any frontend review where `Frontend Structure Correctness` overlaps with
  rendering or component-boundary concerns

## Core Rules

1. Prefer clear rendering and state flow before optimization tricks.
2. Optimize when there is a real rendering, bundle, or interaction reason.
3. Avoid unnecessary memoization and hook complexity by default.
4. Respect the team's modern React guidance already encoded in project
   instructions.

## Accelerate Guidance

- In React stack profiles, this skill complements the active frontend stack
  skill and `typescript-pro`.
- Use the repo's React guidance before importing generic framework folklore.

## Review Checklist

- Is there an actual performance problem?
- Is the proposed pattern clearer and safer?
- Does the change fit the app's current React direction?
