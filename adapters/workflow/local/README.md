# Local Workflow Adapter

## Purpose

The local workflow adapter is the first live workflow backend for Accelerate.

It stores workflow truth inside the governed target repository under:

- `.accelerate/workflow/`

This is not a fake Linear or GitHub adapter. It is an explicit substitute model
that gives Accelerate stable local work-item identity until a remote backend is
selected and implemented.

## Complete-Goal Role

The local adapter is Phase 1 of the progressive live workflow adapter path:

1. local work-item identity
2. review and closure attachment
3. local topology
4. shared adapter contract stabilization
5. Linear adapter
6. GitHub PR adapter
7. GitHub Issues/Projects adapter

## Supported In Phase 1

- local adapter initialization
- stable local work-item ID
- human-readable local locator
- active work-item pointer
- append-only work-item ledger
- append-only workflow event log
- lifecycle transitions
- metadata rehydration by rendering active work-item state

## Capability Manifest

The local adapter capability manifest lives at:

- `capabilities.yaml`

It declares all supported capabilities as `substitute` because the backend is
the local `.accelerate/workflow/` filesystem model rather than a remote API.

## Deferred

- defect/correction attachment
- remote API calls
- remote assignment/project fields

## Lifecycle States

Allowed local lifecycle states:

- `planned`
- `ready`
- `in_progress`
- `review`
- `closure`
- `done`
- `blocked`
- `cancelled`

## Commands

Use from the Accelerate repository against a governed target repository:

- `onboarding/local-workspace/init-local-workflow.sh /path/to/repo`
- `onboarding/local-workspace/create-local-work-item.sh /path/to/repo <slug> <title>`
- `onboarding/local-workspace/transition-local-work-item.sh /path/to/repo <state> [summary]`
- `onboarding/local-workspace/render-local-work-item.sh /path/to/repo`

## Closure Boundary

This adapter provides workflow identity. It does not replace proof gates,
readiness reconciliation, browser proof, AI review, or final forensic closure.
