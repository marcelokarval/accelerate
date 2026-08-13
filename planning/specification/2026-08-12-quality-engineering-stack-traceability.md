# Quality Engineering Stack Traceability

## Authority

- ID: `TRACE-CODEX-QUALITY-001`
- Status: `accepted`
- Governing issue: `CODEX-1`
- Source SDD:
  `../architecture/2026-08-12-quality-engineering-stack-sdd.md`
- Rule: this is the canonical requirement mapping. Other artifacts may link or
  summarize it, but must not maintain a second competing mapping.
- Proof states: `observed-red`, `planned`, `observed-green`, or `blocked`.

## Requirement Matrix

| Requirement | Task | Stable case | Fixture / command | Planned proof locator | Owner | Current proof |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-SPEC-001 | T2 | CASE-SPEC-001 | invalid `mode=none`; `bash tests/specification-lifecycle-contract.sh` | T2-T3 GREEN receipt | contract writer / independent reviewer | observed-green |
| REQ-SPEC-002 | T2 | CASE-SPEC-002 | under-classified micro/standard/critical fixtures; focused test | T2-T3 GREEN receipt | contract writer / independent reviewer | observed-green |
| REQ-SPEC-003 | T2 | CASE-SPEC-003 | invalid `status=draft`; focused test | T2-T3 GREEN receipt | contract writer / independent reviewer | observed-green |
| REQ-SPEC-004 | T2 | CASE-SPEC-004 | missing disposition fixture; focused test | T2-T3 GREEN receipt | contract writer / independent reviewer | observed-green |
| REQ-SPEC-005 | T2 | CASE-SPEC-005 | terminology scan; focused test | T2-T3 GREEN receipt | contract writer / independent reviewer | observed-green |
| REQ-TRACE-001 | T3 | CASE-TRACE-001 | missing task/test fixture; focused test | T2-T3 GREEN receipt | test-contract writer / test reviewer | observed-green |
| REQ-TRACE-002 | T3 | CASE-TRACE-002 | planned proof at implementation fixture; focused test | T2-T3 GREEN receipt | test-contract writer / test reviewer | observed-green |
| REQ-TEST-001 | T3 | CASE-TEST-001 | incomplete dimension disposition fixture; focused test | T2-T3 GREEN receipt | test-contract writer / test reviewer | observed-green |
| REQ-TEST-002 | T3 | CASE-TEST-002 | feature/bug/refactor/docs/migration/security/UI/provider mode fixtures | T2-T3 GREEN receipt | test-contract writer / test reviewer | observed-green |
| REQ-TEST-003 | T3 | CASE-TEST-003 | correction with stale proof fixture | T2-T3 GREEN receipt | test-contract writer / test reviewer | observed-green |
| REQ-REV-001 | T5 | CASE-REV-001 | review-axis contract + eval | T5-T7 GREEN receipt | review skill writer / code reviewer | observed-green |
| REQ-REV-002 | T5 | CASE-REV-002 | category/severity counterexample | T5-T7 GREEN receipt | review skill writer / code reviewer | observed-green |
| REQ-REV-003 | T5 | CASE-REV-003 | incomplete and contradictory finding fixtures | T5-T7 GREEN receipt | review skill writer / code reviewer | observed-green |
| REQ-REV-004 | T5 | CASE-REV-004 | docs/config/workflow review and no-git-mutation scan | T5-T7 GREEN receipt | review skill writer / governance reviewer | observed-green |
| REQ-SEC-001 | T4,T5 | CASE-SEC-001 | STRIDE, supply-chain, exploitability, hostile-path negatives | T4 and T5-T7 GREEN receipts | security writer / independent security reviewer | observed-green |
| REQ-QA-001 | T4,T5 | CASE-QA-001 | writer/reviewer authority-collapse fixture | T4 and T5-T7 GREEN receipts | agent/skill writers / test reviewer | observed-green |
| REQ-PERF-001 | T4,T5 | CASE-PERF-001 | quick-static fabricated-metric fixture | T4 and T5-T7 GREEN receipts | agent/skill writers / runtime reviewer | observed-green |
| REQ-LEAN-001 | T6 | CASE-LEAN-001 | reuse/dependency decision-ladder eval | T5-T7 GREEN receipt | minimalism writer / architecture reviewer | observed-green |
| REQ-LEAN-002 | T6 | CASE-LEAN-002 | unsafe guard deletion fixture | T5-T7 GREEN receipt | minimalism writer / security reviewer | observed-green |
| REQ-LEAN-003 | T6 | CASE-LEAN-003 | rejected-complexity without upgrade trigger | T5-T7 GREEN receipt | minimalism writer / architecture reviewer | observed-green |
| REQ-AGENT-001 | T4 | CASE-AGENT-001 | bounded templates/profiles; `bash tests/quality-agent-contract.sh` | T4 GREEN receipt | agent writer / architecture reviewer | observed-green |
| REQ-AGENT-002 | T4,T8 | CASE-AGENT-002 | template falsely marked promoted fixture | T4 and T8 GREEN receipts | agent writer / governance reviewer | observed-green |
| REQ-AGENT-003 | T4 | CASE-AGENT-003 | return missing required field fixture | T4 GREEN receipt | agent writer / architecture reviewer | observed-green |
| REQ-SKILL-001 | T5,T6,T7 | CASE-SKILL-001 | missing/oversized/malformed/snapshot-drift package fixtures | T5-T7 GREEN receipt | skill writers / governance reviewer | observed-green |
| REQ-SKILL-002 | T5,T6,T7 | CASE-SKILL-002 | substantive role fixtures plus reviewed package snapshot | T5-T7 GREEN receipt; no-history LLM replay remains separate promotion proof | skill writers / governance reviewer | observed-green |
| REQ-RUNTIME-001 | T8 | CASE-RUNTIME-001 | source/mirror drift, stale-file and transactional fault fixtures | T8 GREEN receipt | root integrator / governance reviewer | observed-green |
| REQ-RUNTIME-002 | T11 | CASE-RUNTIME-002 | exact effective inventories, six ephemeral read-only turns, budget-error oracle, and no-history spawn/return | post-restart runtime proof receipt | root / independent runtime reviewer | observed-green |

## Completeness Rule

All 27 SDD requirement IDs appear exactly once above. The three suites aggregate
instead of fail-fast; all 27 named cases executed and emitted their own RED in
the linked stable-case receipt. Implementation entry
requires every row to have a task, stable case, fixture/command, planned proof
locator, and independent owner/reviewer separation. Closure requires every
non-deferred row to become `observed-green`. `CASE-RUNTIME-002` is green because
a post-restart process supplied exact discovery, startup, routing and bounded
spawn/return evidence. Logical profiles remain configuration overlays, not a
claim of native-spawn profile injection, isolation, or physical promotion.
