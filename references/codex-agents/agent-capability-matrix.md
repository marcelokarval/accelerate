# Agent Capability Matrix

Use this matrix when `accelerate` must decide:

- whether the current pool has a clean fit for the task
- whether one family is enough or composition is required
- whether the current pool has a real capability gap

This matrix describes bounded families only.

Manager lanes and root-owned authority are defined separately in:

- `control-plane-org-map.md`
- `manager-lane-map.md`
- `lane-governance-model.md`

The matrix is intentionally operational.

It should answer:

- what phase the family belongs to
- what surfaces it can own
- what risks it can judge
- what write scope it may hold
- which skills are mandatory when activated

## Matrix

| Family | Phase | Dominant surfaces | Risk focus | Write scope | Ownership class | Mandatory skills |
| --- | --- | --- | --- | --- | --- | --- |
| `lifecycle-product-manager` | frame / plan | Linear issue shape, acceptance, parent/child structure, roadmap split, Inertia-first delivery framing | scope drift, execution unreadiness, lifecycle hygiene, stack-insensitive issue shaping | read-only | master-preferred sidecar | `linear-pm`, `linear-implementation-planner`, `prompt-hardening` when needed |
| `django-inertia-technical-planner` | plan | Django/Inertia boundaries, execution order, contract-sensitive decomposition | architecture drift, contract drift, bad slice shape | read-only | delegate-possible sidecar | `architecture`, `p4y-stack-constitution`, `governance-audit`, `planning-with-files` when active |
| `django-domain-implementer` | execute | models, services, tasks, admin, queries, presenters, migrations-aware backend work | backend contract drift, query-shape drift, migration/runtime drift | workspace-write | delegate-possible worker | `django-pro`, `django-service-patterns`, `python-pro`, `python-testing`, `system-adr` |
| `inertia-react-ui-implementer` | execute | Inertia pages, React features, shell-adjacent UI, i18n-aware surfaces, route-level UX | frontend structure drift, shell churn symptoms, copy/i18n drift | workspace-write | delegate-possible worker | `front-react-shadcn`, `inertia-patterns`, `frontend-boundary-governance`, `typescript-pro`, `i18n-patterns` |
| `django-inertia-contract-integrator` | plan / execute | prop contracts, route links, identifier semantics, shared props, page contract truth | contract correctness, backend/frontend boundary drift | workspace-write when mutation is required, otherwise read-only | delegate-possible integrator-sidecar | `django-inertia-integration`, `server-prop-governance`, `api-surface-governance`, `validation-governance` |
| `runtime-proof-auditor` | prove | Django/Inertia browser runtime, staged flows, redirect truth, page refresh scope, shell churn, shared-prop instability, product correctness | runtime/product drift, route-family anomalies, shell persistence symptoms, server-driven runtime drift | read-only by default | delegate-possible reviewer | `dogfood`, `product-runtime-review`, `inertia-runtime-persistence-audit` when churn is suspected |
| `trust-anti-abuse-reviewer` | review / prove | auth, session, OTP, billing, export, deletion, upload, ownership-sensitive list/search | misuse, replay, enumeration, race, privilege drift | read-only by default | delegate-possible reviewer | `anti-abuse-review`, `security-patterns`, `adversarial-security-review` when severity justifies it |
| `legacy-truth-analyst` | frame / plan | legacy modules, business-rule extraction, new-system adaptation packets | legacy truth loss, false rewrites, adaptation drift | read-only | specialist sidecar | `legacy-first-protocol`, `legacy-transplant` |

## Ownership Classes

### Master-owned

Not represented as stable global agents in the initial pool:

- `Master Integrator`
- `Closure / Forensic Reviewer`
- `Delivery PM`

These functions remain with `accelerate` unless a future governance decision
changes the rule explicitly.

They also include:

- proof-lane governance
- trust-lane governance

### Master-preferred

These may appear as sidecars, but the root should still assume they are closer
to the orchestrator than to autonomous workers:

- `lifecycle-product-manager`

### Delegate-possible

These are valid global-agent candidates because they own bounded slices:

- `django-inertia-technical-planner`
- `django-domain-implementer`
- `inertia-react-ui-implementer`
- `django-inertia-contract-integrator`
- `runtime-proof-auditor`
- `trust-anti-abuse-reviewer`

### Specialist-only

These should stay optional and on-demand:

- `legacy-truth-analyst`

## Fit Rules

### Use one family when:

- the task has one dominant surface
- the ownership boundary is clean
- the proof lane is obvious

### Compose two families when:

- one family mutates and a second family proves or audits
- the backend/frontend contract is the real problem
- lifecycle framing and implementation are both needed but still bounded

Common compositions:

- `django-domain-implementer` + `runtime-proof-auditor`
- `inertia-react-ui-implementer` + `runtime-proof-auditor`
- `django-domain-implementer` + `trust-anti-abuse-reviewer`
- `django-inertia-technical-planner` + `django-inertia-contract-integrator`

### Do not force a fit when:

- the task is really master-owned
- the work needs global judgment more than bounded execution
- two or more families only partially fit and the root would still need to
  carry the real specialty manually

That is a gap signal, not a reason to pick the least-wrong role.

If the dominant need is lane opening, topology repair, or blocker judgment,
keep the decision at the root instead of forcing a family fit.

## Gap Signals

Treat the current pool as insufficient when:

- repeated tasks keep needing awkward three-family composition
- `accelerate` repeatedly compensates for the same missing specialty
- a branch in `workflow-catalog.md` has no honest family coverage
- the dominant stack surface is stable and recurring, but no family can own it
  without drift

Examples of likely future gaps:

- async workflow stewardship for Celery/Redis-heavy orchestration
- provider-boundary audit for recurring external-service truth problems
- migration stewardship for rollout-sensitive schema/data change programs

## Empirical Fit Notes

### `lifecycle-product-manager`

Replay confirms this family is valid, but root-preferred rather than fully
autonomous.

The family fits execution-ready issue shape, acceptance hygiene, and
parent/child structuring. It does not replace root-owned framing authority.

### `django-inertia-contract-integrator`

Replay confirms this family is strongest when mapped to:

- `Data / Contract Steward`
- `Governance Auditor`

Do not treat it as a generic "full-stack fixer." Its center of gravity is
contract truth.

### `runtime-proof-auditor`

Replay confirms this family is strongest when mapped to:

- `Runtime/Product Reviewer`
- `Browser-Proof Auditor`

Do not weaken it into generic browser QA language.

### `trust-anti-abuse-reviewer`

Replay confirms this family often remains read-only, but must be allowed to
carry product/runtime judgment when the trust surface is self-service and
user-facing.
