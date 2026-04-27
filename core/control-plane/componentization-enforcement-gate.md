# Componentization Enforcement Gate

## Purpose

Use this gate when UI work touches reusable components, page composition,
template portability, theme portability, premium interface quality, or broad
visual language.

The gate prevents page-local UI sprawl: repeated markup, `div` soup, excessive
`className`, and direct classes that should belong to central primitives,
variants, or theme/config layers.

## Layer Standard

Prefer the strongest honest shared owner:

1. `foundation`
   - tokens, typography scale, focus rings, radius, shadows, motion primitives
2. `ui primitives`
   - button, input, textarea, select, checkbox, switch, badge, card, dialog,
     popover, tooltip, table, tabs, toast, skeleton, empty state
3. `second-layer primitives`
   - product-flavored wrappers around primitives: money field, status badge,
     metric cell, nav item, command item, filter chip
4. `enhanced / composites`
   - data table, form section, pricing card, dashboard panel, action toolbar,
     settings section
5. `shared product components`
   - domain-specific reusable blocks that appear across flows
6. `shells / templates`
   - app frame, dashboard shell, public shell, auth shell, onboarding shell
7. `page consumers`
   - only route-specific composition and data binding

Pages should consume central components. They should not recreate primitive or
composite anatomy unless a bounded exception is recorded.

## Third-Party Adopt-First Rule

Before creating a new primitive or complex composite, check whether a mature
open-source implementation can be adapted faster and safer.

Allowed sources include project-approved packages, shadcn/Radix-style registries,
well-maintained GitHub examples, and curated awesome lists. Imported code must be
reviewed, adapted, licensed appropriately, and then treated as first-party code.

Rules:

- Do not blindly paste third-party code.
- Once adapted, the component is ours: local naming, variants, tokens, tests, and
  ownership apply.
- Create from scratch only when no suitable implementation exists or adaptation
  would be riskier than a local component.
- Record the adoption decision in the componentization packet.

## Anti-Patterns

Closure is blocked when unexcused:

- `div` soup in pages or route files
- repeated page-local primitive anatomy
- excessive `className` strings that should be component variants
- direct raw classes in many pages instead of central variants/config
- hardcoded color/radius/shadow/layout values in consumers
- copy-pasted third-party markup not normalized into local tokens and variants
- broad UI change implemented by only hero/cards/tables while primitives remain
  ungoverned

## Componentization Packet

```text
Componentization Enforcement Packet
- target surfaces:
- central component owners:
- foundation changes:
- ui primitives reused/adapted:
- second-layer primitives reused/adapted:
- enhanced/composites reused/adapted:
- shared product components reused/adapted:
- shells/templates reused/adapted:
- third-party/adapt-first search:
- adopted third-party components:
- created-from-scratch components:
- page-local exceptions:
- div/className/direct-class audit:
- residual componentization debt:
- readiness impact: supports-closure|review-only|blocked
```

## Local Audit

When a governed workspace is available, use:

- `onboarding/local-workspace/check-componentization-discipline.sh`

This audit is intentionally heuristic. It does not prove perfect architecture,
but it blocks obvious page-local visual sprawl and forces exceptions to be
explicit.

## Closure Blockers

Do not close if:

- UI pages recreate primitives or composites that should be central
- no central component owner exists for a broad visual/template change
- excessive `className` or direct classes are present with no exception file
- third-party adoption was skipped for a complex component with no rationale
- adapted third-party code is not normalized into local token/variant ownership
- componentization proof is missing when theme/template portability is claimed
