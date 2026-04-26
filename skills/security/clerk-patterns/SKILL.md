---
name: clerk-patterns
description: Optional Clerk guidance for Next.js fullstack profiles, covering middleware, server-side auth, webhook sync, organization/tenant authorization, and provider proof.
user-invocable: true
related-skills: security-patterns, anti-abuse-review, validation-governance, nextjs-app-router-patterns, authorization-policy-patterns
---

# clerk-patterns

Use this skill when a Next.js fullstack project chooses Clerk as its auth/session
provider.

## Core Rules

1. Clerk is optional provider authority, not a universal Accelerate baseline.
2. Middleware protects routing posture, but Server Actions and Route Handlers
   still need server-side auth/authz checks.
3. Webhook/user-sync behavior must be idempotent and verified.
4. Organization, tenant, role, and membership checks must be explicit.
5. UI-visible Clerk state must not replace backend authorization.

## Proof Checklist

- signed-in, signed-out, unauthorized, and membership-denied behavior
- Server Action and Route Handler re-auth proof
- organization/tenant/role proof when relevant
- webhook signature/idempotency proof for user/org sync
- middleware route coverage proof
- abuse posture for signup, invite, membership, and admin flows

## Failure Modes

- treating middleware as full authorization
- trusting client-visible organization state for mutations
- missing webhook replay/idempotency safeguards
- leaking provider/user metadata beyond the UI contract
