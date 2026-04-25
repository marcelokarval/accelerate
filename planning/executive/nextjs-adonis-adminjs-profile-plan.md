# Next.js AdonisJS AdminJS Profile Plan

## Goal

Create a governed Accelerate profile for projects that intentionally avoid
Django and use:

- Next.js fullstack/frontend shell
- AdonisJS as backend truth and service/runtime base
- AdminJS as the administrative/operator dashboard
- React + TypeScript + shadcn/Radix + Tailwind for product UI componentization

The outcome should preserve extremely tight componentization enforcement while
moving backend/admin authority out of the Django/Inertia assumptions.

## Current Gap

Accelerate currently has local profiles for:

- `profiles/django-inertia-react/`
- `profiles/nextjs-tailwind/`

It does not yet have repo-local authority for:

- AdonisJS architecture and runtime proof
- AdminJS admin/operator surface governance
- Next.js as frontend/app shell paired with an external Adonis backend
- transport contract between Next.js and AdonisJS
- admin dashboard componentization/isolation rules outside Django Unfold

## Non-Negotiables

- Do not use user-home skills or external docs as governed authority.
- Use external/online sources only as research inputs.
- Import, adapt, register, and enforce any needed behavior inside this repo
  before treating it as Accelerate doctrine.
- Keep core capability-oriented; concrete commands belong in adapters or
  profiles.
- Do not let Next.js server code become a second backend truth layer unless a
  bounded exception is explicitly designed.

## Research/Search Stack

Before implementation, run a documented research pass.

### R1 - Local Doctrine Search

Search repo-local authority first:

- `README.md`
- `SKILL.md`
- `core/`
- `adapters/`
- `profiles/`
- `skills/`
- `planning/`

Questions:

- Which existing frontend componentization gates already apply?
- Which runtime proof adapters already apply to Node?
- Which branch-matrix rows must change for non-Django admin surfaces?
- Which existing skills can be reused without new stack-specific doctrine?

### R2 - Existing Skill Search

Search local skill registry and skill bodies for reusable or missing coverage:

- `nextjs-app-router-patterns`
- `front-react-shadcn`
- `tailwind-design-system`
- `frontend-component-hierarchy`
- `frontend-componentization-audit`
- `component-extraction`
- `typescript-pro`
- `api-surface-governance`
- `validation-governance`
- `security-patterns`
- `anti-abuse-review`

Expected result:

- reuse frontend/componentization skills
- create new backend/admin skills only where AdonisJS/AdminJS behavior is not
  already covered

### R3 - Local Adonis Research Corpus Search

Use the existing local research corpus as a primary research input before online
lookup:

- `/home/marcelo-karval/Backup/Projetos/adonisjs-likely-django/`

Important known surfaces include:

- `README.md`
- `AGENTS.md`
- `docs/README.md`
- `docs/architecture/adonisjs-as-django-target.md`
- `docs/architecture/django-to-adonisjs-equivalence-matrix.md`
- `docs/architecture/django-like-magic-gap-analysis.md`
- `docs/architecture/likely-django-admin-layer.md`
- `docs/architecture/likely-django-admin-metadata-resource-derivation.md`
- `docs/architecture/likely-django-packaging-strategy.md`
- `docs/adr/001-target-stack-decision.md`
- `docs/adr/002-build-on-top-vs-fork-strategy.md`
- `docs/adr/003-admin-strategy.md`
- `docs/adr/004-queue-and-job-strategy.md`
- `docs/adr/005-authorization-strategy.md`
- `docs/adr/006-rate-limiting-and-anti-abuse-strategy.md`
- `docs/adr/007-cache-strategy.md`
- `docs/adr/008-locking-strategy.md`
- `docs/adr/009-social-auth-strategy.md`
- `docs/adr/010-file-storage-and-uploads-strategy.md`
- `docs/research/adonisjs-official-package-scan.md`
- `docs/research/adminjs-adonis-integration-analysis.md`
- `docs/research/adonisjs-extensibility-and-package-model.md`
- `docs/research/adonisjs-org-repository-curation.md`
- `docs/plans/django-to-adonisjs-executive-plan.md`

This corpus is research input, not Accelerate authority. Any accepted behavior
must be imported, adapted, registered, and enforced inside this repository before
it governs future projects.

Research packet must classify each useful finding as:

- `import-as-profile-rule`
- `import-as-skill-rule`
- `import-as-runtime-adapter-rule`
- `import-as-risk-fixture`
- `reject-or-defer`

### R4 - Online Technical Source Search

Use current official or primary technical sources before writing local doctrine.

Required source classes:

- AdonisJS official docs for routing, controllers, services, validation, auth,
  Lucid ORM, migrations, testing, config, and security posture
- AdminJS official docs for resources, adapters, actions, authentication,
  authorization, components, branding, and production deployment
- Next.js official docs for App Router, server actions/route handlers, caching,
  middleware, auth/session boundaries, and client/server component rules
- shadcn/Radix/Tailwind docs already covered by local skills, consulted only when
  the local skill needs a repo-local update

Research packet must record:

- source URL
- access date
- topic covered
- behavior to import/adapt
- behavior rejected or intentionally not adopted
- local file that will own the adapted behavior

### R5 - Dependency Governance Review

Before adding AdminJS/AdonisJS as governed stack, run dependency governance:

- why AdonisJS is the backend truth layer instead of Next.js backend-only
- why AdminJS is acceptable for operator/admin surfaces
- which adapters/plugins are required for database/auth/resources
- which risks require custom wrapper doctrine

## Task Sequence

### T1 - Research Packet

Create:

- `planning/executive/nextjs-adonis-adminjs-research-packet.md`

Done when:

- local doctrine search is summarized
- local Adonis research corpus findings are triaged
- official online sources are cited
- imported/rejected behaviors are mapped to future local owners

### T2 - Profile Skeleton

Create:

- `profiles/nextjs-adonis-adminjs/README.md`
- `profiles/nextjs-adonis-adminjs/validation-bundle.md`

Done when:

- frontend, backend, transport, admin, runtime proof, accessibility,
  observability, and closure lanes are explicit
- concrete commands are profile-owned and marked adaptable to project scripts

### T3 - AdonisJS Skill

Create and register:

- `skills/backend/adonisjs-patterns/SKILL.md`
- `skills/backend/adonisjs-patterns/metadata.yaml`
- registry entry in `skills/_registry/manifest.md`

Done when:

- Adonis owns backend truth, validation authority, service boundaries, Lucid
  migrations/schema proof, auth/session posture, and tests

### T4 - AdminJS Skill

Create and register:

- `skills/backend/adminjs-patterns/SKILL.md`
- `skills/backend/adminjs-patterns/metadata.yaml`
- registry entry in `skills/_registry/manifest.md`

Done when:

- admin/operator surfaces cover readonly vs mutation, resource/actions,
  authorization, audit, PII masking, destructive actions, and dashboard proof

### T5 - Node Runtime Adapter Expansion

Update:

- `adapters/runtime/node/README.md`

Done when:

- Node backend runtime proof covers server boot/check, migrations, DB connection,
  route/controller/service tests, auth/session, and background jobs when present

### T6 - Branch Matrix And Gate Ownership

Update:

- `core/control-plane/branch-enforcement-matrix.md`
- `core/control-plane/gate-ownership-index.md` if new gates are introduced

Done when:

- admin/operator row no longer assumes Django Unfold as the only admin path
- AdminJS uses generic admin/operator rules plus AdminJS-specific skill routing

### T7 - Doctrine Integrity And Validation

Run and update as needed:

- `tests/doctrine-integrity.sh`
- `bash scripts/validate-skill-registry.sh`
- profile validation bundle checks

Done when:

- new skills are registered
- new profile has validation bundle
- branch-matrix gate ownership remains complete

## Initial Mandatory Skill Stack

Frontend/componentization:

- `nextjs-app-router-patterns`
- `front-react-shadcn`
- `react-best-practices`
- `typescript-pro`
- `tailwind-patterns`
- `tailwind-design-system`
- `frontend-boundary-governance`
- `frontend-component-hierarchy`
- `frontend-componentization-audit`
- `component-extraction`
- `server-prop-governance`

Backend/admin:

- `adonisjs-patterns` once created
- `adminjs-patterns` once created
- `api-surface-governance`
- `validation-governance`
- `security-patterns`
- `anti-abuse-review`
- `product-runtime-review` for user-facing and operator-facing runtime flows

Data/payment when applicable:

- `database-design`
- `postgresql`
- `postgres-best-practices`
- `sql-optimization-patterns`
- `financial-source-truth`, `payment-integration`, `stripe-integration` when
  money/provider behavior is in scope

## Verification

After implementation slices, run:

- `bash tests/doctrine-integrity.sh`
- `bash scripts/validate-skill-registry.sh`
- `bash tests/core-command-boundary.sh`
- `git diff --check`

Run broader checks when skills/profile changes touch existing gates:

- `bash tests/i18n-doctrine.sh`
- `bash tests/design-system-artifact-consistency.sh`
- `bash tests/local-workspace-proof-gates.sh`

Run export proof after registry/skill changes:

- `bash scripts/sync-skills-to-global.sh && bash scripts/check-global-skill-mirror.sh`

## First Execution Rule

Do not create AdonisJS/AdminJS skills from memory. T1 research packet must land
first, with source citations and local owner mapping.
