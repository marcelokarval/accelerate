---
name: inertia-patterns
description: Codex-native Inertia.js patterns for Django + React, covering server-driven props, navigation, layout hierarchy, partial reloads, and page-name contracts.
user-invocable: true
related-skills: django-inertia-integration, front-react-shadcn, django-service-patterns
---

# inertia-patterns

Use this skill when implementing or reviewing Inertia behavior in Django +
React.

## Purpose

Keep the application aligned with a server-driven Inertia model:

- Django view computes props
- React page renders props
- user acts
- Django recomputes state

This skill is specifically important for:

- page resolution
- hierarchical layouts
- navigation
- partial reloads
- form submission
- polling or deferred props

## Load When

Load this skill when the task touches:

- `inertia.render(...)` in Django
- `@inertiajs/react`
- `router.visit`, `router.reload`, `Link`, `Head`, `usePage`, `useForm`
- page naming or Inertia page resolution
- persistent layouts or layout hierarchy

## Core Rules

1. Treat server props as the primary data source.
2. Do not introduce client-side fetch duplication when the page should be
   server-driven.
3. Use partial reloads for targeted refreshes.
4. Use deferred or optional props when payload size or latency justifies it.
5. Use canonical page naming aligned with the physical `pages/` tree.
6. Prefer hierarchical `layout.tsx` composition for page shells.
7. Use redirects and prop refreshes instead of inventing local cache workflows.

## Accelerate Guidance

### Page Naming

- Inertia page names should converge to the actual `src/pages/**` structure.
- Avoid permanent alias layers that hide architecture drift.

### Layouts

- The private shell should be composed hierarchically.
- Internal section layouts should compose with the shell, not replace it.
- `page.layout = ...` should be treated as legacy in private pages unless a
  migration boundary explicitly says otherwise.

### Forms and Mutations

- Prefer Inertia form submission and Django-side validation.
- Read submitted data from the backend conventions already used by the project.
- Preserve state and scroll when that matches user expectations for filters or
  settings pages.

### Navigation

- Use `router.visit()` or Inertia `Link`.
- Do not use raw `<a href>` for in-app navigation flows.

## Review Checklist

- Is the page still server-driven?
- Is the layout chain resolved from the same canonical page reference?
- Are partial reloads or deferred props being used for a real reason?
- Is navigation preserving shell consistency?

## References

- active frontend entrypoint configured by the stack profile
- active Inertia page resolver
- active Django web interface layer
