# CODEX-3 Agent Routing Hardening Task Breakdown

## Control

- Governing issue: `CODEX-3`
- SDD: `SDD-CODEX-AGENT-ROUTING-001`
- Branch: `codex-1-global-skill-catalog`
- State: `generation 11 closed / Plane FINISH readback observed`
- Correction generation: `11`
- Proof generation: `11`
- Exact correction denominator: `T1,T2,T3,T4,T5,T6,T7`
- Execution rule: finish and focally reprove each task in order; do not reorder
  later convenience work ahead of a failed earlier contract.

## Entry Gate `G0` — Complete

- Historical entry authority: CODEX-3 was read back In Progress before
  implementation; the current provider state is Done with FINISH readback.
- SDD/ADR/Test Design/traceability: materialized and root-accepted.
- Test harness: `tests/codex-agent-routing-hardening.sh`.
- Honest baseline: seven cases observed RED, exit `1`.
- Generation 1 narrow GREEN was invalidated by independent review; generation 2
  corrected five findings and was freshly reproved. A second independent review
  rejected generation 2 closure with `G3-F1` and `G3-F2`; generation 3 was then
  opened, corrected and later superseded by the subsequent generations recorded
  below.

## Frozen Correction Tasks

### `T1` — Repo-own and refresh `skill-catalog-router`

- Write scope: new repo router package, its registry/manifest entries, and
  directly affected router/catalog validators and tests.
- Completion: `CASE-ROUTER-001` GREEN; current index check catches drift and no
  `h55` path remains.
- Depends on: `G0`.

### `T2` — Put exact skill paths and SHA-256 in Spawn Packets

- Write scope: route resolution/index contract, Spawn Packet renderer, direct
  validators/docs/tests.
- Completion: `CASE-SPAWN-002` GREEN for the exact assignment-skill set and
  existing file digests.
- Depends on: `T1`.

### `T3` — Hide/remove raw catalog aliases

- Write scope: catalog manifest visibility, renderer, transactional installer,
  rollback/readback and affected tests.
- Completion: `CASE-ALIASES-003` GREEN; only two recovery profiles are catalog
  launchable and a disposable stale alias is removed with recoverability.
- Depends on: `T2`.
- Generation 3 reentry: reopened for stale logical-agent-owned profile
  preservation across catalog evolution and rollback safety; corrected and
  reproved at generation 3 while generation 2 remains stale history.

### `T4` — Add logical `data-db` and `integrations-ops`

- Write scope: topology, role bindings, logical renderer/installer/runtime
  proof, adapter docs, and affected tests.
- Completion: `CASE-ROUTES-004` GREEN and both logical configs render without
  root authority or cross-group leakage.
- Depends on: `T3`.

### `T5` — Reconcile doctrine and envelopes

- Write scope: capability matrix, ontology, pooling, selection, skill envelopes,
  compatibility tests, and directly affected agent docs.
- Completion: `CASE-DOCTRINE-005` GREEN with one six-family denominator and
  explicit normalized-role mappings.
- Depends on: `T4`.

### `T6` — Make read-only artifact delivery unambiguous

- Write scope: three reviewer templates, policy wording/validator if needed,
  template/agent tests.
- Completion: `CASE-READONLY-006` GREEN; return-only proposals and separate
  persistence executor are explicit.
- Depends on: `T5`.

### `T7` — Enforce `spawn_packet_limit`

- Write scope: topology validator, packet renderer, adapter docs and packet
  tests.
- Completion: `CASE-LIMIT-007` GREEN for limit `8`, configured default remains
  compact, and incomplete packets fail instead of truncating.
- Depends on: `T6`.

## Proof And Delivery Gates Outside The Correction Denominator

### `G11-D1` — Reconcile governing documentary truth

- Finding: `G11-F1` (`P2`) from the contract reviewer.
- Required result: dashboard, traceability and ledger state exact G10
  implementation/runtime receipt facts without stale or contradictory status.
- Result: correction/proof `11/11`; JSON/YAML/link/whitespace static proof passed.
- Boundary: G10 implementation/runtime evidence remains current and accepted;
  its receipt became historical after external drift.

### `G11-D2` — Reprove runtime after external drift

- Finding: `G11-F2` P1 closure blocker.
- Observed state: post-G10-sync `~/.codex/config.toml` has reasoning effort
  `low`, topology requires `medium`, and mirror root plus seven fails.
- Boundary: not a code defect; governed G11 resync restored root Sol/effort
  `medium`, mirror and fresh root plus seven passed. Current GREEN is true;
  independent reviews and root forensic passed.

### `G10-C1..C3` — Catalog transaction and receipt identity

- Exact order: `G10-F1` transactional rollback/cleanup; `G10-F2` exact receipt
  regular/non-symlink/nlink1/owner/mode0600 identity; `G10-F3` unique declared
  rollback-directory identity across validators.
- Status: corrected and reproved at generation 10; three separate REDs then GREEN.

### `G9-C1` — Align ownership receipt identity and mode validators

- Finding: `G9-F1` (`P2`).
- Required result: logical and catalog validators enforce the same canonical
  target-to-backup identity and exact mode `0600`; an adversarial cross-installer
  matrix rejects renamed backups and permissive modes.
- Status: corrected and reproved at generation 9; adversarial matrix passes.

### `G8-C1` — Contain logical fast path to governed history

- Finding: `G8-F1` (`P2`); first correction.
- Required result: logical fast-path eligibility is restricted to state covered
  by CODEX_HOME rollback/backup history.
- Status: corrected and reproved at generation 8.

### `G8-C2` — Preflight receipt destination before mutation

- Finding: `G8-F2` (`P1`); second correction after `G8-C1`; exact RED was
  review-observed because the implementer path stopped at an earlier fail-fast.
- Required result: reject an invalid receipt destination, including a directory,
  before any profile mutation even when real drift exists.
- Status: corrected and reproved at generation 8 with root GREEN regression.

### `G7-C1` — Preserve rollback-valid idempotency on standalone logical reinstall

- Finding: `G7-F1` (`P1`).
- Required result: after sync, a supported standalone logical reinstall must be
  byte-idempotent when configs, modes, ownership, and hashes are canonical, must
  not change the logical receipt `installed_digest`, and must preserve schema-4
  rollback validity; a real change must still update the affected config and
  receipt.
- Status: corrected and reproved at generation 7.

### `G6-C1` — Prove ownership on the inherited FD itself

- Finding: `G6-F1` (`P1`).
- Required result: all four mutators perform direct nonblocking `flock` on the
  inherited FD; holder A plus spoof OFD-B rejects, while legitimate same-OFD
  inheritance succeeds.
- Status: corrected and reproved at generation 6.

### `G5-C1` — Prove held lock ownership

- Finding: `G5-F1` (`P1`); first correction.
- Required result: an inherited FD must prove held `flock` ownership, not only
  identity with the exact lock inode.
- Status: corrected and reproved at generation 5.

### `G5-C2` — Acquire before decisive rollback validation

- Finding: `G5-F2` (`P1`); second correction after `G5-C1`.
- Required result: rollback acquires the shared lock before material receipt or
  runtime validation and holds it through mutation.
- Status: corrected and reproved at generation 5.

### `G5-C3` — Reconcile standalone ownership receipts

- Finding: `G5-F3` (`P2`); third correction after `G5-C2`.
- Required result: combined sync transactionally writes/restores both catalog
  and logical ownership receipts at schema 2/mode `0600`.
- Status: corrected and reproved at generation 5.

### `G4-C1` — Bind logical ownership to a content digest

- Finding: `G4-F1` (`P1`); first correction.
- Required result: logical ownership is accepted only through a digest-bearing
  logical receipt; shape, mtime and backdating cannot launder tampered content.
- Status: corrected and reproved at generation 4.

### `G4-C2` — Enforce installed mode `0600`

- Finding: `G4-F2` (`P2`); second correction after `G4-C1`.
- Required result: every installed runtime config has exact mode `0600` after
  install and reinstall.
- Status: corrected and reproved at generation 4.

### `G4-C3` — Close cooperative TOCTOU with one shared lock

- Finding: `G4-F3` (`P2`); third correction after `G4-C2`.
- Required result: installers, sync and rollback share one cooperative
  single-writer lock over classification/preflight through mutation.
- Status: corrected and reproved at generation 4 for governed cooperative mutators.

### `G3-C1` — Reject destructive rollback over post-sync drift

- Finding: `G3-F1` (`P1`).
- Order: first generation 3 correction.
- Required result: preflight the complete receipt denominator against the
  installed state captured by the receipt; abort before any mutation when a
  target changed or appeared/disappeared after sync.
- Status: corrected and reproved at generation 3.

### `G3-C2` — Preserve stale logical ownership across catalog evolution

- Finding: `G3-F2` (`P1`).
- Order: second generation 3 correction, after `G3-C1`.
- Required result: catalog reconciliation preserves every existing target that
  declares logical-agent ownership across catalog evolution; retirement
  requires the logical owner or an explicit migration.
- Status: corrected and reproved at generation 3.

### `G8` — Repository GREEN

- Run focused test, all directly affected suites, `bash tests/all.sh`,
  `git diff --check`, cache scan, registry/parity validators, and manifest at
  implementation stage.
- Advance proof generation to equal the final correction generation.
- Status: G10 implementation proof remains accepted. Focused routing `7/7`, catalog `131/root13`,
  quality `11/11+6/6`, lifecycle `10/10`, full suite, sync/mirror, receipts/modes
  passed. G11 documentary static proof and runtime recovery proof passed.

### `G9` — Independent Review And Review-Of-Review

- Independent reviewer inspects requested-vs-implemented, authority, security,
  installer rollback, stale aliases, exact hashes, and test adequacy.
- Root corrects findings, invalidates stale proof, reruns affected proof, and
  performs review-of-review.
- Status: generation 2 independent review failed with `G3-F1` and `G3-F2`.
  Final generation 3 review failed closure with `G4-F1` through `G4-F3`.
  Generation 4 review failed closure with `G5-F1` through `G5-F3`. Generation 5
  review failed closure with `G6-F1`; generation 6 correction/proof completed,
  but final generation 6 review failed closure with `G7-F1`. Generation 7
  correction/proof completed, but final generation 7 review failed closure with
  `G8-F1` and `G8-F2`. Generation 8 correction/proof completed and review
  confirmed those fixes, but failed closure with `G9-F1`. Generation 9 review
  failed with `G10-F1` through `G10-F3`; generation 10 correction/proof passed.
  G11 documentary and runtime recovery proof passed. Two independent reviews
  accepted with zero P0-P3 findings; root review-of-review and forensic passed.

### `G10` — Runtime Sync, Fresh Process, And Plane Closure

- Transactionally sync repo source to the global mirror with receipt/readback.
- Start a fresh writable Codex process and prove the root plus all seven logical
  specialist profiles, including bounded no-history spawn/return.
- Record REVIEW and FINISH evidence through governed Plane, transition only to
  the highest supported state, then read back CODEX-3 before closure.
- Runtime sync/fresh process: generation 3 remains installed through schema-4 receipt
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G3-20260813T151014Z/sync-receipt.json`;
  mirror parity and fresh-process root plus seven-specialist proof passed as
  generation 3 history. Generation 5 schema-4 sync, mirror and fresh runtime
  proof passed as history. Generation 6 schema-4 sync installed 130 operations,
  112 changed packages and 18 runtime files; mirror, receipts and fresh runtime
  proof passed as stale history. Generation 7 schema-4 sync installed 130
  operations, 112 changed packages and 18 runtime files; mirror, schema-2
  ownership receipts, fresh-process root plus seven-specialist proof and
  rollback-valid standalone reinstall proof passed as stale history. Generation
  8 schema-4 sync installed 130 operations, 112 changed packages and 18 runtime
  files; mirror, schema-2 ownership receipts, fresh root plus seven-specialist
  proof and transactional containment/preflight proof passed as stale history.
  Generation 9 schema-4 sync installed 130 operations; mirror, all mode-0600
  configs/profiles/receipts, fresh root plus seven-specialist proof and the
  adversarial validator matrix passed. Concurrent `playwright-patterns` was
  preserved byte-exact and the 112-route index regenerated. Generation 10
  receipt `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G10-20260813T190557Z/sync-receipt.json`
  installed 130 operations and passed mirror/fresh runtime, then became
  historical after external drift. Generation 11 receipt
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G11-20260813T192112Z/sync-receipt.json`,
  SHA `5f7ba0e0fd1279f8fbf26fd895b1a3dc262f363817fc7d2eef32b3236bbee9e6`,
  restored root Sol/medium; mirror and fresh root plus seven PASS. Governed
  Plane REVIEW, Done transition, FINISH and final provider readback passed.

## Stop Conditions

Stop and reopen specification if any task requires a new authority source,
profile identity, role family, write boundary, packet schema, external effect,
or proof lane. Never compensate for a failed earlier task by weakening its case
or declaring a later broad suite sufficient.
