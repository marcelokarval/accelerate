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
