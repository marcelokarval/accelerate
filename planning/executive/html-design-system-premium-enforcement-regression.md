# HTML Design-System Premium Enforcement Regression

Date: 2026-04-21

## Decision

Promote the two-project evidence loop into an Accelerate regression expectation
for premium design-system extraction.

The tested projects were:

- `~/Backup/Projetos/nextjs/launch-fullstack`
- `~/Backup/Projetos/all-agrelli-projects/ht-agrelli-com-bot-telegram-dashboard`

Both exposed the same enforcement gap:

- the source-truth extraction and premium direction markdown were useful
- the first premium HTML proofs were visually better than the baseline
- but the premium HTML proofs were too thin to judge recomposition across real
  app screens

## New Enforcement Rule

When premium direction is active and the local frontend stack exposes a broad
component primitive catalog such as shadcn/ui or Radix, the premium package must
include:

- `docs/reference/design-system.slop-audit.md`
- `docs/reference/design-system.premium-direction.md`
- `docs/reference/design-system.premium-direction.html`
- a component coverage matrix
- a broad premium component gallery
- offline render proof for the premium HTML

The broad component gallery must demonstrate the proposed visual treatment for:

- actions and button hierarchy
- forms and validation
- inputs, selects, textarea, checkbox, radio, switch, slider
- tabs, filters, command/search surfaces
- data tables, lists, pagination and status chips
- overlays such as dialogs, dropdowns, popovers and tooltips
- feedback such as alerts, toasts, progress, skeletons and empty states
- navigation and shell treatment when relevant

## Light / Dark Theme Rule

The `sistema-financeiro` follow-up exposed a second enforcement gap: a premium
light theme can be strong while the dark sample is merely a discrepant black
panel.

When the source product supports light/dark themes or the user asks about dark
mode, the premium package must include:

- a light/dark token model in `design-system.premium-direction.md`
- a `Light vs Dark System` section in `design-system.premium-direction.html`
- equivalent component families in both modes, not only a hero sample
- explicit separation between immutable component anatomy and theme tokens
- proof that dark mode preserves product semantics, hierarchy, density and
  component behavior from light mode

The dark theme fails if it feels like an unrelated black/neon dashboard rather
than a token-derived sibling of the light theme.

## Theme Generator Rule

When the project exposes a broad local catalog, treat the premium artifact as a
future theme-generator seed, not a one-off visual mock.

The expected breadth is closer to Bootstrap, shadcn/Radix kits, or mature UI
theme galleries than to a landing-page moodboard. The artifact should prove
enough primitives, variants and states that a future agent can generate many
interfaces by changing tokens and preserving component recipes.

## Status Classification

Use these component status labels:

- `source-observed`: present in current rendered/source product surfaces
- `available-in-code`: primitive exists locally but needs product skin before
  becoming finished UI
- `premium-proposed`: valuable for the target product library but not source
  truth
- `not-approved-yet`: catalog primitive exists, but product need is unproven

## Regression Commands

For each target project, the minimum regression proof is:

```bash
rg -n "Premium Component Coverage Matrix|Component gallery|Coverage matrix|available-in-code|not-approved-yet" docs/reference/design-system.premium-direction.md docs/reference/design-system.premium-direction.html
rg -n "Light vs Dark System|dark-mode|theme generator|token-derived|component anatomy" docs/reference/design-system.premium-direction.md docs/reference/design-system.premium-direction.html
rg -n "[ \t]+$" docs/reference/design-system.premium-direction.md docs/reference/design-system.premium-direction.html
git diff --check
npx playwright screenshot file://$PWD/docs/reference/design-system.premium-direction.html .tmp/design-system-premium-direction-rich-render.png --full-page
file .tmp/design-system-premium-direction-rich-render.png
```

If browser MCP is unavailable, Playwright CLI is acceptable proof for offline
artifact rendering.

## Closure Blockers

Do not close a premium design-system pipeline if:

- the premium HTML only proves atmosphere, hero, cards, and one table
- the component coverage matrix is missing for a shadcn/Radix-style stack
- proposed components are not clearly distinguished from source truth
- the artifact lacks render proof
- the implementation handoff treats shadcn/Radix defaults as final visual style
- the source-truth `design-system.html` was overwritten by redesign
- dark mode is supported or requested but appears only as one isolated visual
  block, a textual mention, or an unrelated skin
- the package does not separate token-level theme variation from fixed
  component/product anatomy
- the component gallery is too narrow to serve as a future theme-generator
  reference

## Applied Accelerate Updates

- `docs/codex-skill-seeds/skills/extract-html-design-system-v2/SKILL.md`
- `core/review/html-design-system-extraction.md`
- `core/review/premium-interface-production.md`
- `core/workflows/catalog.md`
- `core/control-plane/branch-enforcement-matrix.md`
- `references/branch-enforcement-matrix.md`
- `references/adjacent-skill-trigger-audit.md`
- `docs/codex-skill-seeds/skills/README.md`

## Rationale

The learned rule is not "add more components everywhere".

The rule is that premium direction must be useful to an implementation agent
that needs to rebuild or extend a real product. A thin moodboard can look better
than the baseline while still failing as an implementation contract.

The component gallery turns premium direction into a usable recomposition
artifact without corrupting source-truth extraction.
