# Quality Stack Selective Adoption Evidence — 2026-08-12

## Evidence Contract

- Governing issue: `CODEX-1`
- Provider progress receipt: comment
  `1ec56a27-9692-42cd-acb5-ebd057ed169b`
- User decision: approved the reviewed recommendation and explicitly authorized
  all pre-restart phases.
- Frozen sources:
  - `addyosmani/agent-skills@be42637c5af93fdc8526b68ec2f2651b930f316c`
  - `DietrichGebert/ponytail@2ed6c52c9d7e5e56942508591085fd45dea277d3`
- Boundary: this records adopted design decisions, not live runtime proof and
  not a license/provenance substitute for copied code. The implementation is an
  original adaptation of behaviors and contracts.

## Upstream Agent Decisions

| Source capability | Decision | Accelerate target | Reason |
| --- | --- | --- | --- |
| code-reviewer | adapt now | code-reviewer template + code-audit/requesting review contracts | independent multi-axis review fills a real gap |
| security-auditor | evolve existing | security-reviewer template + security skill references | avoid duplicate security authority while adding STRIDE/exploitability |
| test-engineer | adapt now | test-engineer template + test-engineering/TDD skills | pre-code test design is missing today |
| web-performance-auditor | template now, promotion deferred | web-performance template + skill | metric honesty is useful; runtime value needs real-web replay |

## Upstream Skill Decisions

| `agent-skills` capability | Decision | Destination / disposition |
| --- | --- | --- |
| api-and-interface-design | defer standalone skill | retain principles in stack-specific API/validation governance |
| browser-testing-with-devtools | already covered | preserve browser-truth-first ordering |
| ci-cd-and-automation | defer standalone skill | reuse proof/readiness lanes when triggered |
| code-review-and-quality | adapt now | `code-audit` review axes and finding schema |
| code-simplification | adapt now as subordinate lens | `solution-minimalism`, only post-spec/post-green |
| context-engineering | already covered | Accelerate + prompt hardening remain owners |
| debugging-and-error-recovery | already covered | systematic-debugging remains owner |
| deprecation-and-migration | defer until recurring | use architecture/migration contracts per task |
| documentation-and-adrs | adapt now | specification lifecycle + ADR disposition |
| doubt-driven-development | adapt protocol | source verification and independent reconciliation |
| frontend-ui-engineering | already covered | existing frontend/design-system stack |
| git-workflow-and-versioning | reject mutation semantics | no implicit stash/reset/commit; retain atomic-scope guidance |
| idea-refine | defer standalone skill | prompt hardening/brainstorming own intent discovery |
| incremental-implementation | already covered | executing plans owns bounded batches/checkpoints |
| interview-me | defer standalone skill | prompt hardening decides whether clarification is needed |
| observability-and-instrumentation | adapt by reference | SDD/Test Design dispositions and QA proof |
| performance-optimization | adapt now | source-labelled web-performance measurement contract |
| planning-and-task-breakdown | already covered | planning layer remains owner |
| security-and-hardening | adapt now | evolved security reviewer and security contracts |
| shipping-and-launch | already covered | rollout/rollback/closure gates remain owners |
| source-driven-development | adapt and rename | `source-verification` to avoid SDD acronym collision |
| spec-driven-development | adapt lifecycle | `specification-lifecycle`; SDD means document only |
| test-driven-development | adapt now | `test-driven-development` + TDD Receipt |
| using-agent-skills | reject as router | Accelerate remains the sole root classifier |

## Ponytail Decisions

| Technique | Decision | Containment |
| --- | --- | --- |
| repository-context discovery before change | adopt | source verification + minimalism ladder |
| reuse before dependency or abstraction | adopt | project reuse precedes stdlib/platform/dependency |
| smallest complete change | adopt | complete means correct, secure, observable, compatible, testable |
| concise delivery and low ceremony | adopt | proportional SDD modes prevent boilerplate inflation |
| minimal files/LOC as success metric | reject | size is a signal, never proof or closure authority |
| code-first execution | reject | specification/test-design entry remains mandatory |
| autonomous runtime persona/router | reject | no competing root orchestrator |

## Phase Decisions

| Phase | Pre-restart decision | Post-restart boundary |
| --- | --- | --- |
| specification/ADR/Test Design/traceability | implement and independently accept | none |
| gates, templates, packets, validators | implement and prove statically | none |
| skills, references, evals, registry | implement and validate in repo | fresh discovery still pending |
| collaboration profiles | add only as bounded logical routing contracts | empirical prompt/spawn replay required |
| physical specialist promotion | defer | requires containment and value replay |
| repo-to-global mirror sync | allowed with deterministic parity and rollback receipt | fresh process must prove effective catalog |
| CODEX-1 closure | prohibited | only after post-restart proof and root reconciliation |

## Rejected Runtime Mechanics

- foreign session-start or simplify-rewrite hooks;
- Claude-specific agents/commands/persona semantics;
- global meta-router competing with Accelerate;
- auto-commit, publish, deploy, or tracker writes;
- destructive baseline mutation;
- invented metrics and universal numeric thresholds;
- claiming template/config presence as isolation or promotion.
