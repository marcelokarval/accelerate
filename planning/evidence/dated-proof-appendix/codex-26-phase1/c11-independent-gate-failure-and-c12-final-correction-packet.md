# CODEX-26 Phase 1 — C11 Failure / C12 Final Correction

- rejected candidate: `CODEX-26-P1-IMPLEMENT-C11`
- frozen aggregate: `sha256:4b163e4b5286e7fca173444de81fc856ac03e59862c9b2ef76ea8e8ecdd9c16b`
- freeze receipt file: `sha256:7521fc35814e381ec86dd50773ac6f31698e34507d2ae8f2334de3ea5b10d1bc`
- tester verdict: `FAIL`
- reviewer verdict: `FAIL`
- successor: `C12`
- operator-extra correction round: `8/8` (final authorized round)

## Authority reconciliation

The accepted Phase-1 test design requires the complete proposal A04 main row,
the additive A04 supplemental matrix and the snapshot-negative family. The
names `root-manifest-omitted-child-reject`,
`root-manifest-stale-child-reject`, `root-manifest-missing-gates-reject` and
`root-global-proof-mismatch-reject` occur in the A05 Phase-5 table, not the A04
main/supplemental tables. Their presence in `a04-denominator.json` is an
incorrect cross-phase import. C12 removes them from the A04 denominator; this
restores, rather than shrinks, the accepted denominator.

## Closed correction denominator

1. Runtime execution captures an immutable private tuple policy. A public
   read-only projection may exist for inspection, but rebinding or mutating it
   cannot alter the captured execution policy.
2. Every A04 row exactly matches the governing five-field tuple, including
   `root-manifest+acceptance` and
   `root-manifest+operator-disposition` evidence.
3. Every `a+b+...` evidence shorthand expands one-to-one into sorted distinct
   `receipt_digests` keys. Combined shorthand strings are not keys.
4. `included-input-mutation` validates a real mutated execution-input manifest,
   constructs and validates an immutable successor candidate, proves the
   predecessor unchanged and binds actual predecessor/successor digests. A
   caller-supplied old digest is insufficient.
5. `root-manifest-invalid-omission-or-replacement-reject` validates a distinct
   missing/invalid operator-disposition predicate; generic empty-child
   `FAN_IN_INCOMPLETE` cannot satisfy it.
6. Cross-name/private-reason tests cover every semantically distinct family,
   and policy mutation/rebinding counterexamples reject.

All other C11 probes remain regression requirements. C12 requires two real
runs, zero skips, deterministic validated receipts, no caches, clean diff and
zero known residuals. Exhausting this round without independent PASS leaves
Phase 1 blocked pending a new operator disposition; it never permits silent
acceptance. No promotion, runtime, namespace, reader, Plane closure or Phase-2
authority is granted.
