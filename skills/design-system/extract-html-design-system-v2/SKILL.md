---
name: extract-html-design-system-v2
description: Use when a URL, local HTML file, raw HTML, or existing web app must become a reusable visual design-system reference and LLM-safe implementation contract.
---
# Extract HTML Design System v2

You are a **Design System Showcase + Contract Builder**.
You are given a reference website HTML:

`$ARGUMENTS`

`$ARGUMENTS` may be:

- a local `.html` file path
- a URL pointing to a webpage
- raw HTML content

If `$ARGUMENTS` is a URL, fetch or capture the page first and preserve linked
asset references when possible.

Temporary files must be created under `.tmp/` inside the root of the project
where the skill was invoked, or inside the root of the project explicitly
referenced by the user. If that directory does not exist, create it.

If multiple URLs are provided for the same site or product, treat them as one
shared design-system corpus. Capture every URL separately, then build one
consolidated design-system reference from the union of components, typography,
surfaces, layouts, motion, and icons actually present in those sources.

Your task is to create **two coordinated reference artifacts** for this exact
design:

- a human-readable visual showcase
- a machine-readable / LLM-readable implementation contract

When the user asks to improve, humanize, premiumize, de-AI, polish, or upgrade
the extracted design, or when the surface is product-critical,
conversion-critical, brand-critical, or premium-interface class, extend the
run with a premium diagnosis and direction package. This package must improve
from the evidence; it must not overwrite the evidence.

---

## GOAL

Generate both files below and place them under `docs/reference/` inside the root
of the project where the skill was invoked, or inside the root of the project
explicitly referenced by the user:

- `design-system.html`
- `design-system.contract.md`

If `docs/reference/` does not exist, create it.

`design-system.html` must preserve the **exact look & behavior** of the
reference design by **reusing the original HTML, CSS classes, animations,
keyframes, transitions, effects, and layout patterns** — not approximations.

`design-system.contract.md` must translate the same evidence into a strict
implementation contract that another AI/agent can follow when building new
screens. It is not a summary. It is the rulebook.

For premium or humanization work, also generate:

- `design-system.slop-audit.md`
- `design-system.premium-direction.md`
- `design-system.premium-direction.html`

These premium artifacts are directional. They do not replace the source-truth
showcase or contract.

When the next task is to implement, correct, improve, propose, or generate UI
from these artifacts, hand off to `apply-design-system-contract`. Do not keep
using this extraction skill as the implementation workflow.

---

## HARD RULES (NON-NEGOTIABLE)

1. Do **not redesign** or invent new styles.
2. Reuse **exact class names, animations, timing, easing, hover/focus states**.
3. Reference the **same CSS/JS assets** used by the original.
4. If a style/component is not used in the reference HTML, **do not add it**.
5. The HTML file must be **self-explanatory by structure** (sections =
   documentation).
6. Include a **top horizontal nav** with anchor links to each section.
7. Do **not** create synthetic summary cards, placeholder logos, fake metrics,
   invented copy, or "visual language" samples that are not backed by source
   HTML.
8. Keep a clear evidence trail from each displayed pattern back to the captured
   source file or URL.
9. Do **not** invent missing components. If modals, alerts, toasts, tooltips,
   forms, selects, tables, or other components are not evidenced in source or
   runtime captures, list them as `Not Observed / Do Not Invent` in the
   contract.
10. When source code or runtime interaction proves a component exists but the
    initial page state hides it, capture the route/state/interaction that shows
    it before adding it to either artifact.
11. Do **not** mutate `design-system.html` into a redesign. Premium direction
    belongs in the premium artifacts so future agents can compare source truth
    against proposed improvement.
12. Do **not** treat premium direction as a moodboard. It must name concrete
    failures in the baseline and show how the proposed direction corrects them.

---

## REQUIRED EXECUTION PHASES

Do not jump directly from URL/HTML input to a finished showcase. Execute these
phases in order.

### A) Capture Phase

For every input URL or HTML source:

- create `.tmp/` if missing
- save the raw or rendered HTML under `.tmp/`
- save a readable text snapshot when a browser/capture tool is available
- save screenshots when visual QA is relevant
- preserve or record the linked CSS and JS asset URLs

Use stable names such as:

- `.tmp/reference-home.html`
- `.tmp/reference-product-ai-agents.html`
- `.tmp/reference-scheduled-tasks.html`
- `.tmp/reference-home.snapshot.md`
- `.tmp/reference-home-full.png`

The exact names may vary, but the files must be understandable and traceable.

### B) Inventory Phase

Before writing the final artifacts, inspect the captured sources and identify:

- page shell: header, nav, footer, major section wrappers
- hero structure and assets
- typography classes and real text hierarchy
- color/surface classes and gradients
- buttons, links, badges, tabs, cards, menus, forms, labels, inputs, textareas,
  selects, checkboxes, radios, switches, sliders, tables, lists, accordions,
  tooltips, dropdowns, popovers, dialogs, modals, drawers, alerts, banners,
  toasts, progress indicators, skeletons/loaders, empty states, charts, code
  blocks, logos, and other real components
- grid, split, stack, and container patterns
- animation, transition, hover, focus, active, disabled, and `data-state`
  patterns
- icon systems and inline SVG conventions

If an item is not found in the captured sources, omit it.

For existing apps, do not stop at the first route. Inspect source routes,
component imports, rendered navigation, and obvious interactive states so the
component inventory is not artificially thin.

### C) Extraction Phase

Build `docs/reference/design-system.html` by reusing real markup fragments and
class strings from the captured sources.

Allowed documentation additions:

- section headings
- short labels
- anchor navigation
- source/evidence labels

Forbidden additions:

- new component structures that do not exist in source
- new CSS classes or inline styles except where the original fragment already
  used inline styles
- guessed typography sizes
- fake states that are not represented by real source classes
- decorative placeholders replacing real source assets

### D) Contract Phase

Build `docs/reference/design-system.contract.md` from the same evidence.

The contract must be direct, prescriptive, and safe for another LLM/agent to
use as immutable guidance. It must include these sections:

- `Immutable Design Laws`
  - non-negotiable visual rules, tone, density, spacing posture, shape posture,
    contrast posture, and interaction posture extracted from evidence
- `Token Contract`
  - observed colors, gradients, surfaces, border/radius patterns, typography
    classes, spacing/container classes, shadows, blur, and z-index/overlay
    conventions
- `Component Recipes`
  - canonical markup/class recipes for each observed component family
  - required states for each component: default, hover, focus, active, disabled,
    loading, error, selected, expanded, open, closed, empty, and success when
    evidenced
- `Component State Coverage Matrix`
  - table of observed component families and states
  - mark each cell as `runtime observed`, `source-code observed`,
    `not observed`, or `not applicable`
- `Layout Recipes`
  - hero, shell, grid, split, card list, table/list, form, modal/dialog, and
    empty-state layouts when evidenced
- `Motion / Interaction Contract`
  - transitions, timings, easing, animation classes, reveal behavior, hover
    lifts/glows, overlay behavior, and focus behavior
- `Composition Rules For New Screens`
  - how agents should combine existing components into new pages without
    drifting from the design
- `Forbidden Patterns`
  - explicit anti-patterns such as invented colors, invented components,
    generic shadcn defaults, placeholder cards, mismatched radii, fake metrics,
    or unobserved interaction states
- `Not Observed / Do Not Invent`
  - component families or states that were checked but not evidenced
- `Rebuild Checklist`
  - short checklist an AI must satisfy before claiming a new screen follows the
    design system
- `Source Evidence Map`
  - map every major rule and component family back to `.tmp/` captures, source
    files, URLs, or screenshots

If the contract cannot prove a rule from source evidence, it must say so
instead of guessing.

### E) Evidence Phase

Every major section must include concise source evidence.

Use visible labels or comments such as:

- `Source: .tmp/reference-home.html | hero`
- `Source: https://example.com/product | nav product menu`
- `Source: captured CSS class list | hover:bg-* transition duration-*`

This is not optional. The HTML artifact must show where each pattern came from
so future UI work can audit it without redoing the extraction.

The contract must also include source evidence for every major rule, component
family, and forbidden pattern.

### F) AI-Slop Audit Phase

Run this phase when the user asks for improvement/humanization/premium
direction, when the surface is premium/product-critical, or when the extracted
baseline visibly reads as generic AI/template output.

Build `docs/reference/design-system.slop-audit.md`.

The audit must evaluate concrete signals such as:

- purple/violet/fuchsia default bias
- generic AI/SaaS gradient language
- raw shadcn/default component leakage
- card-soup or repeated undifferentiated panels
- typography personality and hierarchy
- brand specificity
- layout memorability
- component originality and curation
- motion intentionality
- premium materiality
- human craft signals

The audit must include:

- input artifacts used
- benchmark references used, if any
- an overall AI/genericity score
- a detection matrix with scores, evidence, and impact
- concrete findings
- priority corrections
- pass/fail judgment for source truth vs premium product direction

Use benchmark libraries such as `popular-web-designs` when locally available,
but only as comparison material. Borrow principles, not identities.

### G) Premium Direction Phase

Run this phase after the audit when premium improvement is in scope.

Build both:

- `docs/reference/design-system.premium-direction.md`
- `docs/reference/design-system.premium-direction.html`

`design-system.premium-direction.md` must include:

- direction name
- core shift from current baseline to premium target
- palette and token proposal
- light/dark theme model when the source app supports dark mode or theme
  switching
- typography direction
- surface system
- component direction for observed and expected product primitives
- premium component coverage matrix based on the local stack and relevant
  primitive catalogs such as shadcn/ui and Radix, classifying each family as
  `source-observed`, `available-in-code`, `premium-proposed`, or
  `not-approved-yet`
- motion direction
- premium rules
- forbidden patterns
- implementation handoff guidance

When light and dark themes are in scope, the premium direction must treat dark
mode as a token-derived sibling of the light system, not as a separate product
skin. The dark theme must preserve the same geometry, semantic colors,
component hierarchy, spacing rhythm, and product meaning as the light theme.
It may shift materiality and contrast, but it must not jump into an unrelated
black/neon dashboard language unless the source product already does that.

For themeable projects, the premium direction must be future theme-generator
ready. It must separate:

- immutable product semantics and component anatomy
- theme tokens that can change through `global.css`, CSS variables, Tailwind
  tokens, or equivalent theme configuration
- component-state recipes that must remain valid across theme variants
- theme-specific examples that prove the same primitive can be reskinned
  without rewriting its markup or behavior

`design-system.premium-direction.html` must be a concrete visual proof of the
direction. It may introduce proposed premium tokens and styles because it is
directional, not source truth. It must clearly identify itself as a premium
direction artifact and must not pretend to be extracted source evidence.

The premium HTML should demonstrate:

- hero or primary product framing
- surface/material language
- at least one card or panel system
- buttons and action hierarchy
- form/input or control treatment when relevant
- table/list/status treatment when relevant
- a component gallery broad enough to judge recomposition, including common app
  primitives such as buttons, inputs, selects, checkboxes, switches, sliders,
  tabs, badges, alerts, dialogs, dropdowns, popovers, tooltips, tables,
  skeletons, toasts/notifications, empty states, pagination, and navigation
  when the local stack supports them
- explicit labels separating `observed baseline`, `available primitive`, and
  `premium proposal` so the directional artifact does not pretend proposed
  components were extracted from source truth
- motion/material intent when practical

When dark mode is supported or requested, the premium HTML must include a
`Light vs Dark System` section. This section must show equivalent treatment for
the same component families in both themes, not a single decorative dark block.
At minimum, demonstrate:

- shell/navigation
- primary/secondary/destructive actions
- cards, KPI/metric blocks, and dense data surfaces
- form controls and validation
- tables/lists/status rows
- overlays such as dialog, sheet, dropdown, popover, tooltip, or command/search
- feedback such as alerts, toasts, progress, skeleton/loading, and empty states

If the light version is premium but the dark version looks like an unrelated
black/neon SaaS moodboard, the premium artifact fails.

For projects with broad component catalogs, the premium HTML must behave like a
theme showroom, not a landing-page moodboard. Use mature systems such as
Bootstrap, shadcn/ui, Radix-based kits, or full product UI libraries as the
coverage expectation: show enough primitives, states, and density to prove that
the direction could generate many future interfaces from tokens and component
recipes.

### H) Acceptance Gate

Before closure, compare the final `design-system.html` and
`design-system.contract.md` against the captured sources.

The output is invalid if any of these are true:

- `.tmp/` does not contain captured source files
- `docs/reference/design-system.html` is missing
- `docs/reference/design-system.contract.md` is missing
- the hero is not a direct clone except for text adaptation
- source assets are not referenced or documented
- major visible source patterns are absent without explanation
- the artifact contains invented cards, icons, layouts, metrics, or copy
- the artifact has no visible source evidence
- the contract reads like a prose summary instead of an implementation rulebook
- the contract lacks component recipes, state coverage, forbidden patterns, or
  source evidence
- source/import/runtime evidence shows forms, modals, tooltips, alerts, toasts,
  tables, menus, or similar components but the artifacts omit them without a
  concrete reason
- the result is merely a moodboard, style sampler, or visual approximation
- premium/humanization work was requested but `design-system.slop-audit.md`,
  `design-system.premium-direction.md`, or
  `design-system.premium-direction.html` is missing
- the premium audit does not name concrete baseline smells
- the premium direction fails to reduce the concrete smells named in the audit
- the premium HTML does not render offline
- the premium HTML is only another generic AI/SaaS moodboard
- the premium HTML is too thin to compare recomposition across a realistic app
  component set
- the premium direction lacks a component coverage matrix when the local stack
  exposes a broad primitive catalog such as shadcn/ui or Radix
- dark mode is supported or requested but the premium artifacts only mention it
  textually, show a single decorative dark block, or make dark mode visually
  unrelated to the light system
- the premium package cannot explain which changes belong in theme tokens
  versus component anatomy, making it unsuitable as a future theme generator
- a broad primitive catalog exists but the premium HTML would not let an agent
  compare a realistic Bootstrap/theme-kit-like component surface across forms,
  overlays, feedback, navigation, data, and stateful controls
- the next implementation/correction/proposal step is not routed through
  `apply-design-system-contract`

If the gate fails, do not claim completion. Report the blockers and revise the
artifact.

---

## OBJECTIVE

Build a **single page** composed of **canonical examples** of the design system, organized in sections.

---

### 0) Hero (Exact Clone, Text Adapted)

The **first section MUST be a direct clone of the original Hero**:

- Same HTML structure
- Same class names
- Same layout
- Same images and components
- Same animations and interactions
- Same buttons and background
- Same UI components (if any)

**Allowed change (only this):**

- Replace the hero text content to present the **Design System**
- Keep similar text length and hierarchy

**Forbidden:**

- Do not change layout, spacing, alignment, or animations
- Do not add or remove elements

---

### 1) Typography

Create a **Typography section** rendered as a **spec table / vertical list**.

Each row MUST contain:

- Style name (e.g. “Heading 1”, “Bold M”)
- Live text preview using the **exact original HTML element and CSS classes**
- Font size / line-height label aligned right (format: `40px / 48px`)

Include ONLY styles that exist in the reference HTML, in this order:

- Heading 1
- Heading 2
- Heading 3
- Heading 4
- Bold L / Bold M / Bold S
- Paragraph (larger body, if exists)
- Regular L / Regular M / Regular S

Rules:

- No inline styles
- No normalization
- Typography, colors, spacing, and gradients MUST come from original CSS
- If a style uses gradient text, show it exactly the same
- If a style does not exist, do NOT include it
- Size and line-height labels must come from computed browser evidence or the
  original CSS. If neither is available, mark the size label as
  `source class only` instead of guessing.

This section must communicate **hierarchy, scale, and rhythm** at a glance.

---

### 2) Colors & Surfaces

- Backgrounds (page, section, card, glass/blur if exists)
- Borders, dividers, overlays
- Gradients (as swatches + usage context)

---

### 3) UI Components

Include every component family evidenced by the reference corpus, not just the
visually obvious ones from the first screen.

Component families to check:

- buttons, links, icon buttons, button groups
- labels, inputs, textareas, selects, checkboxes, radios, switches, sliders
- forms, validation messages, help text, error states, success states
- cards, panels, surfaces, list items, empty states
- tables, rows, cells, filters, pagination, sorting controls
- badges, tags, pills, status chips
- tabs, accordions, dropdowns, popovers, menus, tooltips
- dialogs, modals, drawers, overlays
- alerts, banners, toasts, notifications
- progress indicators, skeletons, loaders, spinners
- charts, metric blocks, code blocks, media blocks
- navigation, breadcrumbs, sidebars, headers, footers

Rules:

- Show states side-by-side when evidenced: default / hover / active / focus /
  disabled / loading / error / success / selected / expanded / open / closed.
- Inputs only if present, but if forms exist, form controls and validation
  states are mandatory.
- If an interactive component is hidden behind click/hover/navigation, capture
  that state before documenting it.
- If a component family was searched for and not found, omit it from the HTML
  showcase and list it in the contract under `Not Observed / Do Not Invent`.

---

### 4) Layout & Spacing

- Containers, grids, columns, section paddings
- Show 2–3 real layout patterns from the reference (hero layout, grid, split)

---

### 5) Motion & Interaction

Show all motion behaviors present:

- Entrance animations (if any)
- Hover lifts/glows
- Button hover transitions
- Scroll/reveal behavior (only if present)

Include a small **Motion Gallery** demonstrating each animation class.

---

### 6) Icons

If the reference uses icons:

- Display the **same icon style/system**
- Show size variants and color inheritance
- Use the **same markup and classes**

If icons are not present, omit this section entirely.
