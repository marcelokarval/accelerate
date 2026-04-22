---
name: django-service-patterns
description: Codex-native Django service-layer patterns for business logic, ownership-aware access, transactions, and public-ID-safe backend workflows.
user-invocable: true
related-skills: security-patterns, django-inertia-integration, python-testing, celery-tasks
---

# django-service-patterns

Use this skill for business logic, ownership-aware access, transactions, and
service-layer design in the Django backend.

## Purpose

Keep Django backend work aligned with the active project architecture:

- business logic lives in the active project's domain/service layer
- interfaces remain thin
- models remain focused on persistence and invariants
- access and mutation patterns remain safe

This skill supports `Backend Query Correctness` whenever service-owned business
logic is also responsible for an honest relational fetch strategy.

## Load When

Load this skill when the task touches:

- domain/service modules
- web/interface modules
- business workflows, transactions, creation/update/delete rules
- ownership-aware object access
- service extraction or refactoring
- any backend review where `Backend Query Correctness` overlaps service-owned
  list/detail/aggregation behavior

## Operating Lens

- thin interfaces
- service-owned business logic
- public-ID discipline
- safe transaction and async boundaries
- focused responsibilities over `God service` accumulation

## Context Minimum

Before editing backend behavior, identify:

- the affected domain and interface surface
- the business rule or mutation being changed
- ownership and security expectations
- async or transaction sensitivity, if relevant

## Core Rules

1. Put business logic in services, not views.
2. Keep web interfaces thin: parse input, call service, render response.
3. Use ownership-aware lookup helpers for private objects.
4. Use stable public identifiers rather than raw PKs in public-facing flows
   when the active project supports them.
5. Use `transaction.atomic()` and `select_for_update()` for financial or
   concurrency-sensitive operations.
6. Use `F()` expressions for atomic counters and incremental updates.
7. Preserve active project model conventions.
8. Keep services focused. If one service starts mixing orchestration, validation,
   serialization, caching, formatting, and provider concerns, split it.
9. Service correctness does not excuse weak query shape; name N+1, missing
   `select_related`, and missing `prefetch_related` explicitly when present.
10. Choose concurrency strategy explicitly rather than defaulting to whichever
    pattern the codebase happened to use nearby.

## Service Design Guidelines

### Service Responsibilities

- enforce business rules
- orchestrate repository/model operations
- keep transaction boundaries explicit
- return domain objects or structured results consistent with the codebase

Orchestration is acceptable when the service coordinates narrower collaborators.
It is not acceptable when the service absorbs unrelated concerns that should
live in dedicated services, helpers, or interface adapters.

### View Responsibilities

- auth and request gating
- input parsing and form validation
- calling the correct service
- converting result to the active interface response, render, or redirect

### Ownership and Access

- private object access must verify ownership
- avoid naked `get_object_or_404` on user-owned resources
- prefer central helpers and shared patterns over ad hoc checks

### Concurrency Strategy Selection

Use the smallest correct integrity tool for the mutation:

- `F()` expressions:
  - for atomic increments, decrements, counters, quotas, or simple numeric
    state transitions performed directly in the database
- `select_for_update()` inside `transaction.atomic()`:
  - for balance-sensitive, default-flip, multi-row, or workflow-critical state
    where conflicting updates are plausible and the code must inspect then
    mutate locked rows safely
- optimistic locking or version/timestamp checks:
  - for lower-conflict flows where explicit row locks would be excessive and the
    model can tolerate retry-or-reject semantics

Do not use a long lock when an `F()` update is sufficient.
Do not use a blind `save()` when the state can race.

### Availability And Query Shape

Hidden N+1 and weak fetch posture are not only performance smells. In list,
search, dashboard, and reporting surfaces they can become availability abuse
under hostile or amplified usage.

When service-owned logic drives relational surfaces, make the fetch strategy
explicit and carry query-shape proof when the branch requires it.

## Review Checklist

- Is business logic still in the service layer?
- Are ownership checks explicit and consistent?
- Are transaction boundaries correct?
- Is the chosen concurrency strategy explicit and appropriate (`F()`,
  `select_for_update()`, or optimistic locking)?
- Are public IDs preserved across interface boundaries?
- Did this change keep the service focused instead of creating or extending a
  `God service`?
- Could weak query shape or N+1 turn this surface into availability debt under
  real or hostile load?

## Handoff And Escalation

- pair with the active server/frontend integration skill when the interface
  contract is a server-driven render or redirect concern
- hand off to `security-patterns` when the remaining work is primarily access,
  secret, or financial hardening
- hand off to `python-testing` when regression coverage becomes the primary
  missing deliverable

## References

- active project domain modules
- active project interface modules
- active project database helpers
