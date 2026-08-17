---
name: hermes-core-change-governance
description: Use when deciding or implementing a Hermes behavior change that may touch config, plugins, middleware, gateway adapters, gateway core, SessionDB, SQLite/PostgreSQL selection, migrations, or runtime promotion. Choose the owning layer before editing and keep source, installed runtime, database, and live service evidence separate.
license: Proprietary - Karval/Hermes internal use
metadata:
  category: hermes-agent
  owner: karval-hermes
  source_of_truth: accelerate-codex-skill-seeds
---

# Hermes Core Change Governance

Use before changing Hermes behavior. Place the change in the smallest correct
layer and prevent a local workaround from becoming an unowned core fork.

## Placement rule

Choose the least permanent surface that can express the invariant:

1. `config.yaml` for profile/chat/topic/routing/display policy;
2. plugin, hook, or middleware for local/provider-specific behavior;
3. platform adapter for a platform protocol change;
4. core source for a shared contract, cross-platform bug, or infrastructure
   invariant that cannot be expressed above;
5. upstream contribution when the behavior is generic beyond the local fork.

Never put a plugin exception directly in `gateway/run.py` or another core file.
If a generic extension point is missing, widen that generic surface first.

## Required sequence

1. Freeze behavior, non-goals, authorization, and affected surfaces.
2. Load runtime-truth and identify active checkout, process, profile, config,
   backend, database, and service unit.
3. Read `AGENTS.md`, ADRs, and the subsystem contract; search upstream issues
   and PRs for duplicates.
4. Reproduce the earliest broken boundary on the real path.
5. Implement in the owning layer with the smallest coherent delta. Preserve
   prompt-cache, role-alternation, profile isolation, and idempotency.
6. Run focused tests, affected contracts, and live PostgreSQL proof when state
   or gateway I/O is involved.
7. Review the complete candidate against its active baseline. Keep commit,
   push, merge, migration, restart, canary, deployment, and rollback separate.
8. Record durable learning in the issue, skill/reference, test contract, or
   runbook after evidence stabilizes.

## Gateway and database rules

- Per-profile/chat behavior belongs in `config.yaml`, not a hardcoded chat-ID
  branch.
- Platform protocol changes belong in the adapter and its contract tests.
- Observation belongs in hooks; request shaping/execution wrapping belongs in
  plugin middleware.
- Shared inbound, authorization, session, dispatch, or delivery invariants
  belong in gateway core only after sibling paths are tested.
- In the Karval fork PostgreSQL 18 is authoritative for governed operational
  state. SQLite is explicit compatibility/import/export/forensics only and
  must never be a silent request fallback.
- Gateway event-loop paths use the async PostgreSQL store; no blocking sync SQL
  or SQLite construction in a governed request loop.
- Backend migration is expand → shadow/readiness → canary → cutover, with
  backup, reconciliation, idempotent schema migration, and data-preserving
  rollback.

Read [references/placement-and-gateway.md](references/placement-and-gateway.md)
for the decision matrix and gateway proof. Read
[references/postgres-rollout.md](references/postgres-rollout.md) for backend
selection, import, readiness, parity, and rollback.

Route deep work to the existing owners when present: use
`hermes-integration-architecture` for gateway/adapter design,
`hermes-plugin-development` for plugin lifecycle, and
`hermes-sessiondb-postgres` for backend implementation and live PG proof.

## Output contract

Return: chosen layer and rationale; truth sources; earliest broken boundary;
changed files/config/schema; proof and result; separate runtime/promotion
gates; rollback boundary; and durable issue/skill/test/documentation record.

Stop before mutation if runtime truth or backend authority is ambiguous, a
migration lacks backup/reconciliation, the proposal creates another service/
store/fallback, or a plugin-specific fix requires core edits.
