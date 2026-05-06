# Next + Adonis container sample

- diagram type: C4/topology
- source truth: example-only pattern, not project runtime truth
- binding: demonstrates visual-modeling packet shape

## Artifact

```text
External User
     │
     ▼
╔════════════════ PROP/APP SYSTEM ═══════════════╗
║                                                ║
║  ╔════════════╗       ╔════════════╗           ║
║  ║ Next.js UI ║━━━━━━→║ Adonis API ║           ║
║  ║ owns UX    ║       ║ owns truth ║           ║
║  ╚════════════╝       ╚═════╦══════╝           ║
║                             │                  ║
║                       ╔═════▼══════╗           ║
║                       ║ PostgreSQL ║           ║
║                       ╚════════════╝           ║
╚════════════════════════════════════════════════╝
```

## Callouts

- [1] Mark validation, authority, cardinality, ordering, retry, or async behavior when relevant.
- [2] Bind the diagram to audit/proof/implementation surfaces when used in real work.

## Residuals

- Replace placeholder entities and actors with inspected project truth before using this as evidence.
