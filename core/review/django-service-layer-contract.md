# Django Service Layer Contract

Django implementation must keep business decisions in service/query boundaries
instead of scattering them across views, serializers, tasks, forms, or admin
classes.

## Default Shape

- Views/controllers handle request parsing, auth decorators/middleware posture,
  form binding, Inertia rendering, and response selection.
- Services own business mutations, ownership-aware state changes, and transaction
  boundaries.
- Query helpers/selectors own read/query shape for reusable complex reads.
- Tasks are thin orchestration wrappers that call services and preserve
  idempotency/retry expectations.
- Admin actions delegate to services for domain mutations.

## Required Mutation Rules

- Ownership and validation happen before mutation.
- Multi-row mutations use transactions when partial write would be unsafe.
- External side effects are idempotent or guarded by recovery state.
- Services return explicit outcomes or raise domain exceptions; views translate
  those to UX/API responses.

## Closure Rule

For Django backend work, service-layer proof is mandatory when business logic,
ownership-sensitive reads, mutations, async tasks, or admin actions change. A
view-local implementation can close only with an explicit bounded exception and
proof that no reusable business rule or ownership decision was introduced.

## Subagent Boundary

A future Django backend subagent must treat this contract as mandatory. It may
edit models, services, views, tasks, tests, and admin surfaces only while keeping
the ownership and query-shape gates satisfied.
