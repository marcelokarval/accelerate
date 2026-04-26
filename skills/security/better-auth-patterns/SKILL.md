---
name: better-auth-patterns
description: Optional Better Auth guidance for Next.js fullstack profiles, covering server-side session authority, action re-authentication, callbacks, provider configuration, and auth runtime proof.
user-invocable: true
related-skills: security-patterns, anti-abuse-review, validation-governance, nextjs-app-router-patterns, authorization-policy-patterns
---

# better-auth-patterns

Use this skill when a Next.js fullstack project chooses Better Auth as its
auth/session provider.

## Core Rules

1. Better Auth is optional provider authority, not a universal Accelerate
   baseline.
2. Server Actions and Route Handlers must re-check session and authorization at
   the mutation boundary.
3. Auth configuration, secrets, trusted origins, adapters, and callback routes
   require runtime proof when touched.
4. UI visibility is not authorization.
5. User/session objects returned to the client must be minimized.

## Proof Checklist

- sign-in, sign-out, signed-out, and expired-session behavior
- unauthorized and ownership-denied mutation behavior
- callback/webhook route proof when provider callbacks are touched
- cookie/session/storage posture proof
- CSRF/origin/trusted-host posture proof where applicable
- rate-limit or abuse posture for login, signup, reset, and verification flows

## Failure Modes

- relying on layout/page checks to secure Server Actions
- exposing full user/session objects to client components
- skipping callback failure states
- missing abuse controls on high-volume auth endpoints
