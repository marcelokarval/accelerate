# Accelerate Skill Dependency Manifest

This manifest lists the skills that local `accelerate` doctrine currently uses
or expects during execution.

Statuses:

- `local-native`: the operating rule exists inside this repository, but not as a
  reusable Codex skill seed.
- `local-seed`: the skill body exists under root `skills/`.
- `global-only`: the skill exists in the runtime mirror but is not yet owned by
  this repository.
- `missing`: the local doctrine implies the capability, but no concrete local
  or global skill was confirmed.
- `role-only`: the docs name a role or family instead of a concrete skill.

Autocontainment target:

- Required runtime skills must become `local-seed` or be replaced by a
  sufficient `local-native` module.
- `global-only` is allowed only as a temporary migration state.
- New skill references must be added here before becoming mandatory doctrine.

## Local Seeded Skills

| Skill | Role | Local native owner | Status |
| --- | --- | --- | --- |
| `extract-html-design-system-v2` | Extract URL, local HTML, raw HTML, or app UI into `docs/reference/design-system.html`, contract, premium direction, and component coverage evidence. | `core/review/html-design-system-extraction.md` | `local-seed` at `skills/design-system/extract-html-design-system-v2/` |
| `apply-design-system-contract` | Use existing `docs/reference/design-system*` artifacts as implementation law for new UI, correction, premium recomposition, proposals, and theme generation. | `core/review/design-system-contract-application.md` | `local-seed` at `skills/design-system/apply-design-system-contract/` |

## Root, Planning, Execution, Closure

| Skill | Role | Local native owner | Current status | Target |
| --- | --- | --- | --- | --- |
| `accelerate` | Root classifier, branch router, runtime operating system, gate owner, proof owner. | `SKILL.md`, `core/control-plane/*` | `root-native exception` | root `SKILL.md`, not duplicated under `skills/root/accelerate/` |
| `prompt-hardening` | Convert ambiguous, long, multi-phase, or weak prompts into bounded execution-ready artifacts. | `core/hardening/prompt-hardening.md`, `references/prompt-hardening-gate.md` | `local-seed` at `skills/root/prompt-hardening/` | `local-authoritative` |
| `planning-with-files` | Persistent file-based planning for multi-step implementation. | `planning/`, `planning/executive/` | `local-seed` at `skills/workflow/planning-with-files/` | `local-authoritative` |
| `executing-plans` | Execute accepted plans with bounded validation and closure. | `core/workflows/catalog.md` | `local-seed` at `skills/workflow/executing-plans/` | `local-authoritative` |
| `verification-before-completion` | Evidence-before-closure gate. | `core/runtime-packets/qa-proof-stack.md` | `local-seed` at `skills/root/verification-before-completion/` | `local-authoritative` |
| `requesting-code-review` | Pre-merge/code-review loop and review report discipline. | `core/review/` | `local-seed` at `skills/review/requesting-code-review/` | `local-authoritative` |

## Workflow Adapters

| Skill | Role | Local native owner | Current status | Target |
| --- | --- | --- | --- | --- |
| `linear-implementation-planner` | Sequence issue execution and dependencies. | `adapters/workflow/linear/` | `local-seed` at `skills/workflow/linear-implementation-planner/` | `local-authoritative` |
| `linear-pm` | Create/update/triage Linear issues and issue bodies. | `adapters/workflow/linear/` | `local-seed` at `skills/workflow/linear-pm/` | `local-authoritative` |
| `linear-progress-reporter` | Report progress, blockers, and execution state. | `adapters/workflow/linear/` | `local-seed` at `skills/workflow/linear-progress-reporter/` | `local-authoritative` |
| `linear-workflow-orchestrator` | Coordinate multi-issue Linear workflows. | `adapters/workflow/linear/` | `local-seed` at `skills/workflow/linear-workflow-orchestrator/` | `local-authoritative` |
| `github-issues` | GitHub issue lifecycle. | `adapters/workflow/github/` | `local-seed` at `skills/workflow/github-issues/` | `local-authoritative` |
| `github-pr-workflow` | PR creation, CI, update, and merge discipline. | `adapters/workflow/github/` | `local-seed` at `skills/workflow/github-pr-workflow/` | `local-authoritative` |
| `github-code-review` | GitHub PR/diff review. | `adapters/workflow/github/` | `local-seed` at `skills/workflow/github-code-review/` | `local-authoritative` |
| `github-auth` | GitHub authentication capability detection and setup. | `adapters/workflow/github/` | `local-seed` at `skills/workflow/github-auth/` | `local-authoritative` |
| `github-repo-management` | Repository, remote, branch, and publishing operations. | `adapters/workflow/github/` | `local-seed` at `skills/workflow/github-repo-management/` | `local-authoritative` |

## Runtime Proof And Debugging

| Skill | Role | Local native owner | Current status | Target |
| --- | --- | --- | --- | --- |
| `systematic-debugging` | Repro-first root-cause workflow for bugs, failures, and regressions. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/review/systematic-debugging/` | `local-authoritative` |
| `dogfood` | Exploratory browser QA, evidence capture, and bug report shaping. | `adapters/runtime/browser/`, `core/runtime-packets/qa-proof-stack.md` | `local-seed` at `skills/runtime/dogfood/` | `local-authoritative` |
| `product-runtime-review` | Product correctness for user-facing runtime flows. | `core/review/product-critical-surfaces.md` | `local-seed` at `skills/review/product-runtime-review/` | `local-authoritative` |
| `inertia-runtime-persistence-audit` | Audit shell persistence, partial reload, page-meta, and navigation churn. | `profiles/django-inertia-react/` | `local-seed` at `skills/frontend/inertia-runtime-persistence-audit/` | `local-authoritative` |
| `react-best-practices` | React implementation quality and pragmatic performance checks. | `profiles/` placeholders | `local-seed` at `skills/frontend/react-best-practices/` | `local-authoritative` |

## Frontend, Design, UI

| Skill | Role | Local native owner | Current status | Target |
| --- | --- | --- | --- | --- |
| `front-react-shadcn` | React/shadcn/Radix/Tailwind stack rules. | `profiles/django-inertia-react/` | `local-seed` at `skills/frontend/front-react-shadcn/` | `local-authoritative` |
| `frontend-boundary-governance` | `.ts`/`.tsx`, backend/frontend truth, and visual/nonvisual boundary control. | `references/adjacent-skill-trigger-audit.md` | `local-seed` at `skills/frontend/frontend-boundary-governance/` | `local-authoritative` |
| `frontend-componentization-audit` | Detect reuse opportunities, duplicate components, and raw-markup drift. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/frontend/frontend-componentization-audit/` | `local-authoritative` |
| `frontend-component-hierarchy` | Component placement, import direction, and hierarchy discipline. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/frontend/frontend-component-hierarchy/` | `local-authoritative` |
| `frontend-chunk-ownership-audit` | Vite/Rollup chunk ownership and feature-edge audit. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/frontend/frontend-chunk-ownership-audit/` | `local-authoritative` |
| `tailwind-design-system` | Tailwind token, theme, variant, and design-system governance. | `core/review/html-design-system-extraction.md`, `core/review/design-system-contract-application.md` | `local-seed` at `skills/frontend/tailwind-design-system/` | `local-authoritative` |
| `tailwind-patterns` | Tailwind utility composition and responsive rules. | `profiles/` placeholders | `local-seed` at `skills/frontend/tailwind-patterns/` | `local-authoritative` |
| `typescript-pro` | TypeScript contracts, strict typing, and type-driven refactors. | `profiles/` placeholders | `local-seed` at `skills/frontend/typescript-pro/` | `local-authoritative` |
| `figma-node-fidelity` | Figma-to-code fidelity when node hierarchy and screenshot truth matter. | `core/review/premium-interface-production.md` | `local-seed` at `skills/frontend/figma-node-fidelity/` | `local-authoritative` |
| `ascii-wireframe` | Structural UI artifacts before implementation when layout uncertainty exists. | `core/review/product-critical-surfaces.md` | `local-seed` at `skills/frontend/ascii-wireframe/` | `local-authoritative` |
| `i18n-patterns` | User-facing copy, locale packs, and runtime non-default locale proof. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/frontend/i18n-patterns/` | `local-authoritative` |
| `nextjs-app-router-patterns` | Next.js layout and composition profile guidance. | `profiles/nextjs-tailwind/` | `local-seed` at `skills/frontend/nextjs-app-router-patterns/` | `local-authoritative` |

## Backend, Data, Django, Inertia

| Skill | Role | Local native owner | Current status | Target |
| --- | --- | --- | --- | --- |
| `django-pro` | Broad Django framework guidance. | `profiles/django-inertia-react/` | `local-seed` at `skills/backend/django-pro/` | `local-authoritative` |
| `django-service-patterns` | Service-layer and business logic ownership discipline. | `references/adjacent-skill-trigger-audit.md` | `local-seed` at `skills/backend/django-service-patterns/` | `local-authoritative` |
| `django-inertia-integration` | Django-side Inertia render, props, redirects, and page-name contracts. | `profiles/django-inertia-react/` | `local-seed` at `skills/backend/django-inertia-integration/` | `local-authoritative` |
| `django-vite-integration` | Django/Vite dev/prod asset pipeline. | `profiles/django-inertia-react/` | `local-seed` at `skills/backend/django-vite-integration/` | `local-authoritative` |
| `inertia-patterns` | Inertia navigation, shared props, layouts, and partial reloads. | `profiles/django-inertia-react/` | `local-seed` at `skills/backend/inertia-patterns/` | `local-authoritative` |
| `inertia-shared-props` | Shared prop contract between Django and frontend. | `profiles/django-inertia-react/` | `local-seed` at `skills/backend/inertia-shared-props/` | `local-authoritative` |
| `server-prop-governance` | Server-to-frontend prop ownership, shell/page boundaries, deferred data. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/frontend/server-prop-governance/` | `local-authoritative` |
| `validation-governance` | Backend authority vs frontend convenience validation. | `references/adjacent-skill-trigger-audit.md` | `local-seed` at `skills/governance/validation-governance/` | `local-authoritative` |
| `python-pro` | Python implementation discipline. | `profiles/django-inertia-react/` | `local-seed` at `skills/backend/python-pro/` | `local-authoritative` |
| `python-testing` | Pytest/Django testing patterns. | `core/personas/mandatory-skills.md` | `local-seed` at `skills/backend/python-testing/` | `local-authoritative` |
| `celery-tasks` | Queue, retry, idempotency, and task-to-service delegation. | `agents/envelopes/skill-envelopes.md` | `local-seed` at `skills/backend/celery-tasks/` | `local-authoritative` |

## Database, Financial, Payment

| Skill | Role | Local native owner | Current status | Target |
| --- | --- | --- | --- | --- |
| `database-design` | Relational schema quality. | `skills/data/README.md` | `local-seed` at `skills/data/database-design/` | `local-authoritative` |
| `database-architect` | Higher-level data architecture. | `skills/data/README.md` | `local-seed` at `skills/data/database-architect/` | `local-authoritative` |
| `postgresql` | PostgreSQL table, constraint, column, and index guidance. | `skills/data/README.md` | `local-seed` at `skills/data/postgresql/` | `local-authoritative` |
| `postgres-best-practices` | PostgreSQL performance and operational quality. | `skills/data/README.md` | `local-seed` at `skills/data/postgres-best-practices/` | `local-authoritative` |
| `sql-optimization-patterns` | Query-shape, N+1, and execution-plan proof. | `references/adjacent-skill-trigger-audit.md` | `local-seed` at `skills/data/sql-optimization-patterns/` | `local-authoritative` |
| `financial-source-truth` | Credit, balance, reconciliation, and money-state truth. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/data/financial-source-truth/` | `local-authoritative` |
| `payment-integration` | Checkout, subscription, idempotency, refund, and provider-event workflows. | `agents/envelopes/skill-envelopes.md` | `local-seed` at `skills/data/payment-integration/` | `local-authoritative` |
| `stripe-integration` | Stripe billing/webhook/provider-state guidance. | `agents/envelopes/skill-envelopes.md` | `local-seed` at `skills/data/stripe-integration/` | `local-authoritative` |

## Security, Abuse, Governance

| Skill | Role | Local native owner | Current status | Target |
| --- | --- | --- | --- | --- |
| `anti-abuse-review` | Misuse, enumeration, replay, race, spam, and abuse-resistance review. | `references/adjacent-skill-trigger-audit.md` | `local-seed` at `skills/security/anti-abuse-review/` | `local-authoritative` |
| `security-patterns` | IDOR, auth, secret, ownership, and race-safety baseline. | `references/adjacent-skill-trigger-audit.md` | `local-seed` at `skills/security/security-patterns/` | `local-authoritative` |
| `adversarial-security-review` | Hostile-path and variant hunting review. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/security/adversarial-security-review/` | `local-authoritative` |
| `untrusted-ingress-hardening` | Upload/import/parser/media ingress hardening. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/security/untrusted-ingress-hardening/` | `local-authoritative` |
| `api-surface-governance` | Transport/API/webhook/integration boundary decisions. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/governance/api-surface-governance/` | `local-authoritative` |
| `dependency-governance` | Dependency add/remove/overlap/posture decisions. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/governance/dependency-governance/` | `local-authoritative` |
| `governance-audit` | Stack adherence, drift, and architectural consistency audit. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/governance/governance-audit/` | `local-authoritative` |
| `accelerate stack governance` | Standalone stack constitution and branch-governance rules. | `core/control-plane/branch-enforcement-matrix.md`, `core/README.md`, `docs/architecture/*` | `local-native` via `governance-audit`, `api-surface-governance`, `dependency-governance`, `validation-governance`, `architecture` | Prop4You-specific constitution belongs in a project overlay, not core Accelerate |
| `architecture` | Architecture tradeoff, ADR, and decision lens. | `core/review/architecture.md` | `local-seed` at `skills/review/architecture/` | `local-authoritative` |

## Legacy, Migration, Skill Evolution

| Skill | Role | Local native owner | Current status | Target |
| --- | --- | --- | --- | --- |
| `legacy-first-protocol` | Consult donor legacy before recreating existing behavior. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/legacy/legacy-first-protocol/` | `local-authoritative` |
| `legacy-transplant` | Adapt legacy truth without copying obsolete shapes blindly. | `core/control-plane/branch-enforcement-matrix.md` | `local-seed` at `skills/legacy/legacy-transplant/` | `local-authoritative` |
| `codex-skill-promotion-protocol` | Promote, reconcile, and sync governed skills. | `skills/_registry/sync-policy.md` | `local-seed` at `skills/governance/codex-skill-promotion-protocol/` | `local-authoritative` |
| `skill-developer` | Create and maintain skills. | `core/workflows/skill-evaluation-lab.md` | `local-seed` at `skills/governance/skill-developer/` | `local-authoritative` |
| `writing-skills` | Skill authoring methodology and skill test discipline. | `core/workflows/skill-evaluation-lab.md` | `local-seed` at `skills/governance/writing-skills/` | `local-authoritative` |
| `using-superpowers` | Legacy/global skill discipline bootstrap. | none confirmed | `replaced` by root `accelerate` | not promoted; see `planning/executive/using-superpowers-replacement-audit.md` |

## Runtime, Tooling, MCP

| Skill | Role | Local native owner | Current status | Target |
| --- | --- | --- | --- | --- |
| `bash-linux` | Safe shell inspection and automation discipline. | `skills/runtime/README.md` | `local-seed` at `skills/runtime/bash-linux/` | `local-authoritative` |
| `native-mcp` | MCP configuration and troubleshooting. | `adapters/runtime/` | `local-seed` at `skills/runtime/native-mcp/` | `local-authoritative` |
| `mcporter` | Direct MCP CLI operation. | `adapters/runtime/` | `local-seed` at `skills/runtime/mcporter/` | `local-authoritative` |
| `codebase-inspection` | LOC, language breakdown, and codebase metrics. | `skills/runtime/README.md` | `local-seed` at `skills/runtime/codebase-inspection/` | `local-authoritative` |
| `code-audit` | Broad static quality/security audit. | `core/review/` | `local-seed` at `skills/review/code-audit/` | `local-authoritative` |
| `component-extraction` | Reusable React component extraction and DRY convergence. | `skills/frontend/README.md` | `local-seed` at `skills/frontend/component-extraction/` | `local-authoritative` |
| `subagent-governance` | Multi-agent write-scope and review aggregation governance. | `core/delegation/subagent-model.md` | `local-seed` at `skills/workflow/subagent-governance/` | `local-authoritative` |
| `parallel-agents` | Parallel independent read/validation orchestration. | `core/workflows/catalog.md` | `local-seed` at `skills/workflow/parallel-agents/` | `local-authoritative` |

## Role-Only Dependencies To Resolve

| Role phrase | Where it appears | Required action |
| --- | --- | --- |
| Backend stack bundle | branch matrix, personas, agent envelopes | Use concrete profile skills: `django-pro`, `django-service-patterns`, `django-inertia-integration`, `django-vite-integration`, `inertia-patterns`, `inertia-shared-props`, `python-pro`, `python-testing`, `celery-tasks`, `database-design`, `postgresql`, `sql-optimization-patterns`. |
| Frontend stack bundle | branch matrix, personas, agent envelopes | Use concrete profile skills: `front-react-shadcn`, `react-best-practices`, `typescript-pro`, `tailwind-patterns`, `tailwind-design-system`, `frontend-boundary-governance`, `frontend-component-hierarchy`, `frontend-componentization-audit`, `component-extraction`, `i18n-patterns`, `server-prop-governance`, `inertia-runtime-persistence-audit`, `nextjs-app-router-patterns` when the profile is Next.js. |
| Workflow adapter planning bundle | agent envelopes and capability matrix | Use concrete adapter skills: `planning-with-files`, `linear-implementation-planner`, `linear-pm`, `linear-workflow-orchestrator`, `github-issues`, `github-pr-workflow`, `github-code-review` as the selected backend requires. |
| Persistent E2E proof bundle | persona matrix and proof stack | Resolved locally by `dogfood`, `product-runtime-review`, `inertia-runtime-persistence-audit`, and the Playwright adapter fixtures in `adapters/runtime/playwright/`. |
| Runtime/product review bundle | persona matrix | Resolved to `product-runtime-review`, with `dogfood` for browser evidence. |
| Domain-truth bundle | product-critical surfaces and branch matrix | Resolved by available local domain seeds such as `financial-source-truth`, `payment-integration`, and `stripe-integration`; future domains need explicit local seeds or overlays. |

## Current Autocontainment Summary

| Class | Count | Meaning |
| --- | ---: | --- |
| `local-seed` | 73 | Repo-owned skill bodies under root `skills/`. |
| `root-native exception` | 1 | Root `accelerate` skill remains at repository root by design. |
| `replaced global-only` | 1 | `using-superpowers` is intentionally replaced by root Accelerate. |
| `partial proof fixture` | 0 blocking | Playwright scenario and proof packet fixtures now exist locally. |
| `role-only` | 0 blocking | Former role phrases now resolve to concrete bundles or documented fixture gaps. |

The next migration must continue prioritizing branch-matrix and persona-matrix
skills before optional provider or stack-specific overlays.
