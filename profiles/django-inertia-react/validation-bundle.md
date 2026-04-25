# Django Inertia React Validation Bundle

Use this bundle when a project declares Django + Inertia + React as its active
profile.

## Mandatory Skills

- `django-pro`
- `django-service-patterns`
- `django-inertia-integration`
- `django-vite-integration`
- `inertia-patterns`
- `inertia-shared-props`
- `python-pro`
- `python-testing`
- `front-react-shadcn`
- `react-best-practices`
- `typescript-pro`
- `frontend-boundary-governance`
- `server-prop-governance`
- `tailwind-patterns`
- `tailwind-design-system`
- `validation-governance`
- `security-patterns` when auth, ownership, or sensitive mutation is involved

## Implementation Proof

Prefer project-native commands. If a command is missing, record it as `blocked`
instead of inventing a fake proof.

Expected command classes:

- Django checks
- Python tests
- TypeScript check
- frontend build or Vite production build
- accessibility proof when user-facing UI changes
- observability/performance proof when metrics, logs, query shape, cache, or
  runtime performance are in scope

## Default Command Mapping

Use project-native wrappers first. For the default Django + Inertia + React
layout, map the command classes as follows:

- Django runtime/config check
  - `uv run python backend/src/manage.py check`
- Django schema drift check
  - `uv run python backend/src/manage.py makemigrations --check --dry-run`
- Django pending migration check
  - `uv run python backend/src/manage.py migrate --check`
- React TypeScript contract check
  - `npm run type-check --prefix frontends/front-react`

If the project uses a different backend path, frontend package path, package
manager, or Python wrapper, translate through the active runtime adapter and
record the resolved command in the proof packet.

## Browser Proof

Use Chrome DevTools first for runtime truth on user-facing flows.

Browser-proof packets should include:

- route or flow covered
- console/runtime errors
- server response or redirect truth
- backend props/state that produced the visible UI
- visible UI state
- residual gaps

Use runtime proof fixtures from `adapters/runtime/proof-fixtures/` when the
branch needs a reusable packet shape instead of a one-off note.

## Accessibility Proof

When user-facing UI changes, use `core/review/accessibility-closure-gate.md`.

Closure should name keyboard/focus, semantic/name, contrast/theme, and state
feedback coverage, or record why accessibility proof is not applicable.

## Observability And Performance Proof

When query shape, metrics, logs, cache, provider runtime behavior, or route/job
latency are in scope, use
`core/runtime-packets/observability-performance-packet.md`.

Do not close with generic performance language. Record baseline/post-change
evidence or an explicit no-metric rationale.

## Persistent Regression

Persist to Playwright only after browser truth is stable.

Use:

- `adapters/runtime/playwright/scenario-fixture-template.md`
- `adapters/runtime/playwright/proof-packet-template.md`
- `adapters/runtime/proof-fixtures/runtime-proof-packet-template.md`
- `adapters/runtime/proof-fixtures/browser-truth-template.md`

## Closure Requirements

Before closure, report:

- `Backend QA=<present|missing|blocked>`
- `Frontend QA=<present|missing|blocked>`
- `Browser-Proof=<present|missing|blocked>`
- `UX/UI Fullstack Surface=<present|missing|blocked|not-applicable>` when backend state and visible UI behavior both changed
- `Accessibility=<present|missing|blocked|not-applicable>` when user-facing UI changed
- `Observability/Performance=<present|missing|blocked|not-applicable>` when metrics, logs, query shape, cache, or runtime performance were active
- `Persistent E2E=<present|missing|blocked|out of order>`
- `blocking lane=<lane or none>`
