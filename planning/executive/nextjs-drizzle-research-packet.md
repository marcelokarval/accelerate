# Next.js Drizzle Research Packet

## Purpose

Record source observations used to govern `profiles/nextjs-drizzle/` and
`skills/data/drizzle-patterns/`.

External sources are research input only. Local authority lives in the profile,
skill, runtime adapter, and tests.

## Source Observations

| Source | Access date | Class | Finding | Disposition | Local owner |
| --- | --- | --- | --- | --- | --- |
| `https://nextjs.org/docs/app/guides/data-security` | 2026-04-26 | official docs | New projects should prefer a Data Access Layer, `server-only`, authz in data access, and minimal DTOs. | `import-as-profile-rule` | `profiles/nextjs-drizzle/validation-bundle.md`; `skills/data/drizzle-patterns/SKILL.md` |
| `https://nextjs.org/docs/app/getting-started/mutating-data` | 2026-04-26 | official docs | Server Actions are direct POST-reachable and must verify auth/authz, validate input, revalidate cache, and return safely. | `import-as-profile-rule` | `profiles/nextjs-drizzle/validation-bundle.md` |
| `https://orm.drizzle.team/docs/get-started` | 2026-04-26 | official docs | Drizzle supports many drivers and providers; provider/runtime posture must be explicit. | `import-as-profile-rule` | `profiles/nextjs-drizzle/data-parity-matrix.md` |
| `https://orm.drizzle.team/docs/migrations` | 2026-04-26 | official docs | Drizzle supports database-first and codebase-first flows: `pull`, `push`, `generate`, `migrate`, `export`, external tools, and runtime migrations. | `import-as-profile-rule` | `profiles/nextjs-drizzle/validation-bundle.md`; `skills/data/drizzle-patterns/SKILL.md` |
| `https://orm.drizzle.team/docs/rqb` | 2026-04-26 | official docs | Relational queries can reduce mapping work, but query shape, relation loading, pagination, and prepared statements need review. | `import-as-skill-rule` | `skills/data/drizzle-patterns/SKILL.md`; `sql-optimization-patterns` |
| `https://orm.drizzle.team/docs/transactions` | 2026-04-26 | official docs | Transactions support nested transactions/savepoints and dialect-specific isolation settings. | `import-as-skill-rule` | `skills/data/drizzle-patterns/SKILL.md` |
| `https://skills.sh/` | 2026-04-26 | public skill ecosystem | Market has skills for Next.js, shadcn, Better Auth, Supabase/Neon Postgres, Playwright, and Vercel deployment. | `import-as-risk-fixture` | `planning/executive/nextjs-fullstack-provider-profile-plan.md` |

## Accepted Local Rules

- Drizzle schema files are the profile's schema authority.
- Drizzle access must stay server-side.
- Production data access should prefer a `server-only` DAL.
- Server Actions must re-check auth/authz and filter return values.
- Schema work must declare a migration strategy before mutation.
- Generated migrations are database artifacts and require review.

## Rejected Or Deferred

| Finding | Reason | Disposition |
| --- | --- | --- |
| Make Drizzle universal for all Next.js fullstack profiles | Prisma is a separate first-class profile. | `reject-or-defer` |
| Allow `push` as silent production default | `push` can be valid, but production use needs explicit posture. | `reject-or-defer` |
| Make a provider such as Neon/Supabase universal | Database provider must remain optional. | `reject-or-defer` |

## Reconciled Gaps

The profile still intentionally leaves these as optional provider decisions:

- auth/session provider
- authorization policy implementation
- jobs, mail, uploads/storage
- Vercel/Neon/Supabase provider posture
- admin/operator surface
