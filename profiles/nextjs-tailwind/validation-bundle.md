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
- accessibility proof when user-facing UI changes
- observability/performance proof when metrics, logs, cache, query shape, or
  runtime performance are in scope

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

Use runtime proof fixtures from `adapters/runtime/proof-fixtures/` when the
branch needs a reusable packet shape instead of a one-off note.

## Theme / Template Portability Proof

When the slice touches `global.css`, `globals.css`, Tailwind config, CSS-first
`@theme`, component theme configuration, or claims theme/template portability,
use:

- `core/control-plane/theme-template-portability-gate.md`
- `onboarding/local-workspace/discover-visual-config.sh`
- `onboarding/local-workspace/check-theme-consumption.sh`
- `core/runtime-packets/theme-swap-proof-packet.md` for token/theme swaps
- `core/runtime-packets/template-swap-proof-packet.md` for shell/template swaps
- `core/control-plane/componentization-enforcement-gate.md`
- `onboarding/local-workspace/check-componentization-discipline.sh`

Tailwind v3 config and Tailwind v4 `@theme` must derive semantic visual values
from the canonical token API or an explicit local Token Alias Map when a
design-system package is active. Do not claim that replacing `globals.css` is
enough unless the real primitives consume the accepted token layer, central
component owners contain reusable anatomy/variants, and a swap proof covers the
changed route/state.

## Accessibility Proof

When user-facing UI changes, use `core/review/accessibility-closure-gate.md`.

Closure should name keyboard/focus, semantic/name, contrast/theme, and state
feedback coverage, or record why accessibility proof is not applicable.

## Observability And Performance Proof

When performance, cache, logs, metrics, provider runtime behavior, or route
latency are in scope, use
`core/runtime-packets/observability-performance-packet.md`.

Do not close with generic performance language. Record baseline/post-change
evidence or an explicit no-metric rationale.

## i18n Proof

When user-facing copy or locale behavior changes, use
`core/review/i18n-closure-gate.md` and
`adapters/runtime/locale-pack-parity/README.md`.

Do not assume a universal locale list. Discover the project's active locale
roots, supported locales, default locale, and i18n library/convention before
editing translation packs. Closure needs locale-pack parity and non-default
locale proof when UX is affected.

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
- `Browser-Proof=<present|missing|blocked>`
- `UX/UI Fullstack Surface=<present|missing|blocked|not-applicable>` when server/runtime state and visible UI behavior both changed
- `Accessibility=<present|missing|blocked|not-applicable>` when user-facing UI changed
- `Observability/Performance=<present|missing|blocked|not-applicable>` when metrics, logs, cache, or runtime performance were active
- `Persistent E2E=<present|missing|blocked|out of order>`
- `Theme/Template Portability=<present|missing|blocked|not-applicable>` when visual config, theme, or template portability is in scope
- `blocking lane=<lane or none>`
