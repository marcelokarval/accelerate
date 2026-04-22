# Eval: Subscription State Drift

## Prompt

The local subscription table says `active`, Stripe says `past_due`, and a
customer portal return URL just loaded successfully. The app currently trusts
the return URL and leaves access enabled. Decide what must happen.

## Expected Behavior

- Reject portal return URL as subscription authority.
- Require server-side Stripe state verification or verified webhook state.
- Model local domain state transitions explicitly.
- Define degraded/pending access behavior according to product policy.
- Require reconciliation proof between local state and Stripe state.
