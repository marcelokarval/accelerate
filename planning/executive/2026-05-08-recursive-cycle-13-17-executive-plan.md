# Recursive Cycle 13..17 Executive Plan

Date: 2026-05-08
Root: Accelerate recursive self-improvement
Repository: `/home/marcelo-karval/Backup/Projetos/accelerate`
Root orchestrator: Claw

## Branch Entry Packet

- classification: orchestrated non-trivial work
- active branch: recursive self-improvement cycle 13..17
- active persona: root orchestrator + final forensic reviewer
- active stack: Linear workflow adapter, browser-proof runtime, skill export/runtime host boundary, agent factory runtime candidate, recursive governance dashboards/tests
- active skills:
  - accelerate
  - subagent-governance
  - parallel-agents
  - verification-before-completion
- active ADRs / references:
  - `AGENTS.md`
  - `SKILL.md`
  - `README.md`
  - `core/control-plane/capability-maturity-dashboard.md`
  - `core/control-plane/runtime-adapter-maturity-dashboard.md`
  - `core/control-plane/recursive-improvement-situation-dashboard.md`
  - `core/control-plane/skill-sync-topology.md`
  - `core/control-plane/agent-factory-promotion-pipeline.md`
  - `core/delegation/agent-factory-promotion-pipeline.md`
  - `core/runtime-packets/browser-proof-packet.md`
  - `adapters/runtime/browser/browser-truth-contract.md`
  - `adapters/workflow/remote-write-registry.yaml`
  - `planning/executive/2026-05-08-recursive-cycle-7-12-executive-plan.md`
  - `planning/executive/2026-05-08-recursive-cycle-7-12-task-ledger.md`
  - `planning/evidence/dated-proof-appendix/recursive-cycle-7-12-final-review-2026-05-08.md`
- local workspace:
  - `.accelerate=present`
  - action=reused + update current plan/ledger references for cycle 13..17
  - readiness dashboard=`.accelerate/status/readiness-dashboard.yaml`
  - current governing artifact=`planning/executive/2026-05-08-recursive-cycle-13-17-executive-plan.md`
  - current task ledger=`planning/executive/2026-05-08-recursive-cycle-13-17-task-ledger.md`
  - drift status=must be checked before closure
- gate ledger:
  - prompt-hardening=applied through this execution plan
  - orchestrator-first-execution=active
  - subagent-governance=active
  - external-provider-safety=active for Linear live proof
  - browser-server-monitoring=active and must emit corrective packets before browser launch
  - skill-host-export-boundary=active; user-home catalogs must not become source truth
  - agent-runtime-candidate=bounded; no autonomous availability claim without runtime binding proof
  - final-verification=required before commit/push/CI closure
- phase / SDLC: recursive improvement implementation + task review + root review-of-review
- issue stack status: planning docs are the governing work item; do not invent fake provider issue authority
- QA / proof lane: targeted tests, browser/server fixture proof, provider proof only where safe, full `bash tests/all.sh`, remote CI after push
- browser-proof intensity: real server readiness + capture attempt + failure correction + process cleanup + persistent regression separation
- persistent E2E status: unpromoted unless a repo-owned persistent regression proof lands
- local review / closure action: root final review, process cleanup, commit/push/CI if supported
- single-threaded exception: n/a; implementation/review delegated to subagents

## Prompt Hardening Packet

- Prompt A: Proceed with the next five steps: Linear live proof, real browser capture, host skill export, runtime-bound agent candidate, and next recursive cycle. Build a complete executive plan and complete detailed tasks; start execution; task review by subagents; root orchestrates and performs final review. Actively monitor agents, close idle delivered agents, replace true stalls, and analyze browser-proof server readiness/correction.
- Prompt B: Execute Accelerate recursive cycle 13..17 as a bounded subagent-driven orchestration. Persist plan and task ledger first. Delegate implementation/review slices for: (1) Linear live fixture proof readiness and safe execution where credentials allow; (2) browser-proof real capture and active server monitoring; (3) skill export from repo-local source to generated host-runtime target with rollback/drift proof; (4) one agent-factory runtime candidate with lifecycle/cleanup/demotion proof but no autonomous availability claim unless proven; (5) governance/dashboard/dogfood/semantic-negative follow-through and next queue emission. Each subagent must anchor the worktree, obey write scopes, self-review, and return requested-vs-implemented/proof/residuals. Root validates actual diffs and tests, cleans managed/fixture processes, commits/pushes only if supported, watches CI, then reports done/residuals/next steps.
- Material changes: split into five bounded RC tasks with explicit proof, stop rules, and status-honesty gates; live provider proof may remain blocked if repo-local credentials are unavailable.

## Executive Objective

Convert the previous cycle's five residuals into proof-bearing, status-honest improvements. The target is not to claim maturity prematurely; it is to remove blockers where possible, improve failure visibility where not, and leave a durable next queue grounded in actual evidence.

## Success Criteria

1. Linear helper live-proof path can determine credential/team/status readiness, execute a non-sensitive fixture when safe, or produce a durable blocked packet explaining the missing prerequisite without promoting availability.
2. Browser-proof produces actionable server-readiness and capture packets, attempts real capture when local runtime is available, records server stdout/stderr/liveness details, and leak-checks fixture server/browser processes.
3. Skill export host-runtime path proves repo-local source to generated host target in a temp/approved target with provenance, drift detection, rollback/cleanup, and explicit non-authority of user-home catalogs.
4. One agent-factory runtime candidate advances from fixture replay toward runtime-bound candidate criteria with lifecycle monitoring, idle-agent cleanup accounting, demotion route, and root acceptance language; autonomous runtime remains blocked unless actual runtime proof exists.
5. Dashboards, `.accelerate/` dogfood state, semantic negative gates, and next queue reflect actual results from RC13..RC16 and prevent optimistic promotion.
6. Final root review records requested-vs-implemented, subagent review quality, diff scope, targeted tests, full suite, process cleanup, commit/push, and remote CI.

## Non-Goals

- Do not commit secrets, provider payloads, private Linear data, screenshots containing sensitive data, or generated user-home catalogs.
- Do not promote Linear, browser persistent E2E, host skill runtime, or autonomous agent runtime to `available` without durable proof locators.
- Do not use user-home skill catalogs as authority.
- Do not kill ambient Chrome/MCP/Playwright processes unless ownership or true idle/trapped state is confirmed.
- Do not leave test-owned fixture servers or agent processes running.
- Do not merge unrelated parallel work.

## Execution Model

Root is orchestrator and final reviewer. Subagents do implementation/review by task. Root may directly write only planning/ledger/final-review artifacts and blocker-class integration corrections if a subagent stalls or final full-suite integration exposes stale contracts.

Every subagent must begin by reporting:

```bash
pwd && git status --short --branch
```

Wrong-worktree output is non-evidence.

Every subagent must return a Subagent Return Packet with:

- assigned scope;
- files changed / inspected;
- requested-vs-implemented;
- validation run;
- self-review;
- self-forensic review;
- defects found and disposition;
- unresolved risks;
- recommendation.

## Task Set

### RC13 — Linear live fixture proof readiness and safe execution

Goal: make the Linear provider boundary operationally honest. If `LINEAR_API_KEY` and a safe non-sensitive fixture are available, run read/create/artifact/closure/status proof through repo-local helpers. If not, produce durable credential/fixture readiness evidence and keep status unpromoted.

Primary files:

- `onboarding/local-workspace/read-linear-mcp-adapter.sh`
- `onboarding/local-workspace/create-linear-mcp-issue.sh`
- `onboarding/local-workspace/attach-linear-mcp-artifact.sh`
- `onboarding/local-workspace/comment-linear-mcp-closure.sh`
- `onboarding/local-workspace/update-linear-mcp-status.sh`
- `onboarding/local-workspace/validate-linear-comment-response.sh`
- `onboarding/local-workspace/validate-linear-issue-response.sh`
- `onboarding/local-workspace/validate-linear-status-response.sh`
- `adapters/workflow/remote-write-registry.yaml`
- `core/control-plane/capability-maturity-dashboard.md`
- `core/control-plane/recursive-improvement-situation-dashboard.md`
- `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md`
- `tests/linear-structured-mcp-binding.sh`

Required work:

- add or improve a repo-local Linear live-readiness/preflight path that checks credential presence without printing secrets;
- identify safe team/status requirements and fail closed when not discoverable;
- run live fixture chain only if non-sensitive target and credential are available;
- sanitize evidence and provider response summaries;
- keep `planned` status if live proof is blocked;
- add/adjust tests for missing-token, path safety, dry-run, response validation, and registry honesty.

Stop rules:

- stop before committing provider payloads or tokens;
- stop before changing real non-fixture Linear issues;
- no availability promotion without live proof locator.

Proof:

- `bash tests/linear-structured-mcp-binding.sh`
- sanitized proof appendix if live proof executes; otherwise blocked appendix with exact prerequisite.

### RC14 — Browser-proof real capture and active server monitoring

Goal: harden browser-proof so server-not-running and server-crashing cases are detected before capture, and real capture is attempted/proven when local automation is available.

Primary files:

- `onboarding/local-workspace/capture-browser-proof.sh`
- `tests/browser-proof-monitoring.sh`
- `core/runtime-packets/browser-proof-packet.md`
- `adapters/runtime/browser/browser-truth-contract.md`
- `core/control-plane/runtime-adapter-maturity-dashboard.md`
- `.accelerate/status/readiness-dashboard.yaml`

Required work:

- inspect current helper for readiness/capture/cleanup gaps;
- ensure server process liveness, HTTP code, stdout/stderr tail, and correction signal are emitted for failures;
- add server startup monitoring guidance so root can actively correct server-not-running captures;
- ensure fixture server is killed and leak-checked;
- if Puppeteer/Chromium is available, prove `browser-capture`; otherwise prove `capture-failed` with an actionable runtime-unavailable correction packet;
- keep persistent regression/E2E unpromoted unless a separate repo-owned proof exists.

Stop rules:

- localhost-only target;
- no sensitive screenshots committed;
- no ambient browser process kills without ownership.

Proof:

- `bash tests/browser-proof-monitoring.sh`
- focused capture/readiness probes as needed.

### RC15 — Skill export host-runtime proof boundary

Goal: move beyond repo-local generated artifact proof toward a safe host-runtime export candidate using temp/approved targets, rollback, drift detection, and source-authority protection.

Primary files:

- `scripts/export-skill-proof.sh`
- `tests/skill-export-proof.sh`
- `core/control-plane/skill-sync-topology.md`
- `core/control-plane/capability-maturity-dashboard.md`
- `skills/README.md`
- `skills/_registry/manifest.md`
- `planning/evidence/dated-proof-appendix/skill-export-proof-2026-05-08.md`

Required work:

- add host-runtime target mode only if it is temp/explicitly approved and never source authority;
- prove rollback/cleanup and stale-export drift detection;
- preserve refusal to write into real user-home catalogs by default;
- document generated-target boundary and non-authority.

Stop rules:

- do not write real `~/.codex/skills`, `~/.claude/skills`, or `~/.agents/skills` during tests;
- no generated export becomes source truth.

Proof:

- `bash tests/skill-export-proof.sh`
- relevant control-plane tests if dashboards change.

### RC16 — Agent factory runtime candidate proof

Goal: advance one bounded proof-auditor candidate toward runtime-bound criteria by proving lifecycle/monitoring/cleanup/demotion contracts, without claiming autonomous runtime availability unless actual runtime binding is proven.

Primary files:

- `core/control-plane/agent-factory-promotion-pipeline.md`
- `core/delegation/agent-factory-promotion-pipeline.md`
- `agents/promotion/bounded-proof-auditor-replay.md`
- `planning/promotion/replay-fixtures/bounded-proof-auditor.md`
- `planning/evidence/dated-proof-appendix/agent-factory-replay-2026-05-08.md`
- `tests/promotion-replay-fixtures.sh`
- `tests/agent-install-export-contract.sh`

Required work:

- define runtime-bound candidate checklist: invocation boundary, lifecycle monitor, idle detection, cleanup, demotion, root acceptance;
- add positive/negative fixture coverage for lifecycle cleanup and unsupported availability claims;
- if no real autonomous runtime exists, keep status `proof-replay`/`blocked` and record the exact remaining runtime binding proof.

Stop rules:

- no autonomous availability claim without runtime binding proof;
- no nested delegation by subagents;
- no generated private transcripts committed.

Proof:

- `bash tests/promotion-replay-fixtures.sh`
- `bash tests/agent-install-export-contract.sh`

### RC17 — Governance follow-through, semantic negatives, dogfood, final next queue

Goal: integrate RC13..RC16 results into dashboards, `.accelerate/` dogfood, semantic negative fixtures, and the next recursive queue.

Primary files:

- `core/control-plane/capability-maturity-dashboard.md`
- `core/control-plane/runtime-adapter-maturity-dashboard.md`
- `core/control-plane/recursive-improvement-situation-dashboard.md`
- `core/control-plane/skill-sync-topology.md`
- `.accelerate/README.md`
- `.accelerate/status/readiness-dashboard.yaml`
- `.accelerate/workflow/active-work-item.yaml`
- `tests/control-plane-rc4-rc6.sh`
- `tests/recursive-self-improvement-contract.sh`
- `tests/semantic-negative-fixtures.sh`
- `tests/dogfood-workspace-contract.sh`

Required work:

- update statuses and proof locators strictly based on RC13..RC16 evidence;
- update `.accelerate/` current plan/ledger references;
- extend semantic negative fixtures for any new status surfaces;
- emit next queue from current residuals, not from stale seeds.

Stop rules:

- no optimistic `available`, `native`, `done`, `implemented`, or `complete` without proof locator;
- generated/private proof outputs remain ignored.

Proof:

- `bash tests/control-plane-rc4-rc6.sh`
- `bash tests/recursive-self-improvement-contract.sh`
- `bash tests/semantic-negative-fixtures.sh`
- `bash tests/dogfood-workspace-contract.sh`

## Final Root Verification Plan

Root will run after subagent delivery and review:

```bash
bash tests/linear-structured-mcp-binding.sh
bash tests/browser-proof-monitoring.sh
bash tests/skill-export-proof.sh
bash tests/promotion-replay-fixtures.sh
bash tests/agent-install-export-contract.sh
bash tests/control-plane-rc4-rc6.sh
bash tests/recursive-self-improvement-contract.sh
bash tests/semantic-negative-fixtures.sh
bash tests/dogfood-workspace-contract.sh
bash tests/all.sh
git diff --check
```

Root will inspect active tool-managed/background processes and fixture server/browser patterns, kill only owned/trapped/idle processes, commit/push only when supported, then watch remote CI for the final commit.
