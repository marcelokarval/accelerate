# QA And Proof Stack

## Purpose

Use this module when the work needs explicit QA lane ownership instead of a
generic "tests/review later" posture.

## Rule

Truth moves through five distinct layers:

1. implementation proof
2. backend/frontend QA proof
3. browser truth
4. persistent regression proof
5. forensic closure

Do not collapse these into a single vague `tested` claim.

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
  - design implementation proof for contract-driven or premium UI mutation
  - optional agent-browser-style CLI operations after the flow is bounded
  - when exploratory browser QA and issue capture are the main need, `dogfood`
    is a valid lane companion
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

Use an `agent-browser` adapter only after browser truth is bounded enough that
its higher automation power will not hide the real user path.

Only persist to Playwright after the interactive truth is stable enough to be
worth automating.

When persistent proof is needed, use the local Playwright adapter fixtures in
`adapters/runtime/playwright/` instead of an informal test note.

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
- `pre-fix visual proof`
  - closure proof still shows the state before an in-scope visual defect was
    corrected.

These are closure-relevant failures, not optional cleanup notes.

## Closure Blocking Rule

Closure must expose proof-lane status, not just accumulated confidence.

Before closure, make visible at least:

- `Backend QA=<present|missing|blocked>`
- `Frontend QA=<present|missing|blocked>`
- `Browser-Proof=<present|missing|blocked>`
- `Persistent E2E=<present|missing|blocked|out of order>`
- `Design Implementation Proof=<present|missing|blocked|not-applicable>` when
  design-system or premium UI mutation was active
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
