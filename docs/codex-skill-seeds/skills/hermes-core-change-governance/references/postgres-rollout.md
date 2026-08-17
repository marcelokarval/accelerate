# PostgreSQL backend and rollout reference

The upstream Hermes documentation describes SQLite/WAL as its default session
store. The Karval fork overrides that for governed operational state:
PostgreSQL 18 is authoritative for session CRUD, messages, search, manifests,
replay, runs, and provenance. SQLite is explicit compatibility,
import/export, or forensics only. Unavailable PostgreSQL/schema/readiness must
fail closed; it must not activate SQLite.

## Selection and bootstrap

Select the backend before Hermes starts. The direct PostgreSQL URL takes
precedence over host/database components. Credentials stay in the secret
environment; behavioral settings stay in configuration/service definitions.
Run the idempotent state migration/bootstrap before the long-running gateway;
do not bootstrap schema lazily inside a governed request.

Operational stores are profile-scoped. Every request/query carries explicit
`profile_id`; caches are keyed by backend/database/profile, never bare session
ID. Startup owns pool, schema/constraint, manifest, and health readiness.

## SQLite import and cutover

1. Freeze and back up the SQLite source.
2. Bootstrap a temporary PostgreSQL target.
3. Import with an explicit message-ID policy.
4. Reconcile sessions/messages, parent-child lineage, titles, search,
   manifests, metadata, and sidecars.
5. Run sync/async parity and PostgreSQL 18 concurrency tests.
6. Canary one profile and observe readiness, errors, latency, duplicates, and
   delivery.
7. Cut over only after the canary receipt is accepted.

Do not delete SQLite or perform destructive DDL during first cutover. Rollback
disables new governed creates/turns or routes traffic away; it does not delete
schema/data, disable ACL/namespace controls, or silently restore SQLite as
authority.

## Sync/async contract

`PostgresSessionDB` is the synchronous compatibility surface. Event-loop paths
use `AsyncPostgresSessionDB`; no blocking synchronous SQL or SQLite in the
request loop. Prove method coverage, return shape, transactions, concurrency,
errors, and live PostgreSQL execution. Partial async rollout must be called
partial, not “complete parity”.

Minimum evidence: selector and redacted DB identity, schema/PG major version,
import reconciliation, sync/async contract tests, readiness failure,
rollback rehearsal, and gateway canary/restart when promoted.

Official references: [Gateway Internals](https://hermes-agent.nousresearch.com/docs/developer-guide/gateway-internals) and [Session Storage](https://hermes-agent.nousresearch.com/docs/developer-guide/session-storage). Fork references: `docs/postgres-state-backend.md`, `docs/postgres-async-state-backend.md`, and `docs/adr/karval-shared-postgres-profile-state.md`.
