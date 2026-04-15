# Risk Enforcement Matrix

Use this module as the single operational table for macro risk enforcement.

Every material risk class must be readable here without cross-assembling
multiple documents mentally.

## Matrix

| Risk class | Detector | Active signal | Owner | Blocker condition | Release condition | Required lane |
| --- | --- | --- | --- | --- | --- | --- |
| decomposition risk | root decomposition-risk detector | unclear slice boundaries, recurring packet repair, mixed ownership in one package | technical lane governor | invalid slice shape or staffing would create structural drift | technical lane confirms bounded slice shape | technical |
| staffing risk | root staffing-risk detector | repeated weak fit, repeated three-family compositions, recurring root compensation | executive routing lane | no honest staffing shape exists yet | staffing ladder produces clean root-only, one-family, or two-family shape | executive routing + technical when needed |
| contract risk | root contract-risk detector | prop drift, route drift, identifier mismatch, validation-boundary confusion, shell/page data-placement doubt | technical lane governor | route/prop/identifier/validation truth unresolved | contract correctness explicitly proven | technical or design-contract depending on dominant pressure |
| proof risk | root proof-risk detector | missing tests, wrong proof tier, browser truth absent, persistent proof claimed too early | proof lane governor | mandatory evidence is missing or out of order | required proof stack is present and coherent | proof |
| trust risk | root trust-risk detector | hostile-path doubt on auth/session/billing/export/upload/recovery/list/search/settings | trust lane governor | trust posture remains materially weak | trust review explicitly revalidated | trust |
| lifecycle risk | root lifecycle-risk detector | weak acceptance, unstable issue shape, broken parent/child truth, stale child rollup | lifecycle lane governor | issue truth is too unstable for execution or closure | lifecycle lane confirms issue truth is clean | lifecycle |
| rollout risk | root rollout-risk detector | migration uncertainty, rollback ambiguity, staged rollout weakness, provider/data evolution risk | technical lane governor with root closure oversight | rollout safety is weak or recovery posture is ambiguous | rollout safety and recovery posture are explicit and evidenced | technical, with rollout blocker handling |

## Reading Rule

Read this file first when the question is:

- which risk is active?
- who owns that risk?
- what blocks closure?
- what evidence releases the block?

Use the adjacent docs for explanation detail, not for replacing this matrix.

