---
name: vercel-deployment-patterns
description: Optional Vercel deployment guidance for Next.js fullstack profiles, covering build/runtime proof, environment variables, cache behavior, preview deployments, and provider integration boundaries.
user-invocable: true
related-skills: nextjs-app-router-patterns, security-patterns, prisma-patterns, drizzle-patterns, product-runtime-review
---

# vercel-deployment-patterns

Use this skill when a Next.js fullstack project deploys to Vercel or changes
Vercel-specific runtime behavior.

## Core Rules

1. Vercel is optional deployment authority, not a universal Accelerate baseline.
2. Build, install, and generated-client behavior must be proven when Prisma or
   Drizzle data profiles are active.
3. Preview, production, and local env sets must not be conflated.
4. Cache, revalidation, edge/node runtime, and region choices are runtime
   decisions that require proof when changed.
5. Secrets must stay server-only and environment-scoped.

## Proof Checklist

- build/install command proof
- environment variable scope proof for local, preview, and production where in
  scope
- Prisma generated-client or Drizzle migration strategy proof when relevant
- route/runtime mode proof for Node vs Edge-sensitive code
- cache/revalidation proof for user-visible data changes
- deployment logs or platform evidence when available
