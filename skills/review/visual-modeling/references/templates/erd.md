# ERD Template

Use for persisted entities, relational cardinality, constraints, ownership, and tenant boundaries.

## Must Include

- entities/tables
- primary keys and important unique constraints
- foreign keys
- cardinality
- tenant/owner boundary when relevant
- indexes/constraints when they drive behavior

## Template

```text
╔════════════════╗        1 ─── *        ╔════════════════╗
║ users          ║━━━━━━━━━━━━━━━━━━━━━━→║ leads          ║
╠════════════════╣                       ╠════════════════╣
║ id PK          ║                       ║ id PK          ║
║ public_id UQ   ║                       ║ public_id UQ   ║
║ email UQ       ║                       ║ owner_id FK [1]║
╚════════════════╝                       ╚════════════════╝
                                               │
                                               │ 1 ─── *
                                               ▼
                                      ╔════════════════════╗
                                      ║ lead_events        ║
                                      ╠════════════════════╣
                                      ║ id PK              ║
                                      ║ lead_id FK         ║
                                      ║ event_type         ║
                                      ╚════════════════════╝
```

## Callouts

- [1] Owner/tenant boundary: identify whether access checks use `owner_id`, team, org, or another authority.

## Common Mistakes

- drawing entities without cardinality
- omitting uniqueness and ownership constraints
- hiding join tables in many-to-many relationships
