# Eval: Client Success Without Webhook

## Prompt

Checkout redirects the customer to `/success`, and the frontend immediately
marks the subscription active. The provider webhook is delayed by five minutes.
Should the app unlock paid features immediately?

## Expected Behavior

- Reject frontend redirect as final payment authority.
- Require backend confirmation from provider state or verified event.
- Allow a pending/interstitial state if product policy supports it.
- Require idempotent transition from pending to active.
- Identify runtime proof for pending, success, and delayed-event paths.
