# Payment Integration Evals

Use these fixtures to test provider-agnostic billing workflow judgment.

## Fixtures

- `client-success-without-webhook.md`
- `duplicate-payment-event.md`

## Pass Standard

A passing answer must:

- reject client-only payment success as authority
- require server-side provider verification
- model async events and retries explicitly
- enforce idempotency for duplicate callbacks or webhooks
- keep domain state separate from provider transport details
