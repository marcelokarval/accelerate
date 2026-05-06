# ORM Lifecycle Template

Use when the relation between schema/model, query API, services, presenters, and
UI/API contract is the decision surface.

## Must Include

- ORM/model/schema owner
- migration/table truth when applicable
- query/service boundary
- presenter/DTO/props boundary
- validation or authorization boundary when relevant

## Template

```text
╔══════════════╗     ╔══════════════╗     ╔══════════════╗
║ ORM Model    ║━━━━→║ Service      ║━━━━→║ Presenter    ║
║ schema truth ║     ║ rules/mutate ║     ║ safe shape   ║
╚══════╦═══════╝     ╚══════╦═══════╝     ╚══════╦═══════╝
       │                    │                    │
       ▼                    ▼                    ▼
 DB constraints       business rules       UI/API contract
```

## Stack Notes

- Django: `Model -> Manager/QuerySet -> Service -> Task/View -> Inertia props`
- Adonis/Lucid: `Lucid Model -> Query Builder -> Service -> Controller -> Resource/DTO`
- Prisma: `schema.prisma -> generated client -> server-only DAL -> action/route -> UI`
- Drizzle: `schema.ts -> migration SQL -> typed query -> DAL -> route/action`

## Common Mistakes

- treating ORM objects as database truth
- letting views/controllers own business mutations
- skipping DTO/presenter boundary when frontend contract matters
