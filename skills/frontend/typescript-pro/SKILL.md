---
name: typescript-pro
description: Use when TypeScript work involves strict typing, shared contracts, unions, generics, frontend/backend data boundaries, or pragmatic type-driven refactors.
user-invocable: true
related-skills: front-react-shadcn, react-best-practices, javascript-pro
---

# typescript-pro

Use this skill for TypeScript modeling, strictness, and type-driven refactors in
frontend or typed utility code.

## Purpose

Strengthen type safety without losing developer ergonomics or fighting the
existing project architecture.

## Load When

Load this skill when the task touches:

- `.ts` or `.tsx` files
- interfaces, unions, generics, utility types
- shared contracts between components, pages, forms, and services

## Core Rules

1. Keep strict mode assumptions intact.
2. Prefer explicit domain interfaces for important data boundaries.
3. Use advanced types only when they improve clarity and safety.
4. Avoid type-level complexity that hides product intent.
5. Preserve readable props and page contracts.

## Accelerate Guidance

- In React code, component and page props should be clear before they are
  clever.
- Use framework-specific skills for UI and route/page behavior; this skill
  focuses on typing.
- Prefer narrowing and stable contracts over `any`, broad casts, or implicit
  escape hatches.

## Review Checklist

- Are the types improving safety at the real boundary?
- Is inference sufficient, or does the boundary need an explicit interface?
- Did the solution avoid unnecessary type gymnastics?
