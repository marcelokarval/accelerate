# Backend Parity Matrix: Django To AdonisJS

## Purpose

This is the living backend parity matrix for the `nextjs-adonis-adminjs` profile.

It tracks how Django backend capabilities map to the AdonisJS-based stack and
what governance Accelerate must enforce when this stack is used.

This file is local Accelerate authority. Source material from
`/home/marcelo-karval/Backup/Projetos/adonisjs-likely-django/` was research
input only.

## Status Legend

- `strong`: close structural equivalent exists
- `adapted`: capability exists but requires explicit project conventions
- `partial`: usable baseline exists but not Django-equivalent
- `defer`: not part of the profile baseline unless a product need opens it
- `gap`: no honest equivalent; needs custom design or explicit rejection

## Core Backend Parity

| Django capability | Django surface | AdonisJS/profile target | Status | Accelerate enforcement |
| --- | --- | --- | --- | --- |
| Framework runtime | `django` | `@adonisjs/core`, HTTP server, application, IoC container | strong | Use `adonisjs-patterns`; keep Adonis as backend truth. |
| App registry / app metadata | `django.apps` | Adonis application metadata + providers | adapted | Define module/app conventions before broad scaffolding. |
| Settings/config | `django.conf`, `settings.py` | Adonis `config`, `env`, project config modules | strong | Config/secrets changes require `Secrets & Config Hygiene Check`. |
| URL dispatcher | `django.urls`, URLconf/includes | Adonis router in `start/routes.ts` | strong | Routes are centralized and order-sensitive; static before dynamic. |
| Views / handlers | FBVs, CBVs | Controllers and route handlers | adapted | Controllers stay thin; services own business logic. |
| Middleware | `django.middleware.*` | Server, router, and named Adonis middleware | strong | Use broad middleware only for broad concerns; route groups use named middleware. |
| Request/response | `django.http` | `HttpContext`, response objects | strong | Do not hide domain truth in response shaping. |
| Templates | Django Template Language | Edge.js when server templates are needed | strong | Not the default product UI when Next owns the shell. |
| Management commands | `django-admin`, `manage.py` | Ace commands | adapted | Automation commands belong to runtime adapter/profile docs. |
| Shell / REPL | `manage.py shell` | Adonis REPL | adapted | Treat as operator/debug tooling, not proof by itself. |

## Data And ORM Parity

| Django capability | Django surface | AdonisJS/profile target | Status | Accelerate enforcement |
| --- | --- | --- | --- | --- |
| ORM models | `django.db.models.Model` | Lucid models | strong | Use `adonisjs-patterns`; migration/schema proof required on schema work. |
| Fields and constraints | model fields/constraints | Lucid columns + migrations + DB constraints | strong | DB schema remains explicit; no hidden model-only constraints. |
| Migrations | `django.db.migrations` | Lucid migrations | strong | Migration check/status and DB proof are profile closure lanes. |
| Query API | QuerySets/managers | Lucid query builder, model queries, repositories/services | adapted | Use `sql-optimization-patterns` for relational list/detail/aggregation risk. |
| Transactions | `django.db.transaction` | Lucid transactions | strong | Critical mutations require explicit transaction boundary. |
| Model hooks/signals | model signals/hooks | Lucid hooks + Adonis events + services | partial | Prefer services for business rules; hooks/events need explicit convention. |
| Model metadata | `_meta`, field metadata | project-owned metadata layer | partial | Living gap: define metadata derivation before admin/form automation. |
| PostgreSQL extras | `django.contrib.postgres` | Lucid/DB functions, migrations, raw SQL where needed | adapted | Use `postgresql` and `postgres-best-practices`; avoid ORM fantasy. |

## Validation, Forms, And Feedback

| Django capability | Django surface | AdonisJS/profile target | Status | Accelerate enforcement |
| --- | --- | --- | --- | --- |
| Forms | `django.forms` | VineJS + project form conventions | adapted | Backend Vine validation is authoritative; UI form composition is separate. |
| ModelForm | `django.forms.ModelForm` | VineJS + service/controller + metadata conventions | partial | Do not claim ModelForm parity; build explicit create/edit conventions. |
| Validators | `django.core.validators` | VineJS rules + custom rules | adapted | Validation governance decides backend vs frontend authority. |
| Messages framework | `django.contrib.messages` | flash messages via session | strong | Keep message/copy ownership aligned with i18n rules. |
| Labels/help text/choices | model/form metadata | project metadata conventions | partial | Living gap tied to metadata layer and AdminJS derivation. |

## Auth, Security, And Abuse Parity

| Django capability | Django surface | AdonisJS/profile target | Status | Accelerate enforcement |
| --- | --- | --- | --- | --- |
| Authentication | `django.contrib.auth` | `@adonisjs/auth` | strong | Auth guard/provider choice must be explicit. |
| Password hashing | `django.contrib.auth.hashers` | Adonis hash service | strong | No custom password hashing without security review. |
| Sessions | `django.contrib.sessions` | `@adonisjs/session` | strong | Session posture is runtime/security proof when touched. |
| CSRF/security headers | CSRF/security middleware | `@adonisjs/shield` | strong | Shield/security posture belongs in Adonis backend proof. |
| Permissions/policies | auth permissions, decorators, mixins | `@adonisjs/bouncer` | adapted | Avoid ad hoc checks; policies/abilities should be testable. |
| Rate limiting | ecosystem/throttling | `@adonisjs/limiter` | adapted | Protect login, reset, admin, high-cost endpoints, job triggers. |
| Social auth | allauth ecosystem | `@adonisjs/ally` | defer | Only adopt for real product need. |
| Signing/encryption | `django.core.signing` | Adonis encryption/signing space | adapted | Treat as sensitive-data/security design, not automatic parity. |
| CORS | third-party Django ecosystem | Adonis CORS middleware/package | adapted | API/transport governance owns cross-origin posture. |

## Files, Mail, Cache, Jobs, And Runtime

| Django capability | Django surface | AdonisJS/profile target | Status | Accelerate enforcement |
| --- | --- | --- | --- | --- |
| Email | `django.core.mail` | `@adonisjs/mail` | strong | Mail side effects need test/fake proof when behavior changes. |
| Files/storage | `django.core.files.storage` | `@adonisjs/drive` | adapted | Use untrusted ingress/storage hardening for uploads. |
| Uploaded files | upload handlers | bodyparser multipart + Drive | adapted | Validate file type/size/ownership/visibility/lifecycle. |
| Static files | `django.contrib.staticfiles` | Adonis static/Vite/Next asset pipeline | partial | In this profile, Next usually owns product UI assets. |
| Cache | `django.core.cache` | `@adonisjs/cache` | adapted | Only adopt with real need; require key ownership and invalidation proof. |
| Locks | no direct Django core equivalent | `@adonisjs/lock` | adapted | Locks do not replace idempotency, transactions, or job contracts. |
| Background jobs | Celery ecosystem | BullMQ or Adonis queue where adopted | partial | Not core baseline; require retry, idempotency, observability contracts. |
| Logging | Python logging integration | Adonis logger/Pino | strong | Observability packet required when logging is the change. |
| Health/readiness | project/ecosystem | Adonis health/watchlist | adapted | Profile can add health proof when runtime ops are in scope. |
| OpenTelemetry | ecosystem | Adonis `otel` watchlist | defer | Adopt when observability requirements justify it. |

## Admin And Operator Parity

| Django capability | Django surface | AdonisJS/profile target | Status | Accelerate enforcement |
| --- | --- | --- | --- | --- |
| Admin site | `django.contrib.admin` | AdminJS via `@adminjs/adonis` or custom admin | partial | AdminJS is baseline, not Django Admin parity. Use `adminjs-patterns`. |
| Admin resources | ModelAdmin/model metadata | explicit AdminJS resources + local metadata derivation | partial | Resources must be explicit, inspectable, overrideable, testable. |
| Admin actions | admin actions | AdminJS resource/record/bulk actions | adapted | Use `isAccessible`, hooks, audit posture, destructive-action guard. |
| Admin docs | `django.contrib.admindocs` | none | gap | Defer unless operator docs become product requirement. |
| Content types/generic relations | `django.contrib.contenttypes` | none | gap | Do not assume generic relation parity. Design explicitly if needed. |
| Sites framework | `django.contrib.sites` | none | gap | Multi-site behavior requires separate architecture. |
| Flatpages | `django.contrib.flatpages` | Adonis content/custom content | gap | Defer; not baseline. |
| Redirects | `django.contrib.redirects` | custom persistence/middleware | gap | Defer until product need. |
| Sitemaps/syndication | contrib packages | custom/Next/SEO layer | gap | Product SEO decision, not backend baseline. |
| GIS | GeoDjango | none official | gap | Requires domain-specific GIS architecture. |

## Developer Experience And Scaffolding

| Django capability | Django surface | AdonisJS/profile target | Status | Accelerate enforcement |
| --- | --- | --- | --- | --- |
| Startproject/startapp | `django-admin startproject/startapp` | `create-adonisjs`, starter kits, project conventions | adapted | Profile needs explicit module/app folder conventions before scaffolding. |
| Test harness | `django.test`, pytest ecosystem | Japa + Adonis/Lucid test utils | adapted | Preserve test intent, not syntax. |
| Factories/fixtures | Django fixtures/factory_boy ecosystem | project/Japa/Lucid conventions | partial | Living gap; define when tests need factories. |
| Serialization/DTOs | serializers/ecosystem | Adonis transformers/DTO layer or project mappers | adapted | API transport contract must define DTO shape. |
| i18n | Django i18n/l10n | `@adonisjs/i18n`; Next/frontend locale layer | adapted | Use `i18n-patterns` and locale-pack parity where applicable. |

## Living Gap Register

Add new findings here before promoting them into stricter profile or skill law.

| Gap | Why it matters | Current disposition |
| --- | --- | --- |
| Shared metadata layer | Needed for Django-like admin/forms/labels/filter derivation. | open; do not fake ModelForm/Admin parity |
| AdminJS resource derivation | Needed to reduce repeated admin config while staying safe. | open; use explicit resources first |
| Form/UI composition | Vine validates, but does not compose UI forms. | open; frontend/profile convention needed |
| Test factories/fixtures | Django-like productivity depends on reliable test data. | open; Japa/Lucid conventions needed |
| Jobs/Celery parity | BullMQ/queue baseline is partial. | defer until real async workload |
| Contenttypes/sites/GIS | No honest baseline equivalent. | reject/defer unless product requires |

## Update Rule

When new backend parity findings are discovered, update this file with:

- Django capability
- AdonisJS/profile target
- status
- enforcement owner
- whether the finding is imported, deferred, or rejected
