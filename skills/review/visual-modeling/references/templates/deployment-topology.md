# Deployment / Runtime Topology Template

Use for deployed runtime shape, provider boundaries, infrastructure surfaces, and
operational dependencies.

## Must Include

- deployed units
- provider/runtime boundaries
- data stores
- queues/workers
- secrets/config boundary when touched
- observability or CI/deploy dependency when relevant

## Template

```text
Browser
  │ HTTPS
  ▼
╔══════════════╗       API        ╔══════════════╗
║ Vercel/Next  ║━━━━━━━━━━━━━━━━→ ║ Backend      ║
║ web runtime  ║                  ║ app runtime  ║
╚══════════════╝                  ╚══════╦═══════╝
                                          │
                    ┌─────────────────────┼─────────────────────┐
                    ▼                     ▼                     ▼
              PostgreSQL                Redis                 S3/R2
              persisted truth           cache/queue           objects
```

## Common Mistakes

- omitting workers/queues from runtime claims
- hiding provider boundaries
- failing to distinguish runtime topology from code architecture
