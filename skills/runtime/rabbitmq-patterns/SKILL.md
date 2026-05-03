---
name: rabbitmq-patterns
description: RabbitMQ and AMQP runtime guidance for broker topology, queues, exchanges, routing keys, acknowledgements, prefetch, retries, dead letters, workers, secrets, and operational proof.
user-invocable: true
related-skills: celery-tasks, security-patterns
---

# rabbitmq-patterns

Use this skill when RabbitMQ or AMQP is the broker for jobs, events, or service
messaging.

## Core Rules

1. Name broker topology: exchanges, queues, routing keys, durability, and
   bindings.
2. Define ack/nack behavior, prefetch, worker concurrency, retry policy, and dead
   letter handling.
3. Make idempotency keys explicit before replayable jobs or event handlers ship.
4. Separate broker credentials, vhosts, and environment-specific connection
   posture from application code.
5. Prove worker boot, queue declaration, poison-message behavior, and monitoring
   visibility before closure.
6. For Celery, pair this with `celery-tasks` and record broker/result backend
   decisions.

## Proof Packet

- topology: <exchange/queue/routing key>
- durability / persistence: <...>
- ack / prefetch / concurrency: <...>
- retry / DLQ: <...>
- idempotency: <...>
- worker boot proof: <command/log/test/manual packet>
- monitoring / alerting: <...>
- residual risk: <...>
