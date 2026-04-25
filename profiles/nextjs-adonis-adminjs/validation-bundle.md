# Next.js AdonisJS AdminJS Validation Bundle

Use this bundle when a project declares Next.js + AdonisJS + AdminJS as its
active profile.

## Mandatory Skills

Frontend/componentization:

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
- `server-prop-governance`

Backend/admin:

- `adonisjs-patterns`
- `adminjs-patterns`
- `api-surface-governance`
- `validation-governance`
- `security-patterns`
- `anti-abuse-review`
- `product-runtime-review` when user-facing or operator-facing runtime behavior
  is in scope

Data/runtime when relevant:

- `database-design`
- `postgresql`
- `postgres-best-practices`
- `sql-optimization-patterns`
- `financial-source-truth`, `payment-integration`, or `stripe-integration` when
  money/provider behavior is in scope

## Boundary Rules

- Adonis is the backend truth layer.
- Backend parity against Django-like expectations is tracked in
  `backend-parity-matrix.md`; do not claim parity outside that matrix.
- Next route handlers/server actions are allowed only for UI shell concerns,
  frontend runtime integration, or explicitly designed edge/server glue.
- Backend validation in Adonis is authoritative; Next/client validation is UX and
  traffic-shaping only.
- Transport between Next and Adonis must be explicit: endpoint shape, auth/session
  model, error shape, DTOs, cache policy, and ownership of mutations.
- AdminJS resources must be explicit and scoped. Do not load the whole database
  as an operator surface without an explicit exception.

## Expected Command Classes

Resolve concrete commands through project scripts and `adapters/runtime/node/`.

Frontend:

- TypeScript check
- lint/static check when configured
- production build
- unit/component tests when configured

Adonis backend:

- server boot/config check
- route/controller/service tests
- Vine validator or request validation tests when behavior changes
- Lucid migration check and database connection proof
- auth/session/authorization proof when relevant
- job/queue proof when background work is present

AdminJS:

- resource registration proof
- action authorization proof
- sensitive field masking proof
- destructive action guard proof
- browser/admin runtime proof for changed operator flows

Cross-cutting:

- accessibility proof when user-facing or operator-facing UI changes
- observability/performance proof when metrics, logs, cache, query shape, jobs,
  or runtime performance are in scope
- browser truth before persistent Playwright regression

## Closure Requirements

Before closure, report:

- `Frontend QA=<present|missing|blocked>`
- `Adonis Backend QA=<present|missing|blocked>`
- `AdminJS QA=<present|missing|blocked|not-applicable>`
- `Transport Contract=<present|missing|blocked>`
- `Browser-Proof=<present|missing|blocked>`
- `Accessibility=<present|missing|blocked|not-applicable>`
- `Observability/Performance=<present|missing|blocked|not-applicable>`
- `Persistent E2E=<present|missing|blocked|out of order>`
- `blocking lane=<lane or none>`

Use:

- `adapters/runtime/proof-fixtures/runtime-proof-packet-template.md`
- `adapters/runtime/proof-fixtures/browser-truth-template.md`
- `core/runtime-packets/observability-performance-packet.md`
- `core/review/accessibility-closure-gate.md`
