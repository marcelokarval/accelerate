---
name: redis-patterns
description: Redis runtime guidance for cache, locks, sessions, pub/sub, rate limits, queue adjacency, invalidation, TTLs, stampede control, secrets, and operational proof.
user-invocable: true
related-skills: bullmq-patterns, security-patterns
---

# redis-patterns

Use this skill when Redis is used beyond being an invisible dependency.

## Core Rules

1. Name the Redis role: cache, lock, session, rate limit, pub/sub, queue backing,
   or ephemeral coordination.
2. Define key ownership, namespace, TTL, invalidation trigger, and serialization
   format before implementation.
3. Do not cache secrets, raw credentials, private tokens, or authorization
   decisions without explicit security review.
4. For locks, prove timeout, renewal, release, owner token, and failure recovery.
5. For cache, prove stale data posture, stampede control, and user-visible
   revalidation behavior.
6. For sessions/rate limits, prove privacy, tenancy, and abuse boundaries.
7. Closure needs runtime proof or an explicit blocked/manual proof packet.

## Proof Packet

- Redis role: <cache|lock|session|rate-limit|pubsub|queue-adjacent>
- key namespace / owner: <...>
- TTL / eviction posture: <...>
- invalidation / refresh trigger: <...>
- serialization / privacy posture: <...>
- concurrency / stampede posture: <...>
- runtime proof: <command/log/test/manual packet>
- residual risk: <...>
