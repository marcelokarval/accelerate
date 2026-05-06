# Stack Trigger Matrix

Use this matrix to pick diagrams for Accelerate stack profiles and recurring work.

## Django + Inertia + React

Required/recommended diagrams:

- ERD for model/table/constraint changes
- ORM lifecycle for `Model -> QuerySet/Manager -> Service -> Presenter -> Inertia props`
- sequence for Celery tasks, auth flows, provider callbacks, and side effects
- swimlane/journey for user/lead/operator workflows
- trust boundary/dataflow for auth, uploads, exports, billing, and IDOR-sensitive work

## Next.js + AdonisJS + AdminJS

Required/recommended diagrams:

- architecture topology for Next.js UI vs Adonis backend truth vs AdminJS operator surface
- ERD for Lucid/PostgreSQL persistence
- sequence for controller/provider/job flows
- agent/team topology when work is delegated across lanes
- trust boundary/dataflow for auth/session/provider/admin masking

## Next.js + Prisma

Required/recommended diagrams:

- ERD for `schema.prisma`
- ORM lifecycle for generated client -> server-only DAL -> action/route -> UI
- sequence for Server Action mutations and provider callbacks
- trust boundary/dataflow for session/provider boundaries

## Next.js + Drizzle

Required/recommended diagrams:

- ERD/table relationship for Drizzle schema
- migration/query ownership diagram
- sequence for mutation and cache invalidation
- trust boundary/dataflow for raw SQL exceptions and provider ingress

## Runtime / Queue / Provider Work

For Celery, BullMQ, pg-boss, Inngest, QStash, Trigger.dev, RabbitMQ, Redis,
Stripe, mail, uploads, and external callbacks:

- sequence for actor/system order
- queue topology for producer/consumer/retry/DLQ
- state machine for lifecycle/status changes
- trust boundary/dataflow for sensitive payloads

## Accelerate Control Plane

For Accelerate itself:

- governance topology for branch/issue/proof/closure truth
- agent communication for root/subagent delegation and return contracts
- state machine for capability promotion or branch lifecycle
- sequence for workflow adapters and live-provider proof
- trust boundary/dataflow for remote write surfaces and credential boundaries
