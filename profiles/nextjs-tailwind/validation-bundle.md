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
