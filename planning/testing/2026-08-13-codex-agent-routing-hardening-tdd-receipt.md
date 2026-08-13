# Codex Agent Routing Hardening TDD Receipt

## Identity And Generations

- Receipt ID: `TDD-RECEIPT-CODEX-AGENT-ROUTING-001`
- Governing requirements: `REQ-ROUTER-001` through `REQ-LIMIT-007`
- Governing issue: `CODEX-3`
- Change kind: `governance`
- Proof mode: `semantic-contract`
- Implementation owner: `accelerate-root`
- Test/fixture writer: `codex3-red-test-writer`
- Independent reviewer: `codex3-final-independent-reviewers`
- Correction generation: `11`
- Proof generation: `11`
- State: `reviewed`
- Independent review verdict: `pass`

## Baseline Evidence

- Baseline status: `observed-red`
- Baseline locator: `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-red-2026-08-13.md`
- Command: `bash tests/codex-agent-routing-hardening.sh`
- Fixture: current repo-owned catalog/topology/policy/doctrine/templates plus a
  disposable temporary Codex home and a derived limit-eight topology
- Observed at: `2026-08-13T09:03:01-04:00`
- Exit status: `1`
- Result: `pass=0 red=7 total=7`
- Test SHA-256:
  `7745f3f5e362fe5cd64f2c9447057f8a9ace9c508add9e78edad6120590fe107`
- Baseline repository commit:
  `7cb65f1b16b2fe8d84c379cf5a7069263d8afef2`
- Interpretation: all seven failures identify missing accepted behavior. The
  valid receipt is the second run after correcting a harness return-propagation
  defect; the discarded first run is not used as RED evidence.

## Generation 1 Correction Evidence

- Historical evidence status: `observed-green / stale for generation 2`
- Historical evidence locator:
  `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-green-2026-08-13.md`
- Historical correction generation: `1`
- Historical proof generation: `1`
- Historical result: focused `7/7`, affected suites, and `tests/all.sh` passed
  locally before independent review exposed uncovered behavior.

Generation 1 implementation and narrow GREEN are claimed only as historical
evidence. They do not authorize current promotion because independent review
invalidated that proof denominator.

## Generation 2 Correction Evidence

- Historical evidence status: `observed-green / stale for generation 3`
- Historical evidence locator:
  `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-green-2026-08-13.md#generation-2-historical-proof`
- Historical correction generation: `2`
- Historical proof generation: `2`
- Historical independent review verdict: `fail`
- Historical disposition: repository proof, global sync, and fresh-process
  runtime proof were observed, but the second independent review rejected the
  generation 2 snapshot for closure.

| Finding | Severity | RED condition |
| --- | --- | --- |
| `G2-F1` | P1 | managed catalog/index divergence breaks the `research` Spawn Packet because `codex`, `plane`, and `using-superpowers` are absent from the index |
| `G2-F2` | P1 | standalone catalog reinstall deletes logical-owned `data-db` and `integrations-ops` profiles |
| `G2-F3` | P1 | `build_index.py --write` follows an escaping index symlink |
| `G2-F4` | P1 | rollback receipt validation depends on future/current topology and fails after drift |
| `G2-F5` | P2 | `rollback_command` is not validated exactly |

Stale evidence excluded from current promotion includes all generation 1 GREEN
output and all generation 2 proof after `G3-F1` and `G3-F2` reopened correction.

## Generation 3 Correction Evidence

- Correction evidence status: `observed-green`
- Correction evidence locator: `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-green-2026-08-13.md#generation-3-current-proof`
- Correction generation: `3`
- Proof generation: `3`
- At-generation disposition: `reproved / independent-review-pending`

| Finding | Severity | Honest RED condition | Current correction/proof |
| --- | --- | --- | --- |
| `G3-F1` | P1 | rollback overwrote or deleted post-sync target drift in the pre-correction fixture | corrected and GREEN: complete receipt denominator is preflighted and drift aborts before mutation |
| `G3-F2` | P1 | stale logical ownership across catalog evolution was lost by a later catalog reinstall | corrected and GREEN: existing logical ownership is preserved; retirement stays with the logical owner or explicit migration |

Generation 3 proof includes focused `7/7`, affected suites, the final full
`PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh` rerun, transactional real runtime
sync, mirror parity and fresh runtime proof. The focused test SHA-256 is
`e93f2fc65b3208032a730602c8e8dd6956857b831fd2c991110ca1890afd632e`.
An earlier full-suite attempt hit a legacy browser-monitoring race; its isolated
test passed afterward, but neither result is used as final suite evidence. Only
the subsequent clean full-suite PASS was retained as generation 3 evidence.

Final independent review verdict for generation 3: `fail` for closure. The
generation 3 proof is now stale after `G4-F1` through `G4-F3` reopened correction.

## Generation 4 Correction Evidence

- Correction evidence status: `observed-green`
- Correction evidence locator: `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-green-2026-08-13.md#generation-4-current-proof`
- Correction generation: `4`
- Proof generation: `4`
- At-generation disposition: `reproved / independent-review-pending`

| Order | Finding | Severity | RED condition | Required correction |
| --- | --- | --- | --- | --- |
| 1 | `G4-F1` | P1 | shape plus mtime launders backdated tampered `data-db` content into logical ownership | corrected and GREEN with digest-bound logical ownership receipt |
| 2 | `G4-F2` | P2 | installed configs may retain mode `0664` | corrected and GREEN with exact installed mode `0600` |
| 3 | `G4-F3` | P2 | cooperative TOCTOU exists after classification/preflight | corrected and GREEN with shared cooperative single-writer lock across governed mutators |

Generation 4 focused cases, final full suite, transactional sync/mirror and
fresh runtime proof are observed. The lock coordinates governed cooperative
mutators; non-cooperating direct filesystem writes and cryptographic
authenticity remain outside its guarantee.

Final independent review verdict for generation 4: `fail` for closure. The
generation 4 proof is stale after `G5-F1` through `G5-F3` reopened correction.

## Generation 5 Correction Evidence

- Correction evidence status: `observed-green`
- Correction evidence locator: `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-green-2026-08-13.md#generation-5-current-proof`
- Correction generation: `5`
- Proof generation: `5`
- At-generation disposition: `reproved / independent-review-pending`

| Order | Finding | Severity | RED condition | Required correction |
| --- | --- | --- | --- | --- |
| 1 | `G5-F1` | P1 | exact inherited lock inode does not prove held `flock` ownership | corrected and GREEN: held lock ownership is proven |
| 2 | `G5-F2` | P1 | rollback validates material receipt state before acquiring the lock | corrected and GREEN: lock precedes decisive validation |
| 3 | `G5-F3` | P2 | combined sync leaves logical ownership receipt schema 1/mode `0664` and catalog receipt absent | corrected and GREEN: catalog/logical receipts schema 2/mode `0600` are transactional and rollback-aware |

Generation 5 focused lock/mirror/rollback/ownership/logical/routing cases, final
full suite, transactional sync/mirror and fresh runtime proof are observed.

Final independent review verdict for generation 5: `fail` for closure. The
generation 5 proof is stale after `G6-F1` reopened correction.

## Generation 6 Correction Evidence

- Correction evidence status: `observed-green`
- Correction evidence locator: `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-green-2026-08-13.md#generation-6-current-proof`
- Correction generation: `6`
- Proof generation: `6`
- At-generation disposition: `reproved / independent-review-pending`

| Finding | Severity | RED condition | Required correction |
| --- | --- | --- | --- |
| `G6-F1` | P1 | four mutators accept unlocked inherited OFD-B while legitimate OFD-A holds the lock | corrected and GREEN: direct nonblocking `flock` with spoof rejection, same-OFD acceptance and no-inheritance acquisition |

Generation 6 direct-flock and affected tests, final full suite, transactional
sync/mirror and fresh runtime proof are observed.

Final independent review verdict for generation 6: `fail` for closure. The
generation 6 proof is stale after `G7-F1` reopened correction.

## Generation 7 Correction Evidence

- Correction evidence status: `observed-green`
- Correction evidence locator: `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-green-2026-08-13.md#generation-7-current-proof`
- Correction generation: `7`
- Proof generation: `7`
- At-generation disposition: `reproved / independent-review-pending`

| Finding | Severity | Honest RED condition | Required correction |
| --- | --- | --- | --- |
| `G7-F1` | P1 | sync followed by a supported standalone logical reinstall rewrites only the logical ownership receipt, changes its `installed_digest`, and invalidates schema-4 rollback | corrected and GREEN: canonical state is byte-idempotent and rollback-valid; real changes still update the affected config and receipt |

Generation 7 affected and full-suite proof, transactional sync/mirror, schema-2
ownership receipts and fresh root plus seven-specialist runtime proof are
observed. Generations 1 through 6 remain stale history.

Final independent review verdict for generation 7: `fail` for closure. The
generation 7 proof is stale after `G8-F1` and `G8-F2` reopened correction.

## Generation 8 Correction Evidence

- Correction evidence status: `observed-green`
- Correction evidence locator: `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-green-2026-08-13.md#generation-8-current-proof`
- Correction generation: `8`
- Proof generation: `8`
- At-generation disposition: `reproved / independent-review-pending`

| Order | Finding | Severity | Honest RED condition | Required correction |
| --- | --- | --- | --- | --- |
| 1 | `G8-F1` | P2 | logical fast path accepts state outside CODEX_HOME rollback/backup history | corrected and GREEN: fast path contained to covered rollback/backup history |
| 2 | `G8-F2` | P1 | reviewer observed receipt path directory plus real drift allowing partial profile mutation before final receipt replace fails; implementer hit earlier fail-fast and did not independently reproduce this exact RED | corrected and GREEN after `G8-F1`: preflight before mutation plus late transactional publication; root regression passes |

Generation 8 focused/affected/full proof, transactional sync/mirror, schema-2
ownership receipts and fresh root plus seven-specialist runtime proof are
observed. Generations 1 through 7 remain stale history.

Final independent review confirmed the generation 8 fixes but returned `fail`
for closure after `G9-F1` reopened correction. Generation 8 proof is stale.

## Generation 9 Correction Evidence

- Correction evidence status: `observed-green`
- Correction evidence locator: `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-green-2026-08-13.md#generation-9-current-proof`
- Correction generation: `9`
- Proof generation: `9`
- At-generation disposition: `reproved / independent-review-pending`

| Finding | Severity | Honest RED condition | Required correction |
| --- | --- | --- | --- |
| `G9-F1` | P2 | within CODEX_HOME/backups, logical fast path accepts a receipt-updated renamed backup and mode `0666` although catalog rejects noncanonical target-to-backup identity | corrected and GREEN: target-bound exact backup identity and mode `0600`; rename/swap/suffix/hardlink/symlink/missing/outside matrix passes |

Generation 9 focused, catalog, quality, lifecycle and full-suite proof,
transactional sync/mirror, mode-0600 configs/receipts and fresh root plus seven-
specialist runtime proof are observed. Concurrent `playwright-patterns` content
was preserved byte-exact and the 112-route index regenerated.

Final independent review verdict for generation 9: `fail` for closure.

## Generation 10 Correction Evidence

- Correction evidence status: `observed-green`
- Correction evidence locator: `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-green-2026-08-13.md#generation-10-current-proof`
- Correction generation: `10`
- Proof generation: `10`
- At-generation disposition: `reproved / independent-review-pending`

| Order | Finding | Severity | RED condition | Required correction |
| --- | --- | --- | --- | --- |
| 1 | `G10-F1` | P1 | late publication leaves temp+backup and mode drift | corrected and GREEN: transactional rollback/cleanup |
| 2 | `G10-F2` | P2 | hardlinked receipt nlink2 accepted | corrected and GREEN: exact regular/non-symlink/nlink1/owner/mode0600 identity |
| 3 | `G10-F3` | P2 | mismatched rollback_directory accepted by catalog | corrected and GREEN: unique declared rollback-directory identity |

All three findings have separate honest RED evidence and subsequent GREEN.

## Generation 11 Documentary Correction Evidence

- Correction evidence status: `observed-green`
- Correction evidence locator: `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-green-2026-08-13.md#generation-11-documentary-proof`
- Correction generation: `11`
- Proof generation: `11`
- Current disposition: `reviewed / root-forensic-pass / Plane-FINISH-readback / closed`

| Finding | Kind | RED condition | Disposition |
| --- | --- | --- | --- |
| `G11-F1` | P2 documentary contract | dashboard, traceability and ledger were stale/contradictory after G10 | corrected; JSON/YAML/link/whitespace static proof observed |
| `G11-F2` | P1 runtime closure blocker | external drift set root effort `low` while topology requires `medium`; mirror root plus seven failed | governed G11 resync restored Sol/medium; mirror and fresh root plus seven PASS |

## Final Independent Review And Forensic Evidence

- Review evidence locator: `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-independent-review-2026-08-13.md`
- Independent reviewers: `codex3_generation2_contract_review` and
  `codex3_runtime_security_review`; both `ACCEPTED`.
- Open findings: `P0=0, P1=0, P2=0, P3=0`.
- Root review-of-review verdict: `pass`.
- Forensic closure review: `observed`.
- Plane REVIEW, Done work-item readback, FINISH and final provider readback
  passed.

## Proof Order

| Lane | Status | Current disposition |
| --- | --- | --- |
| Implementation proof | observed | three separate G10 REDs then GREEN; focused affected suites pass |
| Backend/frontend QA | observed | G10 implementation/full-suite proof remains accepted; G11 documentary static proof passes |
| Browser truth | not-applicable | no product UI or browser flow is changed |
| Persistent regression | not-applicable | repository contract suites and fresh Codex runtime replay are the effective layers |
| Forensic closure review | observed | two ACCEPTED reviews and root review-of-review/forensic pass |

## Root Boundary

This receipt satisfied repository review and forensic gates but did not, by
itself, authorize the Plane transition. Root subsequently performed and
verified governed REVIEW, Done, FINISH and final readback; no lifecycle action
remains pending.
