# Timeline Continuity Gate

## Purpose

This gate prevents multi-step or multi-session work from losing continuity
between onboarding, planning, execution, proof, and closure.

## Rule

When a run is no longer a pure one-shot slice, it must leave a visible
checkpoint trail.

The point is not session logging. The point is preserving:

- the last meaningful transition
- the current checkpoint
- the next expected checkpoint

## Minimum Evidence

When local workspace state exists, continuity should rely on:

- `.accelerate/status/timeline.jsonl`
- readiness dashboard phase
- the active governing artifact

## Failure Conditions

Treat the gate as failed when:

- long-running work has no checkpoint trail
- execution, proof, or closure claims cannot be placed on the timeline
- a rerun or reentry happened but the continuity trail stayed silent
