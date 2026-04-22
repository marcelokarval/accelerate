---
name: i18n-patterns
description: Use when user-facing text, locale packs, translation boundaries, runtime locale proof, backend/frontend copy ownership, or mixed-language drift are part of the change.
user-invocable: true
related-skills: front-react-shadcn, server-prop-governance, django-inertia-integration, auth-form-patterns
---

# i18n-patterns

Use this skill when user-facing text, locale packs, translatable backend errors,
or backend/frontend display boundaries are part of the change.

This is not only a translation helper. It is the governance layer for:

- locale-pack integrity
- backend/frontend text ownership
- runtime mixed-language drift prevention
- non-default locale closure proof

## Purpose

Keep i18n work aligned with the active project model:

- the active frontend i18n library
- supported locales from the active project
- backend authority over truth and codes
- frontend authority over final human-readable copy and locale formatting

## Load When

Load this skill when the task touches:

- user-facing strings in pages, components, dialogs, toasts, banners, tables,
  summaries, or empty states
- translation JSON files
- backend-generated error keys that surface in the frontend
- backend display labels, serialized copy, or presenter fields that may drift
  into frontend-owned i18n territory
- mixed-language runtime regressions
- new user-facing surfaces that need closure in more than the default locale

Use this skill as the primary one when the main problem is i18n drift or
governance. Use it as a supporting skill when the main problem is frontend
implementation, auth UX, or server-prop contract design.

## Core Boundary Model

### Backend owns

- truth
- codes
- enums
- flags
- timestamps
- amounts
- translation keys when explicitly needed
- stable translatable error identifiers

### Frontend owns

- final copy
- locale formatting
- labels
- helper text
- presentation wording
- `t()` usage and namespace composition

The backend must not become a shortcut for localized user-facing copy when the
frontend already owns i18n.

## Hard Rules

1. Every new user-facing string must be governed by i18n unless a narrow local
   exception is explicitly justified.
2. Add or update keys across all supported locales: `en`, `pt`, `es`.
3. Do not treat English fallback text as closure proof.
4. Do not let fallbacks mask missing keys, namespace drift, or contract drift.
5. Prefer explicit stable keys over dynamic key construction.
6. Keep naming grouped by domain, flow, or stable UX region, not by arbitrary
   component filename.
7. Backend-fed display strings must be audited before they are accepted into a
   user-facing surface.
8. Mixed-language runtime is a regression, not cosmetic noise.

## Locale Pack Structure

Locate the active project's locale packs before editing. Common examples:

- `public/locales/<locale>/`
- `src/locales/<locale>/`
- app-specific translation modules

Do not invent a new namespace lightly. First prove the existing namespace split
cannot absorb the new keys cleanly.


## Fallback Policy

Use fallbacks cautiously.

- A fallback may help development ergonomics in code that already follows that
  convention.
- A fallback does not prove locale completeness.
- A fallback must never be used to excuse missing keys or mixed-language
  runtime.

Closure still requires:

- key parity
- no hardcoded user-facing drift in the changed surface
- runtime proof in at least one non-default locale for relevant user-facing
  work

## Mixed-Language Runtime

Assume one of these root causes first:

- namespace drift
- missing key
- fallback masking
- backend/frontend contract drift
- hardcoded copy leakage

Do not treat mixed-language output as a visual polish issue.

## Backend Error Bridge

When backend errors are intentionally translatable on the frontend:

- keep them stable
- keep them namespaced
- do not serialize final localized prose if the frontend already owns i18n
- align them with the frontend error translation hooks and the backend/frontend
  contract

## Required Output

For non-trivial i18n work, produce an i18n packet with at least:

- affected surfaces
- namespaces touched
- keys added or changed
- backend/frontend boundary notes when display data crosses the contract
- parity method
- runtime locale proof plan

## Failure Modes

Treat these as real i18n smells:

- `mixed-language-runtime`
- `fallback-masking-drift`
- `server-prop-localized-copy`
- `namespace-drift`
- `hardcoded-copy-leakage`
- `error-key-without-stable-bridge`
- `locale-pack-parity-drift`

## Review Checklist

- Did every changed user-facing string get governed by i18n?
- Were keys added or updated in all supported locales?
- Was any backend-fed display string audited for ownership drift?
- Was namespace choice explicit and consistent?
- If a gap was namespace-wide, was it handled as a structured insert rather than
  scattered patches?
- Was parity checked with a repeatable command or script?
- Was runtime validated in at least one non-default locale when the surface is
  relevant to UX?
- Is there any mixed-language output left in the changed surface?

## References

Use active locale-pack governance, boundary model, runtime review notes, and
stack profile docs.

## Relationship To Other Skills

Use this skill with:

- `server-prop-governance`
  - when backend/frontend copy ownership is the risk
- active server/frontend integration skill
  - when presenter fields or server props may serialize display labels
- `front-react-shadcn`
  - when implementation still needs frontend stack guidance
- `auth-form-patterns`
  - when auth-specific errors or UX copy are involved
- `accelerate`
  - when the work is non-trivial and needs i18n closure as a formal gate
