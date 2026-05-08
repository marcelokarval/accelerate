# Recursive Cycle 7..12 Executive Plan

Date: 2026-05-08
Root: Accelerate recursive self-improvement
Repository: `/home/marcelo-karval/Backup/Projetos/accelerate`

## Branch Entry Packet

- classification: orchestrated non-trivial work
- active branch: recursive self-improvement cycle 7..12
- active persona: root orchestrator + final forensic reviewer
- active stack: workflow adapters, runtime/browser proof, skill sync/export, agent factory, runtime adapter maturity, dogfood/semantic gates
- active skills:
  - accelerate
  - subagent-governance
  - parallel-agents
  - verification-before-completion
  - github-pr-workflow
  - linear-pm
  - playwright-patterns
- active ADRs / references:
  - `AGENTS.md`
  - `SKILL.md`
  - `README.md`
  - `core/control-plane/capability-maturity-dashboard.md`
  - `core/control-plane/recursive-improvement-situation-dashboard.md`
  - `core/control-plane/runtime-adapter-maturity-dashboard.md`
  - `core/control-plane/skill-sync-topology.md`
  - `core/control-plane/agent-factory-promotion-pipeline.md`
  - `adapters/workflow/remote-write-registry.yaml`
  - `core/runtime-packets/browser-proof-packet.md`
  - `adapters/runtime/browser/browser-truth-contract.md`
  - `planning/executive/2026-05-08-recursive-cycle-1-6-executive-plan.md`
  - `planning/executive/2026-05-08-recursive-cycle-1-6-task-ledger.md`
- local workspace:
  - `.accelerate=present`
  - action=reused + keep current with this cycle
  - readiness dashboard=`.accelerate/status/readiness-dashboard.yaml`
  - current governing artifact=`planning/executive/2026-05-08-recursive-cycle-7-12-executive-plan.md`
  - current task ledger=`planning/executive/2026-05-08-recursive-cycle-7-12-task-ledger.md`
  - drift status=must be rechecked before closure
- gate ledger:
  - prompt-hardening=applied through this execution plan
  - orchestrator-first-execution=active
  - subagent-governance=active
  - linear-live-proof=credential-gated, non-sensitive fixture only
  - browser-proof/server-monitoring=active
  - skill-export-proof=repo-local source only
  - agent-factory-replay=no autonomous runtime claim
  - final-verification=required before commit/push
- phase / SDLC: recursive improvement implementation + review-of-review
- issue stack status: repo uses planning docs as current workflow vehicle; no fake Linear issue authority for this repo
- QA / proof lane: local contract tests, live non-sensitive provider proof where safe, remote CI after push
- browser-proof intensity: server readiness + capture failure packet + successful capture/persistent regression separation
- persistent E2E status: bounded fixture-level only unless subagent proves more
- local review / closure action: root final review, process cleanup, CI watch
- single-threaded exception: n/a; execution and task review delegated to subagents

## Prompt Hardening Packet

- Prompt A: Proceed with the six next steps from the prior recursive cycle; build the complete executive plan and complete tasks; start execution; task execution/review by subagents; root is orchestrator and final reviewer; actively close idle agents with delivered results; monitor agents for real stalls; analyze browser-proof server monitoring and active correction; final report plus next steps.
- Prompt B: Execute Accelerate recursive cycle 7..12 as an orchestrator-first, subagent-driven run. Persist an executive plan and task ledger first. Delegate bounded implementation/review slices for Linear live fixture proof + closure/status bindings, browser-proof runtime expansion, skill export proof, agent factory replay, runtime adapter maturity follow-through, and dogfood/semantic gate maintenance. Require each subagent to anchor the worktree, obey write scopes, self-review, and return requested-vs-implemented/proof/residuals. Root must monitor subagent completion, inspect actual diffs, run final verification, clean processes, commit/push if supported, watch CI, then report outcome and next queue.
- Material changes: bounded into six RC tasks with explicit write scopes, stop rules, live-proof safety, and root review gates.

## Executive Objective

Turn the previous cycle's residuals into bounded proof-bearing improvements without pretending unproven runtime/provider capabilities are available. The cycle must improve actual Accelerate operational maturity, not merely add optimistic documentation.

## Success Criteria

1. Linear repo-local helpers have safe live fixture proof where credentials allow, and closure-comment/status-transition helpers are implemented as structured non-LLM GraphQL bindings with dry-run and live-mode safety.
2. Browser proof is split into explicit phases: server readiness, browser capture, persistent regression/monitoring, failure packet, and cleanup/correction guidance. Server-not-running failures must produce actionable evidence before browser launch.
3. Skill export proof is reproducible from repo-local source to generated export artifact with provenance and drift detection; user-home catalogs remain non-authoritative.
4. One bounded agent-factory candidate role is replayed through intake, skill envelope, proof replay, cleanup/idle-agent handling, and root acceptance without claiming autonomous runtime availability.
5. Runtime adapter maturity dashboard is updated based on proof/demotion results from RC7..RC10, and adapter status honesty is contract-tested.
6. `.accelerate/` dogfood workspace and semantic negative gates reflect this new cycle's state and prevent optimistic status promotion for all new surfaces.
7. All changes pass local verification, `git diff --check`, active process cleanup inspection, commit/push, and remote CI watch.

## Non-Goals

- Do not promote Linear or any runtime adapter to `available` without live non-sensitive proof and durable proof locator.
- Do not use private Linear data or sensitive artifacts as committed proof.
- Do not claim autonomous agent runtime availability.
- Do not edit user-home skill catalogs as source truth.
- Do not leave server/browser/subagent/background processes idle after proof.
- Do not merge unrelated Accelerate work from other sessions.

## Execution Model

Root is orchestrator and final reviewer only. Implementation and task-level review are delegated to bounded subagents. Root may perform planning, monitoring, final verification, and blocker-class corrections only if a subagent times out after producing useful artifacts or if a small integration fix is required for closure.

Subagents must start with:

```bash
pwd && git status --short --branch
```

Wrong worktree output is non-evidence.

Every subagent must return:

- assigned scope;
- files changed / inspected;
- requested-vs-implemented;
- validation run;
- self-review;
- self-forensic review;
- defects found and disposition;
- residual risks;
- recommendation.

## Task Set

### RC7 — Linear live fixture proof + closure/status structured bindings

Goal: move Linear from helper-shape-only toward proof-bearing structured provider operations without optimistic promotion.

Primary files:

- `onboarding/local-workspace/read-linear-mcp-adapter.sh`
- `onboarding/local-workspace/create-linear-mcp-issue.sh`
- `onboarding/local-workspace/attach-linear-mcp-artifact.sh`
- `onboarding/local-workspace/comment-linear-mcp-closure.sh`
- `onboarding/local-workspace/update-linear-mcp-status.sh`
- `onboarding/local-workspace/validate-linear-comment-response.sh`
- `onboarding/local-workspace/validate-linear-issue-response.sh`
- `adapters/workflow/remote-write-registry.yaml`
- `core/control-plane/capability-maturity-dashboard.md`
- `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md`
- `tests/linear-structured-mcp-binding.sh`

Required implementation:

- implement closure comment helper using GraphQL `commentCreate` after issue read/normalization;
- implement status transition helper using GraphQL issue update after issue read/normalization;
- preserve dry-run JSONL with `remote_calls:false`;
- preserve `LINEAR_API_KEY` requirement before live calls;
- validate output path under `.accelerate/workflow/` and reject symlink/escaping paths;
- add/extend contract tests for closure/status dry-run, missing token, path safety, registry honesty, and no LLM-host dependency;
- if live fixture proof is possible, create or use a non-sensitive fixture issue, attach export-approved artifact, write closure comment, transition through a safe status, and record sanitized evidence.

Stop rules:

- stop before committing private Linear payloads or tokens;
- if no safe team/status can be determined, keep live proof blocked and record the blocker honestly;
- do not promote to `available` unless proof exists and dashboards/registry point to the proof.

### RC8 — Browser-proof runtime expansion and active server monitoring

Goal: make browser-proof failure modes actionable and prevent server-not-running conditions from appearing as opaque browser failures.

Primary files:

- `onboarding/local-workspace/capture-browser-proof.sh`
- `tests/browser-proof-monitoring.sh`
- `core/runtime-packets/browser-proof-packet.md`
- `adapters/runtime/browser/browser-truth-contract.md`
- `core/control-plane/runtime-adapter-maturity-dashboard.md`

Required implementation:

- keep server readiness before browser launch;
- add a monitor/correction shape for server startup checks, server process liveness, HTTP code, stdout/stderr detail, and cleanup;
- distinguish packets for `server-readiness`, `browser-capture`, `readiness-only`, `capture-failed`, and persistent regression handoff;
- verify successful capture path when local browser runtime is available, or emit honest runtime-unavailable packet when not;
- ensure fixture servers are actively killed and leak-checked;
- update docs/tests so missing server produces a correction signal, not a vague browser failure.

Stop rules:

- do not require network beyond localhost;
- do not persist screenshots or private output outside approved/ignored paths;
- do not claim Playwright/persistent E2E availability unless repo-owned proof exists.

### RC9 — Skill export proof from repo source to generated bundle

Goal: prove the `repo -> generated export -> host runtime` topology without making generated output source truth.

Primary files:

- `core/control-plane/skill-sync-topology.md`
- `skills/README.md`
- `skills/_registry/manifest.md`
- `scripts/sync-skills-to-global.sh`
- `scripts/check-global-skill-mirror.sh`
- `scripts/validate-skill-registry.sh`
- new/updated export proof script/test if needed
- `planning/evidence/dated-proof-appendix/skill-export-proof-2026-05-08.md`

Required implementation:

- add a reproducible dry-run/export proof path that uses repo-local skills only;
- write provenance with source commit/tree, selected skill set, generated target, and drift detection result;
- keep host/user-home catalogs explicitly non-authoritative;
- add contract tests for provenance, source-only export, generated artifact boundary, and stale export detection.

Stop rules:

- do not overwrite user-home runtime catalogs during tests unless explicitly operating in a temp fixture;
- do not treat generated bundles as authoritative docs.

### RC10 — Agent factory replay of one bounded candidate role

Goal: exercise the promotion pipeline with one bounded candidate role while keeping autonomous runtime blocked.

Primary files:

- `core/control-plane/agent-factory-promotion-pipeline.md`
- `core/delegation/agent-factory-promotion-pipeline.md`
- `agents/promotion/`
- `tests/promotion-replay-fixtures.sh`
- `tests/agent-install-export-contract.sh`
- possible new replay packet under `planning/evidence/dated-proof-appendix/agent-factory-replay-2026-05-08.md`

Required implementation:

- select one bounded role candidate (prefer reviewer/proof auditor, no broad write scope);
- define candidate intake, non-goals, allowed/forbidden scope, skill envelope, proof fixture, negative fixture, cleanup rule, and demotion rule;
- run/prove replay against fixtures;
- update dashboards without claiming autonomous runtime availability.

Stop rules:

- no persistent agent runtime claim;
- no nested delegation from subagent;
- no untracked generated transcript or private provider output committed.

### RC11 — Runtime adapter maturity follow-through

Goal: update maturity dashboards based on actual proof from RC7..RC10 and add status honesty tests for any promotion/demotion.

Primary files:

- `core/control-plane/runtime-adapter-maturity-dashboard.md`
- `core/control-plane/capability-maturity-dashboard.md`
- `core/control-plane/recursive-improvement-situation-dashboard.md`
- `adapters/workflow/remote-write-registry.yaml`
- `tests/control-plane-rc4-rc6.sh`
- `tests/recursive-self-improvement-contract.sh`
- new test if RC7..RC10 need narrower status checks

Required implementation:

- align statuses and proof locators with actual evidence;
- promote only proven scopes;
- demote or keep planned/blocked where proof is absent;
- update next queue from actual residuals.

Stop rules:

- no optimistic `available`, `native`, `done`, `implemented`, or `complete` without proof locator.

### RC12 — Dogfood workspace and semantic negative gate maintenance

Goal: make this cycle visible in `.accelerate/` and extend negative fixtures to guard new surfaces.

Primary files:

- `.accelerate/status/readiness-dashboard.yaml`
- `.accelerate/workflow/active-work-item.yaml`
- `.accelerate/README.md`
- `tests/dogfood-workspace-contract.sh`
- `tests/semantic-negative-fixtures.sh`
- `planning/executive/2026-05-08-recursive-cycle-7-12-task-ledger.md`

Required implementation:

- update current governed plan/ledger references;
- add semantic negative checks for new cycle statuses/proof locators;
- preserve ignored/private output boundaries;
- ensure active work item reflects root orchestrator and subagent review model.

Stop rules:

- do not commit generated/private proof output;
- do not overwrite local workspace state with fiction.

## Review And Verification Plan

Task-level review is required from each subagent. Root final review must inspect actual files and diffs, not only summaries.

Minimum final local commands:

```bash
bash tests/linear-structured-mcp-binding.sh
bash tests/browser-proof-monitoring.sh
bash tests/control-plane-rc4-rc6.sh
bash tests/recursive-self-improvement-contract.sh
bash tests/semantic-negative-fixtures.sh
bash tests/dogfood-workspace-contract.sh
bash tests/all.sh
git diff --check
```

Process cleanup proof:

```bash
pgrep -af "python3 -m http.server|node .*puppeteer|playwright|chrome|chromium" || true
```

Publication proof after supported local verification:

```bash
git status --short --branch
git add -A
git commit -m "Add recursive proof follow-through"
git push origin main
gh run list --branch main --limit 5
gh run watch <run-id>
```

## Residual Policy

Residuals are acceptable only if explicitly recorded as planned/blocked with next proof condition. Silent residuals block closure.
