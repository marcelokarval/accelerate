# Codex Agent Routing Hardening Traceability

## Authority

- ID: `TRACE-CODEX-AGENT-ROUTING-001`
- Status: `generation 11 closed / Plane FINISH readback observed`
- Governing issue: `CODEX-3`
- Source SDD:
  `../architecture/2026-08-13-codex-agent-routing-hardening-sdd.md`
- Focused test: `../../tests/codex-agent-routing-hardening.sh`
- Baseline evidence:
  `../evidence/dated-proof-appendix/codex-agent-routing-hardening-red-2026-08-13.md`
- Historical generation 1 proof:
  `../evidence/dated-proof-appendix/codex-agent-routing-hardening-green-2026-08-13.md`
- Rule: every requirement appears exactly once; `T1` through `T7` are the exact
  ordered correction denominator.

## Requirement Matrix

| Order | Requirement | Task | Stable case | Exact test locator | Generation 0 baseline | Generation 1 proof | Generation 2 proof history | Generation 3 historical disposition | Owner / independent reviewer |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `REQ-ROUTER-001` | `T1` | `CASE-ROUTER-001` | `tests/codex-agent-routing-hardening.sh`; `tests/skill-catalog-router-index-atomicity.sh` | observed-red: repo router missing | narrow GREEN, now stale | observed-green: 112/112 parity and atomic anti-symlink writer | observed-green in generation 3 focused/affected/full proof | router implementer / governance reviewer |
| 2 | `REQ-SPAWN-002` | `T2` | `CASE-SPAWN-002` | `tests/codex-agent-routing-hardening.sh` | observed-red: no path/hash records | narrow GREEN, now stale | observed-green: every logical specialist renders exact path/hash records | observed-green in generation 3 focused/affected/full proof | runtime adapter implementer / security-governance reviewer |
| 3 | `REQ-ALIASES-003` | `T3` | `CASE-ALIASES-003` | `tests/codex-agent-routing-hardening.sh`; `tests/codex-skill-catalog-installer-ownership.sh`; `tests/global-skill-sync-generation-rollback.sh` | observed-red: seven raw aliases launchable | narrow GREEN, now stale | observed-green: reinstall/rollback coverage before second review | observed-green: post-sync rollback drift and stale logical ownership across catalog evolution are protected | installer implementer / runtime reviewer |
| 4 | `REQ-ROUTES-004` | `T4` | `CASE-ROUTES-004` | `tests/codex-agent-routing-hardening.sh`; `tests/codex-skill-catalog-installer-ownership.sh` | observed-red: `data-db` agent missing | narrow GREEN, now stale | observed-green: both logical routes installed and preserved under catalog reinstall | observed-green: logical ownership survives catalog evolution and reinstall | topology implementer / agent-contract reviewer |
| 5 | `REQ-DOCTRINE-005` | `T5` | `CASE-DOCTRINE-005` | `tests/codex-agent-routing-hardening.sh` | observed-red: six-family doctrine diverges | narrow GREEN, now stale | observed-green in focused and full regression proof | observed-green in generation 3 focused/affected/full proof | doctrine implementer / architecture reviewer |
| 6 | `REQ-READONLY-006` | `T6` | `CASE-READONLY-006` | `tests/codex-agent-routing-hardening.sh` | observed-red: return/persistence boundary missing | narrow GREEN, now stale | observed-green in focused and full regression proof | observed-green in generation 3 focused/affected/full proof | template implementer / independence reviewer |
| 7 | `REQ-LIMIT-007` | `T7` | `CASE-LIMIT-007` | `tests/codex-agent-routing-hardening.sh` | observed-red: configured limit `8` rejected | narrow GREEN, now stale | observed-green for exact int limits 8..20 and complete eight-line packets | observed-green in generation 3 focused/affected/full proof | packet implementer / runtime reviewer |

## Generation 2 Review Findings

| Finding | Severity | Exact current failure |
| --- | --- | --- |
| `G2-F1` | P1 | managed catalog/index divergence breaks the `research` Spawn Packet; `codex`, `plane`, and `using-superpowers` are absent from the index |
| `G2-F2` | P1 | standalone catalog reinstall deletes logical-owned `data-db` and `integrations-ops` profiles |
| `G2-F3` | P1 | `build_index.py --write` follows an `index.tsv` symlink outside the repository |
| `G2-F4` | P1 | rollback receipt validation depends on future/current topology and fails after source/topology drift |
| `G2-F5` | P2 | `rollback_command` is not validated exactly |

These findings were corrected and reproved at generation 2. They remain
historical context, not current defects.

## Generation 3 Reentry Findings

| Finding | Severity | Exact generation 2 review failure | Current disposition |
| --- | --- | --- | --- |
| `G3-F1` | P1 | rollback overwrites or deletes a receipt target after that installed target drifted before preflight | corrected and reproved with preflight and fail-closed behavior for pre-existing drift |
| `G3-F2` | P1 | stale logical ownership across catalog evolution can be lost during a later catalog reinstall | corrected and reproved by preserving ownership declared by the existing target and delegating retirement to its owner or explicit migration |

## Completeness And State Rule

The matrix has seven unique requirements, tasks, and cases in the accepted
order. Generation 0 RED and generation 1 narrow GREEN are historical evidence.
Generation 2 focused, affected, full-suite, global-mirror and fresh-process
proof was observed, but the second independent review failed that snapshot for
closure with `G3-F1` and `G3-F2`; it remains stale history. Generation 3 later
produced honest RED/GREEN correction evidence, focused `7/7`, affected and full
suite PASS, transactional runtime sync, mirror parity and fresh runtime proof.
Its later independent review also failed closure, as recorded below; generation
3 is historical rather than the current execution state.

## Generation 4 Reentry Findings

| Order | Finding | Severity | Exact generation 3 review failure | Current disposition |
| --- | --- | --- | --- | --- |
| 1 | `G4-F1` | P1 | shape plus mtime allowed backdated tampered `data-db` content to be preserved and relabelled as logical-owned | corrected and reproved: digest-bound logical ownership receipt |
| 2 | `G4-F2` | P2 | installed runtime configs can remain mode `0664` | corrected and reproved: exact `0600` on runtime configs and `0700` on backup directories |
| 3 | `G4-F3` | P2 | cooperative TOCTOU remains between classification/preflight and mutation | corrected and reproved: shared cooperative single-writer lock across governed mutators |

Generation 3 proof and runtime installation remain preserved as stale history.
Generation 4 focused/full proof, schema-4 sync, mirror and fresh runtime proof
were observed, but independent review failed that snapshot for closure.

## Generation 5 Reentry Findings

| Order | Finding | Severity | Exact generation 4 review failure | Current disposition |
| --- | --- | --- | --- | --- |
| 1 | `G5-F1` | P1 | inherited FD matches the exact lock inode but does not prove held `flock` ownership | corrected and reproved: held lock ownership is proven |
| 2 | `G5-F2` | P1 | rollback performs material validation before lock acquisition | corrected and reproved: lock precedes decisive validation |
| 3 | `G5-F3` | P2 | combined sync leaves logical ownership receipt schema 1/mode `0664` and catalog ownership receipt absent | corrected and reproved: both receipts are schema 2/mode `0600` and rollback-aware |

Correction/proof generation 5 focused/full proof, schema-4 sync, mirror,
schema-2 ownership receipts and fresh runtime proof were observed, but final
independent review failed closure.

## Generation 6 Reentry Finding

| Finding | Severity | Exact generation 5 review failure | Current disposition |
| --- | --- | --- | --- |
| `G6-F1` | P1 | all four mutators accepted unlocked inherited OFD-B while legitimate OFD-A held the lock; exact inode identity did not prove inherited-FD ownership | corrected and reproved: direct nonblocking `flock` on inherited FD with exact three-state proof |

Correction/proof generation 6 lock/affected and full proof, schema-4 sync,
mirror, schema-2 receipts and fresh runtime proof were observed. Final
independent review failed closure, so generation 6 is stale history.

## Generation 7 Reentry Finding

| Finding | Severity | Exact generation 6 review failure | Current disposition |
| --- | --- | --- | --- |
| `G7-F1` | P1 | sync followed by a supported standalone logical reinstall rewrites only the logical ownership receipt, changes its `installed_digest`, and invalidates the schema-4 rollback | corrected and reproved: canonical configs, modes, ownership, and hashes are byte-idempotent and rollback-valid; real changes still update |

Correction/proof generation 7 affected and full proof, schema-4 sync, mirror,
schema-2 receipts and fresh runtime proof were observed. Final independent
review failed closure, so generation 7 is stale history.

## Generation 8 Reentry Findings

| Order | Finding | Severity | Exact generation 7 review failure | Current disposition |
| --- | --- | --- | --- | --- |
| 1 | `G8-F1` | P2 | logical fast path accepts state outside CODEX_HOME rollback/backup history | corrected and reproved: fast path contained to covered history |
| 2 | `G8-F2` | P1 | receipt path directory plus real drift can partially mutate profiles before final receipt replace fails | corrected and reproved after `G8-F1`: receipt destination preflight before mutation plus late transactional publication |

Correction/proof generation is `8`; focused/affected/full proof, schema-4 sync,
mirror, schema-2 receipts and fresh runtime proof are observed. `G8-F2` RED is
review-observed; the implementer path failed earlier at fail-fast and therefore
did not independently reproduce that exact RED before the root GREEN regression.
Final review confirmed the fixes but failed closure, so generation 8 is stale.
The cooperative lock does not govern non-cooperating
direct same-user filesystem writes and is not a cryptographic-authenticity or
universal-linearizability guarantee.

## Generation 9 Reentry Finding

| Finding | Severity | Exact generation 8 review failure | Current disposition |
| --- | --- | --- | --- |
| `G9-F1` | P2 | logical fast path accepts a receipt-updated renamed backup within CODEX_HOME/backups and mode `0666`, while catalog validation requires exact target-to-backup identity | corrected and reproved: target-bound exact backup identity and mode `0600`; rename/swap/suffix/hardlink/symlink/missing/outside matrix passes |

Correction/proof generation is `9`; focused `7/7`, catalog `131/root13`, quality
`11/11+6/6`, lifecycle `10/10`, full-suite, schema-4 sync, mirror, mode-0600
receipts/configs and fresh root plus seven-specialist runtime proof are observed.
Concurrent `playwright-patterns` source/runtime preservation was byte-exact and
the 112-route index was regenerated. Final review failed closure, so generation
9 is stale history.

## Generation 10 Reentry Findings

| Order | Finding | Severity | Exact generation 9 review failure | Current disposition |
| --- | --- | --- | --- | --- |
| 1 | `G10-F1` | P1 | catalog late-publication failure leaves temp+backup and restored target mode drift | corrected and GREEN: transactional rollback/cleanup |
| 2 | `G10-F2` | P2 | catalog no-op accepts hardlinked receipt `nlink=2` | corrected and GREEN: regular/non-symlink/nlink1/owner/mode0600 identity |
| 3 | `G10-F3` | P2 | catalog accepts mismatched declared rollback_directory while logical rejects | corrected and GREEN: unique rollback-directory identity across validators |

Correction/proof generation is `10`; three separate REDs then GREEN, focused/
affected/full, schema-4 sync, mirror, exact receipt identity and fresh runtime
proof were observed. G10 receipt
`/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G10-20260813T190557Z/sync-receipt.json`
was schema 4/installed, SHA
`d80ac01e89b053261406a5884e41e2f75594476bd7b3c59985795e1334fe9d18`,
with 130 operations = 112 package + 18 runtime-file, 124 replace + 6 delete.
Catalog/logical receipts were schema 2, mode `0600`, `nlink=1`, with SHA
`e669404c024093815552d0d2bd793d37f7637243334c001189015464c2953837`
and `e4cf5ae7b036f2470527e8559fc69d75cbfc45d59ea65edb7d870c31575aff98`.
G10 runtime evidence became historical only after external drift.

## Generation 11 Documentary Reentry

| Finding | Severity | Contract-review RED | Initial disposition |
| --- | --- | --- | --- |
| `G11-F1` | P2 | governing dashboard, traceability and task ledger remained stale or contradictory after G10 | corrected and reproved at documentary generation `11/11`; static JSON/YAML/link/whitespace proof passed |
| `G11-F2` | P1 closure blocker | external drift changed `~/.codex/config.toml` effort to `low` after G10 receipt while topology requires `medium`; mirror root plus seven failed | recovered by governed G11 resync; root Sol/medium, mirror and fresh root plus seven PASS |

G10 implementation evidence remains current and accepted. G11 documentary
proof is GREEN. G10 runtime evidence was invalidated by external drift and is
historical; G11 governed resync and fresh runtime proof passed. Overall current
GREEN is true. G11 receipt
`/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G11-20260813T192112Z/sync-receipt.json`
is schema 4/installed, SHA
`5f7ba0e0fd1279f8fbf26fd895b1a3dc262f363817fc7d2eef32b3236bbee9e6`;
root Sol/medium, mirror and fresh root plus seven PASS. Two independent reviews
returned `ACCEPTED` with zero P0-P3 findings; root review-of-review and forensic
closure passed. Evidence:
`../evidence/dated-proof-appendix/codex-agent-routing-hardening-independent-review-2026-08-13.md`.
Plane REVIEW, Done transition, FINISH and final provider readback passed.
