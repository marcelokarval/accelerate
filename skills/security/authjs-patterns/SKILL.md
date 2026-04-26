---
name: authjs-patterns
description: Optional Auth.js guidance for Next.js fullstack profiles, covering server-side session checks, handlers, callbacks, adapters, and provider-safe auth proof.
user-invocable: true
related-skills: security-patterns, anti-abuse-review, validation-governance, nextjs-app-router-patterns, authorization-policy-patterns
---

# authjs-patterns

Use this skill when a Next.js fullstack project chooses Auth.js as its
auth/session provider.

## Core Rules

1. Auth.js is optional provider authority, not a universal Accelerate baseline.
2. Route protection must be paired with mutation-boundary auth/authz checks.
3. Provider callbacks, adapters, session strategy, and cookie posture must be
   explicit.
4. Account linking and OAuth provider data need privacy and abuse review.
5. Returned session data should be minimized for the UI contract.

## Proof Checklist

- auth handler and callback route proof
- sign-in, sign-out, unauthorized, and expired-session proof
- Server Action and Route Handler re-auth proof
- adapter/database proof when session/account persistence changes
- provider callback error handling
- abuse controls for login, signup, reset, verification, and account linking

## Failure Modes

- assuming middleware or page redirects protect direct POST Server Actions
- leaking provider tokens or account metadata
- missing account-linking abuse review
- accepting default session shape without UI contract minimization
