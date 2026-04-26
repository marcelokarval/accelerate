# Next.js Fullstack Provider Profile Plan

## Goal

Complete the next governed stack layer after the `nextjs-prisma` and
`nextjs-drizzle` profiles by adding local Accelerate authority for the provider
and execution surfaces those profiles intentionally left as gaps.

This plan covers:

- auth/session provider profiles or skills
- deployment/runtime/database provider profiles or skills
- jobs, mail, uploads, and storage side-effect surfaces
- Playwright proof posture as first-class local doctrine
- regression tests that prevent profile drift
- formal research packets for `nextjs-prisma` and `nextjs-drizzle`

## Current Context

Already landed:

- `profiles/nextjs-prisma/`
- `profiles/nextjs-drizzle/`
- `skills/data/prisma-patterns/`
- `skills/data/drizzle-patterns/`
- Node runtime adapter proof classes for Prisma and Drizzle
- branch-matrix recognition of Prisma/Drizzle as backend/data stack skills

Known intentional gaps from those profiles:

- auth/session baseline
- authorization/policy model
- jobs/queues
- mail
- uploads/storage
- deployment/runtime/database provider posture
- Playwright-specific proof doctrine
- profile drift regression coverage
- research packets matching the standard used by `nextjs-adonis-adminjs`

## Non-Negotiables

- Do not use user-home skills or `skills.sh` entries as authority.
- External websites and skills are research inputs only.
- Any accepted behavior must be imported, adapted, registered, and enforced in
  this repository before becoming Accelerate doctrine.
- Keep `core/` capability-oriented. Concrete commands belong in profiles or
  adapters.
- Do not make a provider mandatory for all Next.js fullstack projects unless a
  profile explicitly selects it.
- Keep provider slices small enough to commit independently.

## Research Discipline

Each provider or tool slice must produce a short source-observation section in a
research packet before implementation.

Minimum source classes:

- official provider docs
- relevant official Next.js/Vercel/platform docs
- relevant open agent skill listing when comparing skill coverage, such as
  `skills.sh`, as non-authoritative market evidence

Every accepted finding must be classified as:

- `import-as-profile-rule`
- `import-as-skill-rule`
- `import-as-runtime-adapter-rule`
- `import-as-risk-fixture`
- `reject-or-defer`

## Task Sequence

### T1 - Prisma And Drizzle Research Packets

Create formal research packets matching the `nextjs-adonis-adminjs` standard.

Files:

- `planning/executive/nextjs-prisma-research-packet.md`
- `planning/executive/nextjs-drizzle-research-packet.md`

Done when:

- official Next.js, Prisma, and Drizzle docs are summarized with access dates
- `skills.sh`/public skill ecosystem comparison is recorded as market evidence,
  not authority
- accepted/rejected findings map to local owner files
- gaps from `data-parity-matrix.md` are reconciled with the packets

### T2 - Auth Provider Profile Pack

Add optional auth/session provider coverage for the most likely Next.js stacks.

Candidate skills/profiles:

- `skills/security/better-auth-patterns/`
- `skills/security/authjs-patterns/`
- `skills/security/clerk-patterns/`
- optional provider profile docs when a provider needs profile-level proof

Done when:

- auth/session setup, server action re-auth, authorization boundary, session
  storage, CSRF/origin posture, and callback/webhook surfaces are covered
- no auth provider becomes the universal baseline
- registry metadata and manifest entries exist for every new skill

### T3 - Authorization Policy Model Pack

Create stack-neutral authorization guidance for Next.js fullstack data profiles.

Candidate files:

- `skills/security/authorization-policy-patterns/`
- updates to `profiles/nextjs-prisma/data-parity-matrix.md`
- updates to `profiles/nextjs-drizzle/data-parity-matrix.md`

Done when:

- RBAC/ABAC/ownership checks are separated from authentication
- Server Actions, Route Handlers, DAL functions, and UI visibility all have
  explicit authorization expectations
- IDOR and ownership proof expectations are tied to `security-patterns` and
  `anti-abuse-review`

### T4 - Deployment And Database Provider Pack

Add optional runtime/deployment/database provider doctrine.

Candidate skills/profiles:

- `skills/runtime/vercel-deployment-patterns/`
- `skills/data/neon-postgres-patterns/`
- `skills/data/supabase-postgres-patterns/`
- `adapters/runtime/node/README.md` additions for provider proof classes

Done when:

- Vercel build/runtime/env/caching/deployment evidence is covered without making
  Vercel universal
- Neon/Supabase/Postgres provider posture covers pooling, migrations, branches,
  secrets, preview environments, backups, and connection proof
- Prisma generated-client and Drizzle migration strategy proof remain profile
  owned

### T5 - Side Effect Provider Pack

Add optional provider doctrine for jobs, mail, and storage/uploads.

Candidate skills:

- `skills/runtime/inngest-patterns/`
- `skills/runtime/triggerdev-patterns/`
- `skills/runtime/bullmq-patterns/`
- `skills/runtime/pgboss-patterns/`
- `skills/runtime/qstash-patterns/`
- `skills/runtime/resend-patterns/`
- `skills/runtime/postmark-patterns/`
- `skills/runtime/nodemailer-patterns/`
- `skills/runtime/s3-r2-storage-patterns/`
- `skills/runtime/uploadthing-patterns/`

Done when:

- jobs cover idempotency, retries, schedule/trigger source, concurrency, failure
  visibility, and replay safety
- mail covers templates, test/fake proof, bounce/failure handling, provider event
  callbacks, and user-visible state
- uploads/storage cover untrusted ingress, ownership, lifecycle, visibility,
  content-type trust, and deletion/export posture
- provider docs remain optional and do not bloat base profiles

### T6 - Playwright Proof Skill

Promote Playwright proof posture from generic fixture references into a local
skill and optional runtime adapter depth.

Candidate files:

- `skills/runtime/playwright-patterns/`
- `adapters/runtime/playwright/README.md`
- updates to profile validation bundles only where needed

Done when:

- browser truth remains before Playwright persistence
- Playwright scenarios cover stable selectors, auth state, fixtures, retries,
  screenshots/traces, network evidence, and flake triage
- closure distinguishes exploratory browser proof from persisted regression proof

### T7 - Profile Drift Regression Tests

Add regression checks that make the new profile architecture durable.

Candidate files:

- `tests/profile-integrity.sh`
- updates to `tests/doctrine-integrity.sh` only if the checks belong there

Done when tests enforce:

- every active profile listed in `profiles/README.md` has `README.md` and
  `validation-bundle.md`
- every active fullstack data profile has `data-parity-matrix.md`
- no profile claims both Prisma and Drizzle as baseline data authority
- every mandatory skill in a validation bundle exists in the registry or is
  explicitly conditional and registered
- profile-owned proof classes do not move concrete commands into `core/`

### T8 - Index And Registry Closure

Wire all accepted skills/profiles into local indexes and export proof.

Files:

- `skills/_registry/manifest.md`
- relevant `skills/*/README.md` files when present
- `profiles/README.md`
- `planning/executive/README.md`

Done when:

- all new local skills have metadata
- all active profiles are discoverable
- skill export drift check passes

## Recommended Execution Slices

Execute in this order:

1. T1 + T7: research packets and regression harness first, so later slices have
   stronger guardrails.
2. T2 + T3: auth/session and authorization, because they affect every mutation
   path.
3. T4: deployment/database providers, because they shape Prisma/Drizzle runtime
   proof.
4. T5: side-effect providers, split by jobs, mail, and storage if the diff grows.
5. T6 + T8: Playwright proof and final index/registry closure.

## Verification

Run after each bounded slice:

- `bash tests/doctrine-integrity.sh`
- `bash scripts/validate-skill-registry.sh`
- `bash tests/core-command-boundary.sh`
- `git diff --check`

Run broad closure before committing each larger phase:

- `bash tests/i18n-doctrine.sh`
- `bash tests/design-system-artifact-consistency.sh`
- `bash tests/local-workspace-proof-gates.sh`
- `bash onboarding/local-workspace/validate-v2.sh onboarding/local-workspace/v2-template`

Run skill export drift proof after registry or skill content changes:

- `bash scripts/sync-skills-to-global.sh && bash scripts/check-global-skill-mirror.sh`

## Execution Status

Current status: planned, not implemented.

Execution tracking lives in:

- `nextjs-fullstack-provider-profile-task-ledger.md`
