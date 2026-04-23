# Review Readiness Gate

## Purpose

This gate defines when a run may honestly claim it is approaching review or
closure rather than merely accumulating implementation or proof fragments.

## Rule

Do not claim review readiness only because code changed or one proof lane ran.

Review readiness requires a visible synthesized answer to:

- what still blocks review?
- which gate is next?
- whether the active branch is still execution-facing or already review-facing

## Minimum Evidence

When local workspace state exists, review readiness should rely on:

- `.accelerate/status/readiness-dashboard.yaml`
- current governing artifact in `planning/current-plan.md`
- proof-lane evidence already gathered
- explicit remaining blockers

## Failure Conditions

Treat the gate as failed when:

- review is claimed without a readiness dashboard state
- the dashboard still says `blocked`
- proof exists but no one updated the readiness state
- the run presents evidence with no honest next gate
