# Browser-Proof Packet

Use this packet when browser/runtime truth is required for review or closure.

## Packet

```text
Browser-Proof Packet

- surface / route family: <...>
- runtime target: <local URL, environment, or blocked reason>
- phase: <server-readiness|browser-capture|readiness-only|capture-failed|persistent-regression-handoff>
- server/readiness preflight: <passed|failed|blocked|not-required> plus HTTP code/probe summary
- server monitor: <pid/liveness if known; stdout/stderr tail if supplied; HTTP code>
- cleanup: <browser closed; helper-owned server killed or external server not owned; fixture leak-check result>
- correction signal: <none|start-or-fix-server|fix-route|install-readiness-checker|inspect-browser-runtime|other>
- browser launched: <yes|no; readiness failures must be no>
- browser tool: <Chrome DevTools|agent-browser|other>
- browser session posture: <fresh|isolated|existing-intentional|profile-conflict-blocked>
- browser profile / isolation: <profile path|--isolated|dedicated userDataDir|n/a|blocked reason>
- intensity: <sampled|targeted|broad sweep|full route-family audit>
- viewport coverage: <desktop|mobile|both|blocked>
- state coverage: <default|loading|empty|error|auth|role|other>
- session/auth posture: <anonymous|seeded user|existing session|blocked>
- console/runtime errors: <none|list>
- console evidence: <project-root .tmp path, n/a, or blocked>
- network/server truth: <responses, redirects, failures, or n/a>
- network evidence: <project-root .tmp path, n/a, or blocked>
- backend/frontend state reconciliation: <present|not-needed|missing|blocked>
- screenshots/captures: <project-root .tmp paths or blocked>
- defects registered: <ids or none>
- visual comparison packet: <path|included|not-needed|blocked>
- residual route-family gaps: <...>
- readiness impact: <supports-review|supports-closure|still-blocked>
```

## Rules

- A screenshot without route, state, console, and residual-gap context is not
  browser proof.
- Console evidence is required whenever browser/runtime truth is used for review
  or closure. `console/runtime errors: none` still needs a captured console log or
  an explicit blocked/n/a rationale.
- Network evidence is required when network/server truth affects the route,
  redirect, mutation, data load, auth, billing, or state being proved. Use `n/a`
  only for static/no-network surfaces and state why in the surrounding packet.
- Browser capture must not launch before target server availability/readiness is
  actively checked. If the local server is absent, unreachable, returning a
  server error, or a supplied server PID is already dead, write a structured
  `server-readiness` failure packet with `browser launched: no`, HTTP
  code/probe detail, server liveness/stdout/stderr detail when supplied, cleanup
  ownership detail, and an explicit correction signal instead of producing
  screenshot-only or empty proof.
- Use `readiness-only` only for server monitoring/preflight evidence that did
  not launch a browser. It can support review of server availability, but it
  cannot close browser-required work.
- Use `capture-failed` after readiness passed but browser automation failed.
  Include browser/runtime stderr/stdout detail, supplied server PID liveness,
  stdout/stderr tails, and a retry/correction signal. If the server was ready for
  preflight but dies before/during browser navigation, classify the reason as a
  server-crash correction instead of a generic browser-runtime failure.
- A successful `browser-capture` packet still hands off to persistent regression
  separately. Every helper packet must include
  `persistent_regression_handoff.required_before_persistent_e2e_claim: true`.
  Do not mark persistent E2E/Playwright as available from one-off capture proof;
  persistent regression stays `planned` until a separate repo-owned proof locator
  exists.
- Fixture tests that start local servers must kill the owned server and leak
  check common server/browser process patterns before passing.
- `sampled` proof must not be presented as a `broad sweep` or `full
  route-family audit`.
- Capture evidence belongs under the governed project root `.tmp/` tree unless
  the run records an explicit exception.
- For UX/UI fullstack surfaces, browser proof must connect visible state to the
  backend/frontend state that produced it.
- For UI mutation, browser proof must include or reference a visual comparison
  packet. Console and network evidence prove runtime health; they do not prove
  visual correctness.
- A screenshot path without written visual findings is evidence capture, not
  visual proof.
- When `Execution-To-Spec Loop Gate` is active, browser proof findings must feed
  the correction loop until fixed, waived, or blocked. Do not treat browser proof
  as a passive report while claiming the loop converged.
- When `Systemic UI Inconsistency Audit Gate` is active, browser proof must name
  whether route/modal/viewport coverage was sampled, targeted, broad, or full.
  Do not imply all routes, all modals, or all viewports were covered unless the
  inventory and evidence prove it.

## Chrome DevTools Profile Conflict Routing

When Chrome DevTools reports a profile conflict like:

```text
The browser is already running for .../chrome-devtools-mcp/chrome-profile. Use --isolated to run multiple browser instances.
Cause: The browser is already running for .../chrome-profile. Use a different `userDataDir` or stop the running browser first.
```

do not treat that as a normal browser-proof failure and do not silently reuse the
busy profile.

Route in this order:

1. Use an isolated browser session (`--isolated`) when the runtime adapter
   supports it.
2. Use a dedicated temporary `userDataDir` under the governed project root
   `.tmp/` when adapter configuration allows it.
3. Intentionally attach to the existing session only when the proof requires the
   existing authenticated state and the packet records `existing-intentional`.
4. If none of the above is possible, mark browser proof as
   `profile-conflict-blocked` and continue with non-browser validation only as a
   partial result.

Never close browser-required work from a `profile-conflict-blocked` state. A
blocked browser session can support a residual-risk report, not closure.

Record the decision in `browser session posture` and `browser profile /
isolation`.
