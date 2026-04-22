---
name: api-surface-governance
description: Codex-native governance for choosing between Inertia, REST exceptions, GraphQL preparation, webhooks, callbacks, and other integration surfaces.
---

# api-surface-governance

Use this skill when transport or API surface choice is part of the decision.

## Surface Order

1. Use the active product runtime surface for current web-app behavior.
2. Use REST or webhook/callback endpoints only for genuine integration
   boundaries.
3. Use GraphQL only when the active architecture explicitly selects it, or as
   documented future-facing preparation.

## REST Rule

REST must be justified by the boundary itself, not by convenience.

## GraphQL Rule

GraphQL is not an implicit default. If considered, keep the current web scope
separate from future-facing API preparation.

## Framework Status

- No transport framework is implicitly approved by legacy precedent.
- A new API framework must be justified by boundary, consumers, auth model,
  validation authority, and runtime ownership.
- The active stack profile decides which framework is official, deprecated, or
  experimental.

## Review Questions

- Was the active runtime surface rejected only after real justification?
- Does the REST endpoint exist because the boundary requires it?
- Was future API preparation kept out of present web scope?
