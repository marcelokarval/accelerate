# Profiles

Profiles bundle opinionated stack defaults without turning those defaults into
universal platform law.

Profiles may define:

- dominant stack assumptions
- default runtime adapters
- recommended skills
- proof posture
- common reviewers

Every active profile should expose a `validation-bundle.md` before agents or
operators treat it as execution-ready.

The bundle must name:

- mandatory skills
- default implementation proof
- backend/frontend QA commands
- browser-proof posture
- persistent regression posture
- closure packet requirements

## Active Profiles

- `django-inertia-react/`
- `nextjs-tailwind/`
- `nextjs-adonis-adminjs/`
- `nextjs-prisma/`
- `nextjs-drizzle/`

## Current Next.js Fullstack Selection

Use the smallest profile that honestly owns the runtime and data shape:

- `nextjs-tailwind/`
  - UI-oriented or marketing-oriented Next.js work with no durable data authority.
- `nextjs-prisma/`
  - simple data-bearing Next.js apps where Prisma is the schema and migration
    authority.
- `nextjs-drizzle/`
  - SQL-heavy, tenant/RLS, query-control-heavy, or hosted-Postgres-sensitive
    Next.js apps where Drizzle schema files are the data authority.
- `nextjs-adonis-adminjs/`
  - backend/admin/operator-heavy products where Adonis owns backend truth and
    AdminJS provides explicit operator resources/actions.

Do not combine Prisma and Drizzle as equal baseline data authorities in one
profile. If a project wants both, the profile must declare which one owns schema
and migrations and why the other is only an integration or migration aid.

## Provider Skills

Provider skills are optional overlays, not universal baselines. Current provider
families include:

- auth/session: Better Auth, Auth.js, Clerk
- authorization: stack-neutral RBAC/ABAC/ownership/tenancy policy
- hosted Postgres: Neon and Supabase Postgres
- deployment: Vercel
- jobs/queues: Inngest, Trigger.dev, BullMQ, pg-boss, QStash
- mail: Resend, Postmark, Nodemailer/SMTP
- storage/uploads: S3/R2 and UploadThing
- persistent regression: Playwright

Profiles should reference provider skills only when the product shape actually
needs them.

## Integrity Tests

Profile changes must continue to pass:

- `bash tests/profile-integrity.sh`
- `bash tests/doctrine-integrity.sh`
