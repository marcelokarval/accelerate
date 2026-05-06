# Proof lane sample

- diagram type: Agent communication
- source truth: example-only pattern, not project runtime truth
- binding: demonstrates visual-modeling packet shape

## Artifact

```text
╔══════════════════╗ assignment ╔══════════════════╗
║ Accelerate Root  ║━━━━━━━━━━→ ║ Worker Agent     ║
║ owns closure     ║            ║ bounded slice    ║
╚════════╦═════════╝            ╚════════╦═════════╝
         │ evidence packet               │ no closure authority
         ▼                               ▼
╔══════════════════╗             bounded proof only
║ Review Lane      ║
╚══════════════════╝
```

## Callouts

- [1] Mark validation, authority, cardinality, or async behavior when relevant.
- [2] Bind the diagram to audit/proof/implementation surfaces when used in real work.

## Residuals

- Replace placeholder entities and actors with inspected project truth before using this as evidence.
