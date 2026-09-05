# CODEX-26 Phase 1 — C7 Independent Gate Failure / C8 Correction

- rejected candidate: `CODEX-26-P1-IMPLEMENT-C7`
- frozen aggregate: `sha256:b11f43bcbc45050f7a9324929a3097dab43cbac9d50050707e09960010b61e32`
- freeze receipt: `sha256:201cf8563efabe59a17f7f28890ffcd08a1e9372a2e83f7bf90b60c2faeb280c`
- tester verdict: `FAIL`
- reviewer verdict: `FAIL`
- successor: `C8`
- operator-extra correction round: `4/8`

## Closed correction denominator

1. Replace object-materialization JCS with an RFC 8785 serializer that preserves
   UTF-16 lexicographic member order even for integer-like keys; add the
   independent `{"10":"a","2":"b"}` vector.
2. Move the A04 five-field result boundary into production validation/actions.
   Tests must call that boundary and assert the proposal's exact `changed` or
   `unchanged`, state, forbidden effect and receipt digest set; no wrapper may
   catch a broad exception and manufacture an outcome.
3. Require complete set lineage: every G4 receipt ID/digest must be present in
   G5 prerequisites and every G5 receipt in G6 prerequisites. Element-zero
   lineage is forbidden.
4. Pass the fixture-only allowlisted environment to every actual OpenSpec
   process, including `init` and `new`. Reconcile the persisted command mapping
   with the commands actually executed.
5. Implement real Git-aware commit/no-commit snapshot semantics, including
   tracked/untracked/ignored state and gitlink/submodule commit identity. A
   fabricated `.git` regular file is not a submodule fixture.
6. Validate every generated evidence object before writing it; correct the
   invalid `loop_selectors` JCS vector and fail generation on any invalid
   schema/vector.
7. Readiness authority validation must require a trusted signer identity,
   signer-authority binding and current expected context. Arbitrary nonempty
   signatures and omitted caller context cannot produce a valid readiness
   result.

All other C7 and Phase-1 denominators remain regression requirements. C8 needs
two real runs, no skips, deterministic validated receipts, no caches, clean
diff, and zero known residuals before a new freeze. This packet grants no
acceptance, promotion, runtime, namespace, reader, Plane-closure or Phase-2
authority.
