# Active Risk Detection Signals

Use this module to make risk detection continuous and explicit.

This file focuses on signals and cadence.

For the full operational mapping by risk class, use:

- `risk-enforcement-matrix.md`

## Detection Matrix

| Risk class | Active signals | Required lane or response |
| --- | --- | --- |
| decomposition risk | repeated unclear slice boundaries, packet repair keeps recurring, execution package still mixes multiple owners | open technical lane, keep root-owned until repaired |
| staffing risk | repeated weak fit, repeated three-family need, root compensation keeps recurring | re-run staffing ladder, evaluate gap instead of fit |
| contract risk | prop drift, route/link drift, identifier mismatch, validation authority confusion, shell/page data placement doubt | open technical or contract lane, require contract correctness proof |
| proof risk | tests missing, wrong proof tier used, browser truth absent, persistent proof claimed before browser truth | open proof lane, block closure until evidence stack is correct |
| trust risk | auth/session/billing/export/upload/recovery/list/search/settings surface with hostile-path doubt | open trust lane, classify trust blocker |
| lifecycle risk | acceptance weak, issue topology wrong, parent/child unclear, child slices no longer roll up cleanly | open lifecycle lane, block implementation or closure until fixed |
| rollout risk | migration uncertainty, rollback ambiguity, staged rollout not thought through, provider state or data evolution risk | open technical lane plus rollout blocker evaluation |

## Continuous Detection Rule

These signals should be checked:

- before staffing
- before execution
- before moving to `In Review`
- before root closure
