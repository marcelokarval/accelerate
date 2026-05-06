# Stripe webhook sample

- diagram type: Sequence
- source truth: example-only pattern, not project runtime truth
- binding: demonstrates visual-modeling packet shape

## Artifact

```text
User       Frontend       Backend        Stripe         Ledger DB
 │            │             │              │              │
 │ checkout   │             │              │              │
 ├───────────→│ create      │              │              │
 │            ├────────────→│ intent       │              │
 │            │             ├─────────────→│              │
 │            │ client sec  │              │              │
 │            │←════════════┤              │              │
 │ pay        │             │              │              │
 ├───────────→│             │ webhook [1]  │              │
 │            │             │← - - - - - - ┤              │
 │            │             ├────────────────────────────→│
```

## Callouts

- [1] Mark validation, authority, cardinality, or async behavior when relevant.
- [2] Bind the diagram to audit/proof/implementation surfaces when used in real work.

## Residuals

- Replace placeholder entities and actors with inspected project truth before using this as evidence.
