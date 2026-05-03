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

## Operational Closure

- local/dev execution path or explicit blocked reason
- endpoint ownership, signing secret posture, and delivery auth
- schedule ownership, dedupe key, and replay/disable posture
- poison-delivery disposition after retry exhaustion
- observability: message IDs, logs, metrics, dashboard link, or manual packet
- fake/test strategy for deterministic regression proof
