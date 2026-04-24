# Enforcement Surfaces

## Purpose

This document is the native enforcement inventory for backend, frontend,
runtime, and governance work.

Use it when the question is:

- what is mandatory on this branch?
- what smells should be treated as workflow failure?
- what backend/frontend/runtime/governance obligations are live?

## Security And Integrity

- `IDOR / public_id` review on ownership-sensitive flows
- `public_id prefix discipline` on new backend models and identifiers
- `N+1 / query-shape proof` on backend-heavy or relational surfaces
- `anti-abuse` on auth, resend, export, upload, recovery, billing, and
  enumeration-sensitive flows
- `OWASP` review on relevant trust-boundary and user-input surfaces
- `race-condition audit` for critical `save()` calls, mutable shared state,
  counters, balances, and concurrency-sensitive flows
- `secrets / config hygiene` for provider, env, and credential-bound surfaces
- `session auth posture` for browser-authenticated flows
- `CSRF / XSRF correctness` for web mutation surfaces
- `lockout / rate-limit / replay posture` where credentials, resend, or
  verification loops exist

## Backend Enforcement

- backend is source of truth
- service layer first
- use project base classes and inheritance stack
- prefer project mixins or model base classes over repetition
- after the second repetition, suggest mixin/heredity extraction explicitly
- review meaningful `save()` calls for race or side-effect risk
- `soft delete discipline`
- `no direct cross-domain imports`
- `transaction boundary clarity`
- prefer `request.data` over `request.POST` in Inertia flows
- tasks should call services, not own business logic
- use canonical helpers and base abstractions
- `err()` structured backend error protocol
- redirects use named URLs
- `no backend-owned localized copy in props`
- `no duplicate Stripe truth outside dj-stripe`
- `query count evidence`
- `EXPLAIN` when execution-plan claims matter
- `cache truth / invalidation truth`
- `download / upload audit trail`
- `presigned / private / public storage boundary`
- distinguish readonly/admin/operator surfaces explicitly
- frontend validation may exist for UX/protection, but backend validation is
  authoritative
- no narrative closure without backend validation stack when schema/runtime work
  happened
  - `uv run python backend/src/manage.py check`
  - `uv run python backend/src/manage.py makemigrations --check --dry-run`
  - `uv run python backend/src/manage.py migrate --check`

## Frontend Enforcement

- Inertia-first by default
- DRY and shared/component reuse discipline
- use project compounds and enhanced components before inventing new ones
- mandatory source ladder for missing components:
  1. canonical primitives
  2. acceptable third-party source when justified
  3. only then custom construction from base components
- avoid `div soup`
- enforce modularization and import-boundary discipline
- mandatory i18n for user-facing text
- browser/runtime-sensitive structural work should use wireframes when needed
- `Wireframe Before UI` for structural UI uncertainty
- `real data readiness`
- `route-family / shell persistence` awareness
- `no fetch for initial page data` on normal Inertia web flows
- frontend validation should also reduce invalid or hostile traffic reaching the
  backend when the branch calls for it

## Runtime And Proof Enforcement

- browser-proof intensity must be named
- Chrome DevTools for interactive runtime truth
- Playwright for persistent regression proof
- browser-proof comes before Playwright persistence when the flow is not yet
  understood
- design-system or premium UI mutation requires Design Implementation Proof
- corrected-state visual proof is required after in-scope UI defects are fixed
- every bounded batch requires self-review
- every bounded batch requires self-forensic review
- every subagent requires self-review and self-forensic review output
- frontend-bearing or TS contract-bearing slices require `type-check`

## Design And Visual Enforcement

- design-system artifacts are implementation law, not inspiration
- premium direction is directional authority, not a moodboard
- UI mutation must name the honest owner layer before editing
- page-local polish must not bypass shared token, primitive, composite, or shell
  owners without an explicit bounded exception
- browser/runtime proof must compare the delivered surface against active visual
  authorities
- viewport and state coverage must be explicit for premium, product-critical, or
  broad UI work
- visual defects found in scope must enter the defect ledger
- fixed visual defects require corrected-state browser proof before promotion
- residual visual drift must be registered rather than hidden in final prose

## Multi-Agent Enforcement

- non-trivial work should evaluate bounded subagent spawning explicitly
- non-trivial work may stay root-owned when delegation has no honest fit or
  adds more integration cost than execution clarity; staying fully
  single-threaded still requires an explicit exception packet
- each subagent loads `accelerate` first before layer-specific work
- each subagent stays bounded and leaves explicit output
- the master performs review-of-review and final integration closure

## Governance Enforcement

- issue stack is mandatory for mutating work
- `AI Review Report` before `Done`
- repo docs and workflow seeds are not exempt from governance
- stack-specific governance skills should be loaded when branch risk demands
- `Contract Correctness` when presenters, props, routes, identifiers, or action
  URLs are touched
- `shared props governance` when shell/page truth boundaries may drift
- `query ownership -> presenter ownership -> UI ownership` should stay explicit
  whenever data truth crosses backend and frontend boundaries
