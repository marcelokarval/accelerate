# GitHub PR Land/Merge Live Proof Executive Plan

Date: 2026-05-07
Root role: orchestrator / final reviewer
Execution model: bounded subagent live-proof implementation + independent subagent review + root review-of-review
Target capability: GitHub PR land/merge through `onboarding/local-workspace/land-github-pr.sh`
Playground: `marcelokarval/accelerate-playground`

## Goal

Promote the GitHub PR land/merge capability from `planned` to proof-backed `native`/`available` only after a real, non-sensitive, disposable playground pull request is landed through the repo-local adapter path and the proof is persisted in the Accelerate repository.

The proof must preserve the standing playground policy:

- keep `marcelokarval/accelerate-playground` as a persistent proof repository;
- do not delete the repository;
- do not mutate or close the existing fixture PR `#1` on branch `accelerate/live-proof-2026-05-05`;
- create a separate disposable PR/branch for this land proof;
- keep all proof content non-sensitive.

## Current Evidence / Entry State

- `core/control-plane/capability-maturity-dashboard.md` currently records `PR land/merge` as `planned` with no live proof.
- `adapters/workflow/github-pr/capabilities.yaml` currently records `production_merge_land_gate: planned` and `production_merge_land_gate_proof: planned`.
- `adapters/workflow/remote-write-registry.yaml` currently records `github-pr-land` as `planned`, `live_proof: none`, `structured_write: yes`, and opt-in `ACCELERATE_ALLOW_LAND`.
- Existing dated GitHub proof `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` explicitly says land command was dry-run only.
- `land-github-pr.sh` already has safety gates: `ACCELERATE_ALLOW_LAND=1`, ready ship-readiness JSON, closure proof, export approval, production readiness, current PR/head revalidation, fresh readiness re-check, and `gh pr merge --squash --delete-branch --match-head-commit`.

## Non-Goals

- Do not implement Linear MCP writes.
- Do not create a persistent `.accelerate/` dogfood workspace for the Accelerate repo.
- Do not implement the agent factory promotion pipeline.
- Do not merge or close PR `#1` in `accelerate-playground`.
- Do not weaken production-readiness gates for real production usage.
- Do not promote the capability if live land proof fails or cannot be produced.

## Risk Controls

1. **External mutation control**
   - The only allowed external mutation is in `marcelokarval/accelerate-playground`.
   - The allowed mutation is creating and landing one disposable PR branch dedicated to this proof.
   - The existing fixture PR `#1` is read-only for this slice.

2. **Proof branch naming**
   - Use a unique branch, e.g. `accelerate/land-proof-2026-05-07` or a timestamp suffix if a collision exists.

3. **Adapter truth**
   - Prefer proving the actual `land-github-pr.sh` command, not only raw `gh pr merge`.
   - If a hidden mismatch prevents adapter use, stop and record the blocker rather than bypassing the adapter.

4. **Readiness truth**
   - Ship readiness must be generated or made valid enough for the adapter gate.
   - Closure proof must exist and be export-approved.
   - Production readiness artifacts must be non-placeholder and pass `check-production-readiness.sh`.

5. **Promotion honesty**
   - Update status to `native`/`available` only after live proof exists.
   - If proof is partial, leave `planned` and record the residual.

## Task Breakdown

### GPL-1 — Plan and ledger persistence

Owner: root orchestrator
Reviewer: root final review
Write scope:

- `planning/executive/2026-05-07-github-pr-land-live-proof-executive-plan.md`
- `planning/executive/2026-05-07-github-pr-land-live-proof-task-ledger.md`

Required proof:

- Plan and task ledger exist.
- Task ledger names implementer, reviewer, requested-vs-implemented, proof, status, and residual.

### GPL-2 — Live playground PR setup and adapter land proof

Owner: bounded implementation subagent A
Reviewer: reviewer subagent C + root
Write scope:

- temporary playground clone/worktree under `/tmp` or another disposable path;
- external `marcelokarval/accelerate-playground` disposable branch/PR;
- proof notes returned to root.

Forbidden scope:

- Accelerate repo source/docs/tests except via returned evidence;
- existing playground PR `#1`;
- deleting `marcelokarval/accelerate-playground`.

Required actions:

1. Confirm workspace with `pwd && git status --short --branch` in `/home/marcelo-karval/Backup/Projetos/accelerate`.
2. Confirm `gh auth status` and playground repo access.
3. Clone/fetch `marcelokarval/accelerate-playground` into disposable local path.
4. Create unique proof branch from playground `main`.
5. Add a non-sensitive proof file/artifact to the playground branch.
6. Create PR with title/body explicitly saying it is disposable Accelerate land proof.
7. Prepare `.accelerate/` artifacts required by `land-github-pr.sh` in the playground clone:
   - closure proof packet;
   - privacy export approval for closure proof;
   - readiness dashboard/evidence registry sufficient for production readiness;
   - deploy verification packet with non-placeholder provider/check/canary/rollback posture;
   - production risk approval;
   - ship readiness JSON matching repo, branch, PR number, and head OID.
8. Run the repo-local adapter command from Accelerate:
   - `ACCELERATE_ALLOW_LAND=1 onboarding/local-workspace/land-github-pr.sh <playground-clone> <ship-readiness-json>`
9. Verify remote PR is merged and disposable branch deleted by the merge command.
10. Return all durable remote handles: PR URL/number, merged commit, head SHA, branch, proof file path, adapter command output, and any caveat.

Stop rules:

- Stop if branch collision would overwrite existing proof.
- Stop if `land-github-pr.sh` cannot be used without weakening its safety gates.
- Stop if GitHub refuses merge or auth is insufficient.
- Stop rather than touching PR `#1`.

### GPL-3 — Persist proof and capability promotion in Accelerate

Owner: bounded implementation subagent B
Reviewer: reviewer subagent C + root
Depends on: GPL-2 proof handles
Write scope:

- `planning/evidence/dated-proof-appendix/github-pr-land-live-validation-2026-05-07.md`
- `adapters/workflow/github-pr/capabilities.yaml`
- `adapters/workflow/remote-write-registry.yaml`
- `core/control-plane/capability-maturity-dashboard.md`
- `core/control-plane/recursive-improvement-situation-dashboard.md`
- tests proving the promotion contract, if needed.

Required updates if GPL-2 succeeds:

- Persist dated proof appendix with durable remote handles and command evidence.
- Promote `production_merge_land_gate` to `native` in GitHub PR capabilities.
- Set `production_merge_land_gate_proof` to the dated proof appendix path.
- Add live land result/date fields if useful.
- Promote `github-pr-land` in remote write registry to `available` and point `live_proof` to dated proof appendix.
- Update capability maturity dashboard: `PR land/merge` becomes `native`; registry summary `github-pr-land` becomes `available`.
- Update recursive improvement dashboard: GitHub land proof no longer primary `planned`; name the next priority as Linear MCP writes.
- Update tests that currently require land to remain planned.

Required updates if GPL-2 fails or is partial:

- Do not promote capability.
- Persist a blocker appendix or plan residual instead of success proof.
- Keep dashboard/registry/capabilities as planned.

### GPL-4 — Contract tests and local verification

Owner: bounded implementation subagent B or dedicated QA subagent
Reviewer: reviewer subagent C + root
Write scope:

- shell tests under `tests/` only if needed;
- existing tests that assert `production_merge_land_gate: planned` or `github-pr-land` planned.

Required proof:

- `bash tests/governance-maintenance-pack.sh`
- `bash tests/remote-write-registry.sh`
- `bash tests/all.sh`
- `git diff --check`

Contract expectations after successful promotion:

- `github-pr-land` has `status: available` and durable live proof path.
- `production_merge_land_gate: native` and durable proof path.
- dashboard no longer says live merge proof absent.
- Linear writes remain blocked.

### GPL-5 — Independent task review

Owner: reviewer subagent C
Write scope: read-only
Required review questions:

1. Was the assigned scope implemented?
2. Were any files outside scope edited?
3. Was PR `#1` preserved untouched/open?
4. Was a disposable playground PR landed for real?
5. Did `land-github-pr.sh` perform the merge rather than a raw bypass?
6. Does the proof appendix include durable remote handles?
7. Are status promotions justified by proof?
8. Do Linear blocked statuses remain untouched?
9. Did local tests pass?
10. Recommendation: done / partial / follow-up.

### GPL-6 — Root final review, commit, push, remote CI, report

Owner: root orchestrator
Reviewer: root final review
Required proof:

- root inspection of changed files;
- root verification of remote GitHub PR merged state and PR `#1` preservation;
- `bash tests/all.sh`;
- `git diff --check`;
- commit and push to `main`;
- remote GitHub Actions success for final commit;
- `process list` shows no active idle processes.

## Acceptance Criteria

Completion is supported only if all are true:

1. A disposable playground PR was created and merged/landed.
2. The merge was executed through `onboarding/local-workspace/land-github-pr.sh` with `ACCELERATE_ALLOW_LAND=1`.
3. The existing playground PR `#1` remains untouched and open.
4. The proof appendix includes durable handles: repo, PR URL/number, branch, head SHA, merge commit/result, command evidence, and boundary statement.
5. GitHub PR capabilities and remote write registry are promoted only after proof exists.
6. Capability dashboard reflects the new proof honestly.
7. Recursive improvement dashboard advances the next priority queue without hiding residuals.
8. Linear writes remain `blocked`.
9. Local tests pass.
10. Remote CI passes after final push.

## Expected Next Queue After This Slice

If GPL succeeds:

1. Linear structured MCP write binding.
2. Persistent `.accelerate/` dogfood workspace for this repo.
3. Semantic negative gates.
4. Runtime adapter maturity dashboard.
5. Skill sync topology.
6. Agent factory promotion pipeline.

If GPL is blocked:

1. Fix the specific GitHub land adapter blocker.
2. Retry live land proof on a fresh disposable playground PR.
3. Then return to Linear structured MCP write binding.
