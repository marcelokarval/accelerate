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

## Browser Proof

Use Chrome DevTools first for runtime truth on user-facing flows.

Browser-proof packets should include:

- route or flow covered
- console/runtime errors
- server response or redirect truth
- visible UI state
- residual gaps

## Persistent Regression

Persist to Playwright only after browser truth is stable.

Use:

- `adapters/runtime/playwright/scenario-fixture-template.md`
- `adapters/runtime/playwright/proof-packet-template.md`

## Closure Requirements

Before closure, report:

- `Backend QA=<present|missing|blocked>`
- `Frontend QA=<present|missing|blocked>`
- `Browser-Proof=<present|missing|blocked>`
- `Persistent E2E=<present|missing|blocked|out of order>`
- `blocking lane=<lane or none>`
