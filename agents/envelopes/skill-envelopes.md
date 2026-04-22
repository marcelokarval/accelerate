# Agent Skill Envelopes

Use this module when the root must decide which skills a governed family should
carry.

The purpose is to bind the minimum stable envelope that keeps a family honest
for its bounded ownership.

## Root Capability Envelope

The root already owns the capability that designs and governs future bounded
agents for this platform.

Treat that capability as:

- `codex-agent-architect`

This is a semantic role inside `accelerate`, not a separate root control plane.

Use it when the root must:

- design a new family
- validate whether a gap is real
- derive a skill envelope
- shape future promotion artifacts

## Envelope Rules

### 1. Mandatory means runtime-visible

If a family is active and blocking for the slice, its mandatory skills should
be visible in the runtime packet unless an explicit exception is recorded.

### 2. Skills follow ownership

Bind skills because of the bounded job the family is doing now, not because
the family title sounds broad.

### 3. Keep envelopes minimal

The correct question is:

- what minimum skills keep this family honest?

## Current Family Envelopes

### `lifecycle-product-manager`

Mandatory:

- `planning-with-files`
- selected workflow adapter skills such as `linear-implementation-planner`,
  `linear-pm`, `linear-workflow-orchestrator`, `github-issues`, or
  `github-pr-workflow`

Conditional:

- prompt hardening

### `django-inertia-technical-planner`

Mandatory:

- architecture
- `governance-audit`
- branch-specific governance skills such as `api-surface-governance`,
  `dependency-governance`, or `validation-governance`

Conditional:

- file-based planning
- wireframe discipline when structural UI uncertainty exists

### `django-domain-implementer`

Mandatory:

- `django-pro`
- `django-service-patterns`
- `python-pro`
- system-boundary skills such as `validation-governance` and
  `security-patterns`

Conditional:

- testing
- security
- queue/task skills
- database/query skills

### `inertia-react-ui-implementer`

Mandatory:

- `front-react-shadcn` or `nextjs-app-router-patterns` when the active profile
  is Next.js
- `inertia-patterns` when the active profile is Inertia
- `frontend-boundary-governance`
- `typescript-pro`

Conditional:

- i18n
- component hierarchy
- Tailwind guidance

### `django-inertia-contract-integrator`

Mandatory:

- Django-Inertia integration
- prop governance
- validation governance

Conditional:

- API-surface governance
- shared-props guidance

### `runtime-proof-auditor`

Mandatory:

- dogfood
- product runtime review

Conditional:

- persistence audit
- prop governance
- active stack skills when runtime proof depends on them

### `trust-anti-abuse-reviewer`

Mandatory:

- anti-abuse review
- security baseline

Conditional:

- product runtime review
- adversarial review
- ingress hardening
- billing/provider skills

### `legacy-truth-analyst`

Mandatory:

- `legacy-first-protocol`
- `legacy-transplant`
