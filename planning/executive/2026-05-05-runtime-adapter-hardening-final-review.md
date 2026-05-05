# Runtime, Adapter, References, and Agent Promotion Hardening Final Review

## Review Metadata

- Final reviewer: root/orchestrator
- Review timestamp: 2026-05-05T19:01:24Z
- Plan: `planning/executive/2026-05-05-runtime-adapter-hardening-executive-plan.md`
- Task ledger: `planning/executive/2026-05-05-runtime-adapter-hardening-task-ledger.md`
- Execution mode: delegated implementation + delegated skeptical review + bounded delegated corrections + root final confirmation

## Completion Claim

The requested hardening run is supported for repository-local closure after the final residual-fix pass:

- GitHub PR adapter safety is integrated into the default test path.
- Local workspace runtime truth was strengthened across V2 docs, schema init, readiness/evidence surfaces, deploy packet, rehydration, dashboard, lifecycle, list/select, and evidence gate behavior.
- Authority/reference semantics now distinguish governing authority, supporting reference, decision artifact, backend authority, generated export, and forbidden authority.
- Workflow adapters now expose explicit capability manifests and schema-v2 vocabulary instead of broad backend claims.
- Remote provider helper behavior is more fail-closed for GitHub PR read/create/attach/rehydrate/ship/closure/land/recovery flows without executing real remote writes.
- Agent promotion/install/export states and host export schema are explicit enough to avoid confusing template doctrine, generated exports, and promoted runtime agents.

## Surfaces Checked

Changed surfaces include:

- Root and runtime docs: `README.md`, `SKILL.md`, `global-runtime/accelerate/SKILL.md`, `core/runtime-packets/templates.md`, `core/control-plane/authority-set-gate.md`, `references/README.md`.
- Workflow adapter docs/manifests: `adapters/workflow/*`, `adapters/workflow/capability-schema-v2.md`, `adapters/workflow/remote-write-registry.yaml`.
- Runtime host export: `adapters/runtime/*`, `scripts/export-runtime-host.sh`.
- Agent promotion/install/export: `agents/*`, `agents/promotion/*`, `planning/promotion/*`.
- Local workspace helpers/templates/docs: `onboarding/local-workspace/*`, local `.accelerate/status` templates.
- Tests: `tests/all.sh` plus focused authority, workflow, GitHub PR, production, host export, promotion, and local workspace tests.
- Planning artifacts: executive plan, task ledger, this final review.

## Review Evidence

### Automated proof

Final root-run proof:

```bash
bash tests/local-workspace-proof-gates.sh
bash tests/local-workspace-scenario-matrix.sh
bash tests/production-readiness-gate.sh
bash tests/local-workflow-adapter.sh
git diff --check
```

Result: passed.

Full-suite proof after final-review artifact update:

```bash
bash tests/all.sh
git diff --check
```

Result: passed.

### Manual / forensic probes

Root final review verified the previous workstream findings and the newly discovered residuals:

```bash
onboarding/local-workspace/select-workflow-capability.sh github-pr create_update
```

Result: failed closed with exit `3` and `"available": false` for planned capability.

```bash
bash scripts/export-runtime-host.sh codex "$tmp_export"
(cd /tmp && bash -lc "$validation_command")
```

Result: generated host export `validation_command` passed from neutral cwd.

```bash
rg -n "Linear-shaped default|current default distribution shape|strong Linear-shaped default" adapters/workflow/README.md core adapters docs README.md SKILL.md
```

Result: no matches.

## Independent Review Wave

Three skeptical reviewers were delegated after implementation.

### Reviewer 1 — GitHub PR adapter and workflow capabilities

Initial verdict: correction required.

Blocking findings:

1. `select-workflow-capability.sh` exited `0` for planned unavailable capabilities.
2. `land-github-pr.sh` accepted local closure artifact without export approval.
3. GitHub PR recovery validation accepted invalid/unknown recovery packets.

Resolution:

- Selector now exits nonzero for unavailable statuses.
- Land path now requires closure artifact export approval.
- Recovery writer/validator now reject unknown repo and invalid operation enum.
- Focused and full tests passed after correction.

### Reviewer 2 — Local workspace runtime hardening

The first reviewer inspected the wrong worktree and was not used as substantive evidence for this repository. A replacement local-workspace review found three real blockers after the earlier `Supported` draft:

1. Production readiness accepted a deploy packet with `CI/check status: failed` because the checker validated marker presence and `production readiness result: ready`, not the semantic status fields.
2. `list-local-work-items.sh` and `select-local-work-item.sh` reconstructed state from `work_item_created` only, so list/select could show stale state and re-materialize an active item with old/default lifecycle/topology fields.
3. `transition-local-work-item.sh` blocked only `planned -> done`; it accepted other transitions into `done` without closure-ready evidence or a closure packet.

Resolution:

- `render-deploy-verification-packet.sh` now derives `production readiness result` from CI/deployment/canary/rollback semantics instead of emitting `ready` unconditionally.
- `check-production-readiness.sh` now requires exact acceptable `CI/check status` values and rejects blocked deployment action, weak canary evidence, weak rollback posture, and non-ready readiness result.
- `tests/production-readiness-gate.sh` now includes negative coverage for failed CI, weak canary evidence, and weak rollback posture.
- `list-local-work-items.sh` now reconstructs current state from creation records plus lifecycle events and topology events.
- `select-local-work-item.sh` now materializes the selected item from reconstructed current state instead of creation-only state, preserving lifecycle, parent/child/related topology, task ledger, and closure summary.
- `transition-local-work-item.sh` now requires the closure-ready evidence gate and a closure packet before any non-idempotent transition to `done`.
- `tests/local-workflow-adapter.sh` now covers list/select after transition, topology preservation after select, blocked unsafe `in_progress -> done`, blocked unsafe `review -> done`, and allowed `closure -> done` with closure proof.

### Reviewer 3 — Authority, backend neutrality, agent promotion, host export

Initial verdict: correction required.

Blocking findings:

1. Workflow adapter README still leaked Linear/default backend language.
2. Host export validation command was not self-contained from neutral cwd.
3. Capability selector returned success for unavailable planned capabilities.

Non-blocking findings:

- GitHub PR capability manifest had duplicate key.
- Capability schema/proof wording remains conservative and should stay monitored as capability manifests evolve.

Resolution:

- Linear/default leakage was reworded and tests were strengthened.
- Host export validation command is now self-contained and test-executed.
- Capability selector fail-closed behavior fixed.
- Duplicate GitHub PR manifest key removed and duplicate-key detection added to workflow adapter tests.
- Full suite passed after correction.

## Requested vs Implemented

| Request | Implemented | Evidence |
| --- | --- | --- |
| Complete executive plan | Done | `planning/executive/2026-05-05-runtime-adapter-hardening-executive-plan.md` |
| Complete detailed tasks from plan | Done | `planning/executive/2026-05-05-runtime-adapter-hardening-task-ledger.md` |
| Execute by subagents, root as orchestrator/reviewer | Done with bounded correction exception via delegated fixer and root residual fixes | Delegation summaries + final proof |
| Review per task by subagents | Done by workstream review wave; one wrong-worktree review discarded and replaced with focused local-workspace review | Review summaries + root final review |
| Root final confirmation | Done | This file |
| Actively close idle agents/processes | Done | `process list` returned empty before final closure |

## Residual Risks

- No real GitHub, Linear, or production remote writes were executed. This is intentional and aligned with the plan: remote writes remain opt-in and require live provider proof before statuses can be promoted.
- Some capability manifests still contain planned/blocked/substitute states. This is correct honesty, not unfinished implementation, because live adapter proof is absent.
- Production readiness is now semantically stricter, but it still validates packet text/contracts rather than observing a real provider deployment. Promotion to live production automation still requires provider-side proof.
- The hardening run was later committed and pushed as `4ba97bb Harden runtime adapter governance`; the repository-local proof boundary still remains separate from live remote-provider proof.

## Final Verdict

Supported after residual correction.

The earlier `Supported` draft was incomplete because it predated the replacement local-workspace review. After fixing the three residual blockers and adding regression tests, the hardening run is complete at repository-local proof level. The remaining limitations are expected remote-live-proof boundaries, not blockers for this planned governance/runtime hardening slice.
