# Observability And Performance Packet

## Purpose

This packet records observability, performance, query-shape, and N+1 proof in a
way that is stronger than a generic performance claim.

Concrete profilers, log commands, APM tooling, and SQL commands belong in stack
profiles or runtime adapters. This packet defines the proof shape.

## When Required

Use this packet when a branch includes:

- observability or logging changes
- performance claims or regressions
- N+1/query-shape risk
- cache behavior or invalidation truth
- slow route, slow job, slow build, or slow browser interaction analysis
- provider/webhook/background-job runtime visibility

## Packet Template

```md
# Observability And Performance Packet

## Scope

- branch/slice:
- surface:
- user/runtime impact:

## Baseline

- baseline evidence:
- sample size or route/job coverage:
- known noise or environment caveats:

## Metrics

- metric names:
- before:
- after:
- threshold or target:

## Logs And Events

- logs/events inspected:
- correlation IDs or request/job IDs when applicable:
- missing instrumentation:

## Query Shape

- query count evidence:
- N+1 risk:
- execution-plan evidence when relevant:
- indexes or constraints involved:

## Runtime Trace

- route/job/action path:
- timing breakdown:
- external provider or network dependency:

## Result

- improvement, regression, or no material change:
- residual risks:
- follow-up required:
```

## Blocking Conditions

Do not close observability/performance work when:

- the claim has no baseline or no post-change evidence
- the proof omits the surface actually affected by the change
- query-count or execution-plan claims lack evidence
- a cache or invalidation change lacks truth ownership
- logs prove only that code ran, not that the observability gap closed

## Closure Rule

Closure should state:

- `Observability/Performance=<present|missing|blocked|not-applicable>`
- `blocking performance gap=<gap or none>`

When no measurable change is expected, the packet should say that explicitly and
name the proof used to avoid accidental performance claims.
