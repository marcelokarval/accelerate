# Governance / Issue / Proof Topology Template

Use for Accelerate control-plane truth: issue stacks, branch packets, proof order,
review lanes, adapter capabilities, and closure authority.

## Must Include

- governing issue or branch root
- child/slice topology
- proof lane order
- closure authority
- blocked/substitute capabilities when relevant

## Template

```text
╔════════════════════════════════╗
║ Governing Issue / Branch Root  ║
╚════════════════╦═══════════════╝
                 │
       ┌─────────┼─────────┐
       ▼         ▼         ▼
   Backend    Frontend   Proof
   Slice      Slice      Lane
       │         │         │
       └─────────┴─────────▼
              Closure Review
```

## Proof Order

```text
Implementation proof
    ↓
Backend/frontend QA proof
    ↓
Browser truth when runtime-facing
    ↓
Persistent regression when required
    ↓
Forensic closure
```

## Common Mistakes

- issue children with no dependency direction
- closure authority assigned to implementer
- proof lane collapsed into a summary
