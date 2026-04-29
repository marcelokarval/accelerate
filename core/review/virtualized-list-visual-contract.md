# Virtualized List Visual Contract

## Purpose

Use this review contract when UI work changes a row, card, or table item rendered
inside a virtualized list.

Virtualization makes visual regressions easy to miss: the DOM can render, tests
can pass, and screenshots can exist while rows overlap because item anatomy
exceeds the configured row height.

## Rule

Do not add vertical content to virtualized rows without proving the rendered row
height still fits the virtualizer configuration or intentionally updating the
configuration.

## Required Checks

- Locate the virtualizer row-height source, for example `rowHeight`, `itemSize`,
  `estimateSize`, `getItemSize`, or view config constants.
- Compare the changed row/card anatomy against the configured height.
- Inspect the browser screenshot for overlap, clipping, hidden content, and
  unexpected inter-row stacking.
- If content grows, either reduce anatomy, increase row height, or move content
  behind a detail surface.
- Reprove the corrected state with browser screenshot evidence.

## Smells

- More labels were added to every row for premium polish.
- A CTA line was added to every virtualized card.
- Badges wrap to a new line in common data.
- Score/action columns force row content taller than expected.
- Screenshot shows cards touching, overlapping, or partially hidden.

## Acceptance Standard

The branch can answer:

- what virtualizer owns row height
- what height is configured
- whether the changed row fits that height
- which screenshot proves no overlap or clipping
- whether density stayed acceptable for the workflow
