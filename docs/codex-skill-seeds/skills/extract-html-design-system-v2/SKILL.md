---
name: extract-html-design-system-v2
description: Build a single-file living design system and pattern library from a reference website HTML by preserving its exact classes, assets, animations, behavior, and layout patterns.
---
# Extract HTML Design System v2

You are a **Design System Showcase Builder**.
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
consolidated `design-system.html` from the union of components, typography,
surfaces, layouts, motion, and icons actually present in those sources.

Your task is to create **one new intermediate HTML file** that acts as a **living design system + pattern library** for this exact design.

---

## GOAL

Generate **one single file** called: `design-system.html` and place it under
`docs/reference/` inside the root of the project where the skill was invoked, or
inside the root of the project explicitly referenced by the user.

If `docs/reference/` does not exist, create it.

This file must preserve the **exact look & behavior** of the reference design by **reusing the original HTML, CSS classes, animations, keyframes, transitions,effects, and layout patterns** — not approximations.

---

## HARD RULES (NON-NEGOTIABLE)

1. Do **not redesign** or invent new styles.
2. Reuse **exact class names, animations, timing, easing, hover/focus states**.
3. Reference the **same CSS/JS assets** used by the original.
4. If a style/component is not used in the reference HTML, **do not add it**.
5. The file must be **self-explanatory by structure** (sections = documentation).
6. Include a **top horizontal nav** with anchor links to each section.
7. Do **not** create synthetic summary cards, placeholder logos, fake metrics,
   invented copy, or "visual language" samples that are not backed by source
   HTML.
8. Keep a clear evidence trail from each displayed pattern back to the captured
   source file or URL.

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

Before writing `design-system.html`, inspect the captured sources and identify:

- page shell: header, nav, footer, major section wrappers
- hero structure and assets
- typography classes and real text hierarchy
- color/surface classes and gradients
- buttons, links, badges, tabs, cards, menus, forms, code blocks, logos, and
  other real components
- grid, split, stack, and container patterns
- animation, transition, hover, focus, active, disabled, and `data-state`
  patterns
- icon systems and inline SVG conventions

If an item is not found in the captured sources, omit it.

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

### D) Evidence Phase

Every major section must include concise source evidence.

Use visible labels or comments such as:

- `Source: .tmp/reference-home.html | hero`
- `Source: https://example.com/product | nav product menu`
- `Source: captured CSS class list | hover:bg-* transition duration-*`

This is not optional. The artifact must show where each pattern came from so
future UI work can audit it without redoing the extraction.

### E) Acceptance Gate

Before closure, compare the final `design-system.html` against the captured
sources.

The output is invalid if any of these are true:

- `.tmp/` does not contain captured source files
- `docs/reference/design-system.html` is missing
- the hero is not a direct clone except for text adaptation
- source assets are not referenced or documented
- major visible source patterns are absent without explanation
- the artifact contains invented cards, icons, layouts, metrics, or copy
- the artifact has no visible source evidence
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

- Buttons, inputs, cards, etc. (only those that exist)
- Show states side-by-side: default / hover / active / focus / disabled
- Inputs only if present (default/focus/error if applicable)

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
