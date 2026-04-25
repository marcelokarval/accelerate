# Next.js Prisma Validation Bundle

Use this bundle when a project declares Next.js + Prisma as its active profile.

## Mandatory Skills

- `nextjs-app-router-patterns`
- `front-react-shadcn`
- `react-best-practices`
- `typescript-pro`
- `tailwind-patterns`
- `tailwind-design-system`
- `frontend-boundary-governance`
- `frontend-component-hierarchy`
- `frontend-componentization-audit`
- `component-extraction`
- `prisma-patterns`
- `database-design`
- `postgresql` when PostgreSQL-specific features, DDL, or SQL are in scope
- `postgres-best-practices` when indexes, concurrency, pooling, or query posture
  are in scope
- `sql-optimization-patterns` when query shape, pagination, aggregation, or N+1
  risk is in scope
- `validation-governance` when forms, server actions, route handlers, or domain
  validation are in scope
- `security-patterns` when auth, ownership, sessions, secrets, or sensitive
  mutation are in scope
- `anti-abuse-review` when auth, upload, billing, export, deletion, search,
  settings, or other user-driven flows can be abused
- `i18n-patterns` when user-facing copy or locale behavior is involved

## Implementation Proof

Prefer project-native commands. If a command is missing, record it as `blocked`
instead of inventing a fake proof.

Expected command classes:

- TypeScript or contract check
- lint or static check when configured
- production build
- unit/component tests when configured
- server action or route handler request/mutation proof when runtime behavior is
  touched
- Data Access Layer or explicit bounded exception proof for production data
  access
- `server-only` boundary proof for modules that read secrets, sessions, or the
  database
- input validation proof for `FormData`, route params, `searchParams`, headers,
  cookies, and other client-controlled values when used
- Server Action return-value filtering proof when mutations return data to the
  client
- Prisma schema validation or format proof when `schema.prisma` changes
- Prisma migration status, dry-run, or apply proof when schema/migration changes
- generated Prisma client proof after schema changes
- deployment generated-client proof when build/deploy scripts, Vercel, Docker,
  CI, or package installation behavior are in scope
- database connection proof for data-access changes
- transaction and query-shape proof for critical mutations, lists, aggregation,
  ownership filters, pagination, or provider-driven persistence
- cache invalidation proof when data mutations affect rendered Next.js UI
- accessibility proof when user-facing UI changes
- observability/performance proof when metrics, logs, cache, query shape, or
  runtime performance are in scope

## Fullstack Runtime Proof

Next.js is not frontend-only in this profile. When a slice touches server or
runtime-owned behavior, closure also needs evidence for the affected runtime
surface:

- Server Actions: mutation proof covering validation, auth/session behavior,
  transaction behavior when applicable, cache invalidation, filtered return
  values, and resulting UI state
- Route Handlers: request/response proof with status, redirects, and error shape
- middleware: routing/session/header proof for affected paths
- auth/session: signed-in, signed-out, unauthorized, and ownership-denied state
  proof when relevant
- database calls: Prisma query proof, schema/client alignment proof, and an
  explicit blocked reason when local credentials are unavailable
- data access modules: proof that privileged Prisma/env/session access is
  isolated behind server-only boundaries or a documented bounded exception

Use the Node runtime adapter to resolve concrete commands, and record the exact
resolved command or browser/runtime artifact in the proof packet.

## Prisma-Specific Closure

Before closure on data-affecting work, report:

- `Prisma Schema=<present|missing|not-applicable>`
- `Prisma Migration=<present|missing|blocked|not-applicable>`
- `Prisma Client Generation=<present|missing|blocked|not-applicable>`
- `Prisma Deploy Generation=<present|missing|blocked|not-applicable>`
- `DB Connection=<present|missing|blocked|not-applicable>`
- `DAL/Server-Only Boundary=<present|missing|blocked|not-applicable>`
- `Input Validation=<present|missing|blocked|not-applicable>`
- `Return Filtering=<present|missing|blocked|not-applicable>`
- `Transaction/Query Shape=<present|missing|blocked|not-applicable>`
- `Cache Invalidation=<present|missing|blocked|not-applicable>`

## Browser Proof

Use Chrome DevTools first for runtime truth on user-facing flows.

Browser-proof packets should include:

- route or flow covered
- console/runtime errors
- hydration or routing issues
- server/client state that produced the visible UI when applicable
- visible UI state
- residual gaps

Use runtime proof fixtures from `adapters/runtime/proof-fixtures/` when the
branch needs a reusable packet shape instead of a one-off note.

## Persistent Regression

Persist to Playwright only after browser truth is stable.

Use:

- `adapters/runtime/playwright/scenario-fixture-template.md`
- `adapters/runtime/playwright/proof-packet-template.md`
- `adapters/runtime/proof-fixtures/runtime-proof-packet-template.md`
- `adapters/runtime/proof-fixtures/browser-truth-template.md`

## Closure Requirements

Before closure, report:

- `Frontend QA=<present|missing|blocked>`
- `Backend/Data QA=<present|missing|blocked>`
- `Browser-Proof=<present|missing|blocked>`
- `UX/UI Fullstack Surface=<present|missing|blocked|not-applicable>` when server/runtime state and visible UI behavior both changed
- `Accessibility=<present|missing|blocked|not-applicable>` when user-facing UI changed
- `Observability/Performance=<present|missing|blocked|not-applicable>` when metrics, logs, cache, or runtime performance were active
- `Persistent E2E=<present|missing|blocked|out of order>`
- `blocking lane=<lane or none>`
