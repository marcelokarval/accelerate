# Quality Stack Pre-Restart Green Receipt

## Identity

- Governing issue: `CODEX-1`
- Scope: integrated source, agent, skill, evaluation, catalog, and disposable
  runtime contracts through `T8`
- Proof date: `2026-08-13`
- Proof status: `observed-green`
- Root owner: `accelerate-root`
- Independent lanes: specification, tests, agent contracts, skill behavior,
  and runtime parity

## Stable Requirement And Case Evidence

The following stable pairs are observed green in their focused suites and phase
receipts:

| Requirement | Stable case | Evidence |
| --- | --- | --- |
| `REQ-SPEC-001` | `CASE-SPEC-001` | T2-T3 receipt |
| `REQ-SPEC-002` | `CASE-SPEC-002` | T2-T3 receipt |
| `REQ-SPEC-003` | `CASE-SPEC-003` | T2-T3 receipt |
| `REQ-SPEC-004` | `CASE-SPEC-004` | T2-T3 receipt |
| `REQ-SPEC-005` | `CASE-SPEC-005` | T2-T3 receipt |
| `REQ-TRACE-001` | `CASE-TRACE-001` | T2-T3 receipt |
| `REQ-TRACE-002` | `CASE-TRACE-002` | T2-T3 receipt |
| `REQ-TEST-001` | `CASE-TEST-001` | T2-T3 receipt |
| `REQ-TEST-002` | `CASE-TEST-002` | T2-T3 receipt |
| `REQ-TEST-003` | `CASE-TEST-003` | T2-T3 receipt |
| `REQ-REV-001` | `CASE-REV-001` | T5-T7 receipt |
| `REQ-REV-002` | `CASE-REV-002` | T5-T7 receipt |
| `REQ-REV-003` | `CASE-REV-003` | T5-T7 receipt |
| `REQ-REV-004` | `CASE-REV-004` | T5-T7 receipt |
| `REQ-SEC-001` | `CASE-SEC-001` | T4 and T5-T7 receipts |
| `REQ-QA-001` | `CASE-QA-001` | T4 and T5-T7 receipts |
| `REQ-PERF-001` | `CASE-PERF-001` | T4 and T5-T7 receipts |
| `REQ-LEAN-001` | `CASE-LEAN-001` | T5-T7 receipt |
| `REQ-LEAN-002` | `CASE-LEAN-002` | T5-T7 receipt |
| `REQ-LEAN-003` | `CASE-LEAN-003` | T5-T7 receipt |
| `REQ-AGENT-001` | `CASE-AGENT-001` | T4 receipt |
| `REQ-AGENT-002` | `CASE-AGENT-002` | T4 and T8 receipts |
| `REQ-AGENT-003` | `CASE-AGENT-003` | T4 receipt |
| `REQ-SKILL-001` | `CASE-SKILL-001` | T5-T7 receipt |
| `REQ-SKILL-002` | `CASE-SKILL-002` | T5-T7 receipt |
| `REQ-RUNTIME-001` | `CASE-RUNTIME-001` | T8 receipt |
| `REQ-RUNTIME-002` | `CASE-RUNTIME-002` | static post-restart handoff contract |

`CASE-RUNTIME-002` proves that current-process discovery, startup, routing, and
spawn outcomes remain explicitly pending. It is not evidence that those
outcomes already occurred.

## Integrated Proof State

- Focused specification lifecycle: `10/10 PASS`.
- Focused quality agent contracts: `6/6 PASS`.
- Focused quality skill contracts: `11/11 PASS`.
- Official skill validation: `9/9 PASS`.
- Reviewed package integrity and fixture contract: `9/9 PASS`; behavioral LLM
  replay was not performed.
- T4 independent authority/schema denominator: accepted with zero `P0-P3`.
- T5-T7 independent adversarial denominator: accepted with zero `P0-P3`.
- T8 independent runtime/parity denominator and frozen full suite: accepted
  with zero `P0-P3`.
- Root integrated command: `PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh`.
- Root integrated result: `all tests passed`, exit `0`.
- Root official skill validation: `9/9 PASS`.
- Root reviewed package-integrity validator: `9/9 PASS`; its output explicitly
  states that behavioral replay was not performed.
- Root `git diff --check` and generated-cache scan: `PASS`.

## T9 Review Generation Three

The first issue-wide AI review rejected the snapshot with two `P1` and two
`P2` findings. Generation three corrected them before deployment:

- rollback now fingerprints every pre-existing target before mutation and
  preflights the full backup set before moving any installed state; missing or
  corrupted required backups fail closed without changing the target or
  receipt status;
- SDD, test, proof, and other live manifest locators reject any symlink
  component and any resolved path outside the repository;
- expected catalog drift exits cleanly without a Python traceback;
- reentry handoff, state, dashboard, and README report the T9 correction state
  consistently.

The exact missing-backup, corrupted-backup, and SDD/test/proof symlink fixtures
were observed RED before correction. On the corrected snapshot:

```text
tests/specification-lifecycle-contract.sh: PASS (10 cases)
tests/global-skill-mirror-stage.sh: PASS
tests/codex-logical-agent-install.sh: PASS
PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh: all tests passed
```

Independent issue-wide re-review accepted the corrected snapshot with
`P0=0`, `P1=0`, `P2=0`, and `P3=0`. The reviewer independently reproduced
missing/corrupt backup and internal/external symlink variants, confirmed clean
pre-sync diagnostics, and found no false runtime, replay, promotion, or closure
claim. No global sync had run at the time of that review.

## T10 Legacy Runtime Migration Generation Four

The first real production preflight then exposed five governed package paths
as legacy symlinks into the historical sibling catalog
`CODEX_HOME/skill-catalog-h55-20260730/<package>`. The sync rejected them before
mutation, as its then-current blanket policy required.

Generation four replaces that blanket rule with a narrow migration contract:

- only `CODEX_HOME/skill-catalog-*/<same-package-name>` is eligible;
- the target must be an existing directory, exactly two path components below
  the resolved `CODEX_HOME`, with no additional symlink traversal;
- an external, broken, cross-package, nested, or differently named symlink is
  rejected before mutation;
- the receipt fingerprints both the symlink object and the recursively resolved
  legacy package contents;
- rollback restores the original symlink exactly and detects missing or
  corrupted legacy target contents before moving installed state.

The exact legacy migration fixture was observed RED under the blanket rule.
The corrected stage test migrates it to a real governed directory, validates
parity, rejects an external package symlink, detects missing/corrupt backups,
and restores the original link and target exactly. Independent generation-four
re-review accepted the final surface with zero `P0-P3`; relative, directory
chain, package chain, wrong prefix/name/nesting, broken target, and empty-suffix
variants all failed closed without traceback or mutation.

## Pending Boundary

The final issue-wide AI review, governed real global sync, and Plane
progress/readback are T9-T10 work. A newly started Codex process is still
required after those steps. `CODEX-1` must remain open.
