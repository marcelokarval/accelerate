---
name: inngest-patterns
description: Optional Inngest guidance for jobs and event-driven workflows, covering idempotency, retries, concurrency, triggers, observability, and replay safety.
user-invocable: true
related-skills: security-patterns, anti-abuse-review, product-runtime-review
---

# inngest-patterns

Use when a project chooses Inngest for background jobs or event workflows.

## Proof Checklist

- event source and payload contract
- idempotency key or dedupe strategy
- retry, timeout, and concurrency posture
- auth/ownership proof for user-triggered jobs
- failure visibility and replay safety
- user-visible state or notification proof when applicable

## Operational Closure

- local/dev execution path or explicit blocked reason
- deploy topology, function ownership, and environment secrets
- trigger source, schedule ownership, and replay/disable posture
- poison-event disposition after retry exhaustion
- observability: run IDs, logs, metrics, dashboard link, or manual packet
- fake/test strategy for deterministic regression proof
