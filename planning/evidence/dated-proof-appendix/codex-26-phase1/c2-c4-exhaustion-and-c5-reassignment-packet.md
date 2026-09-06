# CODEX-26 Phase 1 — C2–C4 Exhaustion And C5 Reassignment Packet

- issue: `CODEX-26`
- phase: `Phase 1`
- execution route: `orchestrated`
- prior implementer: `/root/phase1_implementer`
- prior implementer model: `gpt-5.6-terra`
- prior implementer reasoning: `medium`
- prior implementer fork: `none`
- ordinary correction rounds consumed: `3/3`
- operator-authorized extra rounds available: `8`
- next candidate: `C5`
- current non-accepted working-tree aggregate: `sha256:7acd6e168e5b09154537499eec0eccb033193530bf545d8710df59caa9a4d046`
- current candidate file denominator: `22`

## Gate history

| Candidate | Pre-QA result | Material outcome |
| --- | --- | --- |
| C1 | FAIL after independent tester and reviewer | Ten blockers established. |
| C2 | NO-GO | Implementer declared A04, snapshots, gates, D01, D12/D14, real CLI coverage and receipts incomplete. |
| C3 | NO-GO | Sixty-three green methods and receipts did not close semantic branches or real CLI coverage. |
| C4 | NO-GO | Implementer again declared five governing domains incomplete after the third ordinary correction. |

No C2, C3 or C4 candidate was frozen. Green targeted tests do not override the
implementer's own residual-blocker declaration or the accepted semantic
denominator.

## C5 bounded denominator

C5 keeps the accepted Phase-1 scope and must close exactly these remaining
domains without weakening or renaming them:

1. exact typed validation for all nine execution-control schemas;
2. exact G4/G5/G6 receipt-denominator equality and lineage semantics;
3. complete typed D12/D14 source, alias, projection, reader and lifecycle
   source-only contracts;
4. all-or-none D01 SQLite/CAS mutation, fault cleanup, tamper/missing and
   restore equivalence;
5. real pinned OpenSpec v1.11.0 status/instructions/validate/archive behavior in
   disposable roots, with derived deterministic receipts.

The A04 and output-snapshot rows remain in the regression denominator. They may
not regress while the five residual domains are repaired.

## Reassignment decision

The prior implementer lane is exhausted for this correction attempt. C5 is
assigned to a fresh Terra/medium implementer with `fork_turns=none`. This is an
implementation reassignment, not a scope change, acceptance, promotion or
closure. Root retains freeze, fan-in, review-of-review, Plane reconciliation and
closure authority.

## C5 entry and exit

Entry is authorized by the existing Phase-1 implementation receipt and the
operator's explicit eight-round extension. C5 may enter independent gates only
when its implementer reports zero known residuals, its real lane passes twice,
receipt bytes are deterministic, caches are absent and `git diff --check`
passes. A fresh tester and a fresh reviewer must then independently return PASS.
