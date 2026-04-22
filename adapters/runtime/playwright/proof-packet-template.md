# Playwright Proof Packet Template

Use this packet when persistent regression proof is part of closure.

## Persistent Regression Packet

- Surface:
- Scenario:
- Scenario class:
- Browser-proof source:
- Browser-proof ordering:
- Command:
- Result:
- Evidence:
- Failures:
- Residual gaps:
- Closure impact:

## Ordering Values

Use one of:

- `ordered`
- `out of order`
- `blocked`

## Result Values

Use one of:

- `passed`
- `failed`
- `blocked`

## Closure Impact Values

Use one of:

- `supports closure`
- `blocks closure`
- `not closure-relevant`

## Example

```text
Persistent Regression Packet
- Surface: billing payment recovery
- Scenario: delinquent user reaches payment resolution page
- Scenario class: regression
- Browser-proof source: planning/executive/billing-browser-proof.md
- Browser-proof ordering: ordered
- Command: npx playwright test tests/e2e/billing-recovery.spec.ts
- Result: passed
- Evidence: 1 passed, no console errors
- Failures: none
- Residual gaps: mobile viewport not covered
- Closure impact: supports closure
```
