# CODEX-26 Phase 1 — OpenSpec Core and execution-control SDD

## Status

- Owner: Codex root
- Independent acceptor: Terra/medium architecture reviewer
- Date: 2026-09-01
- Source request: implement the complete authorized Phase 1 economically with
  Terra/medium children and root validation
- Canonical issue: `CODEX-26`
- Active phase: `Design -> TASKS_READY` only after independent acceptance
- Governing proposal: v0.7.25, SHA-256
  `749d829a5b5868370b05007ad71e4b4b285623db79cbefeaa47ba9a3b07e7cca`

## Design problem

Materialize Phase 1 as a self-contained repository capability: an isolated
OpenSpec Core adapter, a crash-safe fixture-scoped gauntlet store, and the
closed content-addressed control artifacts that later phases consume. The
implementation must prove the whole A03/A04 denominator without installing or
activating anything in a user or runtime catalog.

## Accepted scope

1. Freeze and verify OpenSpec Core `v1.11.0` using the tuple in the CODEX-26
   decision rebinding.
2. Implement D01's SQLite plus filesystem-CAS contract deeply enough for A03,
   restore/CAS proof, transactional idempotency, and divergent replay denial.
3. Implement a fixture-only OpenSpec adapter and `accelerate-governed` schema
   draft that prove JSON status, instructions, validation, and archive behavior
   inside a disposable test root.
4. Implement, canonicalize, and validate every Phase-1-owned row in the
   proposal's exhaustive schema table: three manifests, three readiness
   receipts, and the G4/G5/G6 receipt-set schemas. This is a nine-schema
   denominator; it is not limited to the three manifests.
5. Implement D12/D14 repository source contracts and negative fixtures without
   activating a projection or changing a reader.
6. Produce exact canonical bytes/hashes, A03/A04 fixture results,
   compatibility, cleanup, and rollback receipts.

## Non-goals

- no global, user-home, active-runtime, or production dependency installation;
- no active catalog projection, loader change, symlink, alias activation,
  namespace migration, or reader retirement;
- no Plane lifecycle ownership inside OpenSpec or the gauntlet store;
- no WebUI, LAN binding, deployment, Phase 2–7 behavior, or live archive of a
  real project;
- no implementation of Phase-5 gate schemas or state transitions.

## Target architecture and ownership

```text
core/phase1/
  canonical/       strict JSON parsing, JCS canonicalization, domain hashes
  contracts/       nine closed Phase-1 schemas and registry
  gauntlet/        SQLite ledger + immutable filesystem CAS
adapters/openspec/
  fixture_adapter  exact executable/cwd/env/JSON/process boundary
planning/openspec/
  schemas/accelerate-governed/  tracked schema draft and templates
tests/fixtures/phase1/
  a03/ a04/ openspec/ namespace/
planning/evidence/.../codex-26-phase1/
  generated proof packets and frozen candidate receipts
```

Exact paths may be adjusted by the implementer to existing repository
conventions, but ownership may not move across these layers. Core owns
canonicalization, schema validation, and gauntlet persistence. The adapter owns
only process/protocol/filesystem containment. `planning/openspec/` owns tracked
specification artifacts. Tests own tool and fixture roots. Plane remains the
canonical work-item lifecycle authority.

## Data and contracts

- Strict JSON input rejects duplicate keys before schema validation.
- Canonical bytes use RFC 8785 JCS over UTF-8 and I-JSON-compatible values.
- Each manifest hash is SHA-256 over its exact proposal-defined domain prefix,
  LF, and canonical bytes. Every supplied digest is regenerated and compared.
- All nine schemas are closed (`additionalProperties:false` or equivalent),
  versioned, owner-bound, family-bound, and reject unknown, missing, duplicate,
  malformed digest, wrong family, wrong owner, wrong phase, and duplicate
  semantic references.
- Output snapshots use deterministic path ordering and bind mode, size,
  executable bit, content/target/submodule digests, generated artifacts, and
  declared dependency/config inputs.
- SQLite is canonical only for fixture gauntlet execution state. OpenSpec and
  JSON/YAML outputs are projections, never writable peers.

## OpenSpec adapter boundary

The adapter resolves one verified local executable under a disposable tool
prefix, uses an argument vector (no shell), explicit `cwd` rooted at the
fixture's `planning/`, allowlisted environment, bounded stdout/stderr, timeout
plus process-group termination, and one strict JSON result. Fixture execution
is offline after staging. Status and instructions are read-only projections;
validation is structural evidence; archive is separately invoked and cannot
close CODEX-26 or mutate Plane.

## Security and failure posture

- reject symlinked roots/ancestors, traversal, alternate store roots, foreign
  residue, protocol contamination, stale release tuple, and hash mismatch;
- never pass parent credentials or arbitrary provider environment;
- all negative fixtures assert unchanged canonical revision and no forbidden
  effect;
- uncertain external effects are not retried, though Phase 1 itself performs no
  live external archive/provider effect;
- cleanup removes only run-owned paths after containment and inventory readback;
  ambiguity quarantines instead of deleting.

## Test and proof strategy

- Lowest-effect checks: schema registry, strict parser, canonicalization vectors,
  domain hashes, namespace/collision rules.
- A03 integration: accepted crash replay with unchanged state/no duplicate
  effect; divergent replay conflict with unchanged state/no appended event.
- A04 integration: every named main-row and supplemental fixture, including all
  readiness failures and G4/G5/G6 denominator mismatches.
- OpenSpec fixture integration: status, instructions, validation, archive,
  contamination, timeout, containment, and cleanup.
- Independent tester reruns the frozen denominator; independent reviewer audits
  scope, authority, completeness, security, and proof validity.
- Root runs review-of-review, the Phase-1 targeted suite, `tests/all.sh`, and
  `git diff --check` before any closure claim.

## Migration and rollback

There is no runtime migration. All executable staging and fixture roots are
disposable. Source rollback removes only CODEX-26-owned new files or reverts
their candidate revision; it does not alter existing readers, user catalogs,
global mirrors, Plane history, or the accepted proposal. Store restore targets
a new isolated root and proves event/CAS equivalence before selection.

## Acceptance to tasks

| Unit | Owner | Dependency | Exit |
| --- | --- | --- | --- |
| P1-PLAN | root | CODEX-25 and current user auth | accepted SDD, dispositions, phase auth, frozen DAG |
| P1-CORE | Terra implementer | P1-PLAN | nine schemas/canonicalizers/store plus unit proof |
| P1-ADAPTER | same bounded implementer | P1-PLAN | isolated OpenSpec adapter/schema draft/compatibility proof |
| P1-PROOF | independent Terra tester | frozen implementation candidate | complete A03/A04 and adapter proof receipts |
| P1-REVIEW | independent Terra reviewer | frozen tested candidate | PASS or actionable rejection |
| P1-CLOSE | root | tester+reviewer PASS | review-of-review and Plane reconciliation |

## Stop conditions

- any required current decision digest is absent from the phase authorization;
- the pinned package/tag/integrity tuple disagrees;
- implementation requires global/user-home/runtime mutation;
- the nine-schema or A03/A04 denominator is silently reduced;
- a test would operate on a real project OpenSpec root;
- reviewer and implementer identity/context are not independent;
- existing dirty user files would be overwritten.

## Handoff decision

- Ready for task breakdown: yes
- Ready for execution: only after independent SDD acceptance and a valid
  digest-bound Phase-1 authorization receipt
- Issue bootstrap: satisfied by CODEX-26
- Residual design ambiguity: exact filenames may follow repository conventions;
  schema semantics and fixture denominator may not change.

