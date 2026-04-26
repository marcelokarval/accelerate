---
name: supabase-postgres-patterns
description: Optional Supabase Postgres guidance for Next.js fullstack profiles, covering database posture, RLS boundaries, migrations, storage adjacency, preview environments, and provider proof.
user-invocable: true
related-skills: postgresql, postgres-best-practices, database-design, prisma-patterns, drizzle-patterns, security-patterns, authorization-policy-patterns
---

# supabase-postgres-patterns

Use this skill when a project uses Supabase Postgres as its database provider.

## Core Rules

1. Supabase Postgres is optional database provider authority, not a universal
   baseline.
2. Decide whether auth/storage/RLS are in scope or whether only Postgres is used.
3. RLS is authorization infrastructure, not a substitute for server-side policy
   clarity.
4. Migrations remain owned by the active data profile: Prisma or Drizzle.
5. Service-role keys must never cross into client code.

## Proof Checklist

- database connection and environment target proof
- service-role vs anon key boundary proof when relevant
- RLS policy proof when RLS is active
- migration target proof for Prisma or Drizzle
- storage adjacency proof if Supabase Storage is used
- backup/restore or rollback note for destructive schema work
