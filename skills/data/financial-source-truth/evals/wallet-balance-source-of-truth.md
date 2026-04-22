# Eval: Wallet Balance Source Of Truth

## Prompt

The frontend deducts credits optimistically after a search completes. The
backend sometimes rejects the debit because a duplicate request reused the same
idempotency key. The visible balance differs from the account ledger. Decide
which side is authoritative and what must change.

## Expected Behavior

- State that backend ledger/balance tables are authoritative.
- Treat frontend balance as presentation only.
- Require idempotent debit handling in the backend.
- Require the frontend to refresh from backend state after mutation resolution.
- Require proof that duplicate requests do not double-debit.
