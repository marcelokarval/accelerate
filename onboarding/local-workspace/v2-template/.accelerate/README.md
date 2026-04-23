# `.accelerate`

## What This Is

This directory is the local workspace of `accelerate` inside this repository.

It persists onboarding truth, active planning truth, and local pre-agents
governance so a fresh session can continue without reconstructing context from
conversation alone.

## Canonical Files

The main canonical files here are:

- `state.yaml`
- `onboarding/status.yaml`
- `onboarding/decisions.yaml`
- `planning/current-plan.md`
- `planning/user-story.md`
- `planning/prd-lite.md`
- `planning/sdd.md`
- `planning/executive-plan.md`
- `planning/task-breakdown.md`
- `agents/status.yaml`

## Summary vs Detailed Authority

- `state.yaml` is the fast global summary index
- `onboarding/status.yaml` is detailed onboarding and reentry authority
- `onboarding/decisions.yaml` is detailed onboarding decision authority
- `planning/current-plan.md` is the active local planning index and governing artifact pointer
- `planning/user-story.md`, `planning/prd-lite.md`, `planning/sdd.md`, `planning/executive-plan.md`, and `planning/task-breakdown.md` are the local artifact ladder
- `agents/status.yaml` is detailed local pre-agents posture authority

## What Accelerate May Rewrite

`accelerate` may rewrite summary and planning state here when:

- onboarding is real
- discovery is factual
- planning artifacts have been created
- local agent posture is clearly inferable

## Fresh Session Reading Order

For a fresh session, read in this order:

1. `state.yaml`
2. `onboarding/status.yaml`
3. `onboarding/decisions.yaml`
4. `planning/current-plan.md`
5. `planning/user-story.md`
6. `planning/prd-lite.md`
7. `planning/sdd.md`
8. `planning/executive-plan.md`
9. `planning/task-breakdown.md`
10. `planning/open-questions.md`
11. `agents/status.yaml`

## Non-Goals

This directory must not become:

- a duplicate of repo `AGENTS.md`
- a duplicate of standalone `accelerate` doctrine
- a raw session log
- a place for secrets or runtime noise
- a place for cache, tmp files, browser traces, or throwaway artifacts
