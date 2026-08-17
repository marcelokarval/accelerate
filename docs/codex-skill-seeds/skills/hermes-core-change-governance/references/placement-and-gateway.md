# Placement and gateway reference

## Decision matrix

| Behavior | Owner | Reject |
| --- | --- | --- |
| Profile/chat/topic/display/route policy | `config.yaml` | hardcoded chat-ID branch |
| Local or niche capability | plugin | permanent core tool |
| Request rewrite or execution wrapper | plugin middleware | plugin special case in core |
| Lifecycle observation | hook | log scraping as control flow |
| New messaging protocol | platform adapter | rework all platforms |
| Shared platform-independent invariant | gateway/core module | duplicated adapter logic |
| Session persistence/backend | SessionDB factory + adapter | direct SQLite in governed request |

## Gateway boundary proof

Identify the active runner, profile, service, configuration, and loaded Python
checkout. Trace the event through adapter normalization, authorization,
profile/route resolution, canonical session-key construction, queue/running
guards, slash dispatch, agent/tool execution, and outbound delivery. Change the
owner of the first divergent boundary and test adjacent boundaries.

Stable ownership map:

- `gateway/run.py`: runner, dispatch, slash commands, cross-platform flow;
- `gateway/session.py`: session identity/lifecycle orchestration;
- `gateway/delivery.py`: outbound delivery;
- `gateway/platforms/base.py`: shared adapter contract;
- `plugins/platforms/<name>/`: platform-specific adapters;
- hooks: lifecycle observation;
- plugin middleware: request shaping and execution wrapping.

For a gateway change, prove inbound replies/topics, auth and profile route,
PostgreSQL session lookup, queue behavior, execution, safe egress, restart
recovery, duplicate handling, and idempotency. Mocks alone do not prove config
propagation or runtime parity. Do not manually construct session keys.

If no generic extension point expresses a broadly useful behavior, write a
focused core proposal with invariant, compatibility impact, tests,
migration/rollback, and upstream boundary. Do not hide it in a plugin that
depends on private core internals.

Closure evidence includes source/runtime commits, redacted effective config,
backend identity/readiness, focused and affected receipts, canary/restart
evidence when authorized, and the issue disposition.
