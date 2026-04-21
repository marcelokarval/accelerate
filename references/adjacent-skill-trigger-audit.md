# Adjacent Skill Trigger Audit

Use this module when the question is whether the skills around `accelerate`
are strong enough and whether branch triggers are hard enough.

## Purpose

This reference audits the adjacent skills most relied on by `accelerate` and
turns perceived soft triggers into explicit routing rules.

## Judgment Vocabulary

Use judgment labels that match the evidence strength.

- `exact`: reserved for conclusions with operational proof, such as runtime
  behavior, executed validation, or direct evidence from real runs
- `documentarily-strong`: strong conclusion based on the skill body, linked
  references, and declared workflow contracts, but not yet proven by runtime
  execution in this audit slice
- `partial`: some evidence exists, but important parts remain unproven or
  materially soft
- `stale`: the judgment or references no longer match the live workflow truth

Do not use `exact` for documentary review alone.

## Audited Skills

| Skill | Verdict | Notes |
| --- | --- | --- |
| `frontend-boundary-governance` | `documentarily-strong` | strong `.ts` vs `.tsx` and backend/frontend truth boundary discipline; should be mandatory for structural frontend work |
| `product-runtime-review` | `documentarily-strong` | strong user-facing runtime/product lens; should be mandatory for runtime-sensitive surfaces |
| `anti-abuse-review` | `documentarily-strong` | strong misuse-resistance review; should be mandatory for auth/session/OTP/billing/export/delete/upload/list/search/settings-sensitive flows |
| `security-patterns` | `documentarily-strong` | strong IDOR/auth/race/secret baseline; should pair with abuse-sensitive or ownership-sensitive backend work |
| `django-service-patterns` | `documentarily-strong` | strong backend service and responsibility discipline; should be mandatory when business logic or service shape is part of the slice |
| `sql-optimization-patterns` | `documentarily-strong` | strong query-shape and N+1 lens; should be mandatory when `Backend Query Correctness` is execution-relevant |
| `i18n-patterns` | `documentarily-strong` | strong i18n/runtime proof contract; should be mandatory when user-facing copy changes |
| `validation-governance` | `documentarily-strong` | strong backend-vs-frontend validation authority model; should be loaded when local validation or parsing boundaries are part of the risk |
| `systematic-debugging` | `documentarily-strong` | now present and valid as the bug/regression branch entry skill |
| `extract-html-design-system-v2` | `documentarily-strong` | strong HTML-reference-to-local-design-system bridge; should be loaded when a URL, local HTML file, raw HTML reference, or existing web app is intended to guide UI correction, new-screen generation, recreation, or premium visual convergence |

## Hard Trigger Rules

### Frontend Structural Branch

Treat these as branch-defined, not optional memory aids:

- `front-react-shadcn`
- `frontend-boundary-governance` when structure, `.ts` vs `.tsx`, view-model,
  selector, formatter, page-controller drift, or backend/frontend truth
  boundaries are part of the risk
- `i18n-patterns` when user-facing copy changes
- `product-runtime-review` when the surface is runtime-sensitive or
  user-goal-sensitive
- `extract-html-design-system-v2` when the request supplies a URL, local HTML,
  raw HTML reference, or existing web app that should become
  `docs/reference/design-system.html` and
  `docs/reference/design-system.contract.md` before implementation or visual
  convergence

### Backend Structural / Contract Branch

Treat these as branch-defined when the slice touches business logic or backend
truth shape:

- `django-service-patterns`
- `validation-governance` when local validation or parsing boundaries are part
  of the risk
- `security-patterns` when ownership, auth, IDOR, secret, or race-sensitive
  behavior is in scope
- `sql-optimization-patterns` when query shape, presenter/query aggregation, or
  N+1 risk is plausibly part of correctness

### Abuse-Sensitive Flows

For these categories, do not stop at generic runtime review:

- auth
- session
- OTP / verification
- billing
- export
- deletion
- upload
- list/search/filter with ownership risk
- self-service trust-sensitive state
- admin or operator surfaces with privilege drift risk

Minimum mandatory bundle:

- `anti-abuse-review`
- `security-patterns` when backend ownership/auth/race/secret handling is part
  of the risk
- `product-runtime-review` when the flow is user-facing

## Backend Structure Correctness Decision

A separate `Backend Structure Correctness` lens is not introduced yet.

Current decision:

- backend structural enforcement remains covered by the explicit bundle
  (`django-service-patterns`, `validation-governance`, `security-patterns`,
  `sql-optimization-patterns`, plus domain-truth skills when needed)
- if this bundle still proves too soft in real usage, a dedicated lens can be
  promoted later through the workflow-change approval path

## Enforcement Consequence

When a branch omits one of these mandatory adjacent skills without a clear
reason, classify the run as under-routed rather than merely suboptimal.
