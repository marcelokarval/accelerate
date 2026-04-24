# Defect Ledger Packet

## Purpose

This packet is the runtime update shape for concrete defects found during a
slice or proof lane.

It is the packet form of:

- `core/review/defect-ledger.md`

## Use

Emit this packet when the run needs to make defect status visible without
waiting for closure.

Typical triggers:

- micro-review checkpoint
- subagent return
- browser-proof pass
- backend/frontend QA pass
- review-of-review finding

## Template

```text
Defect Ledger Packet

- slice / batch id: <id>
- defect summary:
  - id=<id>, type=<type>, severity=<severity>, owner=<owner>, status=<status>
  - id=<id>, type=<type>, severity=<severity>, owner=<owner>, status=<status>
- blocking defects: <ids or none>
- newly opened defects: <ids or none>
- defects fixed this slice: <ids or none>
- defects awaiting reproof: <ids or none>
- waived defects: <ids or none>
- evidence roots:
  - <path|packet|capture>
- promotion impact: <clear|blocked|follow-up-required>
```

## Rule

Do not let "quality concerns" replace explicit defect disposition when real
defects are already known.

If the defect is meaningful enough to mention, it is usually meaningful enough
to classify.
