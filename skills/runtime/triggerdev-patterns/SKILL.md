---
name: triggerdev-patterns
description: Optional Trigger.dev guidance for background jobs, schedules, tasks, retries, idempotency, and operational proof.
user-invocable: true
related-skills: security-patterns, anti-abuse-review, product-runtime-review
---

# triggerdev-patterns

Use when a project chooses Trigger.dev for background tasks or scheduled work.

## Proof Checklist

- task trigger and schedule source
- idempotency and duplicate-trigger handling
- retry, timeout, and concurrency posture
- secret/environment boundary proof
- failure visibility and replay proof
- user-visible state proof when tasks affect UX

## Operational Closure

- local/dev execution path or explicit blocked reason
- deploy topology, task ownership, and environment secrets
- trigger source, schedule ownership, and replay/disable posture
- poison-run disposition after retry exhaustion
- observability: run IDs, logs, metrics, dashboard link, or manual packet
- fake/test strategy for deterministic regression proof
