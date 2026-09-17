# CODEX-26 Phase-1 Test Design

## Denominator

The test denominator is the union of proposal A03, the complete A04 main row,
the A04 supplemental matrix, the three-manifest exact-byte/hash vectors, all
nine Phase-1 schema closed-field families, OpenSpec status/instructions/
validation/archive behavior, D12/D14 source-contract negatives, containment,
cleanup, compatibility, and rollback.

No test may claim installation, projection activation, namespace migration,
reader retirement, live project archive, Plane closure, WebUI, or deployment.

## Required suites

1. `phase1-canonical-contracts`: strict duplicate-key JSON, I-JSON/JCS vectors,
   Unicode/member ordering, digest grammar, domain prefixes, exact bytes/hashes.
2. `phase1-schema-contracts`: positive and negative fixtures for the three
   manifests, three readiness receipts, and G4/G5/G6 receipt sets.
3. `phase1-a03-gauntlet-store`: crash replay, divergent replay, atomic event and
   idempotency invariants, CAS tamper/missing, restore equivalence/non-overwrite.
4. `phase1-a04-candidate`: every exact main/supplemental fixture named by the
   proposal, including output snapshot mismatch families.
5. `phase1-openspec-adapter`: verified release tuple, JSON protocol, status,
   instructions, validation, archive, timeout/process cleanup, environment and
   filesystem containment.
6. `phase1-catalog-namespace`: stale/divergent projection, collision, alias
   ambiguity/cycle/retired target, and reader-denominator rejection.
7. `phase1-rollback-cleanup`: isolated restore, candidate removal, inventory
   readback, zero foreign deletion, and no active-runtime change.

## Proof rules

- Every negative fixture declares exact result, state-change class,
  forbidden-effect assertion, and evidence class.
- Fresh proof is run after candidate freeze. Builder self-tests are diagnostic
  until the root freezes the candidate.
- Tester is a distinct Terra/medium instance and may add tests/evidence only;
  it does not repair implementation code.
- Reviewer is a fresh distinct Terra/medium instance, read-only over candidate,
  original SDD, proposal, task graph, and tester proof.
- Root independently checks fixture enumeration against proposal text, reruns
  targeted and full suites, and reviews every diff in owned scope.

## Failure and correction

A failing fixture blocks Phase-1 exit. Findings return to the implementer as a
bounded correction packet. Maximum initial correction budget is three rounds;
no round may shrink the denominator or inherit stale proof. A fourth failure
requires explicit operator disposition.

