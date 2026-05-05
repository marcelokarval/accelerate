# Runtime, Adapter, References, and Agent Promotion Hardening Executive Plan

## Status

- Owner: Accelerate root/orchestrator
- Date: 2026-05-05
- Source request: implement all recommendations from initial project analysis; create complete executive plan and task ledger; execute by subagents; master performs final review.
- Active branch classification: orchestrated non-trivial mutation-bearing governance/runtime hardening
- Root posture: orchestrator-first execution; task execution delegated to bounded subagents; master owns final forensic closure.
- Workflow backend: repo-local planning artifacts and tests; no fake remote issue adapter assumption.

## Prompt Hardening Packet

- Prompt A: "ok, implemente todas as melhorias que vc recomendou, todas. monte o plano executivo completo e detalhado, monte as tasks completas e detalhadas à partir do plano executivo, inicie a execução e o review por tasks será feito por subagent, vc fará o review final de confirmação. vc será orquestrador e não executor e terá o papel de review completo no final. Encerre ativamente agents que estejam idle e com entrega de resultado."
- Prompt B: Build a durable Accelerate hardening plan, task ledger, and delegated execution flow for all prior recommendations: close GitHub PR adapter safety, strengthen local workspace runtime, reduce `references/` authority ambiguity, evolve workflow adapters by exact capabilities, and add explicit agent promotion/install/export boundaries. Execute with bounded subagents, independent task review, correction/reproof, and final orchestrator forensic confirmation.
- Scope: repository-local docs, shell helpers, manifests, templates, tests, and planning artifacts under `/home/marcelo-karval/Backup/Projetos/accelerate`.
- Non-goals: do not perform real remote provider writes; do not mark planned adapters implemented without live proof; do not invent promoted runtime agents; do not weaken root control-plane authority.

## Success Criteria

1. GitHub PR adapter safety is sealed into the canonical test path and stricter argument/repo slug validation is applied where applicable.
2. Local workspace runtime truth is stronger: schema-complete workflow init, clearer V2/V3 docs, production readiness in local status/evidence, deploy packet helper, stronger rehydration, dashboard cockpit fields, lifecycle governance, and no dead proof-writing code in evidence gates.
3. Authority/reference terminology is classified into governing authorities, supporting references, decision artifacts, backend authority, and forbidden authority.
4. Workflow adapter manifests expose the requested exact capability set with commands/proof status, without overstating planned remote behavior.
5. Remote rehydration, provider comments, recovery packets, GitHub PR create/update/land gates are more explicit and fail-closed.
6. Agent factory docs define promotion/install/export states so doctrine/templates cannot be mistaken for runtime-promoted agents.
7. Host export contract is enforceable enough for current generic exports and remains non-authoritative outward output.
8. Tests and docs indexes are updated proportionally; `bash tests/all.sh` passes before closure.

## Constraints

- Master session is orchestrator/final reviewer, not task executor.
- Subagents may edit only assigned scopes; no nested delegation.
- Real GitHub/Linear writes remain opt-in guarded and must not be executed during tests.
- `github-pr` remains `planned` unless live create and land proof exists.
- Generated/global runtime copies must not drift from root doctrine where present.
- `.tmp/` test artifacts are acceptable ignored output; tracked tree must be reviewed explicitly.

## Workstreams

### WS1 — GitHub PR Adapter Safety Closure

Goal: make the adapter safety slice complete in default test coverage and stricter fail-closed parsing.

Primary surfaces:
- `onboarding/local-workspace/*github-pr*.sh`
- `onboarding/local-workspace/check-ship-readiness.sh`
- `onboarding/local-workspace/land-github-pr.sh`
- `tests/github-pr-adapter-safety.sh`
- `tests/github-pr-helper-parse.sh`
- `tests/all.sh`

### WS2 — Local Workspace Runtime Hardening

Goal: strengthen `.accelerate/` local runtime surfaces as the pre-agents execution cockpit.

Primary surfaces:
- `onboarding/local-workspace/README.md`
- `onboarding/local-workspace/v2-materialization-contract.md`
- `docs/architecture/accelerate-project-local-workspace-v2-contract.md`
- `onboarding/local-workspace/init-local-workflow.sh`
- `onboarding/local-workspace/v2-template/.accelerate/status/*`
- `onboarding/local-workspace/*readiness*.sh`
- `onboarding/local-workspace/*handoff*.sh`
- `onboarding/local-workspace/*context*.sh`
- `onboarding/local-workspace/*local-work-item*.sh`
- local workspace tests

### WS3 — Authority and References Governance

Goal: classify authority sources so `references/` no longer reads like unqualified runtime law.

Primary surfaces:
- new `core/control-plane/authority-set-gate.md`
- `SKILL.md`, `README.md`, `core/README.md`
- `core/runtime-packets/templates.md`
- `docs/architecture/accelerate-control-plane.md`
- `references/README.md`
- global runtime mirrors if present

### WS4 — Workflow Adapter Capability Matrix

Goal: move from broad adapter readiness to exact capabilities: read/lookup, create/update, review artifact, rehydrate, write recovery, closure comment, status transition, production/merge/land gate.

Primary surfaces:
- `adapters/workflow/adapter-contract.md`
- `adapters/workflow/*/capabilities.yaml`
- new `adapters/workflow/capability-schema-v2.md`
- `tests/workflow-adapter-contract.sh`
- `tests/manifest-truth-gate.sh`
- `tests/remote-write-registry.sh`

### WS5 — Remote Provider Packet/Comment/Recovery/Land Hardening

Goal: normalize remote adapter outputs and separate review comments from closure comments before land.

Primary surfaces:
- `adapters/workflow/provider-state-rehydration-contract.md`
- `adapters/workflow/provider-comment-contract.md`
- `onboarding/local-workspace/rehydrate-github-pr-adapter.sh`
- new validator/helper scripts for workflow rehydration, comments, recovery, closure comments, PR update
- GitHub PR tests and production readiness tests

### WS6 — Agent Promotion / Install / Export Boundary

Goal: make agent factory promotion explicit and prevent doctrine/runtime confusion.

Primary surfaces:
- new `agents/promotion/install-export-contract.md`
- `agents/promotion/*`
- `agents/README.md`
- `planning/promotion/template-promotion-readiness-packet.md`
- `adapters/runtime/host-export-contract.md`
- `scripts/export-runtime-host.sh`
- tests for promotion/install/export and host export

## Execution Order

1. Plan/ledger creation and audit synthesis.
2. WS1: seal already-near-complete GitHub PR safety slice.
3. WS3 + WS6 docs/contracts in parallel if file scopes are isolated.
4. WS4 capability manifest schema and tests.
5. WS2 local runtime hardening in two batches: docs/schema first, lifecycle/rehydration/helpers second.
6. WS5 remote provider hardening after WS4 defines capability vocabulary.
7. Integration pass to reconcile overlapping tests/docs and run full suite.
8. Independent review per workstream.
9. Master final forensic review and closure packet.

## Proof Plan

Focused proof:

```bash
bash tests/github-pr-helper-parse.sh
bash tests/github-pr-adapter-safety.sh
bash tests/remote-write-registry.sh
bash tests/manifest-truth-gate.sh
bash tests/workflow-adapter-contract.sh
bash tests/local-workflow-adapter.sh
bash tests/local-workspace-proof-gates.sh
bash tests/local-workspace-scenario-matrix.sh
bash tests/production-readiness-gate.sh
bash tests/template-promotion-readiness.sh
bash tests/promotion-replay-fixtures.sh
bash tests/physical-agent-runtime-adapter.sh
bash tests/all.sh
```

Final proof:

```bash
git status --short
bash tests/all.sh
git diff --check
git status --short
```

## Risk Register

| Risk | Mitigation |
| --- | --- |
| Scope too broad for one safe landing | Use bounded subagent scopes and final integration review; keep statuses honest if partial. |
| Remote adapter overclaim | Manifests must keep planned/blocked capabilities visible; live proof required for implemented statuses. |
| Local runtime dashboard bloat | Add compact summary fields only; logs remain in events/timeline. |
| Tests become slow/flaky | Keep shell tests deterministic and `.tmp`-scoped. |
| Agent docs imply real runtime agents | Explicit install/export states and tests must block missing contract fields. |
| Orchestrator accidentally becomes executor | Master writes only orchestration artifacts and reviews; implementation delegated. |

## Definition Of Done

- Plan and task ledger exist and are indexed if repository convention requires.
- Each task has executor output and skeptical review or explicit exception.
- In-scope defects found by reviewers are corrected and reproofed.
- Full test suite passes.
- Final master review compares request, plan, ledger, implemented changes, reviews, defects, proof, and residual risks.
- No idle/background agents or tracked dirty state are left unacknowledged.
