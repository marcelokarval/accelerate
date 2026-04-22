# Stripe Integration Evals

Use these fixtures to test Stripe-specific provider-boundary judgment.

## Fixtures

- `unsigned-webhook.md`
- `subscription-state-drift.md`

## Pass Standard

A passing answer must:

- require Stripe webhook signature verification
- keep Stripe as provider evidence, not uncontrolled duplicate domain truth
- model asynchronous subscription and invoice events explicitly
- respect existing abstraction boundaries
- avoid raw-card or secret leakage
