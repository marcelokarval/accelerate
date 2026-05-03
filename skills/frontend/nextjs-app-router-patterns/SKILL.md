---
name: nextjs-app-router-patterns
description: Codex-native Next.js App Router patterns for fullstack profiles, covering layouts, Server Components, Server Actions, Route Handlers, cache/revalidation, middleware, runtime boundaries, cookies/headers, redirects, streaming, and error boundaries.
user-invocable: true
related-skills: inertia-patterns, architecture
---

# nextjs-app-router-patterns

Use this skill when a selected profile is actually Next.js App Router, or when
referencing App Router concepts as architectural comparison material.

## Purpose

Keep Next.js runtime truth explicit. In Next profiles, this is operational
guidance. In non-Next profiles, it is comparison material only.

## Load When

Load this skill when the task touches:

- hierarchical layout thinking
- server/component boundary comparisons
- migration comparisons with Next.js-style organization
- Server Components and client boundaries
- Server Actions and Route Handlers
- middleware, redirects, cookies, and headers
- cache, revalidation, streaming, and error boundaries
- node/edge runtime selection

## Core Rules

1. In Next.js profiles, backend truth belongs in Server Components, Server
   Actions, Route Handlers, middleware, or server-only modules, not client-only
   convenience code.
2. In non-Next profiles, use App Router only as reference and translate concepts
   into the actual stack.
3. Keep cache and revalidation ownership explicit for user-visible data.
4. Choose node vs edge runtime deliberately; do not assume provider APIs,
   database drivers, crypto, filesystem, or background work behave the same in
   both runtimes.
5. Treat cookies, headers, redirects, and auth/session reads as server authority.
6. Pair Server Actions and Route Handlers with validation, authorization,
   idempotency, and error-state proof.
7. Streaming/loading/error boundaries must preserve product clarity, not just
   framework correctness.

## Accelerate Guidance

- This skill is operational for `nextjs-*` profiles.
- It is comparative only for Django/Inertia or other non-Next profiles.
- It is especially important when reasoning about nested layouts, route
  ownership, server/client boundaries, and cache/revalidation posture.

## Review Checklist

- Is this a concept worth borrowing, or a runtime mismatch?
- Has the idea been translated into the actual stack?
- Are Server Components, Server Actions, and Route Handlers assigned to the
  smallest honest owner?
- Are cache keys, tags, revalidation triggers, and dynamic/static rendering
  choices explicit?
- Are auth/session, cookies, headers, redirects, and middleware proven at the
  server boundary?
- Are loading, empty, error, unauthorized, and success states represented in UI
  proof?
