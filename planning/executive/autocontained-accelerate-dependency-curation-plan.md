# Autocontained Accelerate Dependency Curation Plan

## Executive Summary

The local `accelerate` repository is currently self-contained as a
control-plane product, but not yet self-contained as a complete operating
runtime.

It has native local doctrine for:

- root classification
- branch routing
- workflow catalog
- runtime packets
- issue topology
- delegation and future-agent doctrine
- design-system extraction/application operating rules
- onboarding/local workspace materialization
- adapters and profiles as architecture scaffolding

It does not yet vendor most adjacent skill bodies that the control plane
requires during execution. Those adjacent skills currently live in the global
runtime mirror:

- `~/.codex/skills/`

The migration is now active. Root `skills/` is the authoring source for the
promoted governed skills, and `~/.codex/skills/` is treated as a generated
runtime mirror for those skills.

That means the local repo can already ship the core design-system,
root/review/governance, frontend support, backend support, and security support
skills promoted so far, but it is not yet fully self-contained across workflow
adapters, data, runtime tooling, legacy, and provider/domain overlays.

## Current Local Surfaces Used By Accelerate

### Root And Control Plane

| Local surface | Role | Status |
| --- | --- | --- |
| `SKILL.md` | root entry skill for classification and high-level routing | local native |
| `README.md` | operational guide and orientation | local native |
| `AGENTS.md` | repository bootstrap discipline for Codex | local native |
| `core/control-plane/root-laws.md` | root-level laws | local native |
| `core/control-plane/branch-enforcement-matrix.md` | active branch/skill/gate/evidence matrix | local native |
| `core/control-plane/quick-invocation-map.md` | fast route map | local native |
| `core/control-plane/workflow-change-approval-gate.md` | governs mutation of workflow doctrine | local native |
| `core/control-plane/parity-replacement-gate.md` | governs legacy-to-local parity promotion | local native |

### Workflow And Proof

| Local surface | Role | Status |
| --- | --- | --- |
| `core/workflows/catalog.md` | named workflow lanes | local native |
| `core/workflows/operational-calibration.md` | execution calibration | local native |
| `core/workflows/self-evolution.md` | repeated-evidence-to-rule evolution | local native |
| `core/workflows/maturity-control.md` | maturity and de-escalation controls | local native |
| `core/workflows/skill-evaluation-lab.md` | skill/workflow evaluation method | local native |
| `core/runtime-packets/templates.md` | runtime packet schemas | local native |
| `core/runtime-packets/cadence.md` | observability cadence | local native |
| `core/runtime-packets/qa-proof-stack.md` | proof ordering and QA lanes | local native |

### Review, UI, Product, Design-System

| Local surface | Role | Status |
| --- | --- | --- |
| `core/review/product-critical-surfaces.md` | product-critical UI/runtime surface discipline | local native |
| `core/review/premium-interface-production.md` | premium UI direction/reconciliation | local native |
| `core/review/html-design-system-extraction.md` | native operating surface for extraction skill | local native |
| `core/review/design-system-contract-application.md` | native operating surface for post-extraction implementation | local native |
| `core/review/ui-polishing-observer.md` | future observer/polishing lane | local native |
| `core/review/architecture.md` | architecture review lens | local native |
| `core/review/persisted-modeling-forensics.md` | persisted modeling forensic review | local native |
| `core/review/persisted-modeling-defect-bias.md` | modeling defect bias lens | local native |

### Issue, Delegation, Agents, Adapters, Profiles

| Local surface | Role | Status |
| --- | --- | --- |
| `core/issue-topology/*` | issue-driven mutation stack and topology policy | local native |
| `core/delegation/subagent-model.md` | local subagent governance model | local native |
| `agents/doctrine/*` | future-agent control-plane doctrine | local native |
| `agents/envelopes/skill-envelopes.md` | future-agent skill-envelope model | local native |
| `adapters/workflow/*` | workflow adapter architecture for Linear/GitHub | local scaffold |
| `adapters/runtime/*` | runtime adapter architecture for browser, Playwright, Node, Python | local scaffold |
| `profiles/django-inertia-react/` | stack profile placeholder | local scaffold |
| `profiles/nextjs-tailwind/` | stack profile placeholder | local scaffold |
| `onboarding/local-workspace/*` | project-local `.accelerate/` materialization model | local native/scaffold |

## Current Governed Skill Seeds In Repo

The authoritative current list is:

- `skills/_registry/manifest.md`

As of this slice, 73 governed skill bodies exist under root `skills/` and are
registered for repo-first sync into the global runtime mirror.

## Initial External Skill Dependencies Found During Inventory

The tables below preserve the initial inventory shape from before promotion
began. Current status is governed by `skills/_registry/manifest.md` and
`docs/codex-skill-seeds/skill-dependency-manifest.md`.

### Root, Planning, Closure

| Skill | Role in Accelerate | Local native equivalent | Local seed | Global exists | Autocontained status |
| --- | --- | --- | --- | --- | --- |
| `prompt-hardening` | harden ambiguous/long/epic-like prompts | `core/hardening/prompt-hardening.md` | no | yes | partially local, skill body external |
| `planning-with-files` | file-based implementation planning | planning/onboarding docs only | no | yes | external |
| `executing-plans` | execute accepted implementation plans | workflow catalog only | no | yes | external |
| `verification-before-completion` | final evidence-before-done gate | `core/runtime-packets/qa-proof-stack.md` partially | no | yes | partially local, skill body external |
| `requesting-code-review` | pre-merge/code review loop | no native equivalent | no | yes | external |

### Workflow / Issue / PM

| Skill | Role in Accelerate | Local native equivalent | Local seed | Global exists | Autocontained status |
| --- | --- | --- | --- | --- | --- |
| `linear-implementation-planner` | issue execution sequencing | adapters/workflow/linear scaffold | no | yes | external |
| `linear-pm` | issue creation/update discipline | adapters/workflow/linear scaffold | no | yes | external |
| `linear-progress-reporter` | progress reporting | adapters/workflow/linear scaffold | no | yes | external |
| `linear-workflow-orchestrator` | multi-issue orchestration | adapters/workflow/linear scaffold | no | yes | external |
| `github-issues` | GitHub issue workflow | adapters/workflow/github scaffold | no | yes | external |
| `github-pr-workflow` | PR lifecycle | adapters/workflow/github scaffold | no | yes | external |
| `github-code-review` | GitHub review | adapters/workflow/github scaffold | no | yes | external |
| `github-auth` | GitHub auth setup | adapters/workflow/github scaffold | no | yes | external |
| `github-repo-management` | repo/remote operations | adapters/workflow/github scaffold | no | yes | external |

### Debugging, QA, Runtime Proof

| Skill | Role in Accelerate | Local native equivalent | Local seed | Global exists | Autocontained status |
| --- | --- | --- | --- | --- | --- |
| `systematic-debugging` | bug/failure/regression root cause workflow | branch matrix only | no | yes | external |
| `dogfood` | exploratory browser QA | runtime adapter/browser docs partially | no | yes | external |
| `product-runtime-review` | user-facing runtime/product correctness | `core/review/product-critical-surfaces.md` partially | no | yes | partially local, skill body external |
| `inertia-runtime-persistence-audit` | Inertia persistence/churn review | no native equivalent | no | yes | external |
| `react-best-practices` | React quality/performance lens | profile placeholder only | no | yes | external |

### Frontend, Design, UI

| Skill | Role in Accelerate | Local native equivalent | Local seed | Global exists | Autocontained status |
| --- | --- | --- | --- | --- | --- |
| `front-react-shadcn` | Prop4You React/Inertia/shadcn stack lens | profile placeholder | no | yes | external |
| `frontend-boundary-governance` | TS/TSX and frontend truth boundary | adjacent trigger audit only | no | yes | external |
| `frontend-componentization-audit` | component reuse/convergence audit | no native equivalent | no | yes | external |
| `frontend-component-hierarchy` | React component placement/layering | no native equivalent | no | yes | external |
| `frontend-chunk-ownership-audit` | frontend bundle ownership/chunk review | no native equivalent | no | yes | external |
| `tailwind-design-system` | token/theme/shared variant governance | design-system docs partially | no | yes | external |
| `tailwind-patterns` | Tailwind utility composition | profile placeholder only | no | yes | external |
| `typescript-pro` | TypeScript contracts/refactors | profile placeholder only | no | yes | external |
| `figma-node-fidelity` | Figma-to-code fidelity | premium/reference docs mention | no | yes | external |
| `ascii-wireframe` | structural UI artifact before implementation | product/premium docs mention | no | yes | external |
| `i18n-patterns` | locale/copy proof | branch matrix only | no | yes | external |
| `nextjs-app-router-patterns` | Next.js layout/composition borrowing | nextjs profile placeholder | no | yes | external |

### Backend, Data, Django, Inertia

| Skill | Role in Accelerate | Local native equivalent | Local seed | Global exists | Autocontained status |
| --- | --- | --- | --- | --- | --- |
| `django-pro` | broad Django framework lens | django profile only | no | yes | external |
| `django-service-patterns` | service/business logic discipline | adjacent trigger audit only | no | yes | external |
| `django-inertia-integration` | Django-side Inertia render/props/redirects | profile placeholder only | no | yes | external |
| `django-vite-integration` | Django/Vite asset pipeline | profile placeholder only | no | yes | external |
| `inertia-patterns` | Inertia navigation/layout/shared behavior | profile placeholder only | no | yes | external |
| `inertia-shared-props` | shared prop contract | profile placeholder only | no | yes | external |
| `server-prop-governance` | Django-to-Inertia prop ownership | branch matrix only | no | yes | external |
| `validation-governance` | backend vs frontend validation authority | adjacent trigger audit only | no | yes | external |
| `python-pro` | Python implementation discipline | profile placeholder only | no | yes | external |
| `python-testing` | pytest/Django testing | persona matrix only | no | yes | external |
| `celery-tasks` | async task/idempotency patterns | agent envelopes only | no | yes | external |

### Database, Query, Financial, Payment

| Skill | Role in Accelerate | Local native equivalent | Local seed | Global exists | Autocontained status |
| --- | --- | --- | --- | --- | --- |
| `database-design` | schema design | no native equivalent | no | yes | external |
| `database-architect` | higher-level data architecture | no native equivalent | no | yes | external |
| `postgresql` | PostgreSQL table/index/constraint guidance | no native equivalent | no | yes | external |
| `postgres-best-practices` | PostgreSQL performance/quality | no native equivalent | no | yes | external |
| `sql-optimization-patterns` | query-shape/N+1 proof | adjacent trigger audit only | no | yes | external |
| `financial-source-truth` | money/balance/reconciliation/admin truth | branch matrix only | no | yes | external |
| `payment-integration` | payment workflows | agent envelopes only | no | yes | external |
| `stripe-integration` | Stripe billing/webhooks/provider-state | agent envelopes only | no | yes | external |

### Security, Abuse, Ingress, Governance

| Skill | Role in Accelerate | Local native equivalent | Local seed | Global exists | Autocontained status |
| --- | --- | --- | --- | --- | --- |
| `anti-abuse-review` | misuse/replay/enumeration/rate limit review | adjacent trigger audit only | no | yes | external |
| `security-patterns` | IDOR/auth/secret/race baseline | adjacent trigger audit only | no | yes | external |
| `adversarial-security-review` | hostile-path review | branch matrix only | no | yes | external |
| `untrusted-ingress-hardening` | upload/import/media ingress safety | branch matrix only | no | yes | external |
| `api-surface-governance` | REST/API/webhook/transport boundary | branch matrix only | no | yes | external |
| `dependency-governance` | dependency add/remove/overlap decisions | branch matrix only | no | yes | external |
| `governance-audit` | stack adherence and drift review | branch matrix only | no | yes | external |
| `p4y-stack-constitution` | official Prop4You stack constitution | branch matrix only | no | yes | external |
| `architecture` | architectural decision/ADR lens | `core/review/architecture.md` partially | no | yes | partially local, skill body external |

### Legacy, Migration, Self-Evolution

| Skill | Role in Accelerate | Local native equivalent | Local seed | Global exists | Autocontained status |
| --- | --- | --- | --- | --- | --- |
| `legacy-first-protocol` | consult donor legacy before new behavior | branch matrix only | no | yes | external |
| `legacy-transplant` | adapt legacy truth without cargo-culting | branch matrix only | no | yes | external |
| `codex-skill-promotion-protocol` | promote/sync governed skills | seed README and workflow-change gate partially | no | yes | external |
| `skill-developer` | create/manage skills | skill-evaluation lab partially | no | yes | external |
| `writing-skills` | TDD-like skill authoring methodology | skill-evaluation lab partially | no | yes, under superpowers | external |
| `using-superpowers` | global skill discipline bootstrap | not local | no | yes | external |

### Runtime / Tooling / MCP

| Skill | Role in Accelerate | Local native equivalent | Local seed | Global exists | Autocontained status |
| --- | --- | --- | --- | --- | --- |
| `bash-linux` | safe shell and Linux patterns | no native equivalent | no | yes | external |
| `native-mcp` | MCP config/troubleshooting | runtime adapter docs only | no | yes | external |
| `mcporter` | direct MCP CLI interaction | runtime adapter docs only | no | yes | external |
| `codebase-inspection` | LOC/language/codebase stats | no native equivalent | no | yes | external |
| `code-audit` | broad static/code quality audit | no native equivalent | no | yes | external |
| `component-extraction` | reusable React extraction patterns | no native equivalent | no | yes | external |
| `subagent-governance` | multi-agent governance | `core/delegation/subagent-model.md` partially | no | yes | partially local, skill body external |
| `parallel-agents` | parallel read/validation orchestration | workflow catalog only | no | yes | external |

## Key Finding

There are three different dependency classes today:

1. **Native local doctrine**: the repo owns the rule, usually in `core/`,
   `agents/`, `adapters/`, `profiles/`, or `onboarding/`.
2. **Governed local skill seed**: the repo owns the actual skill body under
   root `skills/` and mirrors it globally.
3. **External global skill dependency**: the repo references the skill but the
   skill body only exists in `~/.codex/skills/`.

The desired target is class 1 + class 2 only.

## Proposed Recomposition

### Target Shape

The final source of truth should be a root-level `skills/` directory.

`docs/codex-skill-seeds/` should be treated as a transition location created
while the repo was still absorbing global Codex skills. It should not remain the
long-term authoring home for executable runtime skills because that buries
runtime behavior under documentation and keeps the product boundary ambiguous.

```text
accelerate/
  SKILL.md
  core/
  agents/
  adapters/
  profiles/
  onboarding/
  overlays/
  skills/
    _registry/
      manifest.md
      provenance.md
      sync-policy.md
    root/
    workflow/
    review/
    frontend/
    backend/
    security/
    data/
    runtime/
    governance/
    design-system/
    legacy/
    overlays/
```

The repo should become the authoring source for every skill it requires.

Global `~/.codex/skills/` should become a generated runtime mirror, not the
source of truth.

### Skill Provenance Model

Because many skills were pre-existing, downloaded, improved, and then seeded,
each skill should carry provenance rather than being treated as originally
authored here.

Each skill directory should support:

- `SKILL.md`: executable skill body
- `metadata.md` or `metadata.yaml`: category, owner, status, version, source,
  adaptation policy, last parity check
- `references/`: only needed supporting material, not broad context dumps
- `examples/`: small runnable or inspectable examples when useful
- `tests/` or `evals/`: prompt fixtures, regression prompts, or benchmark
  cases when the skill is behavior-sensitive

Recommended provenance statuses:

- `native`: authored for standalone `accelerate`
- `adapted-from-global`: imported from `~/.codex/skills/` and rewritten for
  local doctrine
- `adapted-from-external`: sourced from internet/external material and
  normalized into the Accelerate contract
- `vendor-reference`: retained as a reference only, not mandatory runtime law
- `overlay-only`: project/domain-specific skill that should not enter core

### Transition Rule

During migration, `docs/codex-skill-seeds/skills/` may remain as a temporary
staging location.

The end state should be:

- root `skills/` is the repo-owned authoring source
- `docs/codex-skill-seeds/` becomes historical/migration docs or is removed
- sync scripts mirror `skills/*/SKILL.md` into `~/.codex/skills/`
- no runtime branch points at `docs/` as the canonical skill body location

### Skill Seed Categories

| Category | Should contain | Priority |
| --- | --- | --- |
| `root/` | `accelerate`, `prompt-hardening`, `verification-before-completion` | P0 |
| `workflow/` | issue planning, executing plans, Linear/GitHub adapter skills, progress reporting | P0/P1 |
| `review/` | product runtime, architecture, governance, code review, forensic closure | P0/P1 |
| `frontend/` | React/Inertia/shadcn, boundary governance, Tailwind, TypeScript, i18n, componentization | P0/P1 |
| `backend/` | Django, services, Inertia integration, Python, testing, Celery | P1 |
| `security/` | anti-abuse, security baseline, adversarial review, untrusted ingress | P0/P1 |
| `data/` | SQL/query optimization, database design, PostgreSQL, financial truth, payments | P1/P2 |
| `runtime/` | dogfood, browser proof, Playwright, MCP, bash/Linux, codebase inspection | P1 |
| `design-system/` | extract/apply design system, premium UI, popular-web-design integration wrappers | P0/P1 |
| `legacy/` | legacy-first, legacy transplant, migration adaptation | P1 |
| `governance/` | dependency/API/stack constitution, promotion protocol, external skill vetting | P0/P1 |

## Phase Plan

### Phase 0. Freeze And Inventory

Goal: stop hidden dependency growth before migration.

Actions:

1. Create a machine-readable dependency manifest:
   - `skills/_registry/manifest.md`
   - optional historical bridge:
     `docs/codex-skill-seeds/skill-dependency-manifest.md`
2. For every skill referenced by `core/`, `agents/`, `adapters/`,
   `profiles/`, `references/`, and root docs, classify:
   - `local-native`
   - `local-seed`
   - `global-only`
   - `missing`
   - `role-only / no concrete skill`
3. Add a gate:
   - any new reference to a skill not in the manifest is a docs failure.

Deliverable:

- complete dependency manifest
- `global-only` backlog
- no new unregistered skill names

### Phase 1. P0 Self-Containment

Goal: make the root executable without global-only governance/review skills.

Promote or rewrite as repo-owned seeds:

- `accelerate`
- `prompt-hardening`
- `verification-before-completion`
- `product-runtime-review`
- `systematic-debugging`
- `architecture`
- `governance-audit`
- `anti-abuse-review`
- `security-patterns`
- `front-react-shadcn`
- `frontend-boundary-governance`
- `tailwind-design-system`
- `server-prop-governance`
- `ascii-wireframe`
- `linear-implementation-planner`
- `executing-plans`

Do not blindly copy global skills. For each:

1. inspect global skill body
2. decide `adopt`, `adapt`, `split`, or `replace with native local module`
3. remove Prop4You-only assumptions unless the skill belongs in an overlay
4. add source-of-truth file in root `skills/`
5. sync to `~/.codex/skills/`
6. update dependency manifest

Deliverable:

- root branch matrix can execute common architecture, bug, runtime, security,
  product-critical, and visual/frontend work without global-only skill truth

### Phase 2. Stack Profiles Become Skill Bundles

Goal: make stack-specific execution local and composable.

Create repo-owned skill bundles for:

- `profiles/django-inertia-react`
- `profiles/nextjs-tailwind`

Each profile should declare:

- mandatory skills
- optional skills
- validation commands
- proof lanes
- forbidden drift
- generated target `.accelerate/` profile output

Promote or rewrite:

- Django/Inertia skills
- React/TypeScript/Tailwind skills
- Python/testing skills
- i18n skills
- database/query skills

Deliverable:

- `accelerate` can onboard a Django/Inertia or Next/Tailwind project without
  relying on external global stack skill bodies

### Phase 3. Workflow Adapters Become First-Class Local Skills

Goal: eliminate dependency on global Linear/GitHub workflow skills.

For each workflow adapter:

- `adapters/workflow/linear`
- `adapters/workflow/github`

Create local adapter skills:

- issue bootstrap
- issue planning
- progress reporting
- AI review report
- closure reconciliation
- failure fallback

Important distinction:

- adapter skill explains how to use backend-specific workflow tools
- core doctrine explains when workflow backend is required

Deliverable:

- Linear and GitHub can be selected as peer workflow backends from local
  accelerate truth

### Phase 4. Runtime Adapters Become Local Proof Skills

Goal: make browser/proof/tooling lanes self-contained.

Create or promote local runtime skills for:

- Chrome DevTools browser truth
- Playwright persistence
- agent-browser bounded browser operation
- shell/Bash discipline
- MCP/native MCP/mcporter operation
- codebase inspection
- code audit

Deliverable:

- browser proof and persistent regression lanes can run from local doctrine and
  adapter skills rather than global memory

### Phase 5. Security, Data, Legacy, Provider Domains

Goal: cover high-risk specialized domains locally.

Promote or rewrite:

- `untrusted-ingress-hardening`
- `adversarial-security-review`
- `api-surface-governance`
- `dependency-governance`
- `legacy-first-protocol`
- `legacy-transplant`
- `sql-optimization-patterns`
- `database-design`
- `postgresql`
- `financial-source-truth`
- `payment-integration`
- `stripe-integration`

Deliverable:

- specialized branches no longer fail open when global skills are absent

### Phase 6. Agent Envelope Alignment

Goal: make future `*.toml` agents derive from local skill envelopes only.

Actions:

1. Replace role-only skill phrases in `agents/envelopes/skill-envelopes.md`
   with concrete local skill IDs.
2. For each future agent family, create:
   - required local skill list
   - optional local skill list
   - no-global-dependency assertion
3. Add a promotion gate:
   - no agent can be promoted if its mandatory skill envelope includes
     `global-only`.

Deliverable:

- future agents become reproducible from repo state

### Phase 7. Generated Global Mirror

Goal: make `~/.codex/skills/` a deployment target, not a dependency.

Actions:

1. Add sync script:
   - `scripts/sync-skills-to-global.sh`
2. Add validation script:
   - compare repo seeds to global mirror
   - fail on missing or divergent governed skills
3. Add docs:
   - global mirror is disposable
   - repo seed is source of truth

Deliverable:

- any machine can recreate the global runtime skill catalog from repo state

Current implementation:

- `scripts/validate-skill-registry.sh`
- `scripts/sync-skills-to-global.sh`

### Phase 8. Prune And Reindex

Goal: reduce ambiguity and reading cost after migration.

Actions:

1. Convert remaining duplicated `references/` files into pointers when native
   `core/`, `agents/`, `adapters/`, or seeded skills are authoritative.
2. Move historical benchmark logs into `planning/executive/archive/` or
   equivalent.
3. Keep only current operational decision records in the default reading path.
4. Add and maintain `skills/README.md` and `skills/_registry/manifest.md`.
5. Add a "minimum reading set" for new sessions.

Deliverable:

- local repo is smaller to read
- active authority is unambiguous
- history remains available without polluting execution

## Recommended Priority Order

1. `prompt-hardening`
2. `verification-before-completion`
3. `product-runtime-review`
4. `systematic-debugging`
5. `architecture`
6. `governance-audit`
7. `anti-abuse-review`
8. `security-patterns`
9. `front-react-shadcn`
10. `frontend-boundary-governance`
11. `tailwind-design-system`
12. `server-prop-governance`
13. `linear-implementation-planner`
14. `executing-plans`
15. `django-service-patterns`
16. `django-inertia-integration`
17. `typescript-pro`
18. `i18n-patterns`
19. `sql-optimization-patterns`
20. `legacy-first-protocol`
21. `legacy-transplant`

## Acceptance Criteria For "Autocontained"

Accelerate is autocontained only when:

- every skill named in branch matrix, persona matrix, agent envelopes, and
  workflow docs exists as a repo seed or a native local module
- no required workflow depends on `~/.codex/skills/` as authoring source
- `~/.codex/skills/` can be deleted and rebuilt from repo seeds
- stack profiles resolve to local skills
- workflow adapters resolve to local skills
- runtime proof lanes resolve to local skills/adapters
- future agents resolve to local envelopes and local skills
- `references/` no longer contains co-equal operational copies
- validation can detect a new global-only dependency before merge

## Immediate Next Action

The dependency manifest has now been created:

- `skills/_registry/manifest.md`
- `docs/codex-skill-seeds/skill-dependency-manifest.md` as historical bridge

The first P0 root/review skills have now been promoted and rewritten as
standalone local-authoritative skills:

1. `prompt-hardening`
2. `verification-before-completion`
3. `product-runtime-review`
4. `systematic-debugging`
5. `architecture`
6. `governance-audit`

This gives the root enough local execution capacity to classify, harden, debug,
review, verify, and close without relying on global-only doctrine.

The second P0 wave has now been promoted and rewritten as standalone
local-authoritative skills:

1. `anti-abuse-review`
2. `security-patterns`
3. `front-react-shadcn`
4. `frontend-boundary-governance`
5. `tailwind-design-system`
6. `server-prop-governance`
7. `ascii-wireframe`
8. `linear-implementation-planner`
9. `executing-plans`

The stack/profile and review-support skills have now been promoted and
rewritten as standalone local-authoritative skills:

1. `frontend-componentization-audit`
2. `frontend-component-hierarchy`
3. `typescript-pro`
4. `i18n-patterns`
5. `django-service-patterns`
6. `django-inertia-integration`
7. `python-testing`

Next, continue with backend/runtime/security support:

1. `django-pro`
2. `django-vite-integration`
3. `inertia-patterns`
4. `inertia-shared-props`
5. `python-pro`
6. `celery-tasks`
7. `adversarial-security-review`
8. `untrusted-ingress-hardening`

The backend/runtime/security support wave has now been promoted and rewritten
as standalone local-authoritative skills:

1. `django-pro`
2. `django-vite-integration`
3. `inertia-patterns`
4. `inertia-shared-props`
5. `python-pro`
6. `celery-tasks`
7. `adversarial-security-review`
8. `untrusted-ingress-hardening`

Next, continue with governance, validation, data, and legacy support:

1. `api-surface-governance`
2. `dependency-governance`
3. `validation-governance`
4. `database-design`
5. `database-architect`
6. `postgresql`
7. `postgres-best-practices`
8. `sql-optimization-patterns`
9. `legacy-first-protocol`
10. `legacy-transplant`

The governance, validation, data, and legacy wave has now been promoted and
rewritten as standalone local-authoritative skills:

1. `api-surface-governance`
2. `dependency-governance`
3. `validation-governance`
4. `database-design`
5. `database-architect`
6. `postgresql`
7. `postgres-best-practices`
8. `sql-optimization-patterns`
9. `legacy-first-protocol`
10. `legacy-transplant`

Next, continue with workflow/runtime closure support:

1. `planning-with-files`
2. `requesting-code-review`
3. `linear-pm`
4. `linear-progress-reporter`
5. `linear-workflow-orchestrator`
6. `github-issues`
7. `github-pr-workflow`
8. `github-code-review`
9. `dogfood`
10. `inertia-runtime-persistence-audit`

The workflow/runtime closure support wave has now been promoted and rewritten
as standalone local-authoritative skills:

1. `planning-with-files`
2. `requesting-code-review`
3. `linear-pm`
4. `linear-progress-reporter`
5. `linear-workflow-orchestrator`
6. `github-issues`
7. `github-pr-workflow`
8. `github-code-review`
9. `dogfood`
10. `inertia-runtime-persistence-audit`

Next, continue with remaining runtime/tooling and frontend-support gaps:

1. `github-auth`
2. `github-repo-management`
3. `react-best-practices`
4. `tailwind-patterns`
5. `frontend-chunk-ownership-audit`
6. `figma-node-fidelity`
7. `bash-linux`
8. `native-mcp`
9. `mcporter`
10. `codebase-inspection`

The runtime/tooling and frontend-support wave has now been promoted and
rewritten as standalone local-authoritative skills:

1. `github-auth`
2. `github-repo-management`
3. `react-best-practices`
4. `tailwind-patterns`
5. `frontend-chunk-ownership-audit`
6. `figma-node-fidelity`
7. `bash-linux`
8. `native-mcp`
9. `mcporter`
10. `codebase-inspection`

Next, continue with remaining review/delegation/domain gaps:

1. `code-audit`
2. `component-extraction`
3. `subagent-governance`
4. `parallel-agents`
5. `codex-skill-promotion-protocol`
6. `skill-developer`
7. `writing-skills`
8. `financial-source-truth`
9. `payment-integration`
10. `stripe-integration`

The review/delegation/skill-governance/domain wave has now been promoted and
rewritten as standalone local-authoritative skills:

1. `code-audit`
2. `component-extraction`
3. `subagent-governance`
4. `parallel-agents`
5. `codex-skill-promotion-protocol`
6. `skill-developer`
7. `writing-skills`
8. `financial-source-truth`
9. `payment-integration`
10. `stripe-integration`

The final packaging and unresolved dependency cleanup wave has now landed:

1. `nextjs-app-router-patterns`
2. `using-superpowers` replacement audit
3. `accelerate` root seed packaging decision
4. role-only dependency resolution into concrete profile and adapter bundles

Next, continue with proof and release-hardening gaps:

1. stale transition docs pruning after commit
2. optional CI wiring for the mirror check
