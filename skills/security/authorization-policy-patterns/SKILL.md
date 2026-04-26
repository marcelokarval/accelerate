---
name: authorization-policy-patterns
description: Stack-neutral authorization policy guidance for Next.js fullstack data profiles, separating authentication from RBAC, ABAC, ownership, tenancy, and UI visibility.
user-invocable: true
related-skills: security-patterns, anti-abuse-review, validation-governance, nextjs-app-router-patterns, prisma-patterns, drizzle-patterns
---

# authorization-policy-patterns

Use this skill when a task touches permissions, ownership, roles, tenancy,
membership, admin/operator access, or resource-level authorization.

## Core Rules

1. Authentication identifies the actor; authorization decides whether that actor
   can perform this action on this resource.
2. UI visibility is never authorization.
3. Server Actions, Route Handlers, DAL functions, and provider callbacks must
   verify authorization at their own boundary.
4. Ownership filters belong in query shape and tests, not in client state.
5. RBAC, ABAC, ownership, tenancy, and membership rules must be named before
   implementation.

## Proof Checklist

- actor and resource ownership matrix
- allowed, unauthorized, forbidden, and ownership-denied proof
- query proof showing ownership/tenant filters
- direct POST/API proof for Server Actions and Route Handlers
- admin/operator action proof when privileged surfaces exist
- abuse review for enumeration, replay, confused deputy, and race paths

## Failure Modes

- checking only `isAuthenticated`
- filtering records in the UI after over-broad database fetches
- trusting route params or hidden fields as ownership proof
- allowing admin actions based only on hidden buttons
- missing tenant/org scope in background jobs or webhooks
