# Agent Communication Template

Use for multi-agent execution, delegation, lane ownership, return contracts, and closure authority.

## Must Include

- root authority
- delegated agents/lanes
- allowed communication paths
- prohibited paths when relevant
- return artifacts/evidence
- closure owner

## Template

```text
╔════════════════════════╗
║ Accelerate Root        ║
║ owns topology/closure  ║
╚═══════════╦════════════╝
            │ bounded assignment packet
            ▼
╔════════════════════════╗        evidence packet        ╔══════════════════════╗
║ Backend Implementer    ║━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━→║ Root Review Lane     ║
║ owns service slice     ║                               ║ validates closure    ║
╚═══════════╦════════════╝                               ╚══════════════════════╝
            │
            │ allowed: request clarification through root
            │ blocked: direct closure / restaffing
            ▼
       bounded work only
```

## Callouts

- Mark which agent can mutate files, create issues, review, or close.
- Mark cross-agent communication that must return through root.

## Common Mistakes

- letting worker agents inherit root authority
- omitting evidence return path
- hiding who owns final closure
