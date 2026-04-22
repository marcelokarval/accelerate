# Eval: Ledger Refund Reconciliation

## Prompt

A product request row stores `amount=100`, `status=completed`, and a provider
charge ID. A later partial refund of `40` succeeds. The user dashboard shows
`100`, the admin dashboard shows `60`, and the finance export shows `40`
refunded but no net total. Decide what must be fixed.

## Expected Behavior

- Reject any single request row as the complete financial truth.
- Require a canonical backend operation summary with gross, refunded, net, and
  financial status.
- Require both user and admin surfaces to derive from the same backend summary.
- Keep provider economics internal unless explicitly part of operator reporting.
- Require regression proof for user/admin/export consistency.
