# Stack Diagram Selection

Use this reference to pick diagram types for the stack profiles and recurring systems governed by Accelerate.

## Django + Inertia + React

Prefer these diagrams:

- ERD for model/table/cardinality/constraint changes
- ORM lifecycle for `Model -> QuerySet/Manager -> Service -> Presenter -> Inertia props`
- Inertia contract diagram for server props, page ownership, and React state
- Celery sequence or queue topology for async work
- permission/ownership trust-boundary diagram for IDOR-sensitive surfaces
- admin/operator journey for Django Admin or custom operator flows

Compact shape:

```text
Django Model ━━→ Service ━━→ Inertia View ━━→ React Page
     │              │              │              │
     ▼              ▼              ▼              ▼
 constraints   business rules   props shape   UI states
```

## Next.js + AdonisJS + AdminJS

Prefer these diagrams:

- authority split diagram: Next.js UI shell vs Adonis backend truth vs AdminJS operator surface
- Lucid ERD for persistence changes
- service/controller/validator sequence for backend behavior
- AdminJS resource/action/masking diagram for operator access
- provider callback sequence for Stripe, OAuth, mail, uploads, or webhooks
- deployment topology for Next.js + Adonis + Postgres + workers/providers

Compact shape:

```text
Next.js product UI
        │ user-facing contract
        ▼
Adonis backend truth ━━→ Lucid/PostgreSQL
        │
        ├─ Auth / authorization / validation
        ├─ jobs / mail / provider callbacks
        └─ AdminJS operator resources
```

## Next.js + Prisma

Prefer these diagrams:

- Prisma ERD for `schema.prisma` relationships
- generated-client boundary diagram
- server-only DAL diagram
- Server Action or Route Handler mutation sequence
- cache invalidation flow
- trust-boundary diagram for auth/session/provider callbacks

Compact shape:

```text
schema.prisma ━━→ generated client ━━→ server-only DAL ━━→ action/route ━━→ UI contract
```

## Next.js + Drizzle

Prefer these diagrams:

- table relationship diagram from Drizzle schema
- migration generation flow
- SQL/query ownership diagram
- raw SQL exception diagram when needed
- DTO/UI contract flow

Compact shape:

```text
Drizzle schema ━━→ migration SQL ━━→ typed query ━━→ DAL ━━→ DTO/UI
```

## Runtime / Queue / Provider Work

For Celery, BullMQ, pg-boss, Inngest, QStash, Trigger.dev, RabbitMQ, Redis, Stripe, uploads, mail, and external callbacks, prefer:

- sequence diagram for actor/system ordering
- queue topology for producer/consumer/retry/DLQ
- state machine for lifecycle changes
- trust-boundary/dataflow diagram for sensitive payloads

Compact shape:

```text
Producer ━━→ Queue ━━→ Worker ━━→ DB/provider
               │          │
               ▼          ▼
            retry/DLQ   idempotency proof
```

## Accelerate Control Plane

For Accelerate itself, prefer:

- issue topology diagram for parent/child/dependency truth
- lane ownership diagram for lifecycle/technical/design/proof/trust/closure lanes
- agent communication diagram for delegation and return contracts
- proof-order diagram for implementation → QA → browser → regression → closure
- runtime packet flow for Branch Entry Packet → Runtime Delta Packet → Closure Packet
- capability promotion lifecycle for planned/blocked/substitute/native/available truth

Compact shape:

```text
Branch Entry Packet ━━→ Runtime Delta Packet ━━→ Review Packet ━━→ Closure Packet
        │                       │                    │                 │
        ▼                       ▼                    ▼                 ▼
 classification             evidence            review gaps        final verdict
```
