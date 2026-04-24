# Design Implementation Proof Packet

## Purpose

This packet makes contract-driven UI implementation proof visible.

It is the packet form of:

- `core/control-plane/design-implementation-proof-gate.md`

## Use

Emit this packet when a design-system package, premium direction, visual
reference, or approved UI composition drives mutation of a runtime surface.

Typical triggers:

- `apply-design-system-contract` implementation or correction
- premium-direction implementation
- browser-proof pass for a visual / artifact-driven frontend branch
- UI polishing observer finds in-scope drift during an active slice
- corrected-state proof after a visual defect fix

## Template

```text
Design Implementation Proof Packet

- target surface: <route|shell|component|state>
- active branch: <branch>
- contract authority: <path|none>
- source visual evidence: <path|none>
- premium authority: <path|none>
- rollout / task driver: <path|issue|plan>
- owner layer: <token|derived-token|primitive|composite|registry|shell|page>
- component mapping:
  - source-observed: <items>
  - code-available: <items>
  - premium-proposed: <items>
  - not-approved-yet: <items|none>
- anatomy fixed: <yes|no|n/a + notes>
- token changes allowed: <yes|no|n/a + notes>
- viewport coverage: <viewports>
- state coverage: <states>
- runtime adapter used: <Chrome DevTools|agent-browser|other>
- captures: <paths>
- artifact comparison result: <aligned|drift|blocked>
- defects opened: <ids|none>
- defects fixed / reproved: <ids|none>
- residual drift: <none|list>
- promotion posture: <promotable|blocked|follow-up-required>
```

## Rule

Do not use this packet as a design claim without runtime evidence.

If UI changed and the proof is code-only, the packet is incomplete. If defects
were fixed and captures still show the pre-fix state, the packet remains
blocked.
