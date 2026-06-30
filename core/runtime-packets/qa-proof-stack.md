# QA And Proof Stack

## Purpose

Use this module when the work needs explicit QA lane ownership instead of a
generic "tests/review later" posture.

## Rule

Truth moves through six distinct layers:

1. implementation proof
2. backend QA proof
3. frontend QA proof
4. browser truth
5. persistent regression proof
6. forensic closure

Do not collapse these into a single vague `tested` claim.

When `Execution-To-Spec Loop Gate` is active, QA failures, browser proof
failures, and visual proof failures must feed the correction loop. They are not
terminal notes unless the loop is explicitly blocked or narrowed.

QA must actively revalidate the test posture for the work that just landed. If
the branch added, changed, or depended on tests, run the relevant test command
again and report the result. If the project has coverage tooling, run the
smallest meaningful coverage target and report scope, percentage/threshold, and
uncovered critical paths. If no coverage tool exists, state that explicitly and
run the closest deterministic unit/integration/contract suite instead.

## Lane Ownership

- `Backend Tester`
  - service tests
  - unit/integration/contract coverage for changed backend behavior
  - query-shape proof
  - migrations/runtime proof
  - ownership/auth proof
  - backend logs captured and scanned for new errors, warnings, tracebacks,
    rejected requests, migrations, worker failures, provider failures, and
    unexpected retries
  - observability/performance packet when performance, logs, metrics, cache, or
    N+1 behavior is in scope
- `Frontend Tester`
  - frontend unit/component coverage for changed frontend behavior
  - type-check
  - lint/build when available and relevant
  - component state proof
  - i18n proof through `core/review/i18n-closure-gate.md` when copy or locale
    behavior changes
  - route/view-model proof
  - framework/design-system conformance for the active stack
- `Browser-Proof Auditor`
  - interactive truth in Chrome DevTools
  - breadth and route-family audit
  - runtime console and network inspection at minimum
  - screenshots for the active route/state
  - ARIA/accessibility snapshot or equivalent accessibility probe when UI is in
    scope
  - UX/UI alignment and component-layout drift detection
  - responsive viewport coverage when visual correctness is in scope
  - design implementation proof for contract-driven or premium UI mutation
  - optional agent-browser-style CLI operations after the flow is bounded
  - when exploratory browser QA and issue capture are the main need, `dogfood`
    is a valid lane companion
  - UX/UI fullstack proof when backend truth, frontend state, and runtime UX all
    determine closure
- `E2E Regression Engineer`
  - persistent Playwright scenarios
  - regression protection after the flow is understood
  - scenario fixtures from `adapters/runtime/playwright/scenario-fixture-template.md`
  - closure packets from `adapters/runtime/playwright/proof-packet-template.md`

## Chrome DevTools vs Playwright

Do not invert these roles.

- `Chrome DevTools`
  - discovery truth
  - runtime truth
  - broad sweep
  - route-family validation
- `agent-browser`
  - repeatable browser operations after the target flow is bounded
  - high-capability browser interaction, snapshots, screenshots, video, and
    state-aware observation under adapter safety rules
- `Playwright`
  - persistent regression
  - repeatable scenario proof
  - CI-friendly safety net

If the flow is not yet understood, start in Chrome DevTools.

If Chrome DevTools cannot start because its shared `chrome-profile` is already
running, route through the browser-proof profile conflict rule: prefer
`--isolated`, then a dedicated temporary `userDataDir`, then an explicitly
recorded existing-session attachment only when that state is required. Otherwise
mark browser proof blocked; do not close browser-required work from that state.

Use an `agent-browser` adapter only after browser truth is bounded enough that
its higher automation power will not hide the real user path.

Only persist to Playwright after the interactive truth is stable enough to be
worth automating.

When persistent proof is needed, use the local Playwright adapter fixtures in
`adapters/runtime/playwright/` instead of an informal test note.

## Backend QA Minimum Contract

When backend behavior, persistence, auth, jobs, providers, API contracts, CLI
commands, migrations, or server-side validation are touched, backend QA must
include:

- the relevant backend test command rerun after the change;
- coverage command/result when coverage tooling exists;
- API/contract/domain assertions for the changed behavior;
- migration/schema proof when schema or persistence changes;
- backend process, test, worker, or container logs captured after the run;
- log scan result for new errors, tracebacks, warnings, failed jobs, provider
  failures, retry storms, permission failures, or unexpected 4xx/5xx responses.

Do not close backend work from green tests alone when logs show new runtime
errors. Feed the log defect into the correction loop.

## Frontend QA Minimum Contract

When frontend behavior, UI, routes, forms, design-system usage, accessibility,
copy, responsive behavior, or browser-visible state changes, frontend QA must
include:

- the relevant frontend unit/component test command rerun after the change;
- coverage command/result when coverage tooling exists;
- type-check, lint, or build when available and relevant;
- Chrome DevTools console inspection;
- Chrome DevTools network inspection for decisive requests;
- screenshot evidence for changed states;
- ARIA/accessibility snapshot or equivalent accessibility probe when UI is in
  scope;
- active comparison against the framework/design-system rules used by the
  project;
- mobile/tablet/desktop responsive proof when layout or visual behavior matters.

Do not accept "looks good" without screenshots and console/network evidence for
browser-visible changes.

## Responsive 3x3 Viewport Matrix

When visual layout, responsive behavior, premium UI, design-system application,
or user-facing browser UX is in scope, use a 3x3 viewport map unless the user or
repo defines a stricter matrix:

| Family | Small | Medium | Large |
| --- | --- | --- | --- |
| Mobile | 320x568 | 390x844 | 430x932 |
| Tablet | 768x1024 | 834x1194 | 1024x1366 |
| Desktop | 1280x720 | 1440x900 | 1920x1080 |

For each viewport, capture:

- screenshot or visual snapshot;
- console error state;
- relevant network failures;
- layout/overflow/overlap findings;
- ARIA/accessibility findings when UI semantics matter;
- component-system deviations.

If the full 3x3 matrix is not justified, state why and name the reduced matrix.
For product-critical or premium surfaces, missing 3x3 proof is a closure
blocker unless explicitly waived.

## Active Visual Correction

Frontend/browser QA is not a passive report when the branch is supposed to
deliver UI quality. Any in-scope visual, ARIA, layout, responsive, console, or
network defect discovered during QA must enter the correction loop:

```text
detect -> fix -> rerun affected viewport/probe -> compare corrected evidence
```

Do not close on pre-fix screenshots. Closure evidence must show the corrected
state or explicitly classify the defect as waived/deferred/blocked.

## Additional Agnostic QA Gates

Apply these gates when their risk exists in the slice. They are stack-agnostic
and may be proven through unit, integration, contract, browser, log, metric, or
manual runtime evidence as appropriate.

- `Negative Path`
  - backend covers controlled 400/401/403/404/409/422/429 and expected 5xx
    behavior where relevant;
  - frontend covers validation errors, empty/loading/error/success/disabled
    states, and recovery paths.
- `Security/Auth/Ownership`
  - server-side authorization, ownership, CSRF/session, rate-limit/replay, and
    PII exposure boundaries are checked when relevant;
  - frontend protected-route, token handling, and sensitive UI exposure are
    checked when relevant.
- `Concurrency/Idempotency`
  - double submits, retries, duplicate webhooks/jobs/messages, idempotency keys,
    locks, and race-sensitive writes are covered when relevant;
  - frontend rapid-click, optimistic-update, cancellation, and retry states are
    checked when relevant.
- `Performance Minimum`
  - backend latency, query count, N+1, cache behavior, memory, or worker
    pressure is measured or explicitly marked not applicable;
  - frontend LCP/CLS/INP, long tasks, hydration, bundle growth, or equivalent
    runtime cost is checked when relevant.
- `External Resilience`
  - provider down, timeout, retry, backoff, circuit-breaker, and fallback
    behavior is covered when external systems are touched;
  - frontend slow/offline network, request cancellation, and retry UI are
    checked when relevant.
- `Clean State/Cleanup`
  - fixtures, seeds, temporary rows/files, jobs, locks, queues, cookies, local
    storage, service workers, and test artifacts are deterministic and cleaned
    or explicitly retained with rationale.
- `Observability Correlation`
  - correlation/trace/session/request IDs connect frontend action, backend log,
    persistence, job, and provider call where available;
  - the QA packet records the correlation key or states why it is unavailable.

## Browser-Proof Intensity Labels

Every browser-proof packet should classify its breadth as one of:

- `sampled`
- `targeted`
- `broad sweep`
- `full route-family audit`

## Design Implementation Proof

When browser proof is used for design-system application, premium recomposition,
or visual correction, it must also state:

- active visual authorities
- changed route, shell, component, or state
- owner layer from the UI Mutation Ladder
- viewport and state coverage
- comparison target such as source showcase, premium HTML, or approved ASCII
- defects opened, fixed, waived, or deferred
- corrected-state evidence when any in-scope defect was fixed

This is a specialization of browser proof, not a separate shortcut around the
proof stack.

## Named Failure Modes

Name the proof failure explicitly when it appears.

- `browser truth -> Playwright inversion`
  - Playwright regression was authored or used for closure before interactive
    browser truth in Chrome DevTools stabilized the flow.
- `lane-collapse closure`
  - distinct proof lanes were compressed into a vague sentence such as
    `tested successfully`.
- `packetless proof`
  - evidence exists, but the lane did not leave an explicit `QA / Proof Packet`.
- `coverage-claim-without-run`
  - coverage was claimed or implied without rerunning the relevant coverage
    target or declaring no coverage tooling exists.
- `happy-path-only-qa`
  - QA exercised only success paths while in-scope negative/error/empty/loading
    or recovery paths were unproven.
- `backend-log-blind-closure`
  - backend QA closed without capturing/scanning server, worker, test, or
    container logs when backend runtime behavior was in scope.
- `auth-ownership-blind-closure`
  - auth, authorization, ownership, session, CSRF, token, or PII boundaries were
    in scope but not explicitly proved or ruled not applicable.
- `idempotency-race-blind-closure`
  - duplicate submits, retries, concurrent writes, duplicate events, locks, or
    idempotency behavior were in scope but not explicitly proved.
- `resilience-blind-closure`
  - external provider, network, timeout, retry, fallback, or cancellation
    behavior was in scope but not explicitly proved.
- `dirty-state-qa`
  - tests or runtime proof left uncontrolled rows, files, jobs, locks, browser
    storage, service workers, or other state that can pollute later runs.
- `correlation-blind-closure`
  - a traceable runtime flow closed without recording correlation identifiers
    or explaining why they were unavailable.
- `devtools-blind-closure`
  - browser-visible work closed without console and network inspection.
- `responsive-matrix-gap`
  - visual/responsive UI work closed without the required 3x3 matrix or an
    explicit reduced-matrix rationale.
- `aria-blind-ui-closure`
  - UI work with semantic/accessibility impact closed without ARIA/accessibility
    proof or an explicit not-applicable rationale.
- `metricless performance closure`
  - performance or observability was claimed without baseline/post-change
    evidence or an explicit no-metric rationale.
- `pre-fix visual proof`
  - closure proof still shows the state before an in-scope visual defect was
    corrected.
- `proof-not-fed-into-loop`
  - QA/browser/visual proof found a defect but the run did not register,
    correct, reproof, or explicitly waive it before closure.

These are closure-relevant failures, not optional cleanup notes.

## Closure Blocking Rule

Closure must expose proof-lane status, not just accumulated confidence.

Before closure, make visible at least:

- `Backend QA=<present|missing|blocked>`
- `Backend Coverage=<present|missing|not-configured|blocked>`
- `Backend Logs=<present|missing|blocked>`
- `Frontend QA=<present|missing|blocked>`
- `Frontend Coverage=<present|missing|not-configured|blocked>`
- `Frontend Build/Type/Lint=<present|missing|not-applicable|blocked>`
- `Browser-Proof=<present|missing|blocked>`
- `DevTools Console=<present|missing|blocked>`
- `DevTools Network=<present|missing|blocked>`
- `Screenshots=<present|missing|blocked>`
- `ARIA/A11y=<present|missing|not-applicable|blocked>`
- `Responsive 3x3=<present|reduced|missing|not-applicable|blocked>`
- `Persistent E2E=<present|missing|blocked|out of order>`
- `UX/UI Fullstack Surface=<present|missing|blocked|not-applicable>` when the
  slice crosses backend truth, frontend state, and runtime UX/UI behavior
- `Design Implementation Proof=<present|missing|blocked|not-applicable>` when
  design-system or premium UI mutation was active
- `Observability/Performance=<present|missing|blocked|not-applicable>` when
  metrics, logs, query shape, cache, or runtime performance were active
- `Negative Path=<present|missing|not-applicable|blocked>`
- `Security/Auth/Ownership=<present|missing|not-applicable|blocked>`
- `Concurrency/Idempotency=<present|missing|not-applicable|blocked>`
- `Performance Minimum=<present|missing|not-applicable|blocked>`
- `External Resilience=<present|missing|not-applicable|blocked>`
- `Clean State/Cleanup=<present|missing|blocked>`
- `Observability Correlation=<present|missing|not-applicable|blocked>`
- `blocking lane=<lane or none>`

If `Browser-Proof` is missing while `Persistent E2E` is already present for a
runtime-sensitive user flow, treat that as `browser truth -> Playwright
inversion` and keep closure blocked.

Do not accept closure language that hides lane state behind a single generic
claim.

## Calibration Note

Self-service or abuse-sensitive flows may require `anti-abuse-review`, but that
lane is calibration-driven. Do not promote it to mandatory proof by default
unless the branch risk actually justifies it.

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

The browser-proof lane and Playwright lane should never be merged into one
vague sentence.
