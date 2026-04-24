# Seam Proof Packet

## Purpose

This packet captures seam-focused proof when full-route or broad runtime proof
would be too coarse.

It is the packet form of:

- `core/review/seam-proof.md`

## Use

Emit this packet when the likely defect lives at a seam such as:

- shell vs shell sibling
- layout vs content
- state A vs state B
- service vs contract
- docs claim vs runtime behavior

## Template

```text
Seam Proof Packet

- seam id / label: <label>
- slice / batch id: <id>
- seam type: <ui|backend|runtime|governance>
- authorities compared:
  - <layer|artifact>
  - <layer|artifact>
- states compared:
  - <state>
  - <state>
- evidence used:
  - <capture|packet|output>
- defect verdict: <none|found>
- defect ids: <ids or none>
- residual uncertainty: <...>
- temporary evidence root: <project-root/.tmp/...|n/a>
```

## Rule

Use this packet when the seam is the honest proof target.

Do not pretend a broad proof packet is enough if the branch is really deciding
whether a critical seam regressed.
