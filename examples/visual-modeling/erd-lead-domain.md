# Lead domain sample

- diagram type: ERD
- source truth: example-only pattern, not project runtime truth
- binding: demonstrates visual-modeling packet shape

## Artifact

```text
╔══════════════╗        1 ─── *        ╔══════════════╗
║ users        ║━━━━━━━━━━━━━━━━━━━━━━→║ leads        ║
╠══════════════╣                       ╠══════════════╣
║ id PK        ║                       ║ id PK        ║
║ public_id UQ ║                       ║ owner_id FK  ║
╚══════════════╝                       ╚══════╦═══════╝
                                              │ 1 ─── *
                                              ▼
                                      ╔══════════════╗
                                      ║ lead_events  ║
                                      ╚══════════════╝
```

## Callouts

- [1] Mark validation, authority, cardinality, or async behavior when relevant.
- [2] Bind the diagram to audit/proof/implementation surfaces when used in real work.

## Residuals

- Replace placeholder entities and actors with inspected project truth before using this as evidence.
