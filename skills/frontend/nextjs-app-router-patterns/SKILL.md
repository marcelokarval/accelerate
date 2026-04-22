---
name: nextjs-app-router-patterns
description: Codex-native reference skill for borrowing useful Next.js App Router concepts, especially around hierarchical layouts and composition.
user-invocable: true
related-skills: inertia-patterns, architecture
---

# nextjs-app-router-patterns

Use this skill when referencing Next.js App Router patterns as architectural
input, comparison material, or inspiration for layout hierarchy decisions.

## Purpose

Capture useful App Router ideas without pretending the current app is a Next.js
runtime.

## Load When

Load this skill when the task touches:

- hierarchical layout thinking
- server/component boundary comparisons
- migration comparisons with Next.js-style organization

## Core Rules

1. Use App Router patterns as reference, not as literal runtime instructions for
   Inertia.
2. Port concepts only when they make sense in the current stack.
3. Avoid introducing Next.js-specific assumptions into non-Next.js code.

## Accelerate Guidance

- This skill is mostly architectural and comparative.
- It is especially useful when reasoning about nested layouts, route ownership,
  and compositional shell design.

## Review Checklist

- Is this a concept worth borrowing, or a runtime mismatch?
- Has the idea been translated into the actual stack?
