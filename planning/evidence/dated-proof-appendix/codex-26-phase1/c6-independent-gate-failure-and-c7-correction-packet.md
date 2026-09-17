# CODEX-26 Phase 1 — C6 Independent Gate Failure / C7 Correction

- rejected candidate: `CODEX-26-P1-IMPLEMENT-C6`
- frozen aggregate: `sha256:9d06ab81419e8740166c1bcebd2f7a5c0a5e381b37f901ae43a908b241be1da7`
- freeze receipt: `sha256:a2e8c856c5cd639d48c6741aa28290a9a8c637c557ea0580524c23c16b9bab7e`
- tester: `/root/phase1_c6_tester`, `gpt-5.6-terra`, `medium`, fresh read-only context
- reviewer: `/root/phase1_c6_reviewer`, `gpt-5.6-terra`, `medium`, fresh read-only context
- tester verdict: `FAIL`
- reviewer verdict: `FAIL`
- correction: `C7`, operator-authorized extra round `3/8`

The frozen aggregate was independently reproduced by both gates. The real
OpenSpec lane passed twice with 69 tests and stable receipts. Those green tests
do not override the following shared semantic blockers.

## Closed correction denominator

1. **G4/G5/G6 structural mismatch.** Their closed schema omits
   `receipt_ids`/`receipt_digests` although the validator consumes them, causing
   a raw `KeyError`. C7 must declare and validate exact ID-to-digest maps,
   participant denominators and G4 child-parent, G5 seam-to-G4 and G6
   flow-to-G5 lineage.
2. **A04/output snapshot proof theater.** Named tests fabricate tuples and
   accept broad `ContractError`; snapshot negatives mutate a supplied object
   without regenerating the real filesystem tree. C7 must expose a production
   five-field result object, validate its closed grammar and exact reason/effect
   per named row, regenerate the snapshot from a disposable root and compare it
   to the supplied snapshot.
3. **Strict JSON regression.** `invoke` uses permissive `json.loads` and accepts
   duplicate protocol keys. C7 must use the strict parser and test this exact
   counterexample.
4. **D12/D14 lifecycle gaps.** C7 must reject cross-kind namespace/name/version
   reuse, represent and detect alias/replacement cycles, and prohibit retirement
   while any active reader denominator depends on the entry.
5. **Staging containment.** Release verification/install commands must receive
   an explicit allowlisted environment with fixture-local HOME/config/cache;
   staging must lexically reject a symlinked root or ancestor before resolution
   and prove timeout/cleanup/no-parent-credential behavior.

The existing RFC8785, readiness, CAS, real OpenSpec, A04 and snapshot cases
remain regression requirements. C7 requires two real green runs, deterministic
receipts, no skips, no caches and clean diff before a new freeze. It grants no
acceptance, promotion, runtime, namespace, reader, Plane-closure or Phase-2
authority.
