# Recursive Cycle 1..6 Executive Plan

Date: 2026-05-08
Root role: orchestrator / final reviewer, not primary executor
Repository: `/home/marcelo-karval/Backup/Projetos/accelerate`
Subagent budget: maximum 3 total subagents for implementation + task-level review
Execution model: root shapes plan/tasks; bounded subagents execute and review assigned tasks; root performs final review-of-review, local proof, commit/push, remote CI monitoring, and next-step emission.

## Branch Entry Packet

- classification: non-trivial orchestrated recursive self-improvement work
- active branch: `main` at entry; branch may remain `main` unless root opens a bounded branch before commit
- active persona: root orchestrator / final reviewer
- active stack: Accelerate control plane, workflow adapters, local workspace, runtime/browser proof, tests, dashboards, repo-local skill governance, agent-factory governance
- active skills: `accelerate`, `subagent-governance`, `parallel-agents`, `planning-with-files`, `executing-plans`, `requesting-code-review`, `github-pr-workflow`
- active ADRs / references:
  - `AGENTS.md`
  - `SKILL.md`
  - `core/control-plane/recursive-self-improvement-loop.md`
  - `core/control-plane/recursive-improvement-situation-dashboard.md`
  - `core/control-plane/capability-maturity-dashboard.md`
  - `core/runtime-packets/browser-proof-packet.md`
  - `adapters/runtime/browser/browser-truth-contract.md`
  - `adapters/workflow/remote-write-registry.yaml`
- local workspace:
  - .accelerate=absent at entry
  - action=required-init for dogfood cycle
  - onboarding status=n/a
  - reentry status=n/a
  - readiness dashboard=n/a at entry
  - readiness status=blocked until dogfood cycle persists bounded local workspace state
  - timeline=n/a at entry
  - current checkpoint=n/a
  - learnings=n/a
  - learning disposition=candidate-for-promotion
  - current governing artifact=`planning/executive/2026-05-08-recursive-cycle-1-6-executive-plan.md`
  - local agents status=`planning/executive/2026-05-08-recursive-cycle-1-6-task-ledger.md`
  - drift status=warning until final tests/diff/CI pass
- gate ledger: prompt-hardening=applied-in-plan, issue-stack=repo-local-plan-ledger, subagent-budget=max-3, browser-proof-monitoring=open, status-honesty=open, final-root-review=pending
- phase / SDLC: recursive self-improvement execution
- persona handoff artifact: this executive plan + task ledger
- mandatory gates: bounded subagent scopes, task-level review, status honesty, browser/server monitoring, final root review-of-review, local tests, diff check, process cleanup, remote CI after push
- required artifacts: plan, ledger, implementation docs/scripts/tests, subagent return packets, root final closure report
- closure blockers: subagent execution incomplete; local tests pending; root review pending; remote CI pending
- QA / proof lane: local contract tests + full tests + browser-proof dry-run/server-monitoring fixture + remote CI
- issue stack status: repo-local plan/ledger used as governing issue substitute for this recursive cycle
- browser-proof intensity: targeted adapter hardening + fixture proof, not app-wide browser QA
- persistent E2E status: n/a unless browser fixture creates durable regression test
- local review / closure action: manual root review + process cleanup check
- single-threaded exception: n/a; max 3 subagents will be used

## Goal

Execute the six next-cycle improvement items emitted by the prior recursive cycle:

1. Linear structured non-LLM MCP write binding.
2. Persistent `.accelerate/` dogfood workspace.
3. Semantic negative fixtures for status honesty.
4. Runtime adapter maturity dashboard.
5. Skill sync topology.
6. Agent factory promotion pipeline.

The result must improve Accelerate as a self-contained control plane without optimistic capability promotion. When live provider proof is unavailable or unsafe, the artifact must keep the capability blocked/planned and create an explicit proof condition rather than pretending completion.

## Prompt Hardening Packet

- hardened artifact: present
- Prompt A: "prossiga para o ciclo 1..6 ... no máximo 3 subagentes ... plano executivo completo ... tasks completas ... inicie execução ... review por tasks por subagent ... root final review ... encerre agents idle/travados ... analise browser-proof/server monitoring ... reporte feito e próximos passos"
- Prompt B: Execute a bounded recursive improvement cycle for Accelerate cycles 1..6. Root must create durable plan and task ledger, delegate implementation/review to at most 3 subagents, enforce task-level requested-vs-implemented and self-forensic review, monitor/avoid stuck background processes, harden browser-proof server readiness/correction behavior, run final root verification, commit/push if clean, monitor remote CI, and report completed work plus next prioritized steps.
- full artifact location: this file

## Non-Goals

- Do not run unbounded Linear mutations on sensitive production issues.
- Do not promote Linear MCP writes to `available` without actual structured proof and a durable proof locator.
- Do not claim `.accelerate/` dogfood as complete unless repo-local state exists and is contract-tested.
- Do not rewrite the entire Accelerate architecture.
- Do not build a real autonomous agent runtime. This cycle can define promotion criteria and dashboards, but runtime promotion requires proof.
- Do not treat browser screenshots as sufficient browser proof. Server readiness, console/network output, failure capture, and corrective routing are required.

## Subagent Staffing Plan (max 3)

### Subagent A — Workflow Adapter / Linear Binding

Assigned tasks: RC1.

Write scope:

- `onboarding/local-workspace/*linear*mcp*.sh`
- `adapters/workflow/remote-write-registry.yaml`
- `core/control-plane/capability-maturity-dashboard.md`
- Linear-specific tests under `tests/`
- proof appendix only if live fixture proof is actually performed

Forbidden scope:

- `.accelerate/` dogfood workspace
- skill sync topology
- agent factory docs
- unrelated GitHub PR adapter behavior

Completion contract:

- Implement or precisely scaffold structured non-LLM Linear MCP read/write binding using direct non-LLM API mechanics when possible.
- Preserve privacy/export approval gates for artifact/comment writes.
- Keep status blocked/planned unless live non-sensitive fixture proof exists.
- Add/adjust tests proving dry-run, missing-token behavior, path safety, structured-write manifest honesty, and no LLM-host dependency.
- Return task-level requested-vs-implemented, validation, self-review, self-forensic review, defects/residuals.

### Subagent B — Local Dogfood, Semantic Negative Gates, Browser-Proof Monitoring

Assigned tasks: RC2, RC3, and browser-proof/server-monitoring hardening.

Write scope:

- `.accelerate/` repo-local dogfood workspace files when appropriate
- `onboarding/local-workspace/capture-browser-proof.sh`
- `core/runtime-packets/browser-proof-packet.md`
- `adapters/runtime/browser/browser-truth-contract.md`
- `tests/*browser*`, `tests/*semantic*`, recursive contract tests as needed
- `core/control-plane/recursive-improvement-situation-dashboard.md`

Forbidden scope:

- Linear adapter implementation
- skill sync topology
- agent factory pipeline
- GitHub PR live proof

Completion contract:

- Persist a minimal dogfood workspace that is safe to commit if it is intended as canonical fixture; otherwise document why not and add generated/ignored boundary.
- Add semantic negative fixtures that fail if planned/blocked/substitute statuses are promoted without proof.
- Harden browser-proof capture so server availability is actively checked, failure output is captured, and correction signals are explicit when no server is running correctly.
- Avoid starting long-lived unmanaged servers in tests; use bounded fixture servers and cleanup traps.
- Return task-level requested-vs-implemented, validation, self-review, self-forensic review, defects/residuals.

### Subagent C — Runtime Maturity, Skill Sync, Agent Factory Promotion Pipeline

Assigned tasks: RC4, RC5, RC6.

Write scope:

- `core/control-plane/*runtime*adapter*maturity*.md`
- `core/control-plane/*skill*sync*.md`
- `core/control-plane/*agent*factory*promotion*.md`
- `core/delegation/*` if necessary
- `skills/README.md` or repo-local skill index references if necessary
- tests under `tests/` proving required control-plane terms and status honesty
- `core/control-plane/recursive-improvement-situation-dashboard.md`

Forbidden scope:

- Linear adapter implementation
- `.accelerate/` dogfood workspace
- browser proof script implementation

Completion contract:

- Create durable dashboards/control-plane docs for runtime adapter maturity, skill sync topology, and agent factory promotion.
- Define proof locators, promotion/demotion criteria, drift detection, cleanup rules, and status vocabulary.
- Add tests enforcing that these surfaces exist and do not claim runtime capabilities without proof.
- Return task-level requested-vs-implemented, validation, self-review, self-forensic review, defects/residuals.

## Detailed Task Plan

### RC1 — Linear structured non-LLM MCP write binding

Objective: remove the purely LLM-hosted placeholder blocker by introducing a structured, inspectable binding path for Linear operations, while keeping live write promotion honest.

Expected files:

- `onboarding/local-workspace/read-linear-mcp-adapter.sh`
- `onboarding/local-workspace/create-linear-mcp-issue.sh`
- `onboarding/local-workspace/attach-linear-mcp-artifact.sh`
- optional: `onboarding/local-workspace/comment-linear-mcp-issue.sh`
- optional: `onboarding/local-workspace/update-linear-mcp-status.sh`
- `adapters/workflow/remote-write-registry.yaml`
- `core/control-plane/capability-maturity-dashboard.md`
- `tests/linear-*.sh`

Required behavior:

- no `opencode`/LLM host requirement for structured operations;
- direct structured request/response path, preferably GraphQL over `curl` using `LINEAR_API_KEY` when live;
- dry-run emits JSON with `remote_calls:false`;
- live mode requires explicit token and safe parameters;
- artifact attachment/comment path preserves export approval;
- responses are persisted as structured JSONL under target `.accelerate/workflow/` paths;
- registry marks `structured_write: yes` only where the script actually has a structured non-LLM path;
- status remains `blocked` or `planned` unless live fixture proof lands.

Proof:

- dry-run tests;
- missing-token tests;
- manifest status-honesty tests;
- optional live non-sensitive proof appendix if provider fixture is safely created/updated.

### RC2 — Persistent `.accelerate/` dogfood workspace

Objective: make this repo dogfood its own local workspace model with a minimal, committed, non-secret control surface.

Expected files:

- `.accelerate/README.md`
- `.accelerate/workflow/active-work-item.yaml` or equivalent fixture
- `.accelerate/review/README.md` or packet fixture boundary
- `.accelerate/status/` or equivalent dashboard boundary
- tests proving required files exist and contain no secret/provider payloads

Required behavior:

- clearly distinguish committed dogfood fixture/state from generated private proof outputs;
- no secrets, tokens, screenshots, private browser captures, or provider responses committed;
- dogfood status points back to this plan/ledger and recursive cycle;
- cleanup rule for generated `.accelerate/review/*.json`, screenshots, and workflow outputs.

Proof:

- contract test for `.accelerate/` dogfood presence and safe contents;
- root `git status` confirms only intended dogfood files are tracked.

### RC3 — Semantic negative fixtures + browser-proof/server-monitoring hardening

Objective: prevent optimistic promotion regressions and make browser proof fail usefully when the server is absent or broken.

Expected files:

- `tests/semantic-negative-fixtures.sh` or equivalent
- fixture files under `tests/fixtures/` if needed
- `onboarding/local-workspace/capture-browser-proof.sh`
- browser proof docs/packet updates

Required behavior:

- tests must construct negative fixture content where blocked/planned/substitute rows are incorrectly promoted and verify the checker rejects them;
- browser proof helper must check URL reachability/readiness before launching browser capture;
- browser proof helper must capture server/readiness failure output into a structured JSON proof/failure packet when requested;
- tests must use bounded local fixture server with cleanup trap or pure failure case; no unmanaged long-lived server.

Proof:

- semantic negative fixture test;
- browser-proof dry-run and server-down tests;
- if a fixture server is used, process cleanup verified.

### RC4 — Runtime adapter maturity dashboard

Objective: create an explicit runtime adapter maturity inventory instead of scattering planned/substitute/native states.

Expected files:

- `core/control-plane/runtime-adapter-maturity-dashboard.md`
- tests enforcing required rows/fields/status honesty

Required content:

- status vocabulary;
- rows for browser, Playwright/Chrome DevTools posture, local shell/runtime scripts, remote/runtime gaps where applicable;
- proof locator, blocker, promotion condition, demotion condition, owner lane;
- explicit link to browser-proof monitoring improvements.

Proof:

- contract test verifies required fields and no planned runtime adapter is marked available without proof.

### RC5 — Skill sync topology

Objective: make repo-local skill authority/export/drift policy operationally explicit.

Expected files:

- `core/control-plane/skill-sync-topology.md`
- optional supporting test

Required content:

- repo-local source-of-truth rule;
- generated export direction from repo outward;
- forbidden authority assumptions from user-home catalogs;
- drift detection command/contract;
- sync artifact boundaries;
- promotion condition for generated skill bundles.

Proof:

- test checks required policy terms and source-of-truth language.

### RC6 — Agent factory promotion pipeline

Objective: define the criteria and proof loop for promoting agent roles/capabilities into operational availability.

Expected files:

- `core/control-plane/agent-factory-promotion-pipeline.md`
- optional `core/delegation/agent-factory-promotion-pipeline.md` pointer
- tests enforcing required lifecycle terms

Required content:

- candidate role intake;
- skill envelope;
- proof replay;
- runtime binding;
- cleanup/idle-agent handling;
- demotion criteria;
- promotion status vocabulary;
- explicit note that this cycle does not create an autonomous runtime.

Proof:

- test checks required lifecycle and honesty terms.

## Review And Monitoring Rules

- Root will not accept subagent summaries without inspecting actual file contents and diff.
- Any subagent result without `pwd && git status --short --branch` evidence is incomplete.
- Any wrong-repo/wrong-branch output is discarded as non-evidence.
- No background process may remain unmanaged. Tests using servers must trap cleanup; root will inspect managed processes and likely OS processes if needed.
- A subagent is considered stuck only if an interaction/check receives no response or no progress signal after a reasonable prompt/timeout, not merely because a task is long.
- Since `delegate_task` subagents are synchronous in this runtime, root will use bounded scopes and no background child sessions. If a subagent returns, it is considered no longer active; if it times out/fails, root inspects file state before reassigning within the remaining budget.

## Final Root Verification

Required before closure:

```bash
bash tests/recursive-self-improvement-contract.sh
bash tests/all.sh
git diff --check
git status --short --branch
```

Additional targeted proof expected from this cycle:

```bash
bash tests/linear-helper-python-parse.sh
# plus any new Linear, dogfood, semantic-negative, browser-proof, maturity, skill-sync, agent-factory tests added by subagents
```

After commit/push:

```bash
gh run list --repo marcelokarval/accelerate --branch main --limit 5
gh run watch <run-id> --repo marcelokarval/accelerate --exit-status
```

## Closure Packet Template

At closure root must report:

- requested vs implemented by RC1..RC6;
- promised vs delivered;
- subagent assignment/review map;
- defects found and disposition;
- local proof commands and output summary;
- browser-proof/server-monitoring result;
- active process cleanup status;
- commit SHA, push status, remote CI run id/conclusion/URL;
- residual risks;
- next prioritized queue.
