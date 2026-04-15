# Trivial Branch Contract

Use this module when the question is not whether work is small, but what
minimum workflow stack remains mandatory even for bounded trivial execution.

## Core Principle

`trivial` means the smallest valid workflow stack, not workflow absence.

## Trivial Classes

### Trivial Read-Only

Use when all are true:

- no repo mutation
- bounded scope
- no meaningful cross-surface coordination
- no planning artifact needed
- no runtime/browser proof lane needed

Minimum stack:

- `napkin`
- `accelerate`
- `Truth Ownership Check`
- `Stack Adherence`
- minimum relevant stack skill only if needed
- compact `Branch Entry Packet`
- honest verification before closure

### Trivial Mutation

Use when all are true:

- mutation is tiny and bounded
- no meaningful cross-surface coordination
- no decomposition or rollout planning needed
- no heavy runtime proof lane needed

Minimum stack:

- `napkin`
- `accelerate`
- `Truth Ownership Check`
- `Stack Adherence`
- `Issue Bootstrap Gate` when mutating code, workflow seeds, or living docs
- minimum relevant stack skill
- compact `Branch Entry Packet`
- honest verification before closure

## Trivial Packet Shape

```text
Branch Entry Packet

- classification: trivial
- active branch: trivial read-only | trivial mutation
- active persona: <blocking owner>
- active stack: <surface>
- active skills: <minimum set>
- active ADRs / references: <only if actually relevant>
- gate ledger: <minimal gate state>
- phase / SDLC: Execute / Verify
- closure blockers: <none or one-line truth>
```

## Trivial Do / Do Not

### Do

- keep the stack minimal
- keep commentary compact
- still make classification visible
- still verify honestly
- still respect issue bootstrap when mutation governance applies

### Do Not

- skip `accelerate`
- treat trivial as governance-free
- spawn subagents by habit
- create planning artifacts without real need
- use browser-proof or Playwright by default when the branch does not need them

## Escalation Out Of Trivial

Exit trivial immediately if any of these becomes true:

- cross-surface coordination appears
- branch risk grows
- runtime truth is required
- issue/plan complexity expands
- visual uncertainty becomes structural
- sensitive auth/billing/ownership/abuse risk appears
