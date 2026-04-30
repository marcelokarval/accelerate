# Agent Return Packet

Use this packet for promoted or candidate bounded agent returns.

## Packet

```text
Agent Return Packet

- agent family / role: <...>
- assigned task or slice id: <...>
- assigned scope: <...>
- actual scope touched: <...>
- write scope used: <paths|read-only|none>
- files / surfaces inspected or changed: <...>
- evidence roots: <...>
- validations / proof run: <...>
- requested-vs-implemented: <met|partial|missed|blocked + notes>
- self-review: <summary>
- self-forensic review: <summary>
- defects found and disposition suggestion: <...>
- residual risks: <...>
- recommendation: <done|partial|follow-up|blocked>
- final closure authority statement: <root-owned|missing>
- orchestrator handling: <accepted-for-integration|needs-review|needs-correction|conflicts-with-other-return|rejected-out-of-scope|blocked>
```

## Rule

Agent returns are inputs to root review. They never substitute for independent
review, review-of-review, or final forensic closure.
