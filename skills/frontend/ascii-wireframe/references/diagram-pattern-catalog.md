# Diagram Pattern Catalog

Use this catalog as the first-pass menu of ASCII diagram families before choosing a concrete visual artifact.

## Pattern Matrix

| Diagram family | Use when | Primary truth shown | Typical adjacent skills |
| --- | --- | --- | --- |
| UI wireframe | Screen shape, component placement, modal/page ownership, responsive surface | Product surface and interaction zones | `ascii-wireframe`, `product-runtime-review`, `front-react-shadcn` |
| ERD / data model | Schema, tables, constraints, cardinality, tenant ownership | Persisted relational truth | `database-design`, `postgresql`, `postgres-best-practices` |
| ORM lifecycle | Model/query/service/presenter boundaries | Runtime data-access authority | `django-service-patterns`, `adonisjs-patterns`, `prisma-patterns`, `drizzle-patterns` |
| Class / module diagram | Classes, functions, files, modules, imports, ownership | Code structure and dependency direction | `architecture`, `typescript-pro`, `python-pro`, `component-extraction` |
| Sequence diagram | Webhooks, auth, payments, queues, provider callbacks, multi-agent handoffs | Ordered interaction across actors/systems | `stripe-integration`, `payment-integration`, `celery-tasks`, `bullmq-patterns`, `subagent-governance` |
| State machine | Lead, onboarding, billing, issue, agent, queue, or recovery lifecycle | Allowed states and transitions | `architecture`, `validation-governance`, `anti-abuse-review` |
| Swimlane / journey | User/lead/owner/operator/provider path across touchpoints | Actor responsibility over time | `product-runtime-review`, `linear-implementation-planner`, `realoffr-ops-routing` |
| Agent / team topology | Agent families, personas, delegation, return contracts, closure authority | Decision ownership and communication paths | `subagent-governance`, `parallel-agents`, `executing-plans` |
| C4 / architecture topology | System context, containers, components, external dependencies | System boundary and component ownership | `architecture`, `api-surface-governance`, `dependency-governance` |
| Deployment / runtime topology | Hosting, workers, DB, cache, storage, providers, CI/CD | Runtime infrastructure and failure surface | `vercel-deployment-patterns`, `s3-r2-storage-patterns`, `redis-patterns` |
| Queue topology | Producer/consumer, retry, delay, DLQ, idempotency | Async execution path and failure handling | `celery-tasks`, `bullmq-patterns`, `pgboss-patterns`, `qstash-patterns`, `triggerdev-patterns` |
| Trust boundary / dataflow | Auth, uploads, billing, exports, recovery, hostile path risk | Sensitive data and authority crossing | `security-patterns`, `anti-abuse-review`, `untrusted-ingress-hardening` |
| Governance / issue topology | Parent/child issues, proof order, gates, runtime packets, closure | Accelerate control-plane truth | `accelerate`, `linear-pm`, `github-issues`, `verification-before-completion` |

## Notation Guidance

Use notation that matches the decision:

```text
ERD             entity/table boxes + cardinality
ORM lifecycle   source model → query/service → presenter/DTO → consumer
Sequence        columns or actor rows with ordered arrows
State machine   state boxes + named transition arrows
Swimlane        actor rows + time/step columns
Agent topology  authority boxes + allowed/blocked arrows
C4/topology     nested system/container/component boxes
Dataflow        boundary boxes + sensitive payload labels
```

## Selection Rule

Prefer one strong diagram over a hybrid blob.

If two truths matter, draw two diagrams:

```text
Payment work
├─ sequence: user → app → Stripe → webhook → ledger
└─ state machine: trialing → active → past_due → canceled
```

Do not combine ERD, sequence, and UI wireframe into one unreadable artifact unless the goal is only a tiny overview.
