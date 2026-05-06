# Lead lifecycle sample

- diagram type: State machine
- source truth: example-only pattern, not project runtime truth
- binding: demonstrates visual-modeling packet shape

## Artifact

```text
╔══════════╗ qualify  ╔══════════╗ accept   ╔══════════╗
║ captured ║━━━━━━━━→ ║ reviewed ║━━━━━━━━→ ║ active   ║
╚══════════╝          ╚════╦═════╝          ╚════╦═════╝
                           │ reject              │ close
                           ▼                     ▼
                     ╔══════════╗          ╔══════════╗
                     ║ rejected ║          ║ closed   ║
                     ╚══════════╝          ╚══════════╝
```

## Callouts

- [1] Mark validation, authority, cardinality, or async behavior when relevant.
- [2] Bind the diagram to audit/proof/implementation surfaces when used in real work.

## Residuals

- Replace placeholder entities and actors with inspected project truth before using this as evidence.
