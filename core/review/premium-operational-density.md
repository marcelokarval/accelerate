# Premium Operational Density

## Purpose

Use this reference when premium visual work touches dashboards, CRM lists,
tables, lead queues, property lists, billing ledgers, task lists, or other
operational surfaces.

Premium does not mean larger cards, more labels, or lower information density.
For operational products, premium usually means better hierarchy, rhythm,
alignment, restraint, and faster scanning.

## Rule

Preserve the scan density of operational surfaces unless the branch explicitly
redesigns the workflow and proves the density tradeoff.

## Required Checks

- Compare visible item count before and after.
- Confirm primary content is still the fastest thing to read.
- Avoid adding per-row labels that compete with object names.
- Keep actions close to their objects without turning every row into a marketing
  card.
- Verify row height, pagination, and scroll behavior in browser proof.
- Prefer hierarchy and spacing tuning over adding new copy.

## Failure Labels

- `premium-card-bloat`
- `scan-density-loss`
- `label-noise`
- `row-action-dilution`
- `table-as-marketing-card`

## Acceptance Standard

A user can scan at least as quickly after the premium pass as before it, unless
the branch explicitly documents and approves a lower-density workflow.
