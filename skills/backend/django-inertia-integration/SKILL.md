---
name: django-inertia-integration
description: Use when Django-side Inertia integration involves render flows, props, redirects, CSRF behavior, serialization, shared props, or page-name contracts.
user-invocable: true
related-skills: inertia-patterns, django-service-patterns, front-react-shadcn
---

# django-inertia-integration

Use this skill for Django-side Inertia integration, especially where backend
views, shared props, CSRF behavior, rendering, and redirects meet the React
frontend.

## Purpose

Keep Django + Inertia integration aligned with the active project stack instead
of drifting into generic SPA or API-first patterns.

## Load When

Load this skill when the task touches:

- `inertia.render(...)`
- Django views that back Inertia pages
- CSRF behavior for Inertia mutations
- shared props, redirects, flash messages, serialization
- backend/frontend page-name contracts

## Core Rules

1. Treat Django as the authoritative source for server-driven page props.
2. Keep Inertia views thin: validate, call services, render/redirect.
3. Use the project's established CSRF and request parsing conventions.
4. Keep page names and the frontend page tree aligned.
5. Serialize props explicitly and predictably.

## Accelerate Guidance

- This skill complements `inertia-patterns` from the backend side.
- Backend page names must not drift away from the actual frontend page tree.
- Use Inertia redirects and re-renders rather than inventing parallel API
  responses for page flows that are already server-driven.

## Review Checklist

- Does the Django view behave like an Inertia interface, not a mini API?
- Are props serializable and intentionally shaped?
- Is the page name canonical and aligned with the frontend?

## References

- active Django web/interface modules
- active frontend Inertia configuration
