# CODEX-26 Phase 1 — C12 Final Independent Gate Failure

## Candidate

- candidate: `CODEX-26-P1-IMPLEMENT-C12`
- freeze receipt SHA-256: `a9992efec684675d75d0dc19c3cf5112a34d4da5c01186f996c3bdd38daaa451`
- frozen 22-file aggregate: `7c361df1318dfc9b1d1a32ae971b9e9d57dfc1a642ef522d4286c03722f4d79f`
- correction authority consumed: `operator-extra-8-of-8`
- disposition: `REJECTED`
- Phase 1 status: `BLOCKED_PENDING_NEW_OPERATOR_DISPOSITION`

The candidate passed two root pre-freeze real runs (`78/78`, zero skips) and
reproduced its deterministic ten-receipt manifest. Those green checks are not
sufficient to override the semantic counterexamples below.

## Independent fan-in

The independent tester returned PASS for its exercised suite and targeted
checks. The independent skeptical reviewer returned FAIL with two P0 findings
and one P1 finding. Root review-of-review reproduced the reviewer findings and
therefore rejected the tester's self-attesting exactness conclusion.

## Controlling findings

### P0 — A04 evidence keys do not match the accepted table

The accepted proposal requires `root-manifest+acceptance` for the four child
fan-in failures and `root-manifest+operator-disposition` for invalid
omission/replacement. The executable policy emits only `root-manifest` for all
five names:

- `root-manifest-nonaccepted-child-reject`
- `root-manifest-failed-child-reject`
- `root-manifest-blocked-child-reject`
- `root-manifest-unknown-active-child-reject`
- `root-manifest-invalid-omission-or-replacement-reject`

The behavioral test derives expected receipt keys from `A04_POLICY` itself, so
it proves implementation consistency rather than conformity to the independent
normative table.

### P0 — included-input mutation accepts fabricated predecessor lineage

Root independently supplied each of `None`, an arbitrary map, and a string as
the predecessor. All three produced `ACCEPTED / SUCCESSOR_CREATED`. The path
canonicalizes but does not validate the predecessor as the required frozen root
candidate, and it accepts a caller-supplied successor after checking only its
execution-input binding and root context. It therefore does not establish an
immutable predecessor/successor candidate transition.

### P1 — operator-disposition semantics are incomplete

The named invalid-disposition fixture covers an empty reason and reaches the
private `OPERATOR_DISPOSITION_INVALID` predicate. A structurally valid
`{action: "omit", reason: "operator-approved"}` instead terminates as
`A04_SEMANTIC_MISMATCH`; the boundary has no complete normalized outcome for
that semantic branch.

## Confirmed non-blocking controls

- The A04 partition is exactly `35 main + 5 supplemental + 9 snapshot = 49`.
- The four A05-only names are absent from the A04 denominator.
- The dispatcher captures private policy rows and resists public mapping
  mutation/rebinding.
- No additional controlling defect was independently confirmed in JCS, schema
  closure, readiness trust/freshness, G4–G6 authentication/lineage, Git
  snapshots, CAS, D12/D14, or the disposable OpenSpec boundary.
- One initial tester OpenSpec fetch failed due DNS; the isolated pinned v1.11.0
  retry passed. This environmental incident is not the rejection reason.

## Authority and stop condition

C12 consumed the eighth and final operator-authorized extra correction round.
This receipt grants no ninth correction, acceptance, promotion, deployment,
namespace activation, reader retirement, Plane closure, or Phase-2 entry.
CODEX-26 must remain open and Phase 1 must remain blocked until the operator
issues a new explicit disposition.

Any future correction must begin from a new successor candidate and must add
independent normative expected-value fixtures rather than deriving all expected
values from the implementation under test.
