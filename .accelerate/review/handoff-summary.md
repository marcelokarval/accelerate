# Handoff Summary

## Status

- source: committed dogfood subset current planning overlay
- governing issue: `CODEX-3`
- phase: closed
- status: `generation-11-closed-plane-finish-readback-observed`
- reentry: `light_reentry`
- implementation readiness: repository/runtime/review/forensic accepted; Plane REVIEW, Done, FINISH and final readback passed

## Current Authorities

- SDD:
  `planning/architecture/2026-08-13-codex-agent-routing-hardening-sdd.md`
- ADR:
  `planning/architecture/2026-08-13-codex-agent-routing-hardening-adr.md`
- Test Design:
  `planning/testing/2026-08-13-codex-agent-routing-hardening-test-design.md`
- TDD receipt:
  `planning/testing/2026-08-13-codex-agent-routing-hardening-tdd-receipt.md`
- task ledger:
  `planning/execution/2026-08-13-codex-agent-routing-hardening-task-breakdown.md`
- traceability:
  `planning/specification/2026-08-13-codex-agent-routing-hardening-traceability.md`
- current G10 implementation / historical G10 runtime evidence:
  `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-green-2026-08-13.md`

## Gate State

- Issue Bootstrap / Plane: passed; `CODEX-3` is `Done` with provider readback.
- generation-zero focused RED: observed `0/7`.
- generation-one narrow GREEN: observed and invalidated by independent review.
- generation-two correction: five findings corrected — catalog/index parity,
  logical-profile ownership, atomic anti-symlink index write,
  generation-bound rollback and exact rollback command.
- generation-two focused proof: `7/7`, now stale for generation 3 promotion.
- generation-two full repository proof: `all tests passed`, now stale for
  generation 3 promotion.
- global runtime sync: installed through schema-4 receipt at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-20260813T141030Z/sync-receipt.json`.
- installed mirror: static parity passed; 112 packages and 16 runtime files.
- fresh-process runtime proof: root plus all seven logical specialists passed.
- browser / persistent E2E: not applicable; there is no product UI mutation.
- independent generation-two review: `fail`; `G3-F1` P1 found rollback can
  overwrite/delete post-sync drift, and `G3-F2` P1 found stale logical ownership
  could be lost across catalog evolution.
- generation-three correction: `G3-F1` then `G3-F2` corrected with honest
  RED/GREEN; focused `7/7`, affected suites and final clean full suite passed.
- generation-three runtime: schema-4 sync installed 112 packages and 16 runtime
  files at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G3-20260813T151014Z/sync-receipt.json`;
  mirror parity and fresh root plus seven-specialist proof passed.
- receipt SHA-256:
  `4d00d1a8edadfc832b09825210a433afb8a4e92bfa49bd83e4a409d9c23a447e`.
- final generation-three review: `fail` for closure — `G4-F1` P1 logical
  ownership laundering, `G4-F2` P2 config mode `0664`, `G4-F3` P2 cooperative
  TOCTOU after preflight/classification.
- generation-four correction: digest-bound logical receipt, exact `0600`, and
  shared cooperative single-writer lock have honest RED/GREEN.
- runtime state: schema-4 receipt at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G4-20260813T154500Z/sync-receipt.json`;
  128 operations = 112 package plus 16 runtime, `changed_packages=0`; mirror,
  modes and fresh root plus seven specialist proof passed.
- residual: the lock coordinates governed cooperative mutators only; direct
  non-cooperating same-user writes, cryptographic authenticity and universal
  linearizability remain outside the guarantee.
- final generation-four review: `fail` for closure — `G5-F1` P1 inherited FD
  inode identity without held-`flock` proof; `G5-F2` P1 rollback validation
  before lock; `G5-F3` P2 stale/absent standalone ownership receipts.
- generation-five correction: held-lock ownership, lock-before-decisive-
  validation and transactional catalog/logical ownership receipts schema 2/mode
  `0600` have honest RED/GREEN.
- runtime state: schema-4 receipt at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G5-20260813T163811Z/sync-receipt.json`;
  130 operations, 112 changed packages and 18 runtime files; mirror and fresh
  root plus seven-specialist proof passed.
- receipt SHA-256:
  `bb7144111d59776b96b5554a410e5b817ec748482f315b9c8d15878d1995e170`.
- residual: the cooperative lock coordinates governed mutators only; direct
  noncooperating same-user filesystem writers remain outside its boundary.
- final generation-five review: `fail` for closure — `G6-F1` P1; all four
  mutators accepted spoof inherited OFD-B while legitimate OFD-A held the lock.
- generation-six correction: direct nonblocking `flock` on inherited FD itself;
  spoof OFD-B rejects, legitimate shared OFD accepts and no inherited FD
  acquires normally.
- runtime state: schema-4 receipt at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G6-20260813T170900Z/sync-receipt.json`;
  130 operations, 112 changed packages and 18 runtime files; mirror, receipts
  and fresh root plus seven-specialist proof passed.
- receipt SHA-256:
  `aa3a7c1d6bb23baba48e7947db6e9449f41898eb055c72014b264f8f5eb34c19`.
- final generation-six review: `fail` for closure — `G7-F1` P1; sync followed
  by a supported standalone logical reinstall rewrites only the logical receipt,
  changes `installed_digest`, and invalidates schema-4 rollback.
- generation-seven correction: canonical configs, modes, ownership, and hashes
  take a byte-idempotent logical reinstall path with rollback-valid proof; real
  changes still update the affected config and receipt.
- runtime state: schema-4 receipt at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G7-20260813T173220Z/sync-receipt.json`;
  130 operations, 112 changed packages and 18 runtime files; mirror, receipts
  and fresh root plus seven-specialist proof passed.
- receipt SHA-256:
  `e751e656b49991619b2f95e77a2b8f5b7876a913aaa6beea02e030eca2435c0c`.
- catalog receipt: schema 2, mode `0600`, SHA-256
  `0a2e753ddd183bd2c921593deb20b57b77767e8fb1574ad4f429a5dcbbe08cb6`.
- logical receipt: schema 2, mode `0600`, SHA-256
  `e94ea5994a0084fd67bd055ade611c71079eccd72f253e6ea9492707776a7dbe`.
- final generation-seven review: `fail` for closure — `G8-F1` P2 logical fast
  path outside CODEX_HOME rollback/backup history; `G8-F2` P1 receipt-path
  directory plus real drift permits partial mutation before replace failure.
- generation-eight correction order: fast path contained to governed history,
  then receipt destination preflight before mutation with late transactional
  publication; exact G8-F2 RED was review-observed and root GREEN passed.
- runtime state: schema-4 receipt at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G8-20260813T175341Z/sync-receipt.json`;
  130 operations, 112 changed packages and 18 runtime files; mirror, receipts
  and fresh root plus seven-specialist proof passed.
- receipt SHA-256:
  `167d70acc243fd400f7c273bb63093466a58b64829e267ef772248afd9b61b96`.
- catalog receipt: schema 2, mode `0600`, SHA-256
  `8c308ecf8d557131f0232a9bbf4a0b8648ab157aa29478dc306e954403867062`.
- logical receipt: schema 2, mode `0600`, SHA-256
  `b83435e017662f6768aeea414dc883c8856f56e92c1809aa7bb2f569e2043222`.
- final generation-eight review: confirmed G8 fixes, then `fail` for closure on
  `G9-F1` P2; logical fast path accepts a receipt-updated renamed backup within
  CODEX_HOME/backups and mode `0666`, unlike catalog exact-identity validation.
- generation-nine correction: target-bound exact backup identity and mode
  `0600` across validators; rename/swap/suffix/hardlink/symlink/missing/outside
  adversarial matrix passed.
- runtime state: schema-4 receipt at
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G9-20260813T182536Z/sync-receipt.json`;
  130 operations = 112 package plus 18 runtime-file, 124 replace plus 6 delete;
  mirror and fresh root plus seven-specialist proof passed.
- receipt SHA-256:
  `9d7c826b9e26f14a0692f427ba92e943b99769c37f1a6af6d0cb556d0a3ffd06`.
- catalog receipt: schema 2, mode `0600`, SHA-256
  `45d34f0f586a45102d0bc32ad781d5d0c3e0206f325bcfe5ce7c4476a20b32e5`.
- logical receipt: schema 2, mode `0600`, SHA-256
  `266c5fcb54509e07d3332627b696ff362ad4cd445c0af5ea6c904ffd30a8e900`.
- concurrent `playwright-patterns` source/runtime content was preserved
  byte-exact and the 112-route index regenerated.
- final generation-nine review: fail on G10-F1 P1 late-publication rollback/
  cleanup, G10-F2 P2 exact receipt identity, G10-F3 P2 rollback-directory identity.
- generation-ten proof: three separate REDs then GREEN; focused/affected/full pass.
- runtime state: schema-4 receipt
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G10-20260813T190557Z/sync-receipt.json`,
  SHA `d80ac01e89b053261406a5884e41e2f75594476bd7b3c59985795e1334fe9d18`;
  130 operations, mirror and fresh root plus seven specialists PASS.
- catalog/logical receipts are schema 2, mode `0600`, `nlink=1`; all configs,
  profiles and receipts are `0600+nlink1`.
- G11-F1 documentary contract finding: corrected and statically reproved `11/11`.
- G11-F2 recovery: governed receipt
  `/home/marcelo-karval/.codex/backups/skill-sync-CODEX-3-G11-20260813T192112Z/sync-receipt.json`,
  SHA `5f7ba0e0fd1279f8fbf26fd895b1a3dc262f363817fc7d2eef32b3236bbee9e6`;
  Sol/medium, mirror and fresh root plus seven PASS.
- independent reviews: two `ACCEPTED`; open findings `P0=0, P1=0, P2=0, P3=0`.
- root review-of-review: `pass`; forensic closure review: `observed`.
- review evidence:
  `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-independent-review-2026-08-13.md`.
- current blocker: none.
- Plane REVIEW / Done / FINISH / final provider readback: passed.

## Runtime Boundary

The default Codex root is the orchestrator; there is no `-p orchestrator`
profile. The public recovery profiles are only `on-demand` and
`superpowers-on-demand`. The logical specialists are `python-backend`,
`nextjs-frontend`, `research`, `reviewer`, `qa`, `data-db`, and
`integrations-ops`. Paths, hashes, profiles, skills and MCP lists are assignment
and integrity contracts; they do not claim process, tool, filesystem, credential
or MCP isolation.

## Historical Boundary

The accepted CODEX-1 quality-stack overlay and the May dogfood cycle remain
historical accepted evidence. They are not authority for the CODEX-3
generation chain. CODEX-3 closed at generation 11 with Plane FINISH readback;
generation 3 is preserved only as historical correction evidence.
