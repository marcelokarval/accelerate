# Product-Critical Closure Packet

Use this packet when the active branch is a product-critical user surface such
as auth, onboarding, billing, recovery, account settings, destructive actions,
or other flows where technical correctness can still be a product failure.

## Packet

```text
Product-Critical Closure Packet

- surface: <...>
- user/job at risk: <...>
- backend truth: <complete|partial|missing|blocked>
- action model: <primary action, secondary action, escape/cancel path>
- product state coverage: <success|empty|error|loading|blocked|role-specific>
- copy and trust posture: <clear|ambiguous|unsafe|blocked>
- visual hierarchy / CTA posture: <clear|diluted|amateur|blocked>
- browser proof packet: <path or blocked>
- UX/UI fullstack surface packet: <path|not-needed|blocked>
- requested-vs-implemented packet: <path or blocked>
- defect ledger status: <clear|open-defects-remain|waived-defects-present>
- residual user harm: <none|accepted|blocks closure>
- recommendation: <done|follow-up|blocked>
```

## Closure Blockers

- backend truth is too thin for the UI state being shown
- primary user action is unclear, diluted, or missing
- error/blocked states are not represented for a critical flow
- browser proof is absent for a runtime-sensitive path
- backend truth, frontend state, and UX/UI runtime behavior were not reconciled
  for a fullstack surface
- product defects are described but not registered and dispositioned
