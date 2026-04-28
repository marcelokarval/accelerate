# Django ORM Query Shape Gate

The Django ORM is allowed to be expressive, but closure must prove it is not
silently producing N+1 or unbounded query behavior.

## N+1 Risk Triggers

- Rendering lists of models with related user/account/project/billing objects.
- Serializing nested relationships.
- Building Inertia props from querysets.
- Admin changelists or inlines with related fields.
- Export/report/background jobs over multiple rows.
- Per-row permission, billing, or aggregate checks.

## Required Patterns

- Use `select_related` for single-valued foreign keys needed by the response.
- Use `prefetch_related` or `Prefetch` for many-valued relationships.
- Use `annotate`, `Exists`, `Subquery`, or aggregate queries instead of per-row
  count/exists calls.
- Use pagination or explicit bounds for user-visible lists and exports.
- Add indexes or document existing indexes for filter/sort/join paths when query
  shape depends on them.

## Proof Expectations

- Tests should use enough fixtures to expose N+1, not one-row happy paths.
- When feasible, use query-count assertions such as Django's
  `assertNumQueries` or pytest-django query capture.
- If query count is not practical, closure must include code evidence and an
  explicit explanation of why the query shape is bounded.
