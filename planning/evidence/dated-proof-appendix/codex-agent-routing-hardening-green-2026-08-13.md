# CODEX-3 Agent Routing Hardening GREEN Receipt

## Status

- Proof status: `observed-green`
- Current promotion state: `generation 11 closed / Plane FINISH readback observed`
- Governing issue: `CODEX-3`
- Observed at: `2026-08-13T10:19:53-04:00`
- Observed correction generation: `2`
- Observed proof generation: `2`
- Current correction generation: `11`
- Current proof generation: `11`
- Focused test SHA-256: `e93f2fc65b3208032a730602c8e8dd6956857b831fd2c991110ca1890afd632e`

## Current Disposition

Generation 1 narrow GREEN is retained below as historical evidence. Independent
review invalidated it after finding `G2-F1` through `G2-F5`. Generation 2 then
corrected and freshly reproved those defects, including transactional deployment
and fresh-process runtime proof. A second independent review failed the frozen
generation 2 snapshot for closure with `G3-F1` and `G3-F2`. Generation 3 now
contains honest RED/GREEN for both findings, same-generation local and runtime
proof, and a new transactional sync. Generations 1 and 2 remain stale history;
Final independent review failed generation 3 closure with `G4-F1` through
`G4-F3`. Generations 4 and 5 were likewise corrected and reproved, then failed
their final closure reviews. Generation 6 corrected `G6-F1` and observed local
and runtime proof, but its final review failed on `G7-F1`. Generations 1 through
6 were already stale history; final independent review also failed generation 7
closure with `G8-F1` and `G8-F2`. Generations 1 through 7 are now stale history;
final review confirmed the generation 8 fixes but failed closure on `G9-F1`.
Generations 1 through 8 were already stale history; generation 9 was current at
that checkpoint, then failed independent closure review on `G10-F1` through
`G10-F3`. The current disposition is generation 11, recorded below.

## Generation 2 Historical Proof

- Router index: 112 repo-owned managed routes, exact manifest parity, SHA-256
  `2ccfe766da72291e797ff70361f99be64189c8f6ca06a221243c6f2b61370904`.
- Focused hardening: `pass=7 red=0 total=7`.
- Atomic router writer: PASS, including destination/parent symlink rejection,
  atomic replace failure and cleanup.
- Catalog installer ownership: PASS, including catalog -> logical -> catalog
  reinstall and repeat idempotency.
- Generation rollback: PASS, including source/topology drift, exact
  `rollback_command`, tampering and second rollback.
- Full repository command: `PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh`.
- Full repository result: exit `0`, final line `all tests passed`.
- Global mirror command: `CODEX_HOME=/home/marcelo-karval/.codex bash
  scripts/check-global-skill-mirror.sh`.
- Global mirror result: PASS; static installed-state parity observed.
- Fresh process command: `CODEX_RUNTIME_PROOF=1 PYTHONDONTWRITEBYTECODE=1 bash
  tests/codex-logical-agent-runtime-proof.sh`.
- Fresh process result: exit `0`, `codex logical agent runtime proof passed` for
  the real root plus seven logical specialists.
- Sync receipt: schema `4`, status `installed`, 112 packages and 16 runtime
  files at `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-20260813T141030Z/sync-receipt.json`.
- Receipt SHA-256:
  `4f4274702e9fa24f7270aa2768c88c183637431254596ecb457a04562e3393e2`.
- Rollback argv: `/bin/bash
  /home/marcelo-karval/worktrees/codex-1-global-skill-catalog/scripts/rollback-global-skill-sync.sh
  /home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-20260813T141030Z/sync-receipt.json`.

## Generation 3 Current Proof

- `G3-F1` (`P1`) honest RED: rollback overwrote or deleted a receipt target that
  changed before preflight. GREEN: the receipt denominator is preflighted and
  detected pre-existing drift aborts before mutation. This did not prove the
  cooperative post-preflight mutation window closed.
- `G3-F2` (`P1`) honest RED: stale logical ownership across catalog evolution
  was lost by a later catalog reinstall. GREEN: existing logical-agent ownership
  is preserved, with retirement reserved for its owner or an explicit migration.
- Correction generation: `3`.
- Proof generation: `3`.
- Correction state: `reproved`.
- Focused proof: `pass=7 red=0 total=7`.
- Affected proof: PASS, including catalog-installer ownership and
  generation-bound rollback suites.
- Full repository command:
  `PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh`.
- Full repository final rerun: exit `0`, final line `all tests passed`.
- Earlier full-suite attempt: excluded from current proof after a legacy
  browser-monitoring race; the isolated test passed, then only the subsequent
  clean full-suite rerun was retained as final evidence.
- Router index SHA-256:
  `cc0f5355972528bf5cc3c81354ab262a3afbb429dd581d0da0a1e6ee40e1d08b`.
- Rollback script SHA-256:
  `578993a6c6ba890f4db3be0ccd9e61b64e7d44dcb08575b6cbb3f7e496fe84c3`.
- Catalog installer SHA-256:
  `dbbe4a0566d5eb8b6b1312bc746392d388bf8e5bc72186f6282b5e64e91db7f0`.
- Generation 3 sync receipt: schema `4`, status `installed`, 112 packages and
  16 runtime files at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G3-20260813T151014Z/sync-receipt.json`.
- Receipt SHA-256:
  `4d00d1a8edadfc832b09825210a433afb8a4e92bfa49bd83e4a409d9c23a447e`.
- Global mirror readback: PASS.
- Fresh runtime proof: PASS for root plus seven logical specialists; root will
  retain the final clean rerun output for closure review.
- Independent review: `pending`.
- Forensic closure: `pending`.

Generation 3 implementation, QA, sync/mirror and fresh-runtime proof were
observed. Final independent review verdict is FAIL for closure.

## Generation 4 Current Proof

- `G4-F1` (`P1`) honest RED/GREEN: shape plus mtime accepted backdated tampered
  `data-db`; digest-bound logical receipt now rejects laundering.
- `G4-F2` (`P2`) honest RED/GREEN: installed runtime configs could retain
  `0664`; base and seven logical profiles now prove exact `0600` and backup
  directories prove `0700`.
- `G4-F3` (`P2`) honest RED/GREEN: cooperative TOCTOU existed between
  classification/preflight and mutation; governed mutators now share one
  cooperative single-writer lock.
- Correction order: `G4-F1 -> G4-F2 -> G4-F3`.
- Correction generation: `4`.
- Proof generation: `4`.
- Focused proof: all root-focused cases PASS.
- Full repository command: `PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh`.
- Full repository result: exit `0`, final line `all tests passed`.
- G4 sync receipt: schema `4`, status `installed`, operation denominator `128`
  (`112` package operations plus `16` runtime operations), at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G4-20260813T154500Z/sync-receipt.json`.
- `changed_packages`: `0`; package bytes were unchanged, so this receipt does
  not claim 112 packages changed.
- Receipt SHA-256:
  `b38ca01a6e508cb0fd13aa4c40008ac61e47fcb656db4a6519ff33567636ed38`.
- Mirror parity: PASS.
- Runtime modes: exact `0600` on base and seven logical profiles and the lock;
  backup directories mode `0700`.
- Fresh runtime proof: PASS for root plus seven logical specialists.
- Catalog installer SHA-256:
  `388eb3075b7bf82b385df685eacecadd85bf010ed5fd0b507a7ea60473ed58ec`.
- Logical installer SHA-256:
  `22d1e5ca45c2d96737f4c87385cb97997b89fd5bb1257e41102b5f323c53d435`.
- Sync script SHA-256:
  `b624fb51c8db857558255da9a3a3f2adbf96cfcd2ddd9fea859ded789e71c05a`.
- Rollback script SHA-256:
  `25326c93bc12aa9ed16fcb4a25b1d5bfc1cc2cd104087ee0b3f3d599636566b4`.
- Lock test SHA-256:
  `419343ebe8228039d061aea95a8a52ad35b0e0892fd1576990adb2d9c46806a5`.

Generation 4 implementation, QA, sync/mirror and fresh-runtime proof were
observed. Final independent review verdict is FAIL for closure.

## Generation 5 Current Proof

- `G5-F1` (`P1`) honest RED/GREEN: inherited exact-inode FD did not prove held
  `flock`; held lock ownership is now proven.
- `G5-F2` (`P1`) honest RED/GREEN: rollback materially validated before lock;
  it now acquires before decisive validation and holds through mutation.
- `G5-F3` (`P2`) honest RED/GREEN: combined sync left standalone ownership
  receipts stale/absent; catalog and logical receipts are now transactionally
  reconciled at schema 2/mode `0600` with rollback.
- Correction order: `G5-F1 -> G5-F2 -> G5-F3`.
- Correction generation: `5`.
- Proof generation: `5`.
- Root-focused lock/mirror/rollback/ownership/logical/routing proof: PASS.
- Full repository command: `PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh`.
- Full repository result: exit `0`, final line `all tests passed`.
- G5 sync receipt: schema `4`, status `installed`, 130 operations, 112
  `changed_packages`, 18 runtime files, at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G5-20260813T163811Z/sync-receipt.json`.
- Sync receipt SHA-256:
  `bb7144111d59776b96b5554a410e5b817ec748482f315b9c8d15878d1995e170`.
- Catalog ownership receipt: schema `2`, mode `0600`, SHA-256
  `c2f4a36b2777ec2d01d80e97b161f26d60ff2f7a4ac3be00397780f852207e7c`.
- Logical ownership receipt: schema `2`, mode `0600`, SHA-256
  `e0742d81aa908bd5bb0cf4a7cc7c76da0accac644a1b214ee08ec469cfe3922d`.
- Configs and lock mode: exact `0600`.
- Mirror parity: PASS.
- Fresh runtime proof: PASS for root plus seven logical specialists.

Generation 5 implementation, QA, sync/mirror and fresh-runtime proof were
observed. Final independent review verdict is FAIL for closure.

## Generation 6 Current Proof

- `G6-F1` (`P1`) honest RED/GREEN: all four mutators accepted an unlocked inherited OFD-B while
  legitimate OFD-A held the lock; exact inode identity was mistaken for lock
  ownership.
- Correction: direct nonblocking `flock` on the inherited FD itself in all four
  mutators.
- Exact three-state proof: holder A plus spoof B rejects; legitimate shared OFD
  accepts; no inherited FD acquires normally.
- Correction generation: `6`.
- Proof generation: `6`.
- Root lock and affected proof: PASS.
- Full repository command: `PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh`.
- Full repository result: exit `0`, final line `all tests passed`.
- G6 sync receipt: schema `4`, status `installed`, 130 operations, 112 changed
  packages, 18 runtime files, at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G6-20260813T170900Z/sync-receipt.json`.
- Sync receipt SHA-256:
  `aa3a7c1d6bb23baba48e7947db6e9449f41898eb055c72014b264f8f5eb34c19`.
- Catalog ownership receipt: schema `2`, mode `0600`, SHA-256
  `de03e5f541c75fcf07ed2b0df53eeb87ca807818d285aec8a82d2ff3d43d51b2`.
- Logical ownership receipt: schema `2`, mode `0600`, SHA-256
  `5e339e4e7650c030cccbc48e6e4e2c5b30f9cf966a747ddf1dfb6230a5a3c887`.
- Mirror parity: PASS.
- Fresh runtime proof: PASS for root plus seven logical specialists.

Generation 6 implementation, QA, sync/mirror and fresh-runtime proof were
observed. Final independent review verdict is FAIL for closure.

## Generation 7 Current Proof

- `G7-F1` (`P1`) review RED: after sync, a supported standalone logical
  reinstall rewrites only the logical ownership receipt, changes its
  `installed_digest`, and invalidates the schema-4 rollback.
- Correction: when configs, modes, ownership, and hashes are already
  canonical, the logical installer must be byte-idempotent and preserve
  rollback validity; real changes must still update the affected config and
  receipt.
- Correction generation: `7`.
- Proof generation: `7`.
- Correction state: `reproved`.
- Affected proof: PASS.
- Full repository command: `PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh`.
- Full repository result: exit `0`, final line `all tests passed`.
- G7 sync receipt: schema `4`, status `installed`, 130 operations, 112 changed
  packages and 18 runtime files, at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G7-20260813T173220Z/sync-receipt.json`.
- Sync receipt SHA-256:
  `e751e656b49991619b2f95e77a2b8f5b7876a913aaa6beea02e030eca2435c0c`.
- Catalog ownership receipt: schema `2`, mode `0600`, SHA-256
  `0a2e753ddd183bd2c921593deb20b57b77767e8fb1574ad4f429a5dcbbe08cb6`.
- Logical ownership receipt: schema `2`, mode `0600`, SHA-256
  `e94ea5994a0084fd67bd055ade611c71079eccd72f253e6ea9492707776a7dbe`.
- Mirror parity: PASS.
- Fresh runtime proof: PASS for root plus seven logical specialists.
- Independent review: `pending`.
- Forensic closure: `pending`.

Generation 7 implementation, QA, sync/mirror and fresh-runtime proof were
observed. Final independent review verdict is FAIL for closure.

## Generation 8 Current Proof

- `G8-F1` (`P2`) review RED: the logical fast path accepts state outside
  CODEX_HOME rollback/backup history.
- `G8-F2` (`P1`) review RED: with the receipt path replaced by a directory and
  real profile drift, mutation can partially occur before the final receipt
  replacement fails. The implementer path hit an earlier fail-fast and did not
  independently reproduce this exact RED; the review observation is the baseline.
- Correction order: `G8-F1 -> G8-F2`.
- Correction: fast-path eligibility is contained to CODEX_HOME rollback/backup
  history, then the receipt destination is preflighted before any mutation and
  receipt publication remains late and transactional.
- Correction generation: `8`.
- Proof generation: `8`.
- Correction state: `reproved`.
- Focused and affected proof: PASS, including root regression for the
  review-observed `G8-F2` condition.
- Full repository command: `PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh`.
- Full repository result: exit `0`, final line `all tests passed`.
- G8 sync receipt: schema `4`, status `installed`, 130 operations, 112 changed
  packages and 18 runtime files, at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G8-20260813T175341Z/sync-receipt.json`.
- Sync receipt SHA-256:
  `167d70acc243fd400f7c273bb63093466a58b64829e267ef772248afd9b61b96`.
- Catalog ownership receipt: schema `2`, mode `0600`, SHA-256
  `8c308ecf8d557131f0232a9bbf4a0b8648ab157aa29478dc306e954403867062`.
- Logical ownership receipt: schema `2`, mode `0600`, SHA-256
  `b83435e017662f6768aeea414dc883c8856f56e92c1809aa7bb2f569e2043222`.
- Mirror parity: PASS.
- Fresh runtime proof: PASS for root plus seven logical specialists.
- Independent review: `pending`.
- Forensic closure: `pending`.

Generation 8 implementation, QA, sync/mirror and fresh-runtime proof are
observed. Final independent review verdict is FAIL for closure.

## Generation 9 Current Proof

- `G9-F1` (`P2`) review RED: within CODEX_HOME/backups, a renamed backup path
  reflected in the logical receipt plus mode `0666` is accepted by the logical
  fast path, while catalog validation rejects noncanonical target-to-backup
  identity.
- Correction: logical and catalog validators enforce target-bound exact backup
  identity and exact receipt mode `0600`; rename/swap/suffix/hardlink/symlink/
  missing/outside adversarial cases are rejected.
- Correction generation: `9`.
- Proof generation: `9`.
- Correction state: `reproved`.
- Focused routing: `7/7` PASS.
- Catalog: `131` cases and root `13` PASS.
- Quality: `11/11` plus `6/6` PASS.
- Lifecycle: `10/10` PASS.
- Full repository command: `bash tests/all.sh`.
- Full repository result: exit `0`, final line `all tests passed`.
- Concurrent `playwright-patterns` source/runtime preservation: byte-exact;
  route index regenerated with 112 entries.
- G9 sync receipt: schema `4`, status `installed`, 130 operations (`112`
  package plus `18` runtime-file; `124` replace plus `6` delete), at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G9-20260813T182536Z/sync-receipt.json`.
- Sync receipt SHA-256:
  `9d7c826b9e26f14a0692f427ba92e943b99769c37f1a6af6d0cb556d0a3ffd06`.
- Catalog receipt: schema `2`, mode `0600`, SHA-256
  `45d34f0f586a45102d0bc32ad781d5d0c3e0206f325bcfe5ce7c4476a20b32e5`.
- Logical receipt: schema `2`, mode `0600`, SHA-256
  `266c5fcb54509e07d3332627b696ff362ad4cd445c0af5ea6c904ffd30a8e900`.
- All configs, profiles and receipts: mode `0600`.
- Mirror parity: PASS.
- Fresh runtime proof: PASS for root plus seven logical specialists.
- Independent review: `pending`.
- Forensic closure: `pending`.

Generation 9 implementation, QA, sync/mirror and fresh-runtime proof are
observed. Final independent review verdict is FAIL for closure.

## Generation 10 Current Proof

- `G10-F1` P1: separate RED then GREEN for transactional rollback/cleanup.
- `G10-F2` P2: separate RED then GREEN for exact regular, non-symlink,
  `nlink=1`, owner and mode-`0600` receipt identity.
- `G10-F3` P2: separate RED then GREEN for unique declared rollback-directory
  identity across validators.
- Correction order: `G10-F1 -> G10-F2 -> G10-F3`.
- Correction generation: `10`; proof generation: `10`.
- Correction state: `reproved`.
- Focused catalog/logical/mirror/generation-rollback/lock/routing: PASS.
- Routing: `7/7`; catalog: `131`, root: `13`; quality: `11+6`; specification:
  `10`; host export and index `112`: PASS.
- Full command: `PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh`.
- Full result: exit `0`, final line `all tests passed`.
- G10 production sync receipt: schema `4`, status `installed`, 130 operations
  (`112` package + `18` runtime-file; `124` replace + `6` delete), at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G10-20260813T190557Z/sync-receipt.json`.
- Sync receipt SHA-256:
  `d80ac01e89b053261406a5884e41e2f75594476bd7b3c59985795e1334fe9d18`.
- Catalog receipt: schema `2`, mode `0600`, `nlink=1`, SHA-256
  `e669404c024093815552d0d2bd793d37f7637243334c001189015464c2953837`.
- Logical receipt: schema `2`, mode `0600`, `nlink=1`, SHA-256
  `e4cf5ae7b036f2470527e8559fc69d75cbfc45d59ea65edb7d870c31575aff98`.
- Mirror: PASS; fresh runtime root plus seven specialists: PASS.
- All configs, profiles and receipts: mode `0600`, `nlink=1`.
- Independent review: two `ACCEPTED`, zero P0-P3 findings.
- Root review-of-review and forensic closure: `pass` / `observed`.
- Review evidence:
  `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-independent-review-2026-08-13.md`.
- Plane REVIEW, Done transition, FINISH and final provider readback: `passed`.

Generation 10 implementation, QA and runtime proof are observed. No closure is
claimed before independent review and forensic closure.

## Generation 11 Documentary Proof

- `G11-F1` (`P2`) contract-review RED: governing dashboard, traceability and
  task ledger were stale or contradictory after G10.
- Correction/proof generation: `11/11`.
- JSON/YAML parse: PASS.
- Markdown link integrity: PASS.
- Governed-file whitespace validation: PASS.
- Documentary correction status: `observed-green`.
- `G11-F2` P1 runtime closure blocker: external post-G10-sync
  drift set `~/.codex/config.toml` reasoning effort to `low` while topology
  requires `medium`; mirror root plus seven fails.
- `G11-F2` is not a code defect. G10 implementation evidence remains accepted
  and its runtime receipt is historical/stale.
- G11 resync receipt: schema `4`, status `installed`, 130 operations (`112`
  package + `18` runtime-file; `124` replace + `6` delete), at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G11-20260813T192112Z/sync-receipt.json`.
- G11 receipt SHA-256:
  `5f7ba0e0fd1279f8fbf26fd895b1a3dc262f363817fc7d2eef32b3236bbee9e6`.
- Installed config SHA-256:
  `83773104b20a14a66bc91bbab897e0af8f779dd1ee2d11df5f125e70324685ad`;
  root model Sol, reasoning effort `medium`.
- Catalog receipt: schema `2`, mode `0600`, `nlink=1`, SHA-256
  `1e1499247ad0e02d58f0ffa3a7da5adae923cfd9a683069999fad13468533863`.
- Logical receipt: schema `2`, mode `0600`, `nlink=1`, SHA-256
  `3b5644c29c7d4a437ed843688bba791ebba4b7ec3dd6f1b2a633865697402442`.
- Mirror: PASS; fresh runtime root plus seven specialists: PASS.
- Overall current GREEN: `true`.
- Independent review and forensic closure: `pending`.

## Historical Generation 1 Stable Requirement And Case Evidence

Command:

```bash
PYTHONDONTWRITEBYTECODE=1 bash tests/codex-agent-routing-hardening.sh
```

Result: exit `0`, `pass=7 red=0 total=7`. `CASE-ROUTER-001` through
`CASE-LIMIT-007` all passed at this generation.

| Requirement | Stable case | Result |
| --- | --- | --- |
| `REQ-ROUTER-001` | `CASE-ROUTER-001` | PASS |
| `REQ-SPAWN-002` | `CASE-SPAWN-002` | PASS |
| `REQ-ALIASES-003` | `CASE-ALIASES-003` | PASS |
| `REQ-ROUTES-004` | `CASE-ROUTES-004` | PASS |
| `REQ-DOCTRINE-005` | `CASE-DOCTRINE-005` | PASS |
| `REQ-READONLY-006` | `CASE-READONLY-006` | PASS |
| `REQ-LIMIT-007` | `CASE-LIMIT-007` | PASS |

## Historical Generation 1 Affected Integration Proof

The following suites passed after the generation 1 correction:

- `tests/codex-spawn-packet.sh`;
- `tests/codex-skill-catalog-truth.sh`;
- `tests/codex-logical-agent-topology.sh`;
- `tests/codex-logical-agent-install.sh`;
- `tests/codex-collaboration-policy.sh`;
- `tests/agent-family-compatibility.sh`;
- `tests/quality-agent-contract.sh`;
- `tests/template-promotion-readiness.sh`;
- `tests/host-export-contract.sh`;
- `tests/global-skill-mirror-stage.sh`.

## Historical Generation 1 Full Repository Proof

Command:

```bash
PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh
```

Result: exit `0`, final line `all tests passed`.

## Boundary

Generations 1 through 9 are preserved as stale history. G10 implementation proof
remains accepted, while its runtime receipt is stale after external drift. G11
documentary correction/proof and runtime recovery are current GREEN; independent
review and root forensic gates passed. Plane REVIEW, Done, FINISH and final
provider readback passed. The cooperative lock coordinates governed mutators only; non-cooperating
same-user filesystem writes, cryptographic authenticity and universal
linearizability are outside the guarantee. CODEX-3 is closed.
