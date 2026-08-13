# Quality Engineering Stack Task Breakdown

## Status

- Owner: Accelerate root/orchestrator
- Date: 2026-08-12
- Governing issue: `CODEX-1`
- Source SDD:
  `../architecture/2026-08-12-quality-engineering-stack-sdd.md`
- Source ADR:
  `../architecture/2026-08-12-quality-engineering-stack-adr.md`
- Source Test Design:
  `../testing/2026-08-12-quality-engineering-stack-test-design.md`
- Active phase: `completed`
- Execution route: orchestrated, bounded batches with explicit checkpoints
- Closure posture: CODEX-1 accepted and closed after independent review, full
  reproof, root review-of-review, FINISH, and provider readback

## Artifact Manifest

| Artifact | Disposition | Evidence / reason |
| --- | --- | --- |
| User intent / issue | present | user approval plus governed `CODEX-1` |
| PRD-lite | consolidated | capability intent and non-goals are already explicit in CODEX-1 and SDD |
| SDD | present, hierarchical | cross-control-plane/agents/skills/evals/runtime scope |
| ADR | present | durable proportional-SDD and selective-adoption decision |
| DESIGN | not applicable | no product UI or interaction mutation |
| Test Design | present | multi-validator, routing, eval and parity scope |
| Threat model | consolidated in SDD | authority, wildcard, hook, false-proof and parity risks |
| Agent plan | consolidated in SDD | template-first, empirical promotion boundary |
| Visual Modeling | present | agent communication, authority boundary, binding and residuals |
| Rollout / rollback | present in SDD | source-first, mirror receipt, restart stop rule |
| Observability | present in SDD/Test Design | packets, receipts, evals, parity, Plane lifecycle |
| AGENTS/docs | assess per task | update only owner/gate law; avoid duplicated manual prose |

## Source Sufficiency

- Product value clear: `yes`
- Acceptance clear: `yes`
- Technical ownership clear: `yes`
- Dependencies clear: `yes`
- Proof lane clear: `yes`
- Plane readiness: `complete`, CODEX-1 is Done with current provider readback
- Selective-adoption approval: `yes`, durable matrix and Plane comment receipt
  are linked from the SDD
- Local workspace reentry: `accepted`; current CODEX-1 overlay is materialized
  without replacing the last accepted dogfood-cycle evidence
- Implementation entry: `accepted`; T1 executed all 27 mapped RED cases and the
  dated Engineering Artifact Manifest validates at implementation stage

## Task Ledger

| ID | Requirements | Task | Owner / reviewer | Dependencies | Main surfaces | Acceptance / proof | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| T0 | all | Freeze SDD, ADR, Test Design, manifest, visual model, adoption evidence, traceability and task ledger | root / independent spec reviewer | CODEX-1 | exact dated `planning/**` artifacts in this ledger | links, 27/27 mapping, dispositions, workspace reentry and accepted review | completed |
| T1 | all 27 requirements including SEC, QA, PERF and RUNTIME | Add focused RED contract tests and negative fixtures | bounded test writer / independent test reviewer | T0 accepted | `tests/specification-lifecycle-contract.sh`, `tests/quality-agent-contract.sh`, `tests/quality-skill-contract.sh` | 27/27 named cases executed RED; fail-closed and semantic-fixture re-review accepted | completed |
| T2 | REQ-SPEC-* | Implement specification, SDD-mode, decision-artifact and root-entrypoint contracts | bounded docs/contract writer / skeptical reviewer | T0-T1 | `SKILL.md`, `README.md`, `planning/{README.md,specification/**,architecture/{sdd-template.md,delta-sdd-template.md,adr-template.md},design/**}`, `core/control-plane/{specification-entry-gate.md,sdd-mode-gate.md,decision-artifact-gate.md,branch-enforcement-matrix.md,gate-ownership-index.md}`, `core/issue-topology/issue-driven-mutation-stack.md`, `core/runtime-packets/templates.md`, `references/{specification-layer.md,runtime-packet-templates.md,trivial-branch-contract.md}`, `scripts/validate-engineering-artifact-manifest.py` | focused spec/ADR tests green; direct-fast-path cannot bypass semantic SDD | completed |
| T3 | REQ-TRACE-*, REQ-TEST-* | Implement Test Design, TDD receipt, traceability and correction freshness | bounded test-contract writer / test reviewer | T1; parallel with T2 under disjoint scope | only generic files under `planning/testing/**`, `core/control-plane/{test-design-gate.md,tdd-entry-gate.md}` | focused trace/TDD tests green after T2 integration | completed |
| T4 | REQ-AGENT-* | Add specialist templates/envelopes/capability mappings and evolve security | bounded agent-contract writer / architecture reviewer | T2-T3 | `agents/**`, collaboration policy only if validated | containment and exact authority/type/schema mutations green; [T4 receipt](../evidence/dated-proof-appendix/quality-stack-t4-agent-green-receipt-2026-08-13.md) | completed |
| T5 | REQ-REV-*, REQ-SEC-*, REQ-QA-*, REQ-PERF-* | Add/adapt review, security, test engineering and performance skills | bounded skill writer / independent reviewers | T2-T4 | only `skills/review/{code-audit,requesting-code-review,test-engineering,web-performance-review}/**` and `skills/security/security-patterns/**` | structure, finding semantics, exact reviewed-package integrity and review contracts green; [T5-T7 receipt](../evidence/dated-proof-appendix/quality-stack-t5-t7-green-receipt-2026-08-13.md); no-history LLM behavior remains separate | completed |
| T6 | REQ-LEAN-* | Add subordinate solution-minimalism review contract | bounded skill writer / architecture reviewer | T2 | only `skills/review/solution-minimalism/**` | unsafe simplification negatives and read-only boundary pass; shared T5-T7 receipt | completed |
| T7 | REQ-SKILL-* | Add specification lifecycle, TDD and source-verification skills | bounded skill writer / governance reviewer | T2-T3 | only `skills/workflow/{specification-lifecycle,test-driven-development}/**` and `skills/review/source-verification/**` | package, collision/brownfield fixture and reviewed-snapshot contracts green; no-history replay is not inferred; shared T5-T7 receipt | completed |
| T8 | REQ-RUNTIME-* | Integrate registry/catalog/sync/parity and reconcile runtime policy without false promotion | root integrator / governance auditor | T4-T7 | only `skills/_registry/**`, `adapters/runtime/codex/**`, `adapters/runtime/codex-collaboration/**`, sync/check/rollback scripts and tests named by changed contracts | catalog 131/39, transactional install/parity/rollback and disposable runtime proof green; [T8 receipt](../evidence/dated-proof-appendix/quality-stack-t8-runtime-green-receipt-2026-08-13.md); fresh-start remains pending | completed |
| T9 | all | Run full suite, independent AI review, correction, reproof and forensic reconciliation | independent reviewers + root | T1-T8 | entire changed set | corrected schema-3 snapshot accepted with zero P0-P3; `tests/all.sh` and diff/checks green | completed |
| T10 | REQ-RUNTIME-002 | Deploy governed global mirror, record Plane PROGRESS, and preserve restart handoff | root only | T9 | `~/.codex`, Plane, evidence appendix | [schema-3 sync receipt](../evidence/dated-proof-appendix/quality-stack-global-runtime-sync-2026-08-13.md) and parity are green; governed comment `7d5b8b92-048d-4666-9f4a-193edf32ede9` passed provider readback; fresh-process proof remains separate | completed |
| T11 | REQ-RUNTIME-002 | Execute post-restart discovery/startup/spawn proof, correct context-budget regression source-first, redeploy, reprove, and close the governed issue | root / independent runtime reviewer | T10 | catalog/topology/reconcilers/runtime tests, `~/.codex`, Plane, evidence appendix | initial `131/39` startup warning observed RED; corrected `131/13`, exact inventories and six real turns green; independent review accepted with zero P0-P3; REVIEW, Done, FINISH and provider readback complete; [post-restart receipt](../evidence/dated-proof-appendix/quality-stack-post-restart-runtime-proof-2026-08-13.md) | completed |

## Dependency Order And Batches

1. Batch A: T1 establishes failing behavioral contracts.
2. Batch B: T2-T3 implement the pre-code lifecycle and proof semantics.
3. Batch C: T4 implements capability boundaries after owners exist.
4. Batch D: T5-T7 implement progressively disclosed skills and evals.
5. Batch E: T8 integrates catalog/runtime parity without promotion overclaim.
6. Batch F: T9-T10 independently review, correct, deploy, and hand off.
7. Batch G: T11 executes fresh runtime proof, corrects any runtime-only defect,
   reproofs, and enters final independent review.

T5, T6, and T7 have disjoint write scopes. Shared registry, catalog, runtime,
sync, and parity files are exclusively T8-owned after those packages return.
Parallel writes are allowed only for these frozen non-overlapping scopes. All
subagents load Accelerate, receive explicit forbidden scope, do not spawn, and
return requested-vs-implemented, validation, self-review, self-forensic review,
defects, residual risk, and root closure boundary.

## Verification And TDD Receipt

The running TDD receipt belongs here until a dedicated template is implemented:

| Batch | Baseline / RED | GREEN / reproof | Reviewer | State |
| --- | --- | --- | --- | --- |
| T0 | independent specification review found missing 27/27 traceability, deterministic mode selection, root-entrypoint ownership, adoption evidence, visual model, local reentry, exact scopes and proof overclaim | all corrections independently re-reviewed; zero unresolved P0-P3 | independent specification reviewer | completed |
| T1 | All three suites aggregate failures. A combined run exited 1 with exactly 27 named `RED CASE-*` lines (10 specification/test, 6 agent/security/QA/performance, 11 review/lean/skill/runtime). Receipt: `../evidence/dated-proof-appendix/quality-stack-case-red-receipt-2026-08-12.md`. | fail-closed/semantic-fixture corrections independently accepted; GREEN remains future work | independent test reviewer | completed |
| T2-T3 | 10/10 named specification/trace/test cases observed RED | 10/10 GREEN at correction/proof generation 1; semantic bypass suite rejected; independent review accepted with no P0-P3 | independent contract reviewer | completed |
| T4 | original contract tests observed RED; three adversarial review generations added authority, unknown-key, exact-model/effort, bool/int and malformed-shape mutations | root focused suite green; 52/52 independent mutants rejected with no traceback or ungoverned diagnostic; receipt linked above | independent agent reviewer | completed |
| T5-T7 | exact package/semantic bypasses observed RED across multiple adversarial generations, including marker stuffing and exploitability contradictions | 11/11 skill, 6/6 agent, 10/10 lifecycle, 9/9 official and custom package proof; fixed reviewed denominator; receipt linked above | independent skill/review auditor | completed |
| T8 | original stage matrix exposed renderer mismatch, missing config/profile reconciliation, partial rollback loss, unsafe receipt paths and broad allowlists; full suite later exposed one legacy consumer | focused and full frozen-snapshot suite green; symlink/C0/DEL/exact-schema/fault-injection mutants rejected; no real runtime mutation; receipt linked above | independent runtime parity reviewer | completed |
| T9 | full-suite and issue-wide forensic baseline | corrected schema-3 and generation-four migration snapshot | governance + root review-of-review | completed; full suite green and independent review accepted with zero P0-P3 |
| T11 | post-restart root/reviewer emitted the skill-description budget error; static catalog gate observed `39` instead of `13` | source-first redistribution, schema-3 redeploy, exact inventories and six effective turns green | independent runtime reviewer | completed; zero P0-P3 |

## Risks And Stop Rules

- Stop if a proposed agent/profile gains root-exclusive authority.
- Stop if runtime configuration would delete unrelated skills/plugins/MCPs.
- Stop if source/mirror ownership is ambiguous; inspect the actual staging
  scripts before syncing.
- Stop if a foreign hook, global meta-router, wildcard, auto-commit, or
  destructive git action appears.
- Never infer a fresh runtime result from static TOML or disposable rendering;
  execute the opt-in installed-runtime proof after restart.
- Re-plan if focused tests show the current owner model cannot express the
  required behavior without duplicating authority.

## Definition Of Done

- all source artifacts, contracts, agent templates, skills, evals, and parity
  changes that do not require restart are implemented and reviewed;
- focused and full suites pass after observed RED failures;
- every independent finding is dispositioned and meaningful corrections are
  reproofed;
- governed runtime mirror is in parity through the repo-owned path;
- fresh Codex discovery/startup/profile/spawn proof is empirical and warning-free;
- CODEX-1 receives truthful progress/review evidence and closes only after
  independent review, full reproof, review-of-review, and provider readback.
