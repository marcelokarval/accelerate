# CODEX-26 Phase-1 C1 failure and correction packet

## Candidate disposition

- Candidate: `CODEX-26-P1-IMPLEMENT-C1`
- Frozen aggregate: `d3dfe13653096e2c3c3451bcf0c1e93620ade929e37e1e7d77f4c104bcf2df5c`
- Tester: `/root/phase1_tester`, Terra/medium, `FAIL`
- Reviewer: `/root/phase1_reviewer`, Terra/medium, `FAIL`
- Root decision: `CORRECTION_REQUIRED`
- Prior proof validity: invalid for Phase-1 exit; retained for forensics only
- Scope change: none
- Denominator change: none
- Correction round: 1 of 3

## Consolidated blocking corrections

1. Replace the hand-written subset canonicalizer with an actual RFC 8785/JCS
   implementation or a standards-conformant repository-owned implementation;
   prove ECMAScript number serialization, UTF-16 member ordering, I-JSON
   ranges, Unicode, duplicate-key rejection, and exact domain-separated bytes.
2. Replace generic field-presence checks with exact closed definitions and
   semantic validators for all nine Phase-1 schemas. Enforce types independently
   from Python bool/int coercion, enums, cardinality, ordering, digest grammar,
   owner/phase/family, freshness/signature/bindings, and semantic duplicates.
3. Implement the complete candidate output-snapshot contract: commit/no-commit,
   root identity, denominator paths, tracked/untracked/ignored policy, entry
   type/mode/size/content/target/submodule hashes, generated artifacts, and
   dependency/lock/config/non-secret-env inputs.
4. Implement G4/G5/G6 set semantics over exact children/seams/flows,
   participant/parent relations, receipt ids/digests, currentness, sorted
   completeness, omissions, and wrong participants.
5. Turn every named A04 main/supplemental/snapshot fixture into an executable
   behavioral assertion with the proposal's exact five-field outcome. An
   inventory/count test is insufficient.
6. Harden D01 A03: atomic CAS publication, fsync/rename/readback, transactional
   request/revision/fence/idempotency/event semantics, crash injection at
   boundaries, no orphan effect on conflict, tamper/missing detection, and
   verified non-overwriting restore equivalence.
7. Stage the exact pinned OpenSpec `v1.11.0` artifact in a disposable test tool
   root, verify package/tag/commit/npm integrity/tarball hash before spawn, and
   execute its real JSON status, instructions, validation, and archive behavior.
   A shell echo fixture is not integration proof. No global/project install.
8. Harden adapter containment/protocol: reject symlinked roots and every
   symlink ancestor, traversal and alternate roots; strict duplicate-key JSON;
   exact top-level/result envelope; streaming/bounded capture; timeout process-
   group kill and zero residue; allowlisted environment; run-owned cleanup or
   quarantine with inventory readback.
9. Implement D12/D14 accepted source contracts: typed identifiers, typed alias
   records, projection/source/owner/reader/lifecycle/rollback bindings,
   cross-kind collisions, ambiguity/cycles/retired targets, state ordering, and
   frozen reader denominator. Keep every operational effect false.
10. Produce machine-readable release, exact-hash-vector, compatibility,
    cleanup, rollback, A03, and A04 proof receipts. Remove generated caches and
    freeze exact file inventory only after final test cleanup.

## Re-entry conditions

- Same five write roots and no other paths.
- Same Terra/medium implementer, no subdelegation.
- Fresh targeted proof after C2 freeze; C1 proof cannot be inherited.
- Tester and reviewer receive only C2 bytes plus original authority artifacts.
- Any denominator shrink, real runtime effect, or unresolved release mismatch
  stops the correction round.

