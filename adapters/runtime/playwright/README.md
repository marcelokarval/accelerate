# Playwright Adapter

## Purpose

This adapter documents the persistent regression proof layer.

## Role

This adapter owns:

- persistence posture
- scenario mapping
- rerun proof expectations
- failure handling

## Ordering Rule

Playwright is not the first browser truth tool.

Use this adapter only after the runtime path has already been understood through
Chrome DevTools or another explicit browser-truth lane. If a runtime-sensitive
flow jumps directly to Playwright, classify the proof as:

- `browser truth -> Playwright inversion`

That inversion blocks closure until interactive browser truth is captured.

## Scenario Fixture

Every persistent scenario should be derived from:

- `scenario-fixture-template.md`

The fixture records:

- source browser-truth evidence
- exact user path
- assertions worth preserving
- setup and teardown assumptions
- rerun command
- residual gaps

## Scenario Quality

Persistent scenarios should prefer:

- user-facing locators and accessible names
- stable app-owned selectors when accessible locators are insufficient
- explicit fixture setup and teardown
- explicit auth/session state ownership
- minimal assertions that protect real behavior instead of DOM trivia
- network, trace, video, or screenshot artifacts when failures are
  runtime-sensitive

Do not hide auth state, seed data, or provider mocks behind unexplained global
setup. If global setup is used, the scenario fixture must point to it.

## Proof Packet

Every Playwright rerun used for closure should leave a packet using:

- `proof-packet-template.md`

Do not replace this with a generic "Playwright passed" sentence.

## Minimal Scenario Classes

Use these classes before adding project-specific labels:

| Class | Use |
| --- | --- |
| `smoke` | proves the critical path still loads and completes |
| `regression` | protects a previously observed bug or drift |
| `persistence` | protects session, layout, navigation, or state continuity |
| `route-family` | proves a family of related routes after browser truth is stable |

## Closure Standard

For closure-relevant runtime work, the Playwright packet must state:

- `Browser-Proof source=<file/link/packet>`
- `Scenario class=<smoke|regression|persistence|route-family>`
- `Command=<exact command>`
- `Result=<passed|failed|blocked>`
- `Residual gaps=<none|list>`

If the source browser-proof packet is missing, mark the Playwright lane
`out of order`.

## Flake Triage

When a Playwright scenario fails intermittently, classify the failure before
closure:

- product bug
- selector fragility
- fixture/data race
- auth/session setup drift
- provider/network instability
- infrastructure timeout

Do not rerun until green and call that proof. Record the rerun count and the
classification in the proof packet.
