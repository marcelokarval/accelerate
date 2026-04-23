# V2 Drift Reconciliation

## Purpose

This document defines how to reconcile drift inside an emitted `.accelerate/`
workspace when summary and detailed authorities diverge.

## Precedence

When files disagree, use this order:

1. `.accelerate/state.yaml` as summary index
2. `.accelerate/onboarding/status.yaml` for onboarding and reentry truth
3. `.accelerate/onboarding/decisions.yaml` for onboarding decision truth
4. `.accelerate/planning/current-plan.md` for governing execution truth
5. `.accelerate/agents/status.yaml` for local pre-agents posture

## Reconciliation Rules

### Summary drift

If `state.yaml` disagrees with a detailed authority, prefer the detailed file
for the domain truth and update `state.yaml` to mirror it.

Examples:

- `state.yaml` says `completed`, but `onboarding/status.yaml` says
  `in_progress`
- `state.yaml` points to a stale plan path
- `state.yaml` says `agent_mode: root-only`, but `agents/status.yaml`
  says `agent-eligible`

### Planning drift

If `current-plan.md`, the active planning artifacts, and `history/` imply
contradictory execution states:

1. prefer the currently active execution artifact
2. preserve evidence of supersession or incomplete closure
3. do not rewrite history to make it appear cleaner than it is

Examples:

- `current-plan.md` says `task-breakdown.md` governs, but `executive-plan.md`
  still says task decomposition is pending
- `current-plan.md` says PRD-lite is not required, but `prd-lite.md` contains
  active scope decisions
- a superseded `sdd.md` was archived, but `current-plan.md` still points to it

### Discovery vs decisions drift

If `decisions.yaml` contains a decision that discovery does not support:

1. prefer explicit user direction when present
2. otherwise treat the decision as suspect
3. either correct the decision or record the ambiguity explicitly

## Correction Rule

Drift correction should be conservative:

- fix summary mirrors eagerly
- fix domain truths only with evidence
- preserve explicit ambiguity rather than silently normalizing weak inference

The first native enforcement entrypoint for this policy is:

- `validate-v2.sh`
