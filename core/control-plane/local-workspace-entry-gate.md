# Local Workspace Entry Gate

## Purpose

This document defines how `accelerate` must treat a governed target
repository's local `.accelerate/` workspace before branch-specific execution
continues.

It exists to stop project-local state from being treated as optional ambient
context.

## Core Rule

When the run is acting on a governed target repository rather than only
studying the standalone `accelerate` product repo itself, the root must decide
local workspace entry state before deeper branch routing continues.

That means deciding one of these states explicitly:

- no local workspace required yet
- first local install required
- existing local workspace can be reused
- light reentry required
- partial reonboarding required
- structural reonboarding required

Do not leave that decision implicit.

## Gate Ordering

For governed target repositories:

1. detect whether `.accelerate/` exists
2. if absent, decide whether first local install is required now
3. if present, read:
   - `.accelerate/state.yaml`
   - `.accelerate/status/readiness-dashboard.yaml`
   - `.accelerate/onboarding/status.yaml`
   - `.accelerate/onboarding/decisions.yaml`
   - `.accelerate/planning/current-plan.md`
   - `.accelerate/agents/status.yaml`
4. decide whether reentry or reonboarding is required
5. only then continue to branch-specific gating

This gate comes before:

- issue bootstrap
- post-issue planning
- proof-lane selection

because those downstream decisions may depend on persisted local truth.

It also fails when readiness, timeline, or learnings state exists locally but
is ignored during branch routing or closure judgment.

## Satisfied States

### `no local workspace required yet`

Allowed only when all are true:

- the run is read-only or orientation-only
- no governed mutation in the target repo is starting
- no persisted onboarding, planning, or local-agent state is needed to remain
  honest

### `first local install required`

Use when:

- the target repo has no `.accelerate/`
- and the run is non-trivial or mutation-bearing
- or the user explicitly asks to bootstrap `accelerate` locally

The minimum implementation path is:

- `onboarding/local-workspace/emit-v2.sh`
- deterministic signal detection
- initial classification
- validation

### `existing local workspace can be reused`

Use when:

- `.accelerate/` exists
- summary and detailed authorities are coherent enough
- no meaningful repo-shape drift requires reentry

### `light reentry required`

Use when:

- `.accelerate/` exists
- prior decisions remain materially valid
- but the root should refresh observed signals and summary state

### `partial reonboarding required`

Use when:

- docs posture or adjacent local posture changed materially
- but workflow, profile, and runtime assumptions remain mostly intact

### `structural reonboarding required`

Use when:

- stack profile changed materially
- workflow backend posture changed materially
- runtime posture changed materially
- current onboarding assumptions no longer provide honest continuity

## Failure Conditions

Treat the gate as failed when:

- a governed target repo is mutated with no `.accelerate/` even though local
  install was required
- `.accelerate/` exists but the run ignores it during branch selection
- `state.yaml` is trusted over more specific authority after visible drift
- reentry is needed but the run proceeds as if local state were fresh

## Current Pre-Agents Implementation Surface

The current implementation surface is:

- `onboarding/local-workspace/emit-v2.sh`
- `onboarding/local-workspace/detect-signals.sh`
- `onboarding/local-workspace/classify-project.sh`
- `onboarding/local-workspace/bootstrap-or-reentry.sh`
- `onboarding/local-workspace/validate-v2.sh`

## Runtime Visibility

When this gate matters, the runtime packet should expose:

- local workspace status: `absent|present`
- local workspace action: `none|required-init|required-reentry|required-reonboarding|reused`
- onboarding status
- reentry status
- local readiness status when a dashboard exists
- local timeline continuity when a timeline exists
- local durable learning backlog or registration posture when learnings exist
- active local profile
- active local workflow backend
- workspace drift status

Do not say only that onboarding exists. Say whether it is actively governing
this run.
