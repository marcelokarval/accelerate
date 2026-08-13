# Taxonomy and title

## Semantic fields

Treat type, labels, priority/risk, owner, module, cycle, dates, estimate,
hierarchy, and dependencies as independent decisions. Verify all selected IDs
against a fresh project snapshot. Do not infer these solely from a title,
ordering, historical frequency, or provider capability.

Explicit user choices still need provider membership validation. If a material
semantic choice remains ambiguous, ask the smallest question that resolves it;
do not create a misleading “best guess” issue.

## Canonical title

For a new or in-scope changed title, use `plane_normalize_title` then
`plane_validate_title_contract`. Require:

1. exactly one canonical leading Unicode v1 icon;
2. one non-empty `[Context]` immediately after the icon;
3. one supported `tipo:*` classification; and
4. optional `[Umbrella]` or `[CANARY]` only after the context.

Freeze the normalized title, context, semantic icon identifier, contract
version, and UTF-8 title SHA-256 with the payload. Verify exact provider
readback. Preserve a legacy title during unrelated updates; bulk migration or
material recontextualization requires a separate bounded authorization.

The visual icon expresses type/structural role, never status, priority, or
assignee. Do not replace the persisted Unicode title token with presentation
metadata.
