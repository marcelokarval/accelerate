# Linear OAuth MCP + Runtime Proof Gates Executive Plan

Date: 2026-05-08
Root orchestrator: Claw
Governing Linear issue: P4Y-1298
Repository: `/home/marcelo-karval/Backup/Projetos/accelerate`

## Branch Entry Packet

- classification: orchestrated non-trivial recursive self-improvement / runtime proof promotion
- active branch: `main`
- active persona: root orchestrator and final forensic reviewer
- active stack: Accelerate control plane, Linear workflow adapter, runtime/browser proof governance, persistent E2E handoff, skill export topology, agent factory promotion pipeline
- active skills:
  - accelerate
  - subagent-governance
  - linear-pm
  - systematic-debugging
  - browser-proof-tool-routing
- active ADRs / references:
  - `AGENTS.md`
  - `SKILL.md`
  - `README.md`
  - `core/control-plane/capability-maturity-dashboard.md`
  - `core/control-plane/recursive-improvement-situation-dashboard.md`
  - `core/control-plane/runtime-adapter-maturity-dashboard.md`
  - `core/control-plane/skill-sync-topology.md`
  - `.accelerate/status/readiness-dashboard.yaml`
  - `references/recursive-self-improvement-cycle.md`
  - `references/runtime-packet-templates.md`
  - `references/linear-execution.md`
- local workspace:
  - `.accelerate=present`
  - action=reused with current-cycle update required
  - readiness dashboard=`.accelerate/status/readiness-dashboard.yaml`
  - readiness status=active; must be updated to this cycle if artifacts land
  - current governing artifact=`P4Y-1298` + this plan
  - drift status=clean at entry (`git status --short --branch` clean)
- gate ledger:
  - governing Linear issue: passed (`P4Y-1298` created via OAuth MCP and moved to In Progress)
  - prompt hardening: passed by this execution plan
  - subagent budget: max 4 simultaneous; completed/closed agents free slots
  - root executor restriction: active; root creates orchestration artifacts and final review only
  - Linear OAuth discovery: open
  - browser-proof server/capture correction: open
  - persistent E2E handoff: open
  - skill export / agent runtime boundary: open
  - final proof suite: pending
  - remote CI: pending if commit/push occurs
- phase / SDLC: Proof-promotion cycle after pre-agents hardening
- mandatory gates: targeted tests per task, `bash tests/recursive-self-improvement-contract.sh`, `bash tests/all.sh`, `git diff --check`, root review-of-review
- required artifacts:
  - this executive plan
  - `planning/executive/2026-05-08-linear-oauth-runtime-proof-task-ledger.md`
  - updated proof appendix for Linear OAuth MCP
  - final root review appendix
- closure blockers:
  - subagent return packets missing requested-vs-implemented/self-review/forensic review
  - Linear OAuth status promoted beyond actual proof
  - browser proof claiming healthy server without live/readiness evidence
  - persistent E2E claimed from one-off browser capture
  - autonomous/physical-agent runtime claimed without invocation/lifecycle/cleanup/root-acceptance proof
  - failing tests or dirty worktree not accounted for
- QA / proof lane: targeted task proof -> recursive contract -> full suite -> root forensic closure
- issue stack status: P4Y-1298 In Progress
- browser-proof intensity: server readiness/capture correction audit and hardening; no persistent E2E claim without separate proof
- persistent E2E status: planned unless subagent lands a separate repo-owned proof locator
- local review / closure action: root final review after subagent implementation and subagent review waves
- single-threaded exception: n/a; work is delegated with root final review

## Prompt Hardening Packet

- Prompt A: Karval asked to focus on Linear, correcting the assumption that Linear uses API key because it is OAuth-logged in Codex, then build a complete executive plan/task ledger, start execution, use subagents for task review, root as orchestrator/final reviewer, actively monitor/retire idle or stuck agents, analyze browser-proof server monitoring, and report completed work plus next steps with max 4 simultaneous agents.
- Prompt B: Execute a bounded Accelerate recursive proof-promotion cycle governed by P4Y-1298. Root must create the plan/task ledger, delegate bounded implementation and review tasks with max 4 simultaneous subagents, correct Linear API-key-only assumptions by representing OAuth MCP as a first-class authenticated lane, harden browser-proof server/capture monitoring where needed, preserve status honesty for persistent E2E, skill export, and agent runtime gates, run final tests, commit/push if supported by the final proof, watch CI, and report residuals and next steps.
- material change: clarified that Linear proof must use OAuth MCP capability, not only `LINEAR_API_KEY` shell fallback.
- non-goals: no fake provider promotion, no secret/payload commit, no autonomous runtime claim, no root primary implementation beyond orchestration artifacts and final integration repairs.

## Strategic Diagnosis

RC18 correctly failed closed for the repo-local shell helper path, but its promotion model assumed `LINEAR_API_KEY` was the only usable live proof credential. Karval clarified that the execution environment is already authenticated to Linear through OAuth-backed MCP. Therefore the next maturity step is not to keep asking for `LINEAR_API_KEY`; it is to separate and prove two lanes:

1. `linear-oauth-mcp` lane: host-authenticated MCP tools, already usable by the orchestrator environment, suitable for governed issue/read/write operations when privacy and scope gates are satisfied.
2. `linear-api-key-graphql` lane: repo-local shell fallback/direct GraphQL helper, still planned/blocked unless a safe API key and fixture env exist.

The repo must not collapse these lanes. OAuth MCP availability in this operator environment does not automatically prove portable shell execution in CI or another host. Conversely, lack of `LINEAR_API_KEY` does not mean Linear itself is unavailable to the current Codex/Hermes runtime.

## Success Criteria

1. Linear OAuth MCP truth is represented explicitly in repo docs/dashboard/proof without exposing provider secrets or private payloads.
2. API-key GraphQL helper status remains honest as fallback/planned when no API key exists.
3. At least one sanitized OAuth MCP read/discovery proof is recorded; mutation proof may be recorded only if bounded to P4Y-1298 or explicitly created fixture issues.
4. Browser-proof monitoring/capture code/docs/tests are audited and hardened for dead/missing server cases where current behavior is insufficient.
5. Remaining gates are preserved honestly:
   - persistent E2E remains planned unless a separate proof lands;
   - generated host export remains available only under approved generated target boundary;
   - physical/autonomous agent runtime remains blocked/planned unless real invocation/lifecycle/cleanup/root-acceptance proof lands.
6. Subagents implement/review bounded slices; root performs final review-of-review against actual files, tests, diffs, and process state.
7. Final closure includes next-step emission based on updated dashboards.

## Agent Budget And Monitoring Contract

- Maximum simultaneous subagents: 4.
- Completed subagents free slots for new review/fix waves.
- Subagents are leaf workers unless explicitly told otherwise; no nested delegation.
- Each subagent must start by reporting `pwd && git status --short --branch`.
- Each subagent must report whether it started servers, browser sessions, or background processes.
- A subagent is considered stuck only after a health/interaction attempt fails or it stops responding without useful progress signal; naturally slow tasks are not classified as stuck merely by duration.
- Idle delivered subagents are retired/closed by not reusing them for unrelated scope.
- Root must inspect final process state and account for browser/server proof processes before closure.

## Execution Slices

### RC24 — Linear OAuth MCP lane proof and dashboard correction

Owner: implementation subagent A; later reviewed by separate reviewer.

Allowed write scope:
- `planning/evidence/dated-proof-appendix/linear-mcp-oauth-validation-2026-05-08.md`
- `core/control-plane/capability-maturity-dashboard.md`
- `core/control-plane/recursive-improvement-situation-dashboard.md`
- `.accelerate/status/readiness-dashboard.yaml`
- `adapters/workflow/linear/README.md`
- `adapters/workflow/linear/capabilities.yaml`
- tests directly related to Linear OAuth/status honesty

Required work:
- Verify current OAuth MCP capability through available Linear MCP tools without leaking payloads.
- Document the difference between OAuth MCP lane and API-key GraphQL fallback.
- Update dashboards so Linear is not falsely blocked by missing API key when OAuth MCP is the current host lane, but do not claim portable repo-local shell availability.
- Add or update tests/semantic negatives to prevent conflating OAuth MCP proof with API-key fallback proof.

Proof:
- Linear MCP tool read/discovery proof, sanitized.
- Targeted tests: `bash tests/linear-structured-mcp-binding.sh`, `bash tests/semantic-negative-fixtures.sh`, and any new/updated Linear OAuth test.

Stop rules:
- Stop before any broad Linear mutation outside P4Y-1298 or explicitly-created fixture issues.
- Stop if proof would require committing provider payloads, private issue content, user emails, raw team names beyond already-visible public/governing issue identifiers, or tokens.

### RC25 — Browser-proof server readiness, capture, and correction hardening

Owner: implementation subagent B; later reviewed by separate reviewer.

Allowed write scope:
- `onboarding/local-workspace/capture-browser-proof.sh`
- `tests/browser-proof-monitoring.sh`
- `core/runtime-packets/browser-proof-packet.md`
- `adapters/runtime/browser/browser-truth-contract.md`
- `core/control-plane/runtime-adapter-maturity-dashboard.md`
- proof appendix if needed

Required work:
- Audit current server readiness/capture behavior for cases where no server is running, server dies after readiness, or capture starts without a valid live target.
- Harden monitoring and correction output if gaps exist.
- Ensure captured output includes enough server stdout/stderr/process/readiness context for active correction, without pretending capture succeeded.
- Ensure fixture servers are cleaned up and no ambient browser/user Chrome is killed.

Proof:
- `bash -n onboarding/local-workspace/capture-browser-proof.sh`
- `bash tests/browser-proof-monitoring.sh`
- process cleanup statement from subagent.

Stop rules:
- Do not introduce persistent E2E claim.
- Do not kill user-owned browser/devtools processes.

### RC26 — Persistent E2E, generated-host export, and agent-runtime boundary preservation

Owner: implementation subagent C; later reviewed by separate reviewer.

Allowed write scope:
- `core/control-plane/runtime-adapter-maturity-dashboard.md`
- `core/control-plane/skill-sync-topology.md`
- `core/control-plane/agent-factory-promotion-pipeline.md`
- `.accelerate/status/readiness-dashboard.yaml`
- `tests/semantic-negative-fixtures.sh`
- `tests/promotion-replay-fixtures.sh`
- `tests/skill-export-proof.sh` only if necessary

Required work:
- Preserve persistent E2E as planned unless separate proof is implemented.
- Preserve generated-host export boundary: available only for temp/approved generated targets, not user-home authority.
- Preserve agent runtime as blocked/planned without real physical adapter invocation/lifecycle/idle cleanup/demotion/root acceptance proof.
- Add negative checks where current language can be optimistically misread.

Proof:
- `bash tests/semantic-negative-fixtures.sh`
- `bash tests/promotion-replay-fixtures.sh`
- `bash tests/skill-export-proof.sh` if touched.

Stop rules:
- Do not implement broad physical-agent runtime unless it can be proven within this slice.
- Do not promote runtime availability from plan-only evidence.

### RC27 — Governance integration, dogfood state, task ledger, and final next queue

Owner: implementation subagent D; later reviewed or root-reviewed depending on conflicts.

Allowed write scope:
- `.accelerate/README.md`
- `.accelerate/status/readiness-dashboard.yaml`
- `.accelerate/workflow/active-work-item.yaml`
- `core/control-plane/recursive-improvement-situation-dashboard.md`
- `planning/executive/2026-05-08-linear-oauth-runtime-proof-task-ledger.md`
- final proof appendices if requested by root

Required work:
- Align local dogfood state with P4Y-1298 and this cycle.
- Ensure next queue reflects actual updated gates after RC24-RC26.
- Ensure task ledger statuses and proof placeholders are coherent.

Proof:
- `bash tests/dogfood-workspace-contract.sh`
- `bash tests/recursive-self-improvement-contract.sh`

Stop rules:
- Do not mark tasks delivered before implementation/review evidence exists.
- Do not rewrite unrelated historical cycle evidence.

## Review Plan

After implementation wave:

1. Spawn review subagents with read-only scope for RC24, RC25, RC26/RC27 as needed, respecting max 4 simultaneous.
2. Reviewers must compare assigned task text to actual diffs and tests.
3. Root will inspect `git diff`, read changed files, run targeted gates and full suite.
4. Root will make only blocker-class integration repairs if necessary.
5. Root will prepare final review appendix, commit/push, and watch CI if proof supports it.

## Final Verification Plan

Required before closure:

```bash
bash tests/linear-structured-mcp-binding.sh
bash tests/browser-proof-monitoring.sh
bash tests/semantic-negative-fixtures.sh
bash tests/dogfood-workspace-contract.sh
bash tests/recursive-self-improvement-contract.sh
bash tests/all.sh
git diff --check
```

If additional tests are added or touched, run them explicitly.

## Residual Policy

Residuals are acceptable only when they are status-honest and packeted:

- OAuth MCP lane may be available in the current host but not portable to all hosts.
- API-key GraphQL shell fallback may remain planned/blocked without `LINEAR_API_KEY`.
- Persistent E2E may remain planned.
- Agent runtime may remain blocked.
- Browser capture may remain conditional if runtime dependencies are missing, but correction packets must be honest.

## Anticipated Next Steps

Expected next queue after this cycle:

1. Convert OAuth MCP Linear proof from host-discovery/read into a durable non-sensitive fixture mutation package if not completed here.
2. Add portable MCP invocation abstraction or host capability manifest so repo scripts can distinguish MCP OAuth host from API-key GraphQL fallback.
3. Build persistent E2E proof as a separate repo-owned Playwright regression fixture.
4. Implement the first physical-agent adapter binding with lifecycle monitor, idle cleanup, demotion, and root acceptance proof.
