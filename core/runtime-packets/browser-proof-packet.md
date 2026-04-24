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
- network/server truth: <responses, redirects, failures, or n/a>
- screenshots/captures: <project-root .tmp paths or blocked>
- defects registered: <ids or none>
- residual route-family gaps: <...>
- readiness impact: <supports-review|supports-closure|still-blocked>
```

## Rules

- A screenshot without route, state, console, and residual-gap context is not
  browser proof.
- `sampled` proof must not be presented as a `broad sweep` or `full
  route-family audit`.
- Capture evidence belongs under the governed project root `.tmp/` tree unless
  the run records an explicit exception.
