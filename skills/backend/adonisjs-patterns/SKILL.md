---
name: adonisjs-patterns
description: AdonisJS backend patterns for backend truth, controllers, services, VineJS validation, Lucid migrations, auth, security, and tests.
user-invocable: true
related-skills: api-surface-governance, validation-governance, security-patterns, anti-abuse-review, database-design, sql-optimization-patterns
---

# adonisjs-patterns

Use this skill when AdonisJS owns backend/domain truth in an Accelerate-governed
project.

## Purpose

Keep AdonisJS backend work aligned with:

- thin controllers
- service-owned business logic
- VineJS request validation before mutation
- Lucid migration/schema discipline
- explicit auth, authorization, session, and middleware boundaries
- Japa/Lucid-backed tests and runtime proof

## Load When

Load this skill when work touches:

- `start/routes.ts`, controllers, middleware, or `HttpContext`
- services, domain workflows, or provider callbacks
- Vine validators or request validation behavior
- Lucid models, migrations, relationships, queries, or serialization
- auth guards, session posture, Bouncer policies, Shield/security settings
- queues/jobs, cache, locks, file uploads, or background runtime behavior

## Core Rules

1. Adonis owns backend truth for this profile; do not move domain authority into
   Next.js route handlers or client code.
2. Controllers stay thin: validate, authorize, call services, return response.
3. VineJS validation is the request boundary before services and models.
4. Auth initialization is not authorization; protected routes still need explicit
   middleware/policy checks.
5. Lucid migrations are schema authority; schema drift and pending migration
   proof are closure conditions when schema changes.
6. Use Bouncer or an explicit project policy layer for authorization; avoid
   scattered ad hoc permission checks.
7. Protect login, reset, admin, high-cost endpoints, and job triggers with
   anti-abuse posture when relevant.
8. Queues, cache, locks, and storage need ownership, idempotency, lifecycle, and
   observability contracts before closure.

## Proof Expectations

- route/controller/service tests for behavior changes
- validation tests for accepted/rejected inputs
- Lucid migration and database proof for schema work
- auth/session/authorization proof for protected flows
- query-shape proof for relational lists, dashboards, and aggregations
- runtime proof for jobs, cache, locks, uploads, and provider callbacks

## Relationship To Next.js

Next.js may own UI shell and frontend runtime integration, but Adonis owns the
canonical backend mutation and read contracts unless an explicit exception is
designed and documented.
