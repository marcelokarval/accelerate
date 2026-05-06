# C4 / Architecture Topology Template

Use for system context, containers, components, and ownership boundaries.

## Must Include

- system boundary
- external actors/providers
- containers/components
- ownership of truth
- adjacent systems and integration paths

## Container Template

```text
External User
     │
     ▼
╔════════════════ SYSTEM BOUNDARY ════════════════╗
║                                                ║
║  ╔════════════╗       ╔════════════╗           ║
║  ║ Web UI     ║━━━━━━→║ Backend    ║           ║
║  ║ owns UX    ║       ║ owns truth ║           ║
║  ╚════════════╝       ╚═════╦══════╝           ║
║                             │                  ║
║                       ╔═════▼══════╗           ║
║                       ║ PostgreSQL ║           ║
║                       ╚════════════╝           ║
╚════════════════════════════════════════════════╝
```

## Common Mistakes

- not labeling truth ownership
- hiding external systems/providers
- mixing deployment details into context-level diagrams without a reason
