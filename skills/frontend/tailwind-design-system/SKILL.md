---
name: tailwind-design-system
description: Use when Tailwind-based frontend work changes tokens, themes, shared variants, reusable visual primitives, or cross-feature design language.
user-invocable: true
related-skills: tailwind-patterns, active-frontend-stack
---

# tailwind-design-system

Use this skill for higher-level design-system work built on Tailwind.

## Purpose

Support consistent tokens, variants, and visual systems across the frontend
without turning every task into design-system theater.

This skill supports the workflow lens `Frontend Structure Correctness` when the
drift is about variants, tokens, and shared visual language rather than raw
placement alone.

## Load When

Load this skill when the task touches:

- reusable variant systems
- token naming
- theme extension
- consistent visual primitives across features
- any review where `Frontend Structure Correctness` is triggered by shared
  visual drift

Use this skill as the primary one when the change is about shared tokens,
variants, or design-language decisions that should outlive one component or one
page.

## Core Rules

1. Design-system changes should be deliberate and cross-cutting.
2. Avoid local one-off styles when the concern belongs in a shared primitive.
3. Keep token and variant naming semantic.
4. Prefer a small coherent system over a large inconsistent one.

## Accelerate Guidance

- Use this skill when a change affects shared visual language, not just one
  component.
- Coordinate with the active frontend stack and Tailwind utility skills.

## Review Checklist

- Is this really a design-system concern?
- Will the token/variant be reused?
- Does the naming fit the existing language?

## Trigger Matrix

- primary:
  - tokens
  - variants
  - theme extension
  - shared visual-language drift
- supporting only:
  - actual stack implementation -> active frontend stack skill
  - `.ts` vs `.tsx` ownership -> `frontend-boundary-governance`
  - placement/import direction -> `frontend-component-hierarchy`
  - reuse/extract/converge audit -> `frontend-componentization-audit`
