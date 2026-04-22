---
name: figma-node-fidelity
description: Use when rebuilding or refining UI from Figma MCP and visual fidelity depends on exact node hierarchy, child order, spacing, overlaps, or breakpoint-specific composition.
---

# Figma Node Fidelity

Use this when frame-level reading is not enough and the layout must match Figma closely.

## Core Rule

Do not trust a full-page frame alone for fine adjustments. For any section under refinement:

1. Inspect the section node.
2. Inspect the immediate group that actually contains the visual elements.
3. Inspect the relevant children and grandchildren.
4. Only then describe or implement.

## Required Workflow

### 1. Build the real node chain

- Get the section node metadata.
- Find the internal group that owns the actual composition.
- Read the direct children that define the layout.
- For any dense child group, inspect its children too.

If you stop at the frame level, you will miss badges, CTA blocks, separators, arrows, and real child order.

### 2. Separate inventory from interpretation

Before proposing changes, write down:

- every visible primitive
- the order of siblings
- `x/y`, width, height
- gaps between groups
- gaps inside groups
- what is above, below, or overlapping

Do not summarize a group as “logo + countdown” if it is actually “logo + label + boxes + CTA”.

### 3. Validate sequence by the common parent

When the composition involves transitions, overlays, arrows, carousel backgrounds, or stacked sections:

- use the same parent context
- compare sibling order
- verify `y` positions

Do not infer visual order from narrative or from a large screenshot.

### 4. Use screenshots surgically

- Use full-frame screenshots for macro direction.
- Use node-specific screenshots for micro accuracy.
- If details still look ambiguous, inspect the child nodes again instead of guessing.

### 5. Treat desktop, tablet, and mobile separately

Once desktop fidelity is clear:

- keep the desktop composition as the source truth
- adapt tablet independently
- adapt mobile independently

Do not assume one set of offsets scales cleanly across breakpoints.

### 6. Debug overlaps structurally

If an asset should look like a background for elements above and below it:

- confirm which section actually owns that visual scene
- place the asset in that section
- then adjust stacking and spacing

Do not burn time trying to fix section-ownership mistakes with only `z-index`, negative margins, or extra overlays.

## Output Pattern

For each section under refinement, work in this order:

1. node chain
2. primitive inventory
3. ASCII wireframe of the real composition
4. differences versus current implementation
5. implementation
6. breakpoint-specific review

## Use With

- `ascii-wireframe` when the user needs visual comparison before code changes
- browser/devtools validation after implementation
