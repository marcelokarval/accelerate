# Django Backend Safety Gate

Django backend work must not be promoted on functional correctness alone. The
root must require ownership, query-shape, validation, and service-boundary proof
before closure.

## Mandatory Checks

- Ownership / IDOR proof for object reads, mutations, exports, billing actions,
  settings, admin actions, and any user-scoped data.
- Query-shape proof for list/detail pages, Inertia props, serializers, admin
  changelists, background jobs, and exports.
- Service-layer boundary proof for business logic and mutations.
- Backend validation proof for domain-sensitive inputs.
- Negative tests for cross-user or cross-tenant access when the surface is scoped.

## Forbidden Promotion Patterns

- `Model.objects.get(id=...)` or `get(pk=...)` in views/services without an owner,
  tenant, organization, project, or permission scope filter.
- Querying related objects inside loops without a documented bounded reason.
- Returning object existence differences that enable enumeration when ownership
  should fail closed.
- Mutating objects before ownership and validation are both established.
- Treating frontend filtering, hidden buttons, or admin visibility as access
  control.

## Required Evidence

- Code path showing scoped queryset or permission/ownership check.
- Tests proving another user/tenant cannot read or mutate the object.
- Query count or equivalent query-shape evidence for N+1-risk views and services.
- Proof of `select_related`, `prefetch_related`, `annotate`, subquery, pagination,
  or explicit bounded-query decision where relevant.
