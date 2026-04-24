# Next.js Tailwind Validation Bundle

Use this bundle when a project declares Next.js + Tailwind as its active
profile.

## Mandatory Skills

- `nextjs-app-router-patterns`
- `react-best-practices`
- `typescript-pro`
- `tailwind-patterns`
- `tailwind-design-system`
- `frontend-boundary-governance`
- `frontend-component-hierarchy`
- `frontend-componentization-audit`
- `component-extraction`
- `i18n-patterns` when user-facing copy or locale behavior is involved
- `security-patterns` when auth, ownership, or sensitive mutation is involved
- `validation-governance` when form or domain validation is involved

## Implementation Proof

Prefer project-native commands. If a command is missing, record it as `blocked`
instead of inventing a fake proof.

Expected command classes:

- TypeScript check
- lint or static check when configured
- production build
- unit/component tests when configured
- server/runtime proof when server actions, route handlers, middleware,
  auth/session, cache invalidation, database access, or provider callbacks are
  in scope

## Fullstack Runtime Proof

Next.js work is not automatically frontend-only. When the slice touches server
or runtime-owned behavior, closure also needs evidence for the affected runtime
surface:

- route handlers or API-like surfaces: request/response proof with status,
  redirects, and error shape
- server actions: mutation proof covering validation, auth/session behavior, and
  resulting UI state
- middleware: routing/session/header proof for affected paths
- auth/session: signed-in, signed-out, and unauthorized state proof when relevant
- database or provider calls: integration boundary proof or an explicit blocked
  reason when local credentials are unavailable

Use the Node runtime adapter to resolve concrete commands, and record the exact
resolved command or browser/runtime artifact in the proof packet.

## Browser Proof

Use Chrome DevTools first for runtime truth on user-facing flows.

Browser-proof packets should include:

- route or flow covered
- console/runtime errors
- hydration or routing issues
- server/client state that produced the visible UI when applicable
- visible UI state
- residual gaps

## Persistent Regression

Persist to Playwright only after browser truth is stable.

Use:

- `adapters/runtime/playwright/scenario-fixture-template.md`
- `adapters/runtime/playwright/proof-packet-template.md`

## Closure Requirements

Before closure, report:

- `Frontend QA=<present|missing|blocked>`
- `Browser-Proof=<present|missing|blocked>`
- `UX/UI Fullstack Surface=<present|missing|blocked|not-applicable>` when server/runtime state and visible UI behavior both changed
- `Persistent E2E=<present|missing|blocked|out of order>`
- `blocking lane=<lane or none>`
