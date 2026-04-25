---
name: prisma-patterns
description: Codex-native Prisma guidance for Next.js fullstack profiles, covering schema authority, migrations, generated client discipline, transactions, query shape, and deployment posture.
user-invocable: true
related-skills: nextjs-app-router-patterns, validation-governance, security-patterns, database-design, postgresql, postgres-best-practices, sql-optimization-patterns
---

# prisma-patterns

Use this skill when a project uses Prisma as the active data layer under a
Next.js fullstack profile.

## Load When

Load this skill when the task touches:

- `schema.prisma`
- Prisma migrations
- Prisma Client generation or imports
- data access in Server Actions or Route Handlers
- transactions, relation loading, pagination, aggregation, or ownership filters
- serverless, edge, or pooling posture for Prisma

## Core Rules

1. Treat `schema.prisma` as the Prisma profile's schema authority.
2. Keep Prisma access on the server side. Do not import Prisma Client into client
   components.
3. Prefer a `server-only` Data Access Layer for production data access. Direct
   Server Component queries need a bounded exception.
4. Validate all client-controlled values before using them in Prisma queries:
   `FormData`, route params, `searchParams`, headers, cookies, and action args.
5. Do not return raw Prisma model objects as public UI or API contracts when a
   DTO boundary is needed.
6. Critical mutations need explicit validation, authorization, transaction
   posture, and cache invalidation proof.
7. Schema changes need migration proof and generated-client alignment proof.
8. Deployment changes need proof that Prisma Client generation is available in
   build/install/CI/runtime as appropriate.
9. Query-heavy work needs query-shape evidence, not only type safety.

## Prisma Proof Checklist

- Prisma schema validation or format proof when `schema.prisma` changes
- migration status, dry-run, or apply proof when migrations change
- generated client proof after schema changes
- deploy/build generated-client proof when package scripts, Vercel, Docker, CI,
  or install behavior changes
- DB connection proof for data-access work
- DAL or `server-only` proof for privileged data modules
- input validation and return-filtering proof for Server Actions and Route
  Handlers
- transaction proof for multi-write or critical mutations
- query-shape proof for lists, aggregation, relation loading, and pagination
- deployment/pooling proof when serverless, edge, or hosted database constraints
  are relevant

## Common Failure Modes

- treating generated types as authorization
- leaking internal Prisma model shape to public contracts
- importing Prisma/env/session modules into client components
- relying on page-level auth to protect Server Actions
- mutating data without revalidating paths/tags or updating visible state
- returning raw mutation records to the client
- using `db push` as a production migration strategy without explicit exception
- adding raw SQL without Postgres and query optimization review
- ignoring connection pooling in serverless deployments

## Boundaries

- Use `nextjs-app-router-patterns` for Server Action, Route Handler, cache, and
  server/client boundary rules.
- Use `validation-governance` for validation authority.
- Use `security-patterns` and `anti-abuse-review` for auth, ownership, and abuse
  posture.
- Use `database-design`, `postgresql`, `postgres-best-practices`, and
  `sql-optimization-patterns` for relational design and performance.
