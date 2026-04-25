# Next.js Prisma Profile

This profile governs projects that intentionally use:

- Next.js as the fullstack application runtime and product shell
- React + TypeScript + shadcn/Radix + Tailwind for product UI
- Prisma as schema, migration, query, and generated-client authority
- PostgreSQL unless the project explicitly chooses another database through
  database governance

## Authority Model

Next.js owns routing, rendering, server actions, route handlers, middleware, and
runtime integration. Prisma owns database schema shape, migrations, generated
client access, and ORM-level data access.

Do not combine this profile with Drizzle as an equal peer. If a project chooses
Drizzle, use `profiles/nextjs-drizzle/` instead.

## Non-Goals

- No hidden second backend framework by default.
- No Prisma and Drizzle dual-authority baseline.
- No database access from client components.
- No Server Action or Route Handler mutation without validation, auth/session,
  and cache invalidation proof when relevant.

Execution validation for this profile lives in:

- `validation-bundle.md`

Data/backend parity and known gaps live in:

- `data-parity-matrix.md`
