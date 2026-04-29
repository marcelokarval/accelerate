# Product Copy Domain Semantics

## Purpose

Use this reference when UI work adds, renames, or removes user-facing copy in a
domain surface.

Premium UI often fails by adding decorative labels that explain the obvious or
misname the user's object. Copy must serve domain understanding, not visual
ornament.

## Rule

Do not add user-facing copy unless it improves comprehension, decision-making,
or action selection for the current domain context.

## Required Questions

- Is this information already obvious from the page or object context?
- Does this label accurately describe the object in this product's domain?
- Would a user wonder why this label exists?
- Does the copy add action clarity or just decorate the layout?
- Does it imply a lifecycle state that may not be true?
- Is this row/list/table already scoped to the object type being labeled?

## Common Failure Modes

- Labeling every row `saved asset` inside a page that is already the user's saved
  properties.
- Adding `open asset` when clicking the row is already the established detail
  interaction.
- Renaming business objects for aesthetic consistency while losing product truth.
- Repeating the same concept in page title, section title, row label, and CTA.

## Acceptance Standard

New copy passes only when it is necessary, domain-accurate, and not redundant
with the containing surface.
