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
| `specification-engineer` | frame / plan | requirements, non-goals, SDD mode, dispositions, traceability | under-specification, contradiction, premature implementation | read-only | candidate specialist sidecar | `specification-lifecycle`, `architecture`, `source-verification` as needed |
| `code-quality-reviewer` | review | code, docs, configuration, workflow seeds, implementation/spec delta | correctness, maintainability, unnecessary complexity, spec drift | read-only | candidate specialist reviewer | `code-audit`, `requesting-code-review`, `solution-minimalism` as needed |
| `test-engineer` | plan / prove | test design, fixtures, regression proof, negative paths | false confidence, wrong test layer, self-acceptance | read-only; test-only in a separate executor assignment | candidate specialist reviewer | `test-engineering`, `test-driven-development`, active test stack |
| `web-performance-auditor` | review / prove | static source, bundles, network, field/lab/trace evidence | invented metrics, source confusion, unmeasured runtime risk | read-only | candidate specialist reviewer | `web-performance-review`, `product-runtime-review` when live truth is active |
| `data-database-specialist` | plan / execute | schemas, migrations, queries, constraints, database runtime | integrity drift, destructive migration, query and tenancy risk | bounded workspace-write | delegate-possible worker | selected data profile, `database-design`, `postgresql`, `sql-optimization-patterns` as needed |
| `integrations-ops-specialist` | plan / execute | MCP adapters, queues, mail, storage, payment handoffs, retries | provider-boundary drift, replay, idempotency, secret and delivery risk | bounded workspace-write; no provider write by default | delegate-possible worker | selected integrations profile, `native-mcp`, queue/provider skill, `payment-integration` as needed |

## Role Family Compatibility Map

The older capability families above are concrete candidate families. The newer
orchestrator routing layer uses normalized role families in assignment packets.
Adapters must preserve both truths:

- `role family` is the portable routing category
- `capability family` is the concrete promoted or candidate agent family

Use this map when binding a normalized role family to a physical agent:

| Normalized role family | Compatible capability families |
| --- | --- |
| `architecture` | `django-inertia-technical-planner`, `django-inertia-contract-integrator`, `specification-engineer`, `legacy-truth-analyst` when legacy architecture truth is active |
| `research` | Codex collaboration `explorer` or `librarian`; `legacy-truth-analyst` only when bounded legacy truth extraction dominates; otherwise keep the physical family as an explicit gap |
| `backend` | `django-domain-implementer`, `django-inertia-contract-integrator` |
| `frontend` | `inertia-react-ui-implementer`, `django-inertia-contract-integrator` when prop/page contracts dominate |
| `data` | `data-database-specialist`, `django-domain-implementer` only when data behavior remains inseparable from bounded domain work |
| `integrations-ops` | `integrations-ops-specialist`; use `trust-anti-abuse-reviewer` as a separate review lane when hostile provider input is active |
| `qa-regression` | `runtime-proof-auditor`, `test-engineer` |
| `security` | `trust-anti-abuse-reviewer` |
| `governance` | `lifecycle-product-manager`, `code-quality-reviewer`, `django-inertia-technical-planner` when planning/governance is bounded |
| `provider-boundary` | `legacy-truth-analyst` only when provider/legacy truth extraction is the bounded slice; otherwise treat as a gap |
| `product-runtime` | `runtime-proof-auditor`, `web-performance-auditor`, `lifecycle-product-manager` for read-only product acceptance framing |

If a role family maps to more than one capability family, choose by dominant
risk and write scope. Do not select a concrete capability family that cannot
honor the base agent contract.

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
- `data-database-specialist`
- `integrations-ops-specialist`

### Specialist sidecar

Use only when the slice truly needs the specialty:

- `legacy-truth-analyst`

### Candidate specialist

Template-backed, read-only families that may be selected only through their
normalized role binding while empirical replay and promotion evidence remain
incomplete:

- `specification-engineer` as a specialist sidecar
- `code-quality-reviewer` as a specialist reviewer
- `test-engineer` as a specialist reviewer; test mutation requires a separate
  bounded executor assignment
- `web-performance-auditor` as a specialist reviewer

Candidate status is not physical promotion or isolation. Move one of these
families to `Delegate-possible` only after the promotion contract records
successful empirical replay, effective runtime capability visibility, and the
same root-owned closure boundary declared by its template.

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
