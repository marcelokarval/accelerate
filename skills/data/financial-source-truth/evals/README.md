# Financial Source Truth Evals

Use these fixtures to verify that the skill preserves backend financial truth
instead of accepting UI-derived balances or provider-only narratives.

## Fixtures

- `ledger-refund-reconciliation.md`
- `wallet-balance-source-of-truth.md`

## Pass Standard

A passing answer must:

- name the canonical backend source of truth
- distinguish gross, refunded, net, and provider-only values
- reject frontend-computed balances as authority
- require idempotent ledger or operation events for mutation paths
- leave a closure gap when reconciliation evidence is missing
