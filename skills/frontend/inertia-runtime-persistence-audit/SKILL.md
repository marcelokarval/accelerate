---
name: inertia-runtime-persistence-audit
description: Use when Inertia navigation feels flickery, shells or headers seem to re-render too broadly, tabs or local navigation trigger visible churn, or persistent layout, partial reload, deferred prop, and page-meta behavior need architectural review.
---

# Inertia Runtime Persistence Audit

Use this skill to diagnose and correct the gap between "Inertia is working" and
"the product feels persistent, scoped, and professional at runtime."

## Load When

- local navigation feels like a mini reload even though it is Inertia
- headers, avatars, titles, or nav chrome visibly churn on page changes
- tabs or contextual navigation trigger shell-wide updates
- shared props seem too broad or unstable
- page metadata changes in multiple steps
- you need to decide between persistent layouts, partial reloads, deferred
  props, optional props, or a page-boundary refactor

## Core Contract

Answer these questions explicitly:

1. is the shell actually persistent?
2. what data is causing shell-wide churn?
3. is the churn required by the page model, or self-inflicted by prop shape?
4. should this be fixed with prop governance, refresh scoping, or page
   consolidation?

## Audit Workflow

1. reproduce the runtime flow in MCP browser first
2. distinguish:
   - full document reload
   - Inertia visit with stable shell
   - DOM persistence with visible rerender churn
3. inspect:
   - page resolution and layout composition
   - shared props middleware
   - custom middleware and presenter layers that shape Inertia payloads
   - shell/header consumers of `usePage()`
   - page meta authority
   - local navigation route hygiene, including trailing slash redirects
4. compare the behavior against official Inertia and React guidance
5. classify the problem:
   - layout identity instability
   - shared-prop instability
   - over-broad `usePage()` coupling
   - page-meta double authority
   - partial-reload misuse
   - wrong page granularity
6. recommend the smallest correction that improves runtime truth
7. produce a prop ownership matrix when middleware, presenters, or broad shared
   props are part of the diagnosis

## Accelerate Rules

- inspect the active Inertia configuration and frontend entrypoint declared by
  the stack profile
- inspect `src/interfaces/web/middleware/inertia_share.py`
- inspect adjacent custom middleware and app-layer presenters when shared props
  or refresh scope feel suspicious
- inspect shell consumers such as `PrivateHeader`, `HeaderPageTitle`, and local
  account/billing layouts
- treat `app.timestamp`-style per-request values in shared props as churn smells
- do not confuse a new Inertia page object with a full browser reload
- if tabs are backed by different Inertia page components, say that clearly; do
  not pretend partial reloads can remove all churn across page boundaries
- do not confuse `request.data` transport middleware with Inertia output
  contract shaping
- a single cache aggregator or `get_many()` optimization does not by itself
  justify shared-prop placement

## Review Questions

- does the visit preserve the shell DOM?
- are requests taking avoidable `301` redirects due to route hygiene?
- is custom middleware injecting convenience props that should be page-local or
  shell-local instead?
- is the header reading only stable shell props, or the whole page payload?
- is metadata authored in exactly one place?
- are `defer`, `optional`, or `merge` available and unused where they should be?
- is a single goal split across too many page components for the desired UX?

## Output Discipline

Every use of this skill should produce:

- browser/runtime evidence
- code evidence
- root-cause classification
- a prop ownership matrix when shared/page/action boundaries are under review
- whether the issue is:
  - shell persistence
  - prop governance
  - page modeling
  - all three
- a bounded remediation plan

## Required References

- `references/runtime-persistence-checklist.md`
