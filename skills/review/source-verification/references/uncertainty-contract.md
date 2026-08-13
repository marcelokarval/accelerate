# Contradiction And Uncertainty Contract

## Reconciliation Order

When sources conflict, compare:

1. claim definition and scope
2. governing versus advisory authority
3. product/runtime version and configuration
4. publication, commit, and observation date
5. primary evidence versus derived summary
6. documented contract versus actual runtime behavior
7. method quality and reproducibility

Do not count duplicated citations as independent corroboration. Preserve adverse
evidence in the record even when a governing authority decides the outcome.

## Confidence Language

Use calibrated language:

- `high`: direct applicable authority plus compatible observed evidence, with no
  unresolved material contradiction
- `moderate`: good applicable evidence with bounded gaps or indirect
  corroboration
- `low`: incomplete, stale, indirect, or materially contested evidence

Do not assign a percentage unless a defined measurement method produces it.

## Escalation

Return `uncertain` or `blocked` when the missing evidence could change a
material design, security, provider, migration, or closure decision. Name the
smallest next action that would resolve uncertainty: locate a versioned source,
run a controlled reproduction, obtain authorized provider readback, or ask the
governing owner to decide an explicit policy conflict.
