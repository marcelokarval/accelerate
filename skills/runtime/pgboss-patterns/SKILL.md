---
name: pgboss-patterns
description: Optional pg-boss guidance for Postgres-backed jobs, transactional enqueue, retries, idempotency, and operational proof.
user-invocable: true
related-skills: postgresql, postgres-best-practices, security-patterns, anti-abuse-review
---

# pgboss-patterns

Use when a project chooses pg-boss for Postgres-backed jobs.

## Proof Checklist

- queue/job table ownership and migration proof
- transactional enqueue posture
- idempotency and dedupe strategy
- retry, timeout, and dead-letter handling
- worker execution and connection proof
- query/index posture for job tables

## Operational Closure

- local/dev execution path or explicit blocked reason
- Postgres ownership, schema/table posture, and migration expectations
- schedule ownership, dedupe key, retry policy, and concurrency limits
- poison-job disposition after retry exhaustion
- observability: job IDs, logs, metrics/query evidence, or manual packet
- fake/test strategy for deterministic regression proof
