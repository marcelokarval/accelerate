# Linear OAuth MCP + Runtime Proof Gates Task Ledger

Date: 2026-05-08
Governing issue: P4Y-1298
Executive plan: `planning/executive/2026-05-08-linear-oauth-runtime-proof-executive-plan.md`
Concurrency cap: max 4 simultaneous subagents; completed/closed subagents free slots.
Root role: orchestrator + final forensic reviewer, not primary executor.

## Global Task Contract For All Subagents

Every subagent must:

1. Start with `pwd && git status --short --branch` and report the output.
2. Stay in `/home/marcelo-karval/Backup/Projetos/accelerate`.
3. Respect allowed write scope and forbidden scope.
4. Avoid committing secrets, tokens, private provider payloads, private screenshots, generated private artifacts, or raw Linear response dumps.
5. Return a Subagent Return Packet with:
   - scope handled
   - files changed / surfaces inspected
   - evidence used
   - requested-vs-implemented comparison
   - tests / verification run
   - self-review
   - self-forensic review
   - defects found and disposition
   - process/server/browser state
   - unresolved risks
   - recommendation: done / partial / follow-up / blocked
6. Not spawn nested subagents.
7. Stop and report if the correct fix requires broad scope outside the task.

## RC24 — Linear OAuth MCP lane proof and dashboard correction

Status: accepted by root final review after independent subagent review and full-suite verification
Primary implementation owner: Subagent A
Reviewer: separate review subagent after implementation wave
Priority: P0 for this cycle

### Problem

The previous RC18 state treated Linear live proof as blocked because `LINEAR_API_KEY` was absent. Karval clarified that the real current environment is already authenticated through OAuth-backed Linear MCP in Codex/Hermes. The repo must distinguish OAuth MCP host capability from API-key GraphQL shell fallback.

### Allowed Write Scope

- `planning/evidence/dated-proof-appendix/linear-mcp-oauth-validation-2026-05-08.md`
- `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md` only for narrow correction/pointer if needed
- `core/control-plane/capability-maturity-dashboard.md`
- `core/control-plane/recursive-improvement-situation-dashboard.md`
- `.accelerate/status/readiness-dashboard.yaml`
- `adapters/workflow/linear/README.md`
- `adapters/workflow/linear/capabilities.yaml`
- `adapters/workflow/remote-write-registry.yaml` only if needed to add an OAuth MCP lane without disturbing API-key fallback
- `tests/linear-structured-mcp-binding.sh`
- `tests/semantic-negative-fixtures.sh` or a new focused Linear OAuth status-honesty test

### Forbidden Scope

- No broad rewrite of workflow adapter architecture.
- No token/API key assumptions as the only Linear truth.
- No raw provider JSON or private Linear payload committed.
- No unrelated GitHub adapter or agent runtime changes.

### Required Implementation

1. Inspect current Linear helper docs/scripts/status dashboards.
2. Use available Linear MCP/OAuth tools for a sanitized discovery proof:
   - current user identity present;
   - team key/id discoverable;
   - statuses discoverable;
   - P4Y-1298 governing issue created/updated through OAuth MCP if already available in the run.
3. Create `linear-mcp-oauth-validation-2026-05-08.md` with sanitized facts only.
4. Update capability/status dashboards so:
   - Linear OAuth MCP lane is at most `available`/`conditional` for this authenticated host and bounded issue operations if proof supports it;
   - API-key GraphQL shell fallback remains `planned`/blocked without `LINEAR_API_KEY`;
   - no language implies OAuth host proof equals portable CI/script proof.
5. Add tests or semantic negatives that fail if docs collapse OAuth MCP proof into API-key fallback availability.
6. Run targeted tests.

### Required Proof

- `bash tests/linear-structured-mcp-binding.sh`
- `bash tests/semantic-negative-fixtures.sh`
- any new Linear OAuth status test if created

### Stop Rules

- Stop before mutating non-fixture/private Linear issues.
- Stop before promoting broad Linear availability without proof.
- Stop if a proof requires committing private provider details.

### Acceptance

- Repo explicitly models OAuth MCP and API-key GraphQL as separate lanes.
- Status is upgraded only within the proven OAuth host boundary, or remains planned with a clear blocker if proof is insufficient.
- Targeted tests pass.

## RC25 — Browser-proof server readiness/capture correction hardening

Status: accepted by root final review after independent subagent review and full-suite verification
Primary implementation owner: Subagent B
Reviewer: separate review subagent after implementation wave
Priority: P1

### Problem

Browser-proof can become misleading when no server is running correctly, the server dies after readiness, or capture starts without a reachable target. The helper must actively monitor server/process/readiness output and emit correction evidence rather than silent failure or false closure.

### Allowed Write Scope

- `onboarding/local-workspace/capture-browser-proof.sh`
- `tests/browser-proof-monitoring.sh`
- `core/runtime-packets/browser-proof-packet.md`
- `adapters/runtime/browser/browser-truth-contract.md`
- `core/control-plane/runtime-adapter-maturity-dashboard.md`
- optional proof appendix under `planning/evidence/dated-proof-appendix/`

### Forbidden Scope

- No persistent E2E implementation claim.
- No deletion of unrelated browser/runtime docs.
- No killing user-owned Chrome/DevTools processes.
- No committing screenshots/private captures.

### Required Implementation

1. Inspect current capture helper and tests for missing server/dead server/capture failure behavior.
2. Add or improve monitoring so correction packets expose:
   - target URL;
   - readiness status;
   - process liveness where the helper owns the process;
   - bounded stdout/stderr tails;
   - whether browser launch was skipped or capture failed;
   - cleanup disposition.
3. Ensure no browser launches before readiness passes.
4. Ensure server-crash-after-readiness results in correction packet, not false success.
5. Ensure fixture processes are cleaned up by tests.
6. Update docs/dashboard boundaries.

### Required Proof

- `bash -n onboarding/local-workspace/capture-browser-proof.sh`
- `bash tests/browser-proof-monitoring.sh`

### Stop Rules

- Stop if hardening requires unrelated runtime adapter redesign.
- Stop if proof would require non-localhost/private captures.

### Acceptance

- Browser-proof server monitoring handles missing/dead/crashed server cases honestly.
- Targeted browser monitoring tests pass.
- Subagent reports process cleanup status.

## RC26 — Persistent E2E, generated-host export, and agent-runtime boundary preservation

Status: accepted by root final review after independent subagent review and full-suite verification
Primary implementation owner: Subagent C
Reviewer: separate review subagent after implementation wave
Priority: P1

### Problem

The next gates must not be accidentally promoted by improved Linear/browser proof. Persistent E2E, generated-host export, and agent runtime have distinct proof requirements.

### Allowed Write Scope

- `core/control-plane/runtime-adapter-maturity-dashboard.md`
- `core/control-plane/skill-sync-topology.md`
- `core/control-plane/agent-factory-promotion-pipeline.md`
- `core/delegation/agent-factory-promotion-pipeline.md` if necessary
- `.accelerate/status/readiness-dashboard.yaml`
- `tests/semantic-negative-fixtures.sh`
- `tests/promotion-replay-fixtures.sh`
- `tests/skill-export-proof.sh` only if necessary

### Forbidden Scope

- No broad physical-agent implementation unless separately approved by root after proof feasibility.
- No user-home skill catalog writes.
- No promotion of persistent E2E from one-off browser capture.
- No promotion of autonomous runtime from fixture replay.

### Required Implementation

1. Audit current language for persistent E2E, generated host export, and physical/autonomous agent runtime.
2. Add semantic negatives or dashboard clarifications where optimistic language can pass.
3. Keep generated-host export available only inside temp/approved generated-host proof boundary.
4. Keep bounded proof-auditor candidate as proof-replay unless runtime invocation/lifecycle/cleanup/demotion/root acceptance are truly implemented and proven.
5. Keep persistent E2E planned unless a separate proof locator exists.

### Required Proof

- `bash tests/semantic-negative-fixtures.sh`
- `bash tests/promotion-replay-fixtures.sh`
- `bash tests/skill-export-proof.sh` if touched

### Stop Rules

- Stop if implementation would exceed boundary into full autonomous runtime.
- Stop if a status promotion lacks durable proof locator.

### Acceptance

- Remaining gates are status-honest after Linear/browser updates.
- Tests catch accidental overpromotion.

## RC27 — Governance integration, dogfood state, and next queue

Status: accepted by root final review after independent subagent review and full-suite verification
Primary implementation owner: Subagent D
Reviewer: separate review subagent or root depending on conflicts
Priority: P1

### Problem

The local `.accelerate` dogfood state, recursive improvement dashboard, and task ledger must point to this cycle and emit next steps from updated truth, not stale RC18..22 assumptions.

### Allowed Write Scope

- `.accelerate/README.md`
- `.accelerate/status/readiness-dashboard.yaml`
- `.accelerate/workflow/active-work-item.yaml`
- `core/control-plane/recursive-improvement-situation-dashboard.md`
- `planning/executive/2026-05-08-linear-oauth-runtime-proof-task-ledger.md`
- final review appendix skeleton if root requests it

### Forbidden Scope

- No marking tasks complete before evidence exists.
- No rewriting unrelated historical proof appendices.
- No changing source-of-truth rules for user-home skills.

### Required Implementation

1. Align dogfood cycle metadata with this plan and P4Y-1298.
2. Update next queue to reflect OAuth MCP Linear lane and browser-proof hardening outcome.
3. Keep task statuses honest: assigned/in-progress/reviewed/delivered as evidence lands.
4. Ensure dogfood tests continue to pass.

### Required Proof

- `bash tests/dogfood-workspace-contract.sh`
- `bash tests/recursive-self-improvement-contract.sh`

### Stop Rules

- Stop if task ledger would require accepting other subagent work before it exists.

### Acceptance

- Dogfood workspace points to current cycle.
- Next queue is not stale.
- Targeted governance tests pass.

### RC27 Status Alignment Notes

- Dogfood files now point at the current `P4Y-1298` governed cycle and record `P4Y-1302` as the child handoff identifier provided for this RC27 task.
- RC24/RC25/RC26 statuses are not marked reviewed or delivered here; they are marked only as implementation evidence present because changed files/proof locators exist in the worktree and still require independent review/root acceptance.
- RC27 is likewise implementation-evidence-present only after local dogfood/governance edits; final acceptance remains with the reviewer/root after proof inspection.
- Next queue source is `core/control-plane/recursive-improvement-situation-dashboard.md#next-queue-seed` and intentionally keeps portable Linear writes, persistent E2E, broader host export, and autonomous agent runtime unpromoted.

## Review Wave Tasks

### RV24 — Review RC24 Linear OAuth MCP lane

Status: completed; reviewer recommended accept after root fixed two integration nits
Read-only scope: changed Linear files, dashboards, proof appendix, tests.
Required reviewer output:
- requested-vs-implemented by RC24 item;
- status honesty assessment;
- provider privacy assessment;
- proof adequacy;
- defects/blockers;
- recommendation.

### RV25 — Review RC25 browser-proof hardening

Status: completed; reviewer recommended accept after root fixed two integration nits
Read-only scope: browser helper/docs/tests/dashboard.
Required reviewer output:
- server readiness/capture correction assessment;
- process cleanup assessment;
- browser-proof vs persistent E2E boundary assessment;
- defects/blockers;
- recommendation.

### RV26 — Review RC26/RC27 boundary/governance integration

Status: completed; reviewer recommended accept after root fixed two integration nits
Read-only scope: dashboards, semantic negatives, skill export/agent runtime boundaries, dogfood state, task ledger.
Required reviewer output:
- overpromotion scan;
- stale cycle pointer scan;
- test/proof assessment;
- defects/blockers;
- recommendation.

## Root Final Review Task

Status: completed; final review appendix recorded and full test suite passed
Owner: Claw root orchestrator

Required root actions after subagent waves:

1. Inspect `git diff --stat` and actual changed files.
2. Compare implementation to this ledger and executive plan.
3. Run targeted tests and full suite:
   - `bash tests/linear-structured-mcp-binding.sh`
   - `bash tests/browser-proof-monitoring.sh`
   - `bash tests/semantic-negative-fixtures.sh`
   - `bash tests/dogfood-workspace-contract.sh`
   - `bash tests/recursive-self-improvement-contract.sh`
   - `bash tests/all.sh`
   - `git diff --check`
4. Inspect process list / test-owned browser/server leftovers.
5. Prepare final review appendix.
6. Commit and push if verification supports it.
7. Watch remote CI for the final commit.
8. Move P4Y-1298 to In Review/Done only when lifecycle truth supports it and post AI Review Report.
9. Report completed work, residuals, and next steps to Karval.
