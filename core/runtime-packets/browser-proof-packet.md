# Browser-Proof Packet

Use this packet when browser/runtime truth is required for review or closure.

## Packet

```text
Browser-Proof Packet

- surface / route family: <...>
- runtime target: <local URL, environment, or blocked reason>
- browser tool: <Chrome DevTools|agent-browser|other>
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
