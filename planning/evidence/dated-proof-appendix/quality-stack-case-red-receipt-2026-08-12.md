# Quality Stack Stable-Case RED Receipt — 2026-08-12

## Receipt

- Governing issue: `CODEX-1`
- Phase: `T1 / RED contract execution`
- Source Test Design:
  `../../testing/2026-08-12-quality-engineering-stack-test-design.md`
- Canonical traceability:
  `../../specification/2026-08-12-quality-engineering-stack-traceability.md`
- Command:
  `for t in tests/specification-lifecycle-contract.sh tests/quality-agent-contract.sh tests/quality-skill-contract.sh; do bash "$t"; done`
- Aggregate exit: `1`, expected for the pre-implementation baseline
- Named cases executed: `27`
- Named REDs observed: `27`
- Syntax proof:
  `bash -n tests/specification-lifecycle-contract.sh tests/quality-agent-contract.sh tests/quality-skill-contract.sh` passed

## Case Results

| Suite | Cases | Result | Representative current cause |
| --- | --- | --- | --- |
| specification lifecycle | CASE-SPEC-001..005, CASE-TRACE-001..002, CASE-TEST-001..003 | 10 RED | production manifest validator, gates, templates, and normalized terminology are absent |
| agent quality | CASE-AGENT-001..003, CASE-SEC-001, CASE-QA-001, CASE-PERF-001 | 6 RED | specialist templates/profiles and evolved security/performance contracts are absent |
| skill/runtime quality | CASE-REV-001..004, CASE-LEAN-001..003, CASE-SKILL-001..002, CASE-RUNTIME-001..002 | 11 RED | corrected skills, evals, catalog/parity hardening, and restart handoff are absent |

Every case emitted its own `RED CASE-*` line; the suites aggregate instead of
stopping at the first missing artifact. Independent assertions fail closed
within each case. The harness includes disposable invalid manifest and finding
fixtures, mutated security/test/performance policies, a real dirty Git fixture,
and a temporary runtime stage with drift, stale-file, backup, receipt, rollback,
and unrelated-package-preservation assertions.

These REDs prove that the asserted contract is not satisfied before
implementation. They do not claim that a missing production validator or sync
surface executed branches that are currently unreachable; every semantic
fixture must run to completion during GREEN/reproof.

## TDD Boundary

- No product/contract implementation was created to obtain this receipt.
- Test-owned JSON fixtures are generated only in a disposable temporary
  directory and are removed on exit.
- A case may become GREEN only when its own assertions pass; aggregate suite
  success cannot hide a skipped case.
- Corrections require the same case to rerun; old output is stale after a
  material change.
