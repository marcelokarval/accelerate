# Redis Rate-Limit Backend — OmniRoute 3.8.50

## Two Separate Limiters

Do not conflate these runtime paths:

1. `src/shared/utils/rateLimiter.ts` — per-API-key policy counters. `REDIS_URL` selects Redis; without it OmniRoute logs a production warning and uses an in-process Map.
2. `open-sse/services/rateLimitManager.ts` — Bottleneck concurrency manager for provider connections such as `agy`. Its enabled Set is process-local in 3.8.50. A persisted connection flag `rateLimitProtection=true` does not make `enabled=true` survive service restart.

Redis solves durable API-key counters and can support other Redis-aware resilience components. It does not by itself persist the Bottleneck enabled Set.

## Governed Environment Projection

The user-level OmniRoute service should receive only the variables it needs:

```ini
EnvironmentFile=/home/marcelo-karval/.hermes/runtime/omniroute.env
```

The projection file `~/.hermes/runtime/omniroute.env`:

```text
mode=0600
REDIS_URL=redis://:<redacted>@127.0.0.1:6379/0
REDIS_KEY_PREFIX=omniroute:
```

Keep the broader `~/.hermes/.env` at mode `0600`; never attach that full file to the OmniRoute service. Never print, log, or persist the connection string in reports.

## Acceptance Proof

For a non-destructive proof:

1. create a temporary OmniRoute API key;
2. assign a small custom `rateLimits` rule;
3. send an invalid-model Chat Completions request so policy runs but no upstream paid request occurs;
4. inspect Redis for the canary API-key counter and require value `1`;
5. restart only `omniroute.service`;
6. repeat the same request and require the same counter to become `2`;
7. delete the temporary API key and its Redis canary keys;
8. confirm recent logs contain no fresh `REDIS_URL is not set` or `Using in-memory rate limiting` warning.

A `/v1/models` request is not sufficient because it does not traverse the inference rate-limit policy.

## `agy` Readback

After every OmniRoute restart:

```text
GET /api/rate-limits
```

If the governed `agy` connection has stored `rateLimitProtection=true` but runtime `enabled=false`, activate it through:

```text
POST /api/rate-limits
{"connectionId":"<governed-id>","enabled":true}
```

Then require same-session readback `enabled=true`, `queued=0`, and `running=0` before a real canary. Do not claim Redis fixed this separate lifecycle gap and do not hide it behind an unreviewed daemon.

## Redis Recovery Boundary

If the shared Redis Swarm service is down due to AOF corruption, use the production runtime procedure in `production-runtime-operations/references/local-redis-aof-repair.md`: scale to zero, back up the full volume, run `redis-check-aof` with the exact service image, repair only after a valid backup, restore one replica, authenticate, and prove restart persistence. Do not delete the volume or start a competing Redis on the same port.
