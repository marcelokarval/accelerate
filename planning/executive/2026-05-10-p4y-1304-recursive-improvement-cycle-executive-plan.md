# P4Y-1304 Recursive Improvement Cycle Executive Plan — 2026-05-10

Parent issue: P4Y-1304
Child issues: P4Y-1305, P4Y-1306, P4Y-1307, P4Y-1308
Root orchestrator / final reviewer: Claw
Repository: `marcelokarval/accelerate`
Local path: `/home/marcelo-karval/Backup/Projetos/accelerate`
Branch: `marcelokarval/p4y-1304-recursive-improvement-cycle`

## Hardened Prompt

### Prompt A

Karval asked to proceed with all next steps after merging P4Y-1303: close the previous issue, create/persist a complete executive plan and detailed tasks, execute via subagents, keep Claw as orchestrator/final reviewer, monitor subagents actively, use only one subagent at a time, avoid unnecessary MCP/tool exposure, preserve browser/server monitoring discipline, and report completed work plus next steps.

### Prompt B

Run a governed Accelerate recursive-improvement cycle rooted in P4Y-1304. First, close out P4Y-1303 with post-merge AI review evidence. Then persist a full executive plan and task ledger for four bounded lanes: dedicated dogfood V2 subset validator, persistent E2E proof boundary, portable Linear fixture proof contract, and agent factory runtime binding boundary. Start implementation only for the first child slice, P4Y-1305, through exactly one bounded subagent with no unnecessary MCP access. Root Claw must not implement the child slice; root owns planning, issue topology, active monitoring, review-of-review, final verification, commit/PR/CI proof, Linear status truth, and next-step emission.

### Non-goals

- Do not implement all four child slices in one unreviewed pass.
- Do not weaken `onboarding/local-workspace/validate-v2.sh` to make the committed dogfood subset pass.
- Do not promote Linear writes, persistent E2E, or autonomous agents as available without decisive proof locators.
- Do not commit raw provider payloads, screenshots, browser captures, generated workflow JSON/JSONL, credentials, tokens, UUID dumps, or private issue bodies.
- Do not keep idle subagents or background/browser/server processes alive after delivered work.

### Mandatory quality lenses

- Contract Correctness: status wording, lifecycle claims, validator scope, and dashboard promotions must match actual proof.
- Privacy / Anti-Abuse: no provider secrets, private payloads, browser captures, or credential names may enter committed proof.
- Workflow Truth: Linear hierarchy, branch, plan, task ledger, review artifacts, and status transitions must remain coherent.
- Browser/Server Truth: browser-proof work must report server/process state; no dead server may be treated as successful capture evidence.

## Branch Entry Packet

- classification: orchestrated non-trivial recursive improvement
- active branch: `marcelokarval/p4y-1304-recursive-improvement-cycle`
- active persona: root orchestrator/final reviewer
- active stack: Accelerate governance/control-plane, shell contract tests, Linear issue topology
- active skills: accelerate, prompt-hardening, linear-pm, planning-with-files, subagent-governance, executing-plans, verification-before-completion, github-pr-workflow, napkin
- active references:
  - `core/control-plane/recursive-improvement-situation-dashboard.md`
  - `.accelerate/state.yaml`
  - `.accelerate/status/readiness-dashboard.yaml`
  - `planning/evidence/dated-proof-appendix/p4y-1303-dogfood-v2-lifecycle-reconciliation-final-review-2026-05-09.md`
- local workspace:
  - `.accelerate=present`
  - action=`reused`
  - onboarding status=`completed`
  - reentry status=`clean`
  - readiness dashboard=`.accelerate/status/readiness-dashboard.yaml`
  - readiness status=`accepted previous cycle; new cycle in progress via P4Y-1304/P4Y-1305`
  - current governing artifact=`planning/executive/2026-05-10-p4y-1304-recursive-improvement-cycle-executive-plan.md`
  - current task ledger=`planning/executive/2026-05-10-p4y-1304-recursive-improvement-cycle-task-ledger.md`
- gate ledger:
  - P4Y-1303 closure=`AI Review Report posted; issue already Done`
  - P4Y-1304 parent=`created; In Progress`
  - P4Y-1305 first child=`created; In Progress`
  - plan/task artifacts=`required before subagent execution`
  - subagent budget=`max 1 simultaneous subagent`
- phase / SDLC: planning -> first bounded implementation slice -> root review
- issue stack status: parent P4Y-1304 with children P4Y-1305..P4Y-1308
- QA / proof lane: shell contract tests plus child-specific gates
- browser-proof intensity: none for P4Y-1305; required monitoring discipline for P4Y-1306
- persistent E2E status: planned; must not be promoted during P4Y-1305
- local review / closure action: root final review after subagent return
- single-threaded exception: not applicable; execution is delegated to one subagent by user instruction

## Current Situation Summary

P4Y-1303 reconciled committed `.accelerate/` dogfood lifecycle and V2 subset semantics. Main is green after merge commit `d73c80850f9710dc2fd3e649d0fc448ebb9da65b`.

The next queue from `core/control-plane/recursive-improvement-situation-dashboard.md` contains four live lanes:

1. dogfood workspace hygiene and dedicated subset validator;
2. persistent E2E proof boundary separate from browser capture;
3. portable Linear fixture proof lane, blocked until safe credential/fixture opt-in exists;
4. agent factory runtime binding, blocked until actual invocation/lifecycle/cleanup proof exists.

## Execution Strategy

This cycle is intentionally sequential because the first child creates validator/governance surfaces that later children may rely on. Only P4Y-1305 enters implementation now. P4Y-1306..P4Y-1308 stay task-shaped and ready, but not implemented until P4Y-1305 receives root review.

## Child Issue Plan

### P4Y-1305 — Dedicated dogfood V2 subset validator

Status: first execution slice.

Goal: add a dedicated validator for committed repo-safe `.accelerate/` dogfood V2 subset, without claiming full generated V2 template compliance.

Likely files:

- `onboarding/local-workspace/validate-dogfood-v2-subset.sh` or equivalent local-workspace helper
- `tests/dogfood-workspace-contract.sh`
- `.accelerate/README.md`
- `.accelerate/workflow/README.md`
- `planning/evidence/dated-proof-appendix/p4y-1305-dogfood-v2-subset-validator-final-review-2026-05-10.md`

Required proof:

```bash
bash onboarding/local-workspace/validate-dogfood-v2-subset.sh .
bash tests/dogfood-workspace-contract.sh
bash tests/recursive-self-improvement-contract.sh
bash tests/all.sh
git diff --check
```

Stop rules:

- stop if existing full V2 validator must be weakened;
- stop if required committed files cannot be validated without generated/private paths;
- stop if tests require committing private/generated proof outputs.

### P4Y-1306 — Persistent E2E proof boundary

Status: shaped, not started in this first wave.

Goal: prevent browser capture/server monitoring evidence from being promoted as persistent E2E availability.

Likely files:

- browser proof scripts/tests under `tests/`
- status dashboards under `core/control-plane/` and `.accelerate/status/`
- semantic negative fixtures

Required proof:

```bash
bash tests/browser-proof-monitoring.sh
bash tests/semantic-negative-fixtures.sh
bash tests/all.sh
git diff --check
```

Browser/server rules:

- any server started must be tracked with PID/log path;
- any capture failure must include server reachability and output tails;
- root must inspect process state before closure.

### P4Y-1307 — Portable Linear fixture proof contract

Status: shaped, blocked for live mutation unless safe fixture prerequisites exist.

Goal: clarify the portable Linear write proof lane without confusing host OAuth MCP proof with repo-local API-key proof.

Required live prerequisites before mutation:

- safe API key outside committed state;
- explicit opt-in env/config outside committed state;
- fixture team identifier;
- fixture status identifier;
- non-sensitive fixture issue policy.

Expected proof without credentials:

```bash
bash tests/linear-helper-python-parse.sh
bash tests/linear-oauth-status-honesty.sh
bash tests/semantic-negative-fixtures.sh
bash tests/all.sh
git diff --check
```

Stop rules:

- do not run provider writes without explicit prerequisites;
- do not commit provider JSON, raw issue bodies, emails, UUID dumps, or tokens.

### P4Y-1308 — Agent factory runtime binding boundary

Status: shaped, not started in this first wave.

Goal: define/prove the next runtime binding lane without promoting synchronous subagent delegation or proof replay as autonomous availability.

Expected proof:

```bash
bash tests/promotion-replay-fixtures.sh
bash tests/agent-family-compatibility.sh
bash tests/physical-agent-runtime-adapter.sh
bash tests/all.sh
git diff --check
```

Stop rules:

- do not spawn unmanaged long-lived agents as proof;
- do not claim autonomous availability until invocation, lifecycle monitoring, idle cleanup, demotion, and root acceptance are proven.

## Subagent Monitoring Protocol

- Concurrency cap: 1 simultaneous subagent. Completed/closed subagent frees the slot for a later wave.
- Toolset cap for P4Y-1305: terminal + file + skills only. No Linear/GitHub/browser MCP access.
- Required first action by subagent: report `pwd` and `git status --short --branch` from `/home/marcelo-karval/Backup/Projetos/accelerate`.
- Required progress artifact: update the task ledger or add a child final-review artifact with requested-vs-implemented, proof, self-review, forensic review, residuals, and process/server state.
- Idle handling: if subagent returns a complete result, retire it; do not reuse it for unrelated work. If it appears stuck, interact/health-check before classifying stuck. If no response and artifacts exist, root validates artifacts before accepting or rerunning.
- Browser/server handling: P4Y-1305 should not start servers or browser sessions. If it does anyway, it must report PID/log/capture state and root must verify cleanup.

## Root Review Contract

Root Claw will not treat subagent completion as final proof. Closure requires:

1. inspect diff and changed files;
2. verify requested-vs-implemented against P4Y-1305;
3. run targeted proof and `bash tests/all.sh`;
4. run `git diff --check`;
5. inspect process table if any browser/server/process work is reported;
6. write root final review artifact;
7. update Linear child to In Review/Done only after evidence supports it;
8. commit/push/PR only after root review supports it;
9. report completed work and next steps.

## Expected Deliverables For This Turn

- P4Y-1303 post-merge AI Review Report posted.
- P4Y-1304 parent issue created and In Progress.
- P4Y-1305..P4Y-1308 child issues created.
- This executive plan persisted.
- Detailed task ledger persisted.
- P4Y-1305 execution delegated to one bounded subagent.
- Root final review attempted if subagent completes within session.
