---
name: neon-postgres-patterns
description: Optional Neon Postgres guidance for Next.js fullstack profiles, covering connection posture, pooling, branches, migrations, previews, backups, and database proof.
user-invocable: true
related-skills: postgresql, postgres-best-practices, database-design, prisma-patterns, drizzle-patterns, security-patterns
---

# neon-postgres-patterns

Use this skill when a project uses Neon Postgres as its database provider.

## Core Rules

1. Neon is optional database provider authority, not a universal baseline.
2. Connection strings, pooling, branch choice, and preview database behavior must
   be explicit.
3. Migrations remain owned by the active data profile: Prisma or Drizzle.
4. Secrets and branch credentials must stay environment-scoped.
5. Backup/restore and branch reset posture must be understood before destructive
   schema work.

## Proof Checklist

- direct vs pooled connection posture
- local, preview, and production database target proof where relevant
- migration target proof for Prisma or Drizzle
- branch/preview environment proof
- connection health or integration test proof
- backup/restore or rollback note for destructive schema work
