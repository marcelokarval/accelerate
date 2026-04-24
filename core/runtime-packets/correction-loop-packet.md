# Correction Loop Packet

## Purpose

This packet makes the active correction loop visible when a slice finds a
meaningful in-scope defect and corrects it before promotion.

It is the packet form of:

- `core/review/active-correction-loop.md`

## Use

Emit this packet when the run moves through:

- defect detected
- fix applied
- fresh proof captured

Use it to prevent correction from disappearing into vague "addressed" language.

## Template

```text
Correction Loop Packet

- slice / batch id: <id>
- trigger defect(s): <ids>
- detection evidence: <path|packet|capture>
- owner who corrected: <owner>
- correction summary: <what changed>
- fresh proof run: <tests|browser capture|runtime output>
- corrected-state evidence: <path|packet|capture>
- comparison result: <defect cleared|partial improvement|still failing>
- promotion posture: <promotable|blocked|follow-up-required>
```

## Rule

Do not emit this packet without fresh proof of the corrected state.

If proof still reflects the pre-fix state, the correction loop remains
incomplete.
