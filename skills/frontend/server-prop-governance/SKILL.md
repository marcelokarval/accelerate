---
name: server-prop-governance
description: Use when designing or reviewing server-to-frontend page contracts, shared data, deferred or optional props, shell-vs-page boundaries, or payloads causing frontend churn, coupling, or bloat.
---

# Server Prop Governance

Use this skill to keep server-side page-contract shaping intentional instead of
letting shared data and page props blur together.

## Load When

- shared props feel too broad, unstable, or expensive
- shell data and page data are mixed together
- a page receives large payloads on every visit
- frontend runtime churn suggests backend prop contracts are poorly scoped
- custom middleware or presenters blur shell-vs-page ownership
- you need to decide whether data belongs in:
  - shared props
  - page props
  - deferred props
  - optional props
  - local JSON endpoints

## Core Contract

Every prop must answer:

1. who owns this data?
2. who needs it?
3. how often does it truly change?
4. should it arrive on first render?
5. should it live in shared shell state at all?

## Governance Rules

- shared props are for shell-stable, broadly needed data only
- page props are for route-specific state
- `defer(...)` is for data that can land after the initial page render
- `optional(...)` is for data that should not be sent unless requested
- `merge(...)` is for mergeable prop updates, not broad convenience
- do not place request-local timestamps or diagnostics into shared props unless
  they are truly user-facing
- do not use shared props as a dumping ground for convenience data
- do not let a cache aggregator decide ownership just because the data became
  cheap to fetch
- keep `request.data` transport concerns separate from prop contract concerns
- do not serialize user-facing localized copy in server props when the frontend
  owns i18n; prefer truth, enums, flags, reason codes, raw timestamps, raw
  amounts, and explicit translation keys when copy semantics must travel

## Accelerate Guidance

- inspect shared-prop middleware or layout loaders first
- inspect adjacent custom middleware, presenters, loaders, or route handlers
  that build page props
- classify auth, locale, legal, billing, account, and settings props by shell
  need versus page need when those domains exist
- keep shell contracts stable enough that headers, sidebars, and global
  providers do not churn on unrelated page visits
- if a local action only needs to refresh a card, prefer:
  - local JSON endpoint
  - or narrowed `router.reload({ only: [...] })`
  over broad page payload resets

## Review Questions

- is this prop global, section-local, or page-local?
- does it change every request for no user-facing reason?
- is this prop only present because custom middleware made it convenient?
- is it safe to defer?
- is it safe to omit on first load?
- is the current placement causing header, shell, or avatar churn?
- should this be split into multiple contracts?
- is the frontend following the canonical presenter/contract, or hand-building
  assumptions on top of it?
- did any route, identifier, or acceptance URL get invented in the frontend
  instead of emitted by the backend?

## Contract Correctness Signals

Treat these as hard red flags during review:

- frontend rebuilding links that the backend already emits
- mixing `public_id`, `key`, `id`, or slug semantics without an explicit
  contract
- page code assuming fields not present in the canonical presenter
- presenter code serializing one shape while the frontend types another
- backend props carrying English or mixed-language copy that bypasses frontend
  i18n and locale formatting

## Required Output

Produce a prop ownership matrix with:

- prop
- current source
- current consumers
- judgment
- target placement

## Required References

- active project prop-boundary checklist, stack profile, or server-rendering
  contract docs
