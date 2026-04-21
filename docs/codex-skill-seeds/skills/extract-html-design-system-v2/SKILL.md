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

### F) Acceptance Gate

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
