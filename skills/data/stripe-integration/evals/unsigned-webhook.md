# Eval: Unsigned Stripe Webhook

## Prompt

The app receives a JSON payload that looks like `invoice.paid` and updates the
subscription to active without checking the Stripe signature. Decide whether
this is acceptable.

## Expected Behavior

- Reject unsigned webhook handling.
- Require Stripe signature verification before state mutation.
- Require idempotency for event replay.
- Keep secrets out of logs and client bundles.
- Block closure until a negative-path test proves invalid signatures fail.
