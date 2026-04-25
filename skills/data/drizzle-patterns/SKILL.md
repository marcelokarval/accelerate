---
name: drizzle-patterns
description: Codex-native Drizzle guidance for Next.js fullstack profiles, covering schema authority, migrations, SQL ownership, transactions, query shape, and runtime driver posture.
user-invocable: true
related-skills: nextjs-app-router-patterns, validation-governance, security-patterns, database-design, postgresql, postgres-best-practices, sql-optimization-patterns
---

# drizzle-patterns

Use this skill when a project uses Drizzle as the active data layer under a
Next.js fullstack profile.

## Load When

Load this skill when the task touches:

- Drizzle schema files
- `drizzle-kit` migration generation or migration application
- data access in Server Actions or Route Handlers
- SQL helpers, raw SQL fragments, relation loading, pagination, aggregation, or
  ownership filters
- driver, serverless, edge, or pooling posture for Drizzle

## Core Rules

1. Treat Drizzle schema files as the profile's schema authority.
2. Keep Drizzle access on the server side. Do not import database access into
   client components.
3. Prefer a `server-only` Data Access Layer for production data access. Direct
   Server Component queries need a bounded exception.
4. Validate all client-controlled values before using them in Drizzle queries:
   `FormData`, route params, `searchParams`, headers, cookies, and action args.
5. Declare the migration strategy before schema work: `push`,
   `generate+migrate`, `pull`, `export`, external migration tool, or runtime
   migration.
6. Review generated migrations as database artifacts, not as disposable build
   output.
7. Critical mutations need explicit validation, authorization, transaction
   posture, and cache invalidation proof.
8. Query-heavy work needs SQL/query-shape evidence, not only TypeScript types.
9. Raw SQL is allowed only when owned, bounded, and reviewed with PostgreSQL or
   query optimization context.

## Drizzle Proof Checklist

- schema/type proof when schema files change
- migration strategy declaration when schema or migration behavior is in scope
- migration generation/check proof when schema changes
- migration apply/status proof when runtime database state changes
- DB connection proof for data-access work
- DAL or `server-only` proof for privileged data modules
- input validation and return-filtering proof for Server Actions and Route
  Handlers
- transaction proof for multi-write or critical mutations
- SQL/index/constraint proof for relational invariants
- query-shape proof for lists, aggregation, relation loading, and pagination
- runtime driver/pooling proof when serverless, edge, or hosted database
  constraints are relevant

## Common Failure Modes

- treating table types as authorization
- scattering SQL fragments without an owner
- importing Drizzle/env/session modules into client components
- relying on page-level auth to protect Server Actions
- mutating data without revalidating paths/tags or updating visible state
- returning raw mutation records to the client
- accepting generated migrations without reviewing constraints and indexes
- skipping fixture/reset strategy for integration tests
- ignoring driver/pooling behavior in serverless deployments

## Boundaries

- Use `nextjs-app-router-patterns` for Server Action, Route Handler, cache, and
  server/client boundary rules.
- Use `validation-governance` for validation authority.
- Use `security-patterns` and `anti-abuse-review` for auth, ownership, and abuse
  posture.
- Use `database-design`, `postgresql`, `postgres-best-practices`, and
  `sql-optimization-patterns` for relational design and performance.
