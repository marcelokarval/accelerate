# Next.js Fullstack Scenario Evaluation Report

## Purpose

Record the orchestrated scenario test requested after S1-S5 execution of
`nextjs-fullstack-provider-profile-plan.md`.

Five subagents evaluated different product scenarios using repo-local
Accelerate doctrine only. This report aggregates their simulated Accelerate
headers, recommended stacks, strengths, weak spots, breaches, and missing
follow-up work.

## Scenario Matrix

| Scenario | Product Shape | Recommended Stack/Profile | Confidence | Primary Reason |
| --- | --- | --- | --- | --- |
| A | Fintech SaaS dashboard with accounts, ledgers, Stripe, mail, admin-lite, Vercel | `profiles/nextjs-drizzle/` | Medium-high | Financial/ledger work benefits from SQL-facing query/migration proof; provider lanes cover Stripe, financial truth, mail, auth, Vercel. |
| B | B2B multi-tenant collaboration with org roles, Clerk, Supabase Postgres/RLS, uploads, audit, Playwright | `profiles/nextjs-drizzle/` | High with blockers | Drizzle fits SQL/RLS control; Clerk/Supabase/Vercel/provider skills exist; tenant/RLS/audit/upload choices remain blockers. |
| C | Content marketplace with complex admin/operator workflows, bulk moderation, uploads, jobs, no Django | `profiles/nextjs-adonis-adminjs/` | High | Only profile that honestly matches Django-like backend/admin productivity without Django. |
| D | Data-heavy import/ingestion with CSV/PDF uploads, S3/R2, parsing/enrichment jobs, observability | `profiles/nextjs-adonis-adminjs/` | Medium-high | Backend-authoritative ingestion, storage, parser, retry, observability, and operator retry/inspection fit Adonis/AdminJS better than pure Next. |
| E | Small marketing site with contact form, simple admin view, one leads table, Vercel | `profiles/nextjs-prisma/` | Medium | Simplest repo-local fullstack data profile; avoids overfitting to Adonis/AdminJS and avoids `nextjs-tailwind` data gap. |

## Simulated Accelerate Header Patterns

Across the scenarios, a useful Accelerate header should include:

- `Run Type=<read-only evaluation|orchestrated non-trivial|product-critical fullstack>`
- `Selected Profile=<nextjs-prisma|nextjs-drizzle|nextjs-adonis-adminjs>`
- `Rejected Baselines=<why alternatives are not selected>`
- `Runtime Adapters=<node|playwright|browser proof fixtures>`
- `Provider Overlays=<auth|database|deployment|jobs|mail|storage>`
- `Risk Lanes=<security|anti-abuse|authorization|untrusted ingress|financial|observability>`
- `Proof Order=implementation -> QA -> browser truth -> persistent regression -> forensic closure`
- `Blocking Lanes=<unresolved provider/profile choices>`

## Strong Coverage Detected

| Area | Evidence Of Strength |
| --- | --- |
| Prisma/Drizzle separation | `profiles/nextjs-prisma/` and `profiles/nextjs-drizzle/` prohibit dual-authority and own separate data parity matrices. |
| Drizzle for SQL-heavy work | `profiles/nextjs-drizzle/validation-bundle.md` and `skills/data/drizzle-patterns/SKILL.md` cover migration strategy, SQL/index/constraint proof, transactions, query shape, and server-only DAL. |
| Prisma for small/simple data apps | `profiles/nextjs-prisma/` covers schema, migrations, generated client, deploy generation, DAL, and Vercel-compatible proof without a second backend. |
| Adonis/AdminJS for backend/admin-heavy apps | `profiles/nextjs-adonis-adminjs/` covers backend truth, AdminJS operator surfaces, transport boundary, and Node backend proof. |
| Auth provider optionality | Better Auth, Auth.js, and Clerk are covered as optional provider skills rather than universal baseline. |
| Authorization separation | `authorization-policy-patterns` separates authentication from RBAC/ABAC/ownership/tenancy and direct mutation proof. |
| Financial/payment surfaces | Existing `financial-source-truth`, `payment-integration`, and `stripe-integration` provide strong financial correctness lanes. |
| Upload/import hardening | `untrusted-ingress-hardening`, `s3-r2-storage-patterns`, and `uploadthing-patterns` cover untrusted file posture. |
| Jobs/mail/storage provider posture | Inngest, Trigger.dev, BullMQ, pg-boss, QStash, Resend, Postmark, Nodemailer, S3/R2, and UploadThing now have optional proof skills. |
| Browser/Playwright ordering | Playwright remains persistence-only after browser truth; flake triage and scenario quality are now explicit. |

## Weak Or Brittle Coverage Detected

| Weakness | Why It Matters | Suggested Follow-up |
| --- | --- | --- |
| `nextjs-app-router-patterns` mismatch | The skill text is still framed as comparative/architectural borrowing, while Next.js is now real runtime authority in `nextjs-prisma` and `nextjs-drizzle`. | Rewrite or split into a real `nextjs-runtime-patterns` skill. |
| No formal stack selector | The repo lacks a deterministic selector for small/simple app vs Prisma vs Drizzle vs Adonis/AdminJS. | Add a profile selection matrix and regression fixtures. |
| Admin-lite gap in Next.js data profiles | `nextjs-prisma`/`nextjs-drizzle` defer admin/operator surface, but common apps need simple admin pages without AdminJS. | Add `nextjs-operator-pages-patterns` or profile note. |
| Provider skills are first-pass | New provider skills are proof posture, not deep command/config guides. | Add provider-specific source packets and examples as real projects use them. |
| B2B tenant/RLS depth | Supabase/Clerk/authorization skills cover posture, but not org/member/invite/RLS fixture matrices. | Add B2B tenant authorization fixture pack. |
| Audit trail doctrine missing | Several scenarios need audit trails, but no dedicated skill owns append-only audit modeling. | Add `audit-trail-patterns`. |
| Moderation domain missing | Marketplace moderation needs queues, quarantine, appeals, reversals, reviewer assignment, and decision retention. | Add moderation/operator workflow overlay. |
| PDF/document parser specifics missing | Generic untrusted ingress is necessary but not sufficient for PDF/OCR/malware/decompression risks. | Add `document-parser-hardening` or `pdf-ingress-patterns`. |
| Invite lifecycle missing | B2B invites need expiry, resend cooldown, revocation, race, idempotency, and enumeration-safe UX. | Add invite lifecycle anti-abuse fixture. |
| Recommendation tests missing | `profile-integrity.sh` checks structure, not scenario-to-profile recommendation quality. | Add scenario recommendation fixtures. |

## Breaches Found Across Scenarios

| Breach Pattern | Impact | Guardrail |
| --- | --- | --- |
| Recommending `nextjs-tailwind` for data-bearing apps | Misses data parity, migration, DAL, DB proof. | Route data apps to Prisma/Drizzle or Adonis profile. |
| Recommending Adonis/AdminJS for small/simple apps | Over-engineers and violates minimality. | Use Prisma/Drizzle unless backend/admin complexity justifies Adonis/AdminJS. |
| Treating AdminJS as Django Admin parity | Overstates coverage and risks broad database exposure. | Keep AdminJS partial and explicit-resource-only. |
| Mixing Prisma and Drizzle in one baseline | Creates conflicting schema/migration authority. | Keep separate profiles. |
| Treating middleware/UI visibility as authz | Server Actions and Route Handlers remain directly reachable. | Use `authorization-policy-patterns` and provider auth proof. |
| Trusting upload MIME/extensions/frontend validation | Parser and storage attacks remain possible. | Use `untrusted-ingress-hardening` and storage provider proof. |
| Using Playwright before browser truth | Persists unknown or unstable behavior. | Browser proof first, Playwright second. |
| Letting frontend dashboard totals become financial truth | Financial misstatement and reconciliation drift. | Use `financial-source-truth` and provider reconciliation proof. |

## Orchestrator Judgment

The new S1-S5 provider layer materially improved Accelerate coverage. It now
has enough local doctrine to recommend among `nextjs-prisma`, `nextjs-drizzle`,
and `nextjs-adonis-adminjs` for diverse product shapes without pretending one
stack fits all.

The strongest recommendations are:

- simple data app -> `nextjs-prisma`
- SQL-heavy or tenant/RLS app -> `nextjs-drizzle`
- backend/admin/operator-heavy app -> `nextjs-adonis-adminjs`
- ingestion/moderation-heavy app -> usually `nextjs-adonis-adminjs`, unless the
  project explicitly rejects a separate backend and accepts provider gaps

The largest remaining breach is not provider coverage. It is selector clarity:
Accelerate needs a formal profile recommendation matrix and scenario fixtures so
future runs consistently emit the right profile and blocking lanes.

## Recommended Next Work

1. Create `profiles/selection-matrix.md` covering `nextjs-tailwind`,
   `nextjs-prisma`, `nextjs-drizzle`, and `nextjs-adonis-adminjs`.
2. Rewrite/split `nextjs-app-router-patterns` so it can govern actual Next.js
   runtime profiles.
3. Add scenario recommendation regression tests for the five scenarios above.
4. Add `nextjs-operator-pages-patterns` for admin-lite pages without AdminJS.
5. Add B2B tenant/RLS, audit trail, invite lifecycle, moderation workflow, and
   document parser hardening fixtures.

## Validation Note

This report is a read-only scenario evaluation artifact. It does not claim the
provider skills are exhaustive implementation guides; it records where the local
Accelerate doctrine is strong enough, where it is brittle, and which gaps should
drive the next planning slice.
