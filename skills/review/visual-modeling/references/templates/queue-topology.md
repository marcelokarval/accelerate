# Queue / Retry / DLQ Topology Template

Use for background jobs, async work, retries, dead-letter queues, schedules, and
idempotency surfaces.

## Must Include

- producer
- queue/broker
- worker/consumer
- retry policy
- DLQ/failure path
- idempotency/audit point

## Template

```text
Producer
  │ enqueue job [1]
  ▼
╔══════════════╗     lease/pop      ╔══════════════╗
║ Queue/Broker ║━━━━━━━━━━━━━━━━━━→ ║ Worker       ║
╚══════╦═══════╝                    ╚══════╦═══════╝
       │ retry n                           │ success
       │                                   ▼
       │                            DB/audit write
       ▼
╔══════════════╗
║ DLQ / failed ║
╚══════════════╝
```

## Callouts

- [1] Include idempotency key or dedupe strategy when duplicate execution matters.

## Common Mistakes

- no failure path
- no retry limit
- no idempotency/audit point
