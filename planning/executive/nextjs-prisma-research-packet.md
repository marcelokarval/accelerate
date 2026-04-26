# Next.js Prisma Research Packet

## Purpose

Record source observations used to govern `profiles/nextjs-prisma/` and
`skills/data/prisma-patterns/`.

External sources are research input only. Local authority lives in the profile,
skill, runtime adapter, and tests.

## Source Observations

| Source | Access date | Class | Finding | Disposition | Local owner |
| --- | --- | --- | --- | --- | --- |
| `https://nextjs.org/docs/app/guides/data-security` | 2026-04-26 | official docs | New projects should prefer a Data Access Layer, `server-only`, authz in data access, and minimal DTOs. | `import-as-profile-rule` | `profiles/nextjs-prisma/validation-bundle.md`; `skills/data/prisma-patterns/SKILL.md` |
| `https://nextjs.org/docs/app/getting-started/mutating-data` | 2026-04-26 | official docs | Server Actions are direct POST-reachable and must verify auth/authz, validate input, revalidate cache, and redirect/return safely. | `import-as-profile-rule` | `profiles/nextjs-prisma/validation-bundle.md` |
| `https://www.prisma.io/docs/guides/nextjs` | 2026-04-26 | official docs | Prisma with Next.js uses `schema.prisma`, migrations, `prisma generate`, seed scripts, a server-side client module, and deployment generation hooks. | `import-as-skill-rule` | `skills/data/prisma-patterns/SKILL.md`; `adapters/runtime/node/README.md` |
| `https://skills.sh/` | 2026-04-26 | public skill ecosystem | Market has skills for Next.js, shadcn, Better Auth, Supabase/Neon Postgres, Playwright, and Vercel deployment. | `import-as-risk-fixture` | `planning/executive/nextjs-fullstack-provider-profile-plan.md` |

## Accepted Local Rules

- `schema.prisma` is the Prisma profile's schema authority.
- Prisma Client access must stay server-side.
- Production data access should prefer a `server-only` DAL.
- Server Actions must re-check auth/authz and filter return values.
- Schema changes need migration and generated-client proof.
- Deploy/build changes need proof that Prisma Client generation is available.

## Rejected Or Deferred

| Finding | Reason | Disposition |
| --- | --- | --- |
| Make Prisma universal for all Next.js fullstack profiles | Drizzle is a separate first-class profile. | `reject-or-defer` |
| Make Vercel universal | Deployment provider must remain optional. | `reject-or-defer` |
| Make Auth.js/Better Auth/Clerk mandatory | Auth provider should be selected by project/profile. | `reject-or-defer` |

## Reconciled Gaps

The profile still intentionally leaves these as optional provider decisions:

- auth/session provider
- authorization policy implementation
- jobs, mail, uploads/storage
- Vercel/Neon/Supabase provider posture
- admin/operator surface
