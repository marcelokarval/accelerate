# Data Parity Matrix: Next.js Prisma

## Purpose

This is the living data/backend parity matrix for the `nextjs-prisma` profile.

It tracks what Prisma and Next.js can safely own, where project conventions are
required, and which gaps must not be hidden by generic fullstack language.

## Status Legend

- `strong`: close structural equivalent exists
- `adapted`: capability exists but requires explicit project conventions
- `partial`: usable baseline exists but not equivalent to a full backend framework
- `defer`: not part of the profile baseline unless a product need opens it
- `gap`: no honest equivalent; needs custom design or explicit rejection

## Runtime And API Surface

| Capability | Next.js/Prisma target | Status | Accelerate enforcement |
| --- | --- | --- | --- |
| Fullstack runtime | Next.js App Router, Server Components, Server Actions, Route Handlers | adapted | Use `nextjs-app-router-patterns`; do not hide backend truth in client code. |
| API-like routes | Route Handlers | strong | Request/response proof required when touched. |
| Mutations | Server Actions or Route Handlers | adapted | Validation, auth/session, cache invalidation, and UI-state proof required. |
| Transport contracts | DTOs or typed action return shapes | adapted | Use `server-prop-governance` and `typescript-pro`; avoid leaking ORM objects. |
| Data Access Layer | `server-only` DAL modules for production data access | adapted | Preferred for new production work; component-level data access needs bounded exception. |
| Middleware | Next.js middleware/proxy | partial | Keep domain mutations out of middleware; prove routing/session/header behavior. |

## Data And ORM Parity

| Capability | Prisma target | Status | Accelerate enforcement |
| --- | --- | --- | --- |
| Schema authority | `schema.prisma` | strong | Schema changes require Prisma proof and database design review. |
| Generated client | Prisma Client | strong | Regenerate/prove client alignment after schema changes. |
| Deploy-time client generation | `prisma generate`, package scripts, CI/deploy build hooks | adapted | Prove deploy/build can generate or access the expected client output. |
| Migrations | Prisma Migrate | strong | Migration status/apply/dry-run proof required for schema changes. |
| Query API | Prisma Client queries | strong | Query-shape proof required for lists, aggregates, ownership filters, and pagination. |
| Transactions | Prisma interactive or batch transactions | adapted | Critical mutations require explicit transaction boundary and failure-path proof. |
| Constraints/indexes | Prisma schema + database constraints | adapted | Use `database-design`, `postgresql`, and `postgres-best-practices` for relational invariants. |
| Raw SQL | Prisma raw query escape hatch | partial | Require `postgresql`/`sql-optimization-patterns`; avoid raw SQL as hidden domain layer. |
| Connection pooling | Prisma adapter/pooler/platform config | partial | Deployment profile must prove pooling/serverless posture when relevant. |

## Validation, Forms, And Feedback

| Capability | Profile target | Status | Accelerate enforcement |
| --- | --- | --- | --- |
| Backend validation | Project-selected schema validation such as Zod/Valibot/ArkType | adapted | `validation-governance` decides authority; frontend validation is convenience only. |
| Client-controlled input | `FormData`, route params, `searchParams`, headers, cookies | adapted | Validate before trust; page-level checks do not protect Server Actions. |
| UI forms | shadcn/Radix + project form library | adapted | Form composition is frontend-owned; backend validation remains authoritative. |
| Domain errors | Typed action/route error shape | adapted | Error shape must be explicit and visible in UI proof. |
| Flash/toast feedback | Project UI convention | adapted | Product-runtime proof required for visible state feedback. |

## Auth, Security, And Abuse

| Capability | Profile target | Status | Accelerate enforcement |
| --- | --- | --- | --- |
| Authentication | Project-selected auth provider/library | gap | No baseline equivalent; choose Auth.js, Better Auth, Clerk, custom, or provider explicitly. |
| Sessions | Project-selected session strategy | gap | Security proof required; do not assume Next.js provides session policy. |
| Authorization | Project RBAC/ABAC/policy convention | gap | Use `authorization-policy-patterns`; ownership and permission checks must be explicit and tested. |
| Server Action exposure | Direct POST-reachable Server Actions | adapted | Re-check auth/authz inside every action; filter returned data. |
| CSRF/security headers | Framework/provider/project controls | adapted | Mutation and cookie posture requires `security-patterns`. |
| Rate limiting | Provider, middleware, edge, or route-level limiter | gap | Protect login, reset, admin, high-cost endpoints, and job triggers explicitly. |

## Runtime Services

| Capability | Profile target | Status | Accelerate enforcement |
| --- | --- | --- | --- |
| Background jobs | Inngest, Trigger.dev, BullMQ, pg-boss, QStash, cron provider, or custom worker | gap | Not baseline; require idempotency, retries, and observability when adopted. |
| Mail | Resend, Postmark, Nodemailer, or provider abstraction | gap | Provider side effects need test/fake proof. |
| Files/uploads | S3/R2/Supabase Storage/UploadThing or custom storage | gap | Use `untrusted-ingress-hardening`; validate type/size/ownership/visibility/lifecycle. |
| Cache | Next.js cache, tags, paths, React cache, DB/provider cache | adapted | Mutations require invalidation proof; cache key ownership must be explicit. |
| Observability | Project logger/tracing/platform metrics | gap | Use observability/performance packet when runtime behavior is in scope. |

## Living Gap Register

| Gap | Why it matters | Current disposition |
| --- | --- | --- |
| Auth/session baseline | Product security varies heavily by provider/library. | open; choose per project |
| Authorization/policy model | Prisma does not provide domain authorization. | open; require explicit ownership tests |
| Validation library baseline | Next.js and Prisma do not define form/domain validation. | open; govern via `validation-governance` |
| Jobs/mail/files baseline | Fullstack products need side effects beyond Next.js/Prisma. | open; provider-specific skills may be needed |
| Serverless/edge DB posture | Prisma deployment behavior depends on platform and pooling. | open; prove before closure |
| DAL/server-only convention | Prevents leaking secrets or raw database data into client components. | open; preferred for production data access |
| Admin/operator surface | No Django Admin/AdminJS equivalent is baseline. | defer unless product requires |

## Update Rule

When new Prisma/Next.js data findings are discovered, update this file with:

- capability
- profile target
- status
- enforcement owner
- whether the finding is imported, deferred, or rejected
