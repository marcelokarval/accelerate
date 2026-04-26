---
name: qstash-patterns
description: Optional QStash guidance for HTTP-delivered jobs, schedules, signatures, retries, idempotency, and replay-safe handlers.
user-invocable: true
related-skills: security-patterns, anti-abuse-review, api-surface-governance
---

# qstash-patterns

Use when a project chooses QStash for delayed, scheduled, or queued HTTP jobs.

## Proof Checklist

- target endpoint and payload contract
- signature verification and replay protection
- idempotency key or dedupe strategy
- retry/backoff/failure handling
- auth/ownership proof for user-triggered jobs
- observability of delivered, failed, and replayed messages
