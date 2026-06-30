# QA And Proof Stack

## Local Authority Status

Primary local authority lives in:

- `../core/runtime-packets/qa-proof-stack.md`

Use this reference for supporting doctrine and comparison depth.

If the native local file and this reference disagree, prefer the local file.

Use this module when the work needs explicit QA lane ownership instead of a
generic "tests/review later" posture.

## Rule

Truth should move through six distinct layers:

1. implementation proof
2. backend QA proof
3. frontend QA proof
4. browser truth
5. persistent regression proof
6. forensic closure

QA must revalidate the test posture for the work that just landed. If tests
were added, changed, or are relied on for acceptance, rerun the relevant test
command. If coverage tooling exists, run the smallest meaningful coverage target
and report scope, percentage/threshold, and uncovered critical paths. If no
coverage tooling exists, state `not-configured` and run the closest
deterministic test suite.

## Lane Ownership

- `Backend Tester`
  - service tests
  - unit/integration/contract coverage for changed backend behavior
  - query-shape proof
  - migrations/runtime proof
  - ownership/auth proof
  - backend logs captured and scanned for new errors, warnings, tracebacks,
    worker failures, provider failures, retries, and unexpected 4xx/5xx
- `Frontend Tester`
  - frontend unit/component coverage for changed frontend behavior
  - type-check
  - lint/build when available and relevant
  - component state proof
  - i18n proof
  - route/view-model proof
  - framework/design-system conformance for the active stack
- `Browser-Proof Auditor`
  - interactive truth in Chrome DevTools
  - breadth and route-family audit
  - runtime console and network inspection at minimum
  - screenshot evidence for changed states
  - ARIA/accessibility snapshot or equivalent accessibility probe when UI is in
    scope
  - UX/UI alignment and component-layout drift detection
  - responsive viewport coverage when visual correctness is in scope
  - when exploratory browser QA and issue capture are the main need, `dogfood` is a valid lane companion
- `E2E Regression Engineer`
  - persistent Playwright scenarios
  - regression protection after the flow is understood

## Chrome DevTools vs Playwright

Do not invert these roles.

- `Chrome DevTools`
  - discovery truth
  - runtime truth
  - broad sweep
  - route-family validation
- `Playwright`
  - persistent regression
  - repeatable scenario proof
  - CI-friendly safety net

If the flow is not yet understood, start in Chrome DevTools.

Only persist to Playwright after the interactive truth is stable enough to be
worth automating.

## Backend QA Minimum Contract

Backend QA must include relevant backend tests, coverage when configured,
API/contract/domain assertions, migration/schema proof when persistence changes,
and backend process/test/worker/container logs captured and scanned. Green tests
do not close backend work when logs show new runtime errors.

## Frontend QA Minimum Contract

Frontend QA must include relevant frontend tests, coverage when configured,
type-check/lint/build when available, DevTools console and network inspection,
screenshots, ARIA/accessibility proof when UI semantics matter, and comparison
against the active framework/design-system rules.

## Responsive 3x3 Viewport Matrix

When visual layout, responsive behavior, premium UI, design-system application,
or user-facing browser UX is in scope, use this viewport map unless the repo has
a stricter matrix:

| Family | Small | Medium | Large |
| --- | --- | --- | --- |
| Mobile | 320x568 | 390x844 | 430x932 |
| Tablet | 768x1024 | 834x1194 | 1024x1366 |
| Desktop | 1280x720 | 1440x900 | 1920x1080 |

For each viewport, capture screenshot/visual state, console state, relevant
network failures, layout/overflow/overlap findings, ARIA/accessibility findings
when applicable, and component-system deviations. Missing 3x3 proof blocks
product-critical or premium UI closure unless explicitly waived.

## Active Visual Correction

In-scope visual, ARIA, layout, responsive, console, or network defects found
during frontend/browser QA must feed:

```text
detect -> fix -> rerun affected viewport/probe -> compare corrected evidence
```

Do not close on pre-fix screenshots.

## Additional Agnostic QA Gates

When risk exists, proof must also name:

- `Negative Path`: expected 4xx/5xx, validation, empty/loading/error/recovery
  states.
- `Security/Auth/Ownership`: authz, ownership, CSRF/session, rate-limit/replay,
  token handling, and PII exposure.
- `Concurrency/Idempotency`: double-submit, retry, duplicate event/job/message,
  locks, idempotency keys, and race-sensitive writes.
- `Performance Minimum`: latency, query count, N+1/cache/memory, LCP/CLS/INP,
  long tasks, hydration, or bundle cost.
- `External Resilience`: provider down/timeout/retry/backoff/fallback,
  offline/slow network, cancellation, and retry UI.
- `Clean State/Cleanup`: deterministic fixtures and cleanup for rows, files,
  jobs, locks, queues, cookies, storage, service workers, and artifacts.
- `Observability Correlation`: correlation/trace/session/request ID from
  frontend action through backend logs, persistence, jobs, and provider calls
  when available.

## Browser-Proof Intensity Labels

Every browser-proof packet should classify its breadth as one of:

- `sampled`
- `targeted`
- `broad sweep`
- `full route-family audit`

## Visual Proof Diagram

```text
╔════════════════════════════════════════════════════════════════════════════════════╗
║                           QA / PROOF STACK                                         ║
╠══════════════════════╦══════════════════════╦══════════════════════╦═══════════════╣
║ Backend Tester       ║ Frontend Tester      ║ Browser-Proof        ║ E2E Regression║
║ [service/query/auth] ║ [TS/i18n/states]     ║ Auditor              ║ Engineer       ║
║                      ║                      ║ [Chrome DevTools]    ║ [Playwright]   ║
╠══════════════════════╬══════════════════════╬══════════════════════╬═══════════════╣
║ query proof          ║ type-check           ║ targeted             ║ smoke          ║
║ migration proof      ║ component proof      ║ broad sweep          ║ regression     ║
║ ownership proof      ║ locale proof         ║ route-family audit   ║ persistence    ║
╚══════════════════════╩══════════════════════╩══════════════════════╩═══════════════╝
```

## Required Outputs

Each lane should leave a packet with:

- scope covered
- intensity or depth
- evidence used
- failures found
- residual gaps

The browser-proof lane and Playwright lane should never be merged into a single
vague sentence.

Closure must expose at least: `Backend QA`, `Backend Coverage`, `Backend Logs`,
`Frontend QA`, `Frontend Coverage`, `Frontend Build/Type/Lint`,
`Browser-Proof`, `DevTools Console`, `DevTools Network`, `Screenshots`,
`ARIA/A11y`, `Responsive 3x3`, `Negative Path`, `Security/Auth/Ownership`,
`Concurrency/Idempotency`, `Performance Minimum`, `External Resilience`,
`Clean State/Cleanup`, `Observability Correlation`, `Persistent E2E`, and
blocking lane status.
