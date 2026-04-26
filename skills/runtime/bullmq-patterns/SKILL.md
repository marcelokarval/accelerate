---
name: bullmq-patterns
description: Optional BullMQ guidance for Redis-backed jobs, queues, workers, retries, idempotency, concurrency, and operational proof.
user-invocable: true
related-skills: security-patterns, anti-abuse-review, product-runtime-review
---

# bullmq-patterns

Use when a project chooses BullMQ for queue and worker execution.

## Proof Checklist

- queue name, payload contract, and worker ownership
- Redis connection/secrets posture
- idempotency and dedupe strategy
- retry, backoff, concurrency, and dead-letter/failure handling
- worker boot and job execution proof
- replay and abuse controls for user-triggered jobs
