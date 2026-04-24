# UX/UI Fullstack Surface Packet

Use this packet when a user-facing slice must reconcile backend truth,
frontend state, UX/UI quality, and browser runtime proof.

## Packet

```text
UX/UI Fullstack Surface Packet

- surface / route: <...>
- user job: <...>
- backend truth owner: <service|view|presenter|route|endpoint|blocked>
- frontend state owner: <page|component|hook|store|blocked>
- visual/UX owner: <design-system|primitive|composite|shell|page|blocked>
- runtime proof owner: <Chrome DevTools|agent-browser|Playwright-after-browser|blocked>
- backend contract proof: <present|missing|blocked>
- frontend state proof: <present|missing|blocked>
- browser proof packet: <path|missing|blocked>
- state coverage: <success|loading|empty|error|auth|permission|blocked|other>
- viewport coverage: <desktop|mobile|both|not-relevant|blocked>
- primary action: <clear|unclear|missing|blocked>
- secondary / escape actions: <clear|unclear|missing|not-relevant>
- copy / trust posture: <clear|ambiguous|unsafe|blocked>
- visual hierarchy posture: <clear|flat|card-soup|blocked>
- defects registered: <ids|none>
- corrected-state proof: <present|not-needed|missing|blocked>
- residual gaps: <...>
- recommendation: <done|follow-up|blocked>
```

## Rules

- A backend-only proof cannot satisfy this packet.
- A screenshot-only proof cannot satisfy this packet.
- If error, blocked, auth, or empty states matter, happy-path-only proof blocks
  closure.
- If defects were fixed, corrected-state browser proof must be present before
  promotion.
