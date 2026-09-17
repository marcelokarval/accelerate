# D01 — Gauntlet durable state: SQLite ledger plus filesystem CAS

## Disposition

| Field | Value |
| --- | --- |
| Disposition ID | `CODEX-17/D01/2026-09-01-gauntlet-durable-state-v1` |
| Status | `proposed-for-root-acceptance` |
| Owner | core owner |
| Author | Codex delegated architecture worker (`/root/phase1_d01_durable_state`) |
| Date | 2026-09-01 |
| Governing proposal | `planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md` |
| Proposal SHA-256 | `79473c41e77c626a0c849d0ff385be7c140e7f66cfbf047e55ba5ccfe05cd067` |
| Affected phases | 1 and 5 |
| Required later receipt | ADR plus restore/CAS fixture digest; A03 at Phase 1, A05/A07 at Phase 5 |

This is an ADR/disposition only. It does not create a store or claim that any
fixture, validator, adapter, backup, promotion, or runtime capability exists.

## Context

The proposal makes the Gauntlet store canonical for active execution state and
requires revisioned, fenced CAS; stale writes reject and ambiguity becomes
`UNKNOWN` ([proposal §Field authority, lines 151-188](../2026-09-01-accelerate-portable-agent-fabric-openspec-design.md#field-authority-projection-and-conflict-resolution)). It also requires immutable content-addressed manifests, all-or-none correction/admission transactions, and fenced scheduler recovery ([§Content-addressed manifests](../2026-09-01-accelerate-portable-agent-fabric-openspec-design.md#content-addressed-execution-input-and-review-candidate-manifests); [§Candidate lineage](../2026-09-01-accelerate-portable-agent-fabric-openspec-design.md#candidate-and-root-run-lineage); [§Scheduler and fencing](../2026-09-01-accelerate-portable-agent-fabric-openspec-design.md#mission-scheduler-and-fencing)).

Existing `.accelerate/workflow/` is an explicit filesystem *substitute* for
local work-item identity and lifecycle, not a Gauntlet-state authority
([local adapter lines 5-45](../../../adapters/workflow/local/README.md)). It may
project/read back state but cannot become a writable peer.

## Alternatives

| Alternative | Assessment | Disposition |
| --- | --- | --- |
| Filesystem-only JSON plus event log | Portable and familiar, but cannot honestly give crash-safe, serializable, multi-record atomicity for state, lease, fence, counters, successor, and outbox across processes. Locks/renames would recreate a fragile transaction manager and invite split-brain projections. | Rejected for active canonical state; retained for immutable blobs and read-only exports. |
| SQLite metadata/event ledger plus filesystem CAS | One repository-local unit with ACID transactions, uniqueness/FKs, WAL recovery, portable backup, and immutable large payloads outside DB. Meets the Phase-1/5 shape without a service. | **Selected.** |
| External database plus object storage | Proper future multi-host/HA scaling, but adds deployment, credentials, network/availability, migration, and restore authority unnecessary to the first portable contract. | Deferred behind explicit escalation. |

## Selected Phase-1/Phase-5 contract

The unit is one governed-workspace root:

```text
<workspace>/.accelerate/gauntlet/
  state.sqlite3                 canonical mutable metadata and append-only ledger
  cas/sha256/aa/<digest>         immutable exact-byte objects
  exports/                       replaceable read-only projections
  backups/                       recovery material, never canonical state
```

`state.sqlite3` is the sole canonical owner of active state, legal
transitions, revision/fence values, idempotency decisions, mission counters,
receipts, CAS reachability, retention, and backup provenance. CAS holds
immutable bytes only. OpenSpec, workflow adapters, JSON/YAML renderings, and
exports are projections that carry source record/revision/digest and MUST NOT
be used as a write source or recovery fallback. The state root cannot be a
symlink or lie outside the governed workspace.

### Schema and invariants

Core owns transactional migrations and requires `foreign_keys=ON`, WAL,
`synchronous=FULL`, and a bounded busy timeout. Critical invariants belong in
schema/queries, not an unvalidated metadata blob.

| Family | Required invariant |
| --- | --- |
| `store_meta`, `migrations` | One format version; applied migration checksum; unknown/newer format fails closed; migration is atomic. |
| `records` | PK `record_id`, closed kind/state, `revision`, payload digest, actor/epoch, current token domain/fence, predecessor. Terminal records never reopen. |
| `event_log` | Monotonic event sequence; append-only; every accepted canonical mutation appends exactly one event in its transaction. |
| `leases`, `fences` | One current acquired lease per subject/domain; fence strictly increases; released/expired/revoked/superseded leases never authorize a write. |
| `idempotency_effects` | Unique `(token_domain,effect_idempotency_key)` with request/result digests. Same request replays original result; divergent request is `CONFLICT`; stale writes have no effect. |
| `mission_ledgers`, `correction_attempts` | Counters only increase; unique correction attempt/round; at most three rounds; successors inherit counters/caps and never reset hard floors. |
| `cas_objects`, `cas_refs` | Digest PK, length/class; references are owned record/revision/role/ordinal. A committed record references only an already verified object. |
| `outbox` | Immutable external-effect intent/result and reconciliation link. Uncertain send is `UNKNOWN`, never automatic replay. |
| `retention_marks`, `backup_catalog` | Holds, reachability/quarantine/purge disposition, backup inventory, verification and restore provenance. |

Use `RESTRICT`/equivalent, never `CASCADE`, on canonical, evidence, lineage,
receipt, event, and backup provenance. This follows the repository review rule
against destructive history and writable projections ([review bias lines
97-124, 154-166](../../../core/review/persisted-modeling-defect-bias.md)).

Payload digest is `sha256:<64 lowercase hex>` over exact bytes. The three
proposal manifests retain their RFC 8785 JCS/UTF-8/domain-separated hashing;
the store records but does not redefine those Phase-1 schemas ([proposal lines
766-827](../2026-09-01-accelerate-portable-agent-fabric-openspec-design.md)).

### Fenced CAS, idempotency, and crash recovery

Every mutation uses:

```text
record_id, expected_revision, actor_id, actor_epoch, token_domain,
fencing_token, effect_idempotency_key, payload_digest
```

In `BEGIN IMMEDIATE` (or equivalent proved transaction), validate schema and
CAS object; read current record; check revision/current unexpired lease/fence;
check idempotency; validate transition/budget/lineage; append event; update
canonical rows/counters; persist replay result; commit. Predicate failure rolls
back all effects. Fences rotate at reservation, reclaim, successor creation,
expiry, actor-epoch change, and revocation.

CAS publication stages on the same filesystem, fsyncs, atomically creates the
digest path without replacement, then rereads/hashes. Only then may its DB
reference commit. Before DB commit, a crash leaves an unreachable object for
quarantine; after commit, bytes were verified. On open/resume, missing,
unreadable, or mismatched referenced bytes block rather than regenerate truth.

External calls use a transactional outbox intent, then a separately fenced
result update. Crash after send but before result is `UNKNOWN`; recovery must
read back or obtain an operator disposition, never replay a real effect. This
matches the proposal's A10 partial-outbox/duplicate-effect boundary.

### Retention, backup, restore, corruption

Default retention keeps canonical records, events, receipts, manifests,
evidence, lineage, correction attempts, and restore provenance for the
governed window. GC freezes a reachability epoch, marks only unreferenced and
unheld aged objects, moves them to same-volume quarantine, verifies through a
later backup/restore scan, and only then permits a separately receipted purge.
History purge is never incidental deletion.

A usable backup is a crash-consistent SQLite backup plus CAS inventory
(digest/length, format/migrations, event high-water mark, inventory digest).
It is valid only after isolated restore, SQLite integrity/foreign-key/event
checks, CAS reachability, and rehash of all inventory bytes. Copying a live DB
file is not an approved backup.

Restore is non-destructive: stop writers; restore into a new target; verify
inventory/checks; migrate only forward compatibly; issue operator/root
activation disposition; retain old store for rollback until readback succeeds.
Never merge two active stores or overwrite an active root. Integrity, FK,
event-chain, migration-checksum, or CAS failure quarantines the store
read-only, emits an incident receipt, and yields `BLOCKED` (or `UNKNOWN` for
uncertain outbox effect); recovery is a verified backup or successor decision,
not hand editing SQLite/JSON.

### Portability, observability, and acceptance

This is portable single-host storage, not distributed storage. Network filesystems,
shared sync folders, and multiple independent writers are unsupported; adapters
must refuse them. Secret-free telemetry includes root/record/event/transaction
IDs, revision, actor epoch, token/fence, payload digest, result, and latency.
Metrics cover CAS failures, stale conflicts, replays/divergence, rollbacks,
unknown outboxes, backup age/verification, restore, GC, and integrity failures.

Phase 1 MUST later add (this ADR does **not** claim they exist): accepted CAS;
stale revision/fence reject; same-key replay/no duplicate effect; divergent
replay reject; crash around CAS/commit; no partial transaction; tampered/missing
CAS reject; restore equivalence/non-overwrite; and GC hold/quarantine. A03
requires `crash-replay` and `divergent-replay` exact outcomes. Phase 5 consumes
this for gates/scheduler/corrections and must prove root/successor rollback,
single-winner races, expired-lease `UNKNOWN`, and old-token rejection; it never
extends Phase-1 manifest schemas ([proposal lines 781-785, 1845-1857,
1894-1910, 1998-2011](../2026-09-01-accelerate-portable-agent-fabric-openspec-design.md)).

## Rollback, non-goals, escalation

Before an external effect, rollback is a verified restore to a new target plus
event/CAS readback; ledger history is never rewritten. Once an outbox may have
sent, reconcile first—rollback cannot claim undo.

Non-goals: selecting remote binding; making `.accelerate/workflow` canonical;
implementing OpenSpec or Apply; provider replay; multi-host HA; storing arbitrary
transcripts/secrets; or authorizing runtime/deployment mutation.

External relational DB plus object storage becomes mandatory before multiple
writer hosts, network-mounted writes, HA/RPO-RTO beyond verified local backup,
impractical local object/retention volume, centralized access/audit retention,
or provider coordination unavailable via outbox/reconcile. It requires a
successor D01 ADR with migration/cutover, no-split-brain fencing, backup/restore,
rollback, and fixture proof—never a silent configuration fallback.

## Source locators and recommendation

- Proposal: lines 151-188, 224-258, 766-870, 923-1027, 1845-1857,
  1894-1910, 2004-2041.
- Local workflow: `adapters/workflow/local/README.md`, lines 5-45; rehydration:
  `adapters/workflow/provider-state-rehydration-contract.md`, lines 1-6.
- Durable registration: `core/control-plane/durable-learning-registration-gate.md`, lines 8-34.

Recommend root acceptance with the explicit single-host boundary and mandatory
restore/CAS receipts intact. This is the simplest repository-native design that
can meet atomic CAS, fencing, crash recovery, and lineage requirements.
