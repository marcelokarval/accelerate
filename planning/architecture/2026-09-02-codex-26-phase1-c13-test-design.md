# CODEX-26 Phase 1 C13 Test Design

## Baselines (must be RED before correction)

| ID | Pre-change scenario | Expected baseline |
| --- | --- | --- |
| RED-1 | Compare five named A04 receipt-key rows to an independent normative table. | mismatch |
| RED-2 | Use `None`, a string, and an arbitrary map as included-input predecessor. | invalid values accepted |
| RED-3 | Supply `{action: "omit", reason: "operator-approved"}`. | generic `A04_SEMANTIC_MISMATCH` |
| RED-4 | Run historical currentness validator against current authority. | stale CODEX-17 digest mismatch |

## Green matrix

1. A separate immutable fixture declares the exact normative A04 tuples and
   receipt keys. Tests must compare production outcomes to it; no expected
   assertion may be derived only from `A04_POLICY`.
2. A predecessor must pass closed root-candidate validation. The operation
   creates a successor candidate from the predecessor and mutated execution
   manifest; both candidate digests and predecessor bytes are asserted.
3. Valid and invalid operator dispositions each map to explicit, distinct,
   normalized outcomes.
4. The root suite runs the offline Phase-1 suite. The real pinned OpenSpec
   integration remains a named opt-in proof lane and cannot be silently skipped
   when a Phase-1 candidate is frozen.
5. Candidate testers execute a copied candidate with bytecode disabled and
   compare post-run inventory/hash to the frozen inventory/hash.

## Regression and review

- Regression: all Phase-1 offline tests, the named real-OpenSpec lane twice,
  affected root-suite tests, `git diff --check`, cache scan, and deterministic
  receipt manifest.
- Independent review: tester proves behavior; reviewer compares all outcomes to
  the frozen proposal and independent normative fixture.
- No PASS is accepted if expected data is sourced from the implementation under
  test.

