# Next.js AdonisJS AdminJS Research Packet

## Purpose

This packet records the research used to import Next.js + AdonisJS + AdminJS
support into local Accelerate doctrine.

External and adjacent-project sources are research inputs only. The governed
authority is the adapted content in this repository.

## Local Accelerate Findings

| Finding | Classification | Local owner |
| --- | --- | --- |
| Existing `nextjs-tailwind` profile already owns Next.js frontend/runtime proof, but not an external Adonis backend. | `import-as-profile-rule` | `profiles/nextjs-adonis-adminjs/validation-bundle.md` |
| React/shadcn/Tailwind componentization enforcement already exists through frontend hierarchy, componentization audit, extraction, boundary, and design-system skills. | `import-as-profile-rule` | `profiles/nextjs-adonis-adminjs/validation-bundle.md` |
| Node runtime adapter is currently frontend/tooling-centric and needs backend runtime classes. | `import-as-runtime-adapter-rule` | `adapters/runtime/node/README.md` |
| Admin/operator branch assumes Django Unfold and must become stack-generic. | `import-as-profile-rule` | `core/control-plane/branch-enforcement-matrix.md` |
| API/transport and validation authority can reuse existing governance skills. | `import-as-skill-rule` | `profiles/nextjs-adonis-adminjs/validation-bundle.md` |

## Local Adonis Research Corpus

Source root: `/home/marcelo-karval/Backup/Projetos/adonisjs-likely-django/`

Accepted backend parity findings are materialized in:

- `profiles/nextjs-adonis-adminjs/backend-parity-matrix.md`

| Source | Finding | Classification | Local owner |
| --- | --- | --- | --- |
| `docs/adr/001-target-stack-decision.md` | AdonisJS is the backend truth target; official packages should be preferred. | `import-as-profile-rule` | `profiles/nextjs-adonis-adminjs/README.md` |
| `docs/research/adonisjs-official-package-scan.md` | Baseline package set includes Lucid, VineJS, auth, session, shield, mail, i18n, Japa. | `import-as-skill-rule` | `skills/backend/adonisjs-patterns/SKILL.md` |
| `docs/adr/002-build-on-top-vs-fork-strategy.md` | Extend Adonis through packages/hooks/providers; do not fork first. | `import-as-runtime-adapter-rule` | `adapters/runtime/node/README.md` |
| `docs/research/adminjs-adonis-integration-analysis.md` | Prefer `@adminjs/adonis`; legacy `adminjs-adonis` is not the baseline. | `import-as-skill-rule` | `skills/backend/adminjs-patterns/SKILL.md` |
| `docs/architecture/likely-django-admin-layer.md` | AdminJS needs a local admin layer for resource metadata, policies, validation, audit, and testing. | `import-as-skill-rule` | `skills/backend/adminjs-patterns/SKILL.md` |
| `docs/architecture/likely-django-admin-metadata-resource-derivation.md` | Admin resources should be derivable, overrideable, inspectable, and testable; sensitive fields hidden by default. | `import-as-risk-fixture` | `skills/backend/adminjs-patterns/SKILL.md` |
| `docs/adr/005-authorization-strategy.md` | Authorization baseline is Bouncer; avoid scattered ad hoc checks. | `import-as-risk-fixture` | `skills/backend/adonisjs-patterns/SKILL.md` |
| `docs/adr/006-rate-limiting-and-anti-abuse-strategy.md` | Use limiter posture for login, reset, admin, costly endpoints, and job triggers. | `import-as-risk-fixture` | `skills/backend/adonisjs-patterns/SKILL.md` |
| `docs/adr/004-queue-and-job-strategy.md` | Queues/jobs are later subsystem; require retry, backoff, idempotency, observability. | `import-as-runtime-adapter-rule` | `adapters/runtime/node/README.md` |
| `docs/adr/007-cache-strategy.md` | Cache only with real performance/invalidation need; require key ownership and observability. | `import-as-runtime-adapter-rule` | `profiles/nextjs-adonis-adminjs/validation-bundle.md` |
| `docs/adr/008-locking-strategy.md` | Locks are for critical sections, not replacements for idempotency or transactions. | `import-as-risk-fixture` | `skills/backend/adonisjs-patterns/SKILL.md` |
| `docs/adr/010-file-storage-and-uploads-strategy.md` | Drive/storage needs ownership, visibility, lifecycle, validation, auth, serving rules. | `import-as-risk-fixture` | `skills/backend/adonisjs-patterns/SKILL.md` |
| `docs/architecture/django-to-adonisjs-equivalence-matrix.md` | Lucid maps to models/ORM, Vine to validation/forms, Bouncer to permissions, AdminJS to weak admin partial. | `import-as-profile-rule` | `profiles/nextjs-adonis-adminjs/README.md` |
| `docs/research/django-functionality-curation.md` | Full Django Admin/contenttypes/sites/GIS parity should be deferred. | `reject-or-defer` | `profiles/nextjs-adonis-adminjs/README.md` |

## Official Source Findings

Access date: 2026-04-25.

| Source URL | Finding | Classification | Local owner |
| --- | --- | --- | --- |
| `https://nextjs.org/docs/app/getting-started/route-handlers` | Route handlers live in `app/**/route.ts`, use Web Request/Response, and must not conflict with `page.tsx` at same segment. | `import-as-profile-rule` | `profiles/nextjs-adonis-adminjs/validation-bundle.md` |
| `https://nextjs.org/docs/app/getting-started/server-and-client-components` | Server Components are default; `use client` defines a client bundle boundary. | `import-as-profile-rule` | `profiles/nextjs-adonis-adminjs/validation-bundle.md` |
| `https://nextjs.org/docs/app/getting-started/mutating-data` | Mutations use Server Actions or Route Handlers; auth/authz must be checked in mutation handlers. | `import-as-risk-fixture` | `profiles/nextjs-adonis-adminjs/validation-bundle.md` |
| `https://nextjs.org/docs/app/guides/data-security` | Use minimal DTOs and server-only boundaries for privileged modules. | `import-as-skill-rule` | `skills/frontend/nextjs-app-router-patterns/SKILL.md` already owns Next guidance; profile references it. |
| `https://docs.adonisjs.com/guides/basics/routing` | Routes are centralized and order-sensitive. | `import-as-skill-rule` | `skills/backend/adonisjs-patterns/SKILL.md` |
| `https://docs.adonisjs.com/guides/basics/controllers` | Controllers are request-scoped and receive `HttpContext`. | `import-as-skill-rule` | `skills/backend/adonisjs-patterns/SKILL.md` |
| `https://docs.adonisjs.com/guides/basics/validation` | VineJS validation via `request.validateUsing()` is a request boundary. | `import-as-skill-rule` | `skills/backend/adonisjs-patterns/SKILL.md` |
| `https://docs.adonisjs.com/guides/auth/introduction` | Auth uses guards/providers; attaching `ctx.auth` is not itself route protection. | `import-as-risk-fixture` | `skills/backend/adonisjs-patterns/SKILL.md` |
| `https://lucid.adonisjs.com/docs/migrations` | Migrations are schema authority and need production safety posture. | `import-as-runtime-adapter-rule` | `adapters/runtime/node/README.md` |
| `https://lucid.adonisjs.com/docs/testing` | Lucid/Japa testing supports migration/truncation/transaction/DB assertions. | `import-as-runtime-adapter-rule` | `profiles/nextjs-adonis-adminjs/validation-bundle.md` |
| `https://docs.adminjs.co/basics/resource` | Resources are managed entities; explicit resources are preferred over whole-database loading. | `import-as-skill-rule` | `skills/backend/adminjs-patterns/SKILL.md` |
| `https://docs.adminjs.co/basics/action` | Actions are resource/record/bulk and expose generated REST endpoints. | `import-as-risk-fixture` | `skills/backend/adminjs-patterns/SKILL.md` |
| `https://docs.adminjs.co/tutorials/adding-role-based-access-control` | RBAC is custom; `isAccessible` blocks API access while `isVisible` only hides UI. | `import-as-risk-fixture` | `skills/backend/adminjs-patterns/SKILL.md` |
| `https://docs.adminjs.co/ui-customization/writing-your-own-components` | Custom UI uses ComponentLoader; component customization must stay bounded. | `import-as-profile-rule` | `profiles/nextjs-adonis-adminjs/validation-bundle.md` |

## Rejected Or Deferred

- Do not import Django Admin parity as a claim; AdminJS is a baseline operator
  surface with local hardening.
- Do not make Next.js route handlers/server actions the default backend truth
  when Adonis owns backend/domain behavior.
- Do not adopt legacy `adminjs-adonis` as the default AdminJS integration target.
- Do not add concrete project commands to core; profile and runtime adapter own
  command classes.
