# Next.js Drizzle Profile

This profile governs projects that intentionally use:

- Next.js as the fullstack application runtime and product shell
- React + TypeScript + shadcn/Radix + Tailwind for product UI
- Drizzle as schema, migration, query, and SQL-facing data authority
- PostgreSQL unless the project explicitly chooses another database through
  database governance

## Authority Model

Next.js owns routing, rendering, server actions, route handlers, middleware, and
runtime integration. Drizzle owns schema definitions, migration generation,
query construction, and SQL-facing data access.

Do not combine this profile with Prisma as an equal peer. If a project chooses
Prisma, use `profiles/nextjs-prisma/` instead.

## Non-Goals

- No hidden second backend framework by default.
- No Prisma and Drizzle dual-authority baseline.
- No database access from client components.
- No scattered raw SQL/domain logic without explicit query ownership.
- No Server Action or Route Handler mutation without validation, auth/session,
  and cache invalidation proof when relevant.

Execution validation for this profile lives in:

- `validation-bundle.md`

Data/backend parity and known gaps live in:

- `data-parity-matrix.md`
