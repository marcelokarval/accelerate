---
name: apply-design-system-contract
description: Use when existing docs/reference design-system artifacts must drive UI implementation, correction, improvement, premium recomposition, or new-screen generation in a new or existing project.
---
# Apply Design System Contract

Use this skill after a project already has one or more of these artifacts:

- `docs/reference/design-system.html`
- `docs/reference/design-system.contract.md`
- `docs/reference/design-system.slop-audit.md`
- `docs/reference/design-system.premium-direction.md`
- `docs/reference/design-system.premium-direction.html`

This skill turns the design-system package into implementation law. It is not
an extraction skill and it is not a moodboard reader.

## Activation

Use when the user asks to:

- implement a new screen from an extracted design system
- correct an existing screen against the design-system contract
- improve or premiumize UI using the premium direction artifacts
- propose UI changes while preserving source-truth design laws
- generate a theme or broad component treatment from the premium direction

Do not use when there is no local design-system artifact package yet. In that
case, run `extract-html-design-system-v2` first.

## Required Reading Order

1. Read `docs/reference/design-system.contract.md`.
2. Inspect `docs/reference/design-system.html` for visual/source examples.
3. If premium artifacts exist and the task allows improvement, read:
   - `docs/reference/design-system.slop-audit.md`
   - `docs/reference/design-system.premium-direction.md`
   - `docs/reference/design-system.premium-direction.html`
4. Inspect the target app's real component inventory, tokens, routes, and
   current runtime before editing.

If the contract and premium direction conflict, source-truth anatomy wins for
component structure; premium direction may change tokens, hierarchy, materiality,
and composition only where it explicitly says so.

## Implementation Protocol

### 1. Contract Lock

Create a short implementation packet before mutation:

- source artifacts used
- target routes/components
- immutable design laws that apply
- premium direction rules that apply, if any
- forbidden patterns for this slice
- component/state coverage required for closure

During or after mutation, leave:

- a `Requested-Vs-Implemented Packet`
- defect disposition when concrete defects are found
- seam proof when the likely drift lives at a shell/layout/state seam

### 2. Component Mapping

Map every planned UI element to one of:

- `source-observed`: appears in `design-system.html` / contract evidence
- `code-available`: exists in the project component library but not extracted
- `premium-proposed`: appears only in premium direction artifacts
- `not-approved-yet`: useful but not evidenced or approved

Do not implement `not-approved-yet` elements without explicitly recording the
gap and either extracting more evidence or getting a product/design decision.

### 3. Anatomy vs Token Split

Keep these separate:

- component anatomy: structure, hierarchy, density, state model, interaction
- theme tokens: colors, radii, shadows, borders, gradients, fonts, spacing

For theme-generator or multi-project reuse, prefer token/config changes over
forking component anatomy.

### 4. Implementation

When editing UI:

- reuse existing project components before raw markup
- preserve the contract's typography, spacing, radius, density, and state rules
- apply premium direction only where it is explicit
- keep light and dark themes as sibling token systems over the same anatomy
- cover broad primitives when the target project exposes shadcn/Radix or
  similar component breadth
- avoid generic violet SaaS gradients, raw default shadcn surfaces, card soup,
  placeholder metrics, and invented visual language

### 5. Proof

Closure requires proof against the artifacts:

- runtime screenshot or browser proof for the changed surface
- side-by-side judgment against `design-system.html`
- side-by-side judgment against `design-system.premium-direction.html` when used
- corrected-state proof when an in-scope defect was fixed
- seam proof when shell/layout/state joins are the likely failure surface
- type-check/lint/build according to the target stack
- residual drift list if anything remains below contract

Temporary screenshots and captures should live under the governed project root
`.tmp/` tree, not `/tmp`.

Do not claim design-system compliance from code inspection alone.

## Proposal Mode

When asked only to propose:

- still read the contract first
- mark each recommendation as `source-observed`, `code-available`,
  `premium-proposed`, or `not-approved-yet`
- include implementation risk and proof needed
- do not present unsupported components as if they were part of the design
  system

## Closure Blockers

Do not close if:

- `design-system.contract.md` was not read
- premium artifacts existed but were ignored for premium/polish work
- implementation treats the artifacts as loose inspiration
- component anatomy and theme tokens are mixed without reason
- dark mode is a disconnected skin instead of a sibling token system
- broad component coverage is required but only hero/cards/tables were checked
- the active slice leaves no `Requested-Vs-Implemented Packet`
- concrete defects are described but not dispositioned
- the proof still reflects pre-fix state after an in-scope correction
- seam-sensitive drift is closed without seam proof
- temporary proof captures are left outside `project-root/.tmp/`
- the result uses raw framework defaults that the contract forbids
- there is no runtime/browser visual proof after mutation
- unresolved drift is hidden instead of registered
