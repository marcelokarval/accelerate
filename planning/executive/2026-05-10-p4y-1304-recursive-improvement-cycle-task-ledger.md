# P4Y-1304 Recursive Improvement Cycle Task Ledger — 2026-05-10

Parent issue: P4Y-1304
Plan: `planning/executive/2026-05-10-p4y-1304-recursive-improvement-cycle-executive-plan.md`
Root orchestrator: Claw
Subagent concurrency cap: 1 simultaneous worker

## Status Vocabulary

- `pending`: shaped but not started
- `in-progress`: actively executing
- `blocked`: cannot proceed without prerequisite
- `review`: implementation complete, root or reviewer gate open
- `accepted`: root final review accepted the slice
- `follow-up`: intentionally deferred to future issue/cycle

## Execution Policy

1. Root plans, creates issues, monitors, and reviews.
2. Subagent executes bounded child scope only.
3. Subagent must not use unnecessary MCPs. For P4Y-1305, allowed toolsets are terminal/file/skills only.
4. Subagent must load or follow these skills/concepts in its handoff: `accelerate`, `using-superpowers`, `napkin`, `planning-with-files`, `executing-plans`, `verification-before-completion`, and relevant repo-local docs.
5. Subagent must report `pwd`, branch, touched files, validation commands, self-review, forensic review, process/server state, residuals, and recommendation.
6. Root must re-run proof and inspect artifacts before acceptance.
7. If a subagent appears stuck, root must health-check/interact before terminating/replacing; slow work is not automatically stuck.
8. If a subagent returns complete work, root retires the subagent and frees the slot.

## Task 0 — Prior Cycle Closure Hygiene

- id: T0
- issue: P4Y-1303
- owner: root
- status: accepted
- scope:
  - verify P4Y-1303 state after merge;
  - post AI Review Report with merge commit and post-merge CI evidence.
- evidence:
  - Linear comment: AI Review Report posted 2026-05-10
  - merge commit: `d73c80850f9710dc2fd3e649d0fc448ebb9da65b`
  - post-merge CI: Accelerate Tests / Shell contract suite success
- residuals:
  - next-cycle work moved to P4Y-1304/P4Y-1305..P4Y-1308

## Task 1 — Parent Issue And Branch Bootstrap

- id: T1
- issue: P4Y-1304
- owner: root
- status: in-progress
- scope:
  - create parent issue;
  - create child issue package;
  - open branch `marcelokarval/p4y-1304-recursive-improvement-cycle`;
  - persist executive plan and task ledger.
- files expected:
  - `planning/executive/2026-05-10-p4y-1304-recursive-improvement-cycle-executive-plan.md`
  - `planning/executive/2026-05-10-p4y-1304-recursive-improvement-cycle-task-ledger.md`
- verification:
  - `git status --short --branch`
  - Linear parent/child relation readback
- acceptance:
  - parent and children exist;
  - parent and first child are In Progress;
  - plan/ledger are persisted.

## Task 2 — P4Y-1305 Dedicated Dogfood V2 Subset Validator

- id: T2
- issue: P4Y-1305
- owner: bounded subagent, root final reviewer
- status: accepted
- enforcement: medium; high not authorized unless a blocker requires escalation
- allowed toolsets for subagent: terminal, file, skills
- forbidden toolsets: Linear, GitHub, browser, Stripe, Telegram, external MCPs not needed for local repo work
- scope:
  1. inspect existing validators and dogfood contract tests;
  2. add a dedicated validator for committed repo-safe dogfood V2 subset;
  3. wire the validator into dogfood contract or canonical suite;
  4. update docs to distinguish subset validator from full generated V2 validator;
  5. add child final-review evidence artifact;
  6. run targeted and full verification.
- likely files:
  - `onboarding/local-workspace/validate-dogfood-v2-subset.sh`
  - `tests/dogfood-workspace-contract.sh`
  - `.accelerate/README.md`
  - `.accelerate/workflow/README.md`
  - `planning/evidence/dated-proof-appendix/p4y-1305-dogfood-v2-subset-validator-final-review-2026-05-10.md`
- forbidden files / content:
  - generated/private `.accelerate/proof/`, `.accelerate/tmp/`, provider exports, screenshots, browser captures;
  - raw Linear/MCP/API provider payloads;
  - credential names or secret values beyond existing safe policy wording.
- required validation:
  ```bash
  bash onboarding/local-workspace/validate-dogfood-v2-subset.sh .
  bash tests/dogfood-workspace-contract.sh
  bash tests/recursive-self-improvement-contract.sh
  bash tests/all.sh
  git diff --check
  ```
- subagent deliverable format:
  - workspace confirmation;
  - requested-vs-implemented;
  - files changed;
  - validation run and results;
  - self-review;
  - self-forensic review;
  - process/server/browser state;
  - residuals and recommendation.
- root acceptance:
  - root inspects diff and artifacts;
  - root re-runs validation;
  - root decides accepted / partial / follow-up.

## Task 3 — P4Y-1306 Persistent E2E Proof Boundary

- id: T3
- issue: P4Y-1306
- owner: future subagent after T2 root acceptance
- status: pending
- enforcement: medium by default
- scope:
  - audit browser-proof and persistent-regression surfaces;
  - add negative overpromotion tests;
  - preserve server-readiness/capture-failure honesty;
  - document persistent E2E proof requirements.
- validation:
  ```bash
  bash tests/browser-proof-monitoring.sh
  bash tests/semantic-negative-fixtures.sh
  bash tests/all.sh
  git diff --check
  ```
- monitoring rule:
  - any server/browser/background process must be declared with PID/log and cleaned up or explicitly retained with reason.

## Task 4 — P4Y-1307 Portable Linear Fixture Proof Contract

- id: T4
- issue: P4Y-1307
- owner: future subagent after T2/T3 sequencing decision
- status: pending / blocked-for-live-provider-write
- enforcement: medium by default; no live provider mutation without explicit prerequisite proof
- scope:
  - shape safe fixture contract;
  - block overpromotion from OAuth host-bound proof;
  - keep credential and fixture identifiers outside committed state;
  - add negative tests/manifest wording.
- live mutation prerequisites:
  - safe API key outside committed state;
  - explicit opt-in outside committed state;
  - fixture team/status identifiers;
  - non-sensitive fixture policy.
- validation without live writes:
  ```bash
  bash tests/linear-helper-python-parse.sh
  bash tests/linear-oauth-status-honesty.sh
  bash tests/semantic-negative-fixtures.sh
  bash tests/all.sh
  git diff --check
  ```

## Task 5 — P4Y-1308 Agent Factory Runtime Binding Boundary

- id: T5
- issue: P4Y-1308
- owner: future subagent after earlier proof-lane cleanup
- status: pending
- enforcement: medium by default
- scope:
  - audit agent factory runtime/promotion surfaces;
  - define/prove invocation, lifecycle monitoring, idle cleanup, demotion, root acceptance requirements;
  - add tests preventing overpromotion from fixture replay.
- validation:
  ```bash
  bash tests/promotion-replay-fixtures.sh
  bash tests/agent-family-compatibility.sh
  bash tests/physical-agent-runtime-adapter.sh
  bash tests/all.sh
  git diff --check
  ```
- process rule:
  - no unmanaged long-lived agents; any background process must be tracked and cleaned up.

## Active Subagent Slots

| Slot | Agent | Issue | Status | Last signal | Expected artifact | Action |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Codex CLI `proc_4b08a1d04175` | P4Y-1305 | retired/killed | 2026-05-10 root killed after useful implementation because broad MCP sidecars were spawned unnecessarily | P4Y-1305 final review artifact + root proof | accepted by root review; slot freed |

## Root Review Checklist

Before accepting any child slice, root must confirm:

- [ ] correct repo and branch;
- [ ] issue scope matched implementation;
- [ ] no forbidden files/content were added;
- [ ] required scripts are executable where applicable;
- [ ] targeted tests pass;
- [ ] `bash tests/all.sh` passes;
- [ ] `git diff --check` passes;
- [ ] subagent reported process/server/browser state;
- [ ] root independently inspected process state if any browser/server/process was used;
- [ ] final review artifact is present and not just a recap;
- [ ] Linear status update matches evidence.

## Current Progress Log

- 2026-05-10: P4Y-1303 post-merge AI Review Report posted.
- 2026-05-10: P4Y-1304 parent and P4Y-1305..P4Y-1308 children created.
- 2026-05-10: branch `marcelokarval/p4y-1304-recursive-improvement-cycle` created from `main`.
- 2026-05-10: parent P4Y-1304 and first child P4Y-1305 moved to In Progress.
- 2026-05-10: executive plan and task ledger persisted.
- 2026-05-10: P4Y-1305 subagent spawned, monitored, and actively killed after it spawned unnecessary MCP sidecars; root retained useful local changes and did not count subagent as approval.
- 2026-05-10: P4Y-1305 root verification passed: subset validator, dogfood contract, recursive self-improvement contract, full `tests/all.sh`, and `git diff --check`.
