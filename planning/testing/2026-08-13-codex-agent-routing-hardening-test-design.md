# Codex Agent Routing Hardening Test Design

## Status

- ID: `TEST-DESIGN-CODEX-AGENT-ROUTING-001`
- Status: `accepted`
- Owner: `codex3-test-author`
- Independent reviewer: `codex3-independent-reviewer`
- Accepted by: `accelerate-root`
- Date: 2026-08-13
- Governing issue: `CODEX-3`
- Source SDD:
  `../architecture/2026-08-13-codex-agent-routing-hardening-sdd.md`
- Proof mode: `semantic-contract` with valid current files, invalid temporary
  topology, and disposable installer-home fixtures.

## Objective

Prove the seven ordered routing corrections at the lowest effective layer
before broader integration or runtime sync. The oracle must distinguish a real
missing contract from shell syntax, missing fixture, or unrelated global state.
It must not write to `~/.codex`.

## Dimension Dispositions

| Dimension | Status | Lowest effective oracle |
| --- | --- | --- |
| Happy | covered | all seven named cases pass after the correction |
| Negative | covered | missing router, missing route records, raw aliases, missing agents/families, ambiguous read-only wording, and unconsumed limit each fail |
| Boundary | covered | exact assignment-skill set, 64-hex hash, absolute existing file, and temporary limit `8` |
| Ownership | covered | logical specialists have no external-write/closure authority; read-only persistence requires another executor |
| Concurrency/idempotency | covered | catalog install runs in a disposable home and must remove stale aliases transactionally; concurrent shared-worktree mutation is outside this focused oracle |
| Failure/recovery | covered | stale aliases and invalid topology fail without touching the real runtime; installer backup proof remains an affected integration test |
| Fixtures/data | covered | current TOML/JSON/Markdown plus one `mktemp` Codex home and derived topology |
| Observability | covered | aggregate `PASS/RED`, exact case IDs, exit status, timestamp, test hash, and evidence locator |
| Lowest effective level | covered | shell plus Python semantic parsing; full suite and fresh runtime are later lanes |

## Stable Case Matrix

| Case | Requirement / task | Happy oracle | Negative or boundary oracle |
| --- | --- | --- | --- |
| `CASE-ROUTER-001` | `REQ-ROUTER-001` / `T1` | repo package exists and `build_index.py --repo-root <root> --check` passes | missing/stale index or historical `h55` reference fails |
| `CASE-SPAWN-002` | `REQ-SPAWN-002` / `T2` | assignment set has exact `skill/path/sha256` records and every digest matches bytes | name-only, missing, duplicate, nonexistent, or mismatched route fails |
| `CASE-ALIASES-003` | `REQ-ALIASES-003` / `T3` | only two recovery profiles remain and stale raw aliases disappear from a disposable home | any raw specialist profile remains launchable or installed |
| `CASE-ROUTES-004` | `REQ-ROUTES-004` / `T4` | both logical agents match explicit role/profile/model/effort/write/root boundaries | a missing agent, wrong binding, or elevated authority fails |
| `CASE-DOCTRINE-005` | `REQ-DOCTRINE-005` / `T5` | six concrete families occur in every governing doctrine surface | any surface retains a smaller or divergent family set |
| `CASE-READONLY-006` | `REQ-READONLY-006` / `T6` | each ambiguous reviewer template states forbidden mutation, return-only artifact, separate executor | read-only plus unqualified draft/edit/write wording fails |
| `CASE-LIMIT-007` | `REQ-LIMIT-007` / `T7` | a derived topology with limit `8` renders a complete packet in at most eight lines | hard-coded `10`, ignored limit, truncation, or renderer failure is RED |

## Baseline And Planned Commands

Observed baseline:

```bash
bash tests/codex-agent-routing-hardening.sh
```

Result: exit `1`, `pass=0 red=7 total=7`, recorded at
`planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-red-2026-08-13.md`.

Planned focused GREEN uses the same command. Affected integration includes at
least the existing catalog truth/install, logical topology/install/runtime,
Spawn Packet, collaboration policy, base contract, quality-agent, template,
family compatibility, registry/parity, and host export suites. Root then runs
`PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh` and `git diff --check`.

## Proof-Level Boundaries

- Static/focused GREEN does not prove global mirror parity.
- Global parity does not prove a newly started process discovered the mirror.
- A successful logical profile turn does not prove native profile injection,
  tool/MCP isolation, or credential access.
- The test author cannot independently accept the oracle it authored.
- Browser truth and persistent product E2E are not applicable because no
  product UI or journey changes; fresh Codex runtime replay remains required.

## Exit Criteria

All seven cases pass at one correction generation, affected suites and full
suite pass, stale evidence is excluded, transactional global sync/readback and
fresh-process root plus seven specialist turns pass, independent review reports
no unresolved blocking finding, and root review-of-review confirms the issue
contract before closure.
