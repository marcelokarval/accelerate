# Agent Skill Envelopes

Use this module when `accelerate` must decide which skills a governed family
should carry.

The purpose is not to preload the whole repo brain into every role.

The purpose is to bind the minimum stable skill envelope that keeps the family
honest for its bounded ownership.

## Root Capability Envelope

The `accelerate` root owns the capability that designs and governs Codex
agents for this ecosystem.

Treat this capability as:

- `codex-agent-architect`

This is a semantic role within `accelerate`, not a separate root control plane.

Its donor stack is:

- `role-creator`
- `find-skills`
- `skill-creator`
- `writing-skills`
- `subagent-driven-development`

Use this capability when the root must:

- design a new governed family
- validate whether the pool has a real gap
- derive a skill envelope for a new family
- shape TOML seeds for future promotion into `~/.codex/agents/*.toml`

## Envelope Rules

### 1. Mandatory means runtime-visible

If a family is active and blocking for the slice, its mandatory skills should
be visible in the runtime packet unless an explicit exception is recorded.

### 2. Skills are attached to ownership, not to title aesthetics

Bind skills because of the bounded job the family is doing now, not because the
family name sounds broad or impressive.

### 3. Keep envelopes minimal

The correct question is:

- what minimum skills keep this family honest?

Not:

- what full body of knowledge could possibly be useful?

## Family Envelopes

### `lifecycle-product-manager`

Mandatory:

- `linear-pm`
- `linear-implementation-planner`

Conditional:

- `prompt-hardening`
  - when issue shape, acceptance, or task framing is still weak

Do not attach by default:

- implementation stack skills
- proof/review skills
- trust/security review skills

### `django-inertia-technical-planner`

Mandatory:

- `architecture`
- `p4y-stack-constitution`
- `governance-audit`

Conditional:

- `planning-with-files`
  - when a written plan artifact is required
- `ascii-wireframe`
  - when structural UI uncertainty blocks clean planning

Do not attach by default:

- direct mutation skills
- final closure skills

### `django-domain-implementer`

Mandatory:

- `django-pro`
- `django-service-patterns`
- `python-pro`
- `system-adr`

Conditional:

- `python-testing`
  - when backend verification or test mutation belongs to the slice
- `security-patterns`
  - when the backend surface is trust-sensitive
- `celery-tasks`
  - when the bounded slice owns queue/task behavior
- `database-design`, `postgresql`, or `sql-optimization-patterns`
  - when schema/query shape is central, not incidental

Do not attach by default:

- frontend structure skills
- browser-proof skills
- lifecycle skills

### `inertia-react-ui-implementer`

Mandatory:

- `front-react-shadcn`
- `inertia-patterns`
- `frontend-boundary-governance`
- `typescript-pro`

Conditional:

- `i18n-patterns`
  - when the slice touches user-facing copy or locale-sensitive behavior
- `frontend-component-hierarchy`
  - when composition and placement decisions are central
- `tailwind-patterns`
  - when utility composition or design-token hygiene is central

Do not attach by default:

- backend contract-shaping skills
- trust review skills
- final proof skills

### `django-inertia-contract-integrator`

Mandatory:

- `django-inertia-integration`
- `server-prop-governance`
- `validation-governance`

Conditional:

- `api-surface-governance`
  - when the boundary question involves transport choice or future external
    surfaces
- `inertia-shared-props`
  - when the issue is shared-prop truth or shell-vs-page data placement

Do not attach by default:

- broad implementation mutation stacks from both sides
- final closure skills

### `runtime-proof-auditor`

Mandatory:

- `dogfood`
- `product-runtime-review`

Conditional:

- `inertia-runtime-persistence-audit`
  - when shell churn, header flicker, or persistent-layout doubt is present
- `server-prop-governance`
  - when runtime anomalies may be driven by prop scope or shared-prop hygiene
- active frontend/backend stack skills as needed
  - when browser truth depends on a stack-specific contract interpretation

Do not attach by default:

- mutation skills
- lifecycle planning skills

### `trust-anti-abuse-reviewer`

Mandatory:

- `anti-abuse-review`
- `security-patterns`

Conditional:

- `product-runtime-review`
  - when the trust-sensitive surface is self-service and user-facing
- `adversarial-security-review`
  - when the severity or exploitability posture justifies a deeper hostile-path
    pass
- `untrusted-ingress-hardening`
  - when uploads/imports/images/parser boundaries are central
- `payment-integration` or `stripe-integration`
  - when billing/provider state is part of the trust surface

Do not attach by default:

- generic implementation skills
- browser-proof skills unless the review packet explicitly requires runtime
  confirmation

### `legacy-truth-analyst`

Mandatory:

- `legacy-first-protocol`
- `legacy-transplant`

Conditional:

- `architecture`
  - when the adaptation packet needs explicit modern placement rationale

Do not attach by default:

- direct implementation skills
- closure or browser-proof skills

## Envelope Change Rule

Do not widen a family envelope casually.

If the envelope keeps growing because the family repeatedly needs unrelated
skills, that is usually evidence of:

- a boundary problem
- a composition problem
- or a real pool gap

Treat growing envelopes as a governance smell first, not as a reason to add
more skills automatically.
