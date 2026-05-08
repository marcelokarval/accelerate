# Recursive Cycle 7..12 Task Ledger

Date: 2026-05-08
Root orchestrator: Claw
Repository: `/home/marcelo-karval/Backup/Projetos/accelerate`

## Staffing Ledger

| Subagent | Assigned tasks | Type | Write scope | Forbidden scope | Status |
| --- | --- | --- | --- | --- | --- |
| A | RC7 Linear live fixture proof + closure/status bindings | workflow adapter implementer + task reviewer | Linear helper scripts, Linear tests, remote-write registry, capability dashboard, sanitized Linear proof appendix | browser proof, skill export, agent factory, unrelated GitHub adapter changes | delivered-for-root-review; live proof blocked by missing `LINEAR_API_KEY` |
| B | RC8 browser-proof runtime expansion + RC12 dogfood/semantic maintenance | runtime QA implementer + task reviewer | browser-proof helper/docs/tests, `.accelerate/` non-secret state, semantic negative tests | Linear provider writes, skill export, agent factory runtime claims | delivered-for-root-review |
| C | RC9 skill export proof + RC10 agent factory replay + RC11 maturity dashboard integration | control-plane implementer + task reviewer | skill sync topology/scripts/tests/proof appendix, agent factory docs/tests/proof appendix, maturity dashboards/tests | Linear live provider changes, browser-proof helper internals, user-home catalogs as source truth | partial output accepted after Replacement Subagent D blocker repairs + validation |

## Task Ledger

| ID | Task | Owner | Reviewer | Status | Requested outcome | Required proof | Residual policy |
| --- | --- | --- | --- | --- | --- | --- | --- |
| RC7 | Linear live fixture proof + closure/status structured bindings | Subagent A | Subagent A self-review + root final review-of-review | implemented; live proof blocked by missing `LINEAR_API_KEY` | Implement dedicated structured non-LLM GraphQL closure-comment and status-transition helpers; prove or honestly block non-sensitive live fixture read/create/artifact/closure/status; update registry/dashboard/proof appendix. | `bash tests/linear-structured-mcp-binding.sh`; live proof appendix if safe; `git diff --check` | Keep status `planned`/`blocked` if live proof or safe fixture/status is unavailable. No provider promotion without proof locator. |
| RC8 | Browser-proof runtime expansion and active server monitoring | Subagent B | Subagent B self-review + root final review-of-review | delivered-for-root-review | Split server readiness, browser capture, capture failure, readiness-only, and persistent regression handoff; ensure missing server emits actionable correction packet; ensure fixture server cleanup and leak checks. | `bash tests/browser-proof-monitoring.sh`; targeted helper dry-run/readiness/capture probes where possible | If browser runtime unavailable, emit honest packet and keep persistent E2E unpromoted. |
| RC9 | Skill export proof from repo source to generated bundle | Subagent C + Replacement Subagent D | Subagent C self-review absent due timeout; Replacement D finisher review + root final review-of-review | accepted-after-repair | Add reproducible repo-local generated export proof with provenance/drift detection and tests; keep user-home non-authoritative. | `bash tests/skill-export-proof.sh`; `bash tests/control-plane-rc4-rc6.sh`; `git diff --check` | Generated export may become `available` only for proven generated artifact boundary, not source authority. |
| RC10 | Agent factory replay of one bounded candidate role | Subagent C + Replacement Subagent D | Subagent C self-review absent due timeout; Replacement D finisher review + root final review-of-review | accepted-after-validation | Replay one bounded role through candidate intake, skill envelope, positive/negative fixtures, cleanup, demotion rules, and proof appendix; no autonomous runtime claim. | `bash tests/promotion-replay-fixtures.sh`; `bash tests/agent-install-export-contract.sh`; proof appendix | Keep autonomous runtime `blocked`; role replay is fixture-scoped only unless actual runtime binding is proven. |
| RC11 | Runtime adapter maturity follow-through | Subagent C + Replacement Subagent D | Subagent C self-review absent due timeout; Replacement D finisher review + root final review-of-review | accepted-after-repair | Align maturity dashboards and status honesty tests with actual RC7..RC10 proof/demotion outcomes; update next queue from reality. | `bash tests/control-plane-rc4-rc6.sh`; `bash tests/recursive-self-improvement-contract.sh`; `git diff --check` | No optimistic status language without proof locator. |
| RC12 | Dogfood workspace and semantic negative gate maintenance | Subagent B | Subagent B self-review + root final review-of-review | delivered-for-root-review | Update `.accelerate/` current cycle references; extend semantic negative fixtures for new surfaces; keep private/generated outputs ignored. | `bash tests/dogfood-workspace-contract.sh`; `bash tests/semantic-negative-fixtures.sh` | Dogfood state must be truthful; missing generated/private proof remains ignored and non-blocking only when documented. |
| RC13 | Root final integration review, process cleanup, commit/push, remote CI, final report + next queue | Root | Root final review only | final-reviewed; local proof complete; remote CI pending commit/push | Inspect actual diff, review subagent reviews, run final proof stack, clean active processes, commit/push if supported, watch CI, report completed work and next steps. | `bash tests/all.sh`; `git diff --check`; process inspection; `planning/evidence/dated-proof-appendix/recursive-cycle-7-12-final-review-2026-05-08.md`; remote CI URL/conclusion after push | If any mandatory proof is blocked, closure becomes partial with explicit blockers and no unsupported promotion. |

## Active Monitoring Rules

- Subagents are synchronous delegated tasks. Root will treat returned packets as self-reports until verified against files/tests.
- If a subagent takes a long time but is still likely executing a bounded task, do not kill it prematurely.
- If a subagent stops responding after producing useful artifacts, root must inspect actual files, run the task proof, record partial delivery, and either accept after validation or reassign to a new agent.
- At closure, root must inspect managed background processes and common server/browser process patterns; any idle proof server/browser process must be killed unless explicitly retained with reason.

## Runtime Delta Packet — initial

- skills added: linear-pm, playwright-patterns, github-pr-workflow, subagent-governance, parallel-agents, verification-before-completion
- gates opened: Linear live fixture proof, browser-proof server monitoring, skill export proof, agent factory replay, maturity dashboard follow-through, dogfood/semantic maintenance
- local workspace transition: reused -> active recursive cycle 7..12
- QA / proof lane transition: planning proof -> delegated implementation proof + root closure proof
- browser-proof intensity transition: readiness-only preflight -> readiness/capture/failure/persistent handoff separation
