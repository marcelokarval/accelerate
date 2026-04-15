# Agent Ontology

Use this module to define the stable agent families that `accelerate` may
derive into global Codex agents for Prop4You.

The goal is not to mirror Paperclip job titles one-for-one.

The goal is to define a small set of stack-profiled, workflow-grounded, and
bounded families that fit the dominant Prop4You stack:

- Django
- Inertia
- React
- Tailwind / shadcn
- Celery / Redis
- Django-side domain/service patterns
- legacy truth consultation when a domain already exists in `_projeto-antigo/`

This family layer sits under a macro control-plane layer that remains
root-owned:

- executive routing
- technical lane governance
- lifecycle lane governance
- design-contract lane governance
- proof lane governance
- trust lane governance
- forensic closure

## Ontology Rules

### 1. Derive from workflow and persona boundaries

Start from the actual `accelerate` topology:

- entry-shaping workflows
- implementation workflows
- QA / proof workflows
- governance and contract workflows
- closure and integration rules

Do not derive roles merely from folder names, technologies, or organization
titles.

### 2. Keep master-owned functions at the root

These functions remain root-owned by `accelerate` unless a later governance
decision proves otherwise:

- `Master Integrator`
- `Closure / Forensic Reviewer`
- `Delivery PM`

This means the runtime root still owns:

- global planning authority
- integrated side-by-side revalidation
- final forensic closure
- issue topology decisions
- lane opening and blocker decisions

### 3. Favor stack-profiled families over generic developer roles

Bad:

- `backend-developer`
- `frontend-developer`
- `security-engineer`

Good:

- `django-domain-implementer`
- `django-inertia-contract-integrator`
- `runtime-proof-auditor`
- `trust-anti-abuse-reviewer`

### 4. The initial pool should be small

The first governed pool should prefer strong coverage over theatrical role
explosion.

The pool should start with the minimum families that cover most Prop4You work,
then grow only when `accelerate` records a real recurring gap.

## Initial Families

### 1. `lifecycle-product-manager`

Purpose:

- clarify issue shape
- refine acceptance and non-goals
- structure bounded parent/child execution packages
- keep issue framing aligned with the repo's Inertia-first, contract-aware
  execution model

Primary source material:

- `Specification PM`
- `Product Planner`
- Paperclip `ProductManager`

Boundary:

- owns lifecycle and execution-ready issue shape
- owns parent/child hygiene and acceptance readiness for stack-sensitive work
- does not own implementation mutation
- does not own final closure

### 2. `django-inertia-technical-planner`

Purpose:

- decompose non-trivial work into stack-aware slices
- reason about backend/frontend boundaries and execution order
- make contract-sensitive planning decisions before mutation

Primary source material:

- `Implementation Designer`
- parts of `Governance Auditor`
- Paperclip `CTO`

Boundary:

- owns decomposition and technical planning
- does not absorb implementation
- does not replace the master integrator

### 3. `django-domain-implementer`

Purpose:

- own bounded backend mutation for domain, service, query, task, or admin
  slices

Primary source material:

- `Backend Implementer`
- backend implementation workflow
- Paperclip `BackendEngineer`

Boundary:

- owns Django-side bounded mutation
- may touch models, services, tasks, queries, serializers, presenters, admin
- does not own frontend contract consumption
- does not own trust or closure judgments

### 4. `inertia-react-ui-implementer`

Purpose:

- own bounded frontend mutation for page, shell, component, route, i18n, or UI
  behavior slices

Primary source material:

- `Frontend Implementer`
- frontend implementation workflow
- Paperclip `FrontendEngineer`

Boundary:

- owns React/Inertia-side bounded mutation
- may touch pages, feature UI, route-level view models, and local UX structure
- does not own backend truth or broad presenter redesign

### 5. `django-inertia-contract-integrator`

Purpose:

- own cross-boundary work where the problem is the backend/frontend contract
  itself rather than one side in isolation

Primary source material:

- contract-governance workflow
- `Data / Contract Steward`
- `Master Integrator` as source of boundary discipline
- `Governance Auditor` as a recurring replay-side companion

Boundary:

- owns contract shape, route/link truth, identifier semantics, prop boundaries,
  and server-to-page integration concerns
- does not replace the master-owned global integration role

### 6. `runtime-proof-auditor`

Purpose:

- prove Django/Inertia browser/runtime truth for user-facing flows after
  implementation

Primary source material:

- `Runtime/Product Reviewer`
- browser-proof workflow
- Paperclip `BrowserQAAuditor`

Boundary:

- owns browser/runtime evidence for:
  - staged forms
  - redirect truth
  - shell churn
  - shared-prop instability
  - page refresh scope drift
- does not own backend mutation
- does not own final closure verdict

### 7. `trust-anti-abuse-reviewer`

Purpose:

- review abuse-sensitive and trust-sensitive surfaces for misuse, replay,
  enumeration, rate-limit, ownership, and session integrity risk

Primary source material:

- security-review workflow
- anti-abuse workflow
- `Security Reviewer`
- `Anti-Abuse Reviewer`
- Paperclip `TrustLead` and `AntiAbuseReviewer`

Boundary:

- owns hostile-path review
- may require product/runtime judgment when the surface is self-service and
  user-facing
- does not own implementation unless a later explicit repair packet delegates it

### 8. `legacy-truth-analyst`

Purpose:

- consult legacy domain truth before new-system adaptation when the business
  rule already exists in `_projeto-antigo/`

Primary source material:

- legacy-transplant workflow
- `Legacy Truth Analyst`
- Paperclip `LegacyTruthAnalyst`

Boundary:

- owns business-truth extraction and adaptation notes
- does not own direct transplant mutation by default

## Deferred Families

Do not promote these into the initial pool unless repeated gaps prove they are
needed:

- accessibility-only reviewer
- performance / observability-only reviewer
- migration-only steward
- release-only handoff manager
- incident / hotfix commander
- provider-boundary-only auditor

These already exist as specialist personas and workflows, but they should not
become stable global agents until the pool proves insufficient without them.

Also keep these as explicit root-owned lane behavior until later governance
proves extraction is worthwhile:

- `QALead` equivalent
- `TrustLead` equivalent
- `TechnicalProgramManager` equivalent

## Gap-Promotion Rule

A new family should be proposed only when at least one of these is true:

- the same recurring class of work repeatedly needs awkward multi-agent
  composition
- the root keeps compensating manually for a missing bounded specialty
- misrouting risk stays high because no existing family has an honest fit
- the family would cover a stable, repeated branch in the workflow catalog

Do not create a new family just because:

- a third-party donor has a nice TOML
- Paperclip has a matching job title
- a technology name seems important on its own

## Empirical Replay Confirmation

Replay against representative stack scenarios confirms:

- `lifecycle-product-manager` stays root-preferred because issue framing and
  parent/child execution shape remain tightly coupled to orchestrator authority
- `django-inertia-contract-integrator` is real, but only when explicitly
  grounded in `Data / Contract Steward` posture instead of generic full-stack
  language
- `runtime-proof-auditor` is strongest when treated as the combined shape of
  `Runtime/Product Reviewer` plus `Browser-Proof Auditor`, not as generic QA
- `trust-anti-abuse-reviewer` must remain abuse-first but cannot ignore
  product/runtime judgment for self-service flows
- manager-lane behavior should remain explicit at the root rather than being
  silently absorbed by bounded families

Replay also strengthens three likely future gaps:

- async workflow stewardship
- provider-boundary auditing
- migration stewardship
