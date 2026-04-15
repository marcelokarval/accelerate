# QA And Proof Stack

Use this module when the work needs explicit QA lane ownership instead of a
generic "tests/review later" posture.

## Rule

Truth should move through four distinct layers:

1. implementation proof
2. backend/frontend QA proof
3. browser truth
4. persistent regression proof

## Lane Ownership

- `Backend Tester`
  - service tests
  - query-shape proof
  - migrations/runtime proof
  - ownership/auth proof
- `Frontend Tester`
  - type-check
  - component state proof
  - i18n proof
  - route/view-model proof
- `Browser-Proof Auditor`
  - interactive truth in Chrome DevTools
  - breadth and route-family audit
  - runtime console and UX drift detection
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
