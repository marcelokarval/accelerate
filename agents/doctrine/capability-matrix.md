# Agent Capability Matrix

Use this matrix when the root must decide:

- whether delegation is justified at all
- whether the current pool has an honest family fit
- whether a second family is needed for proof or audit
- whether the pool has a real gap

This matrix describes bounded families only. Root-owned lane governance remains
outside this table.

## Matrix

| Family | Phase | Dominant surfaces | Risk focus | Write scope | Ownership class | Mandatory skills |
| --- | --- | --- | --- | --- | --- | --- |
| `lifecycle-product-manager` | frame / plan | issue shape, acceptance, parent/child structure | scope drift, execution unreadiness | read-only | root-preferred sidecar | `planning-with-files`, selected workflow adapter skills, `prompt-hardening` when needed |
| `django-inertia-technical-planner` | plan | Django/Inertia boundaries, execution order, decomposition | architecture drift, contract drift | read-only | delegate-possible sidecar | `architecture`, `governance-audit`, `api-surface-governance`, `validation-governance` as needed |
| `django-domain-implementer` | execute | models, services, tasks, admin, backend queries | backend contract drift, migration/runtime drift | workspace-write | delegate-possible worker | `django-pro`, `django-service-patterns`, `python-pro`, `validation-governance`, `security-patterns` as needed |
| `inertia-react-ui-implementer` | execute | Inertia pages, React features, route-level UX, i18n-aware UI | frontend structure drift, shell churn symptoms | workspace-write | delegate-possible worker | `front-react-shadcn`, `inertia-patterns`, `typescript-pro`, `frontend-boundary-governance`, `tailwind-patterns` |
| `django-inertia-contract-integrator` | plan / execute | prop contracts, route truth, shared props, identifier semantics | contract correctness, boundary drift | read-only or workspace-write depending on slice | delegate-possible integrator | Django-Inertia integration, prop governance, validation governance |
| `runtime-proof-auditor` | prove | browser runtime, staged flows, redirect truth, shell persistence | runtime/product drift | read-only by default | delegate-possible reviewer | runtime review and dogfood skills |
| `trust-anti-abuse-reviewer` | review / prove | auth, session, billing, export, deletion, upload, ownership-sensitive flows | misuse, replay, enumeration, privilege drift | read-only by default | delegate-possible reviewer | anti-abuse and security review skills |
| `legacy-truth-analyst` | frame / plan | donor-system or legacy truth extraction | adaptation drift, false rewrites | read-only | specialist sidecar | `legacy-first-protocol`, `legacy-transplant` |

## Ownership Classes

### Root-owned

These are not stable bounded families by default:

- master integrator
- closure / forensic reviewer
- delivery or routing owner

### Root-preferred sidecar

Useful, but still closer to root orchestration than to autonomous execution:

- `lifecycle-product-manager`

### Delegate-possible

Valid bounded families for clean slices:

- `django-inertia-technical-planner`
- `django-domain-implementer`
- `inertia-react-ui-implementer`
- `django-inertia-contract-integrator`
- `runtime-proof-auditor`
- `trust-anti-abuse-reviewer`

### Specialist sidecar

Use only when the slice truly needs the specialty:

- `legacy-truth-analyst`

## Fit Rules

Use one family when:

- one dominant surface exists
- ownership is clean
- the proof lane can remain local

Compose two families when:

- one family mutates and another proves or audits
- the contract boundary is the real problem
- the slice needs framing plus bounded execution

Repeated need for awkward three-family composition is a gap signal.
