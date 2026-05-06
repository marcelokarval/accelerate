# Next + Adonis + Postgres deployment sample

- diagram type: Deployment/runtime topology
- source truth: example-only pattern, not project runtime truth
- binding: demonstrates visual-modeling packet shape

## Artifact

```text
Browser
  │ HTTPS
  ▼
╔══════════════╗       API        ╔══════════════╗
║ Vercel/Next  ║━━━━━━━━━━━━━━━━→ ║ Adonis App   ║
║ web runtime  ║                  ║ Node runtime ║
╚══════════════╝                  ╚══════╦═══════╝
                                          │
                    ┌─────────────────────┼─────────────────────┐
                    ▼                     ▼                     ▼
              PostgreSQL                Redis                 Object Store
              durable truth             jobs/cache            uploads
```

## Callouts

- [1] Mark validation, authority, cardinality, ordering, retry, or async behavior when relevant.
- [2] Bind the diagram to audit/proof/implementation surfaces when used in real work.

## Residuals

- Replace placeholder entities and actors with inspected project truth before using this as evidence.
