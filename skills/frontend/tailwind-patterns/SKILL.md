---
name: tailwind-patterns
description: Codex-native Tailwind CSS guidance for utility composition, responsive behavior, theme tokens, and readable class structures.
user-invocable: true
related-skills: tailwind-design-system, front-react-shadcn
---

# tailwind-patterns

Use this skill for Tailwind CSS usage patterns, responsive behavior, theme
tokens, and modern utility composition in the frontend.

## Purpose

Provide a practical Tailwind baseline for the project's current frontend stack.

## Load When

Load this skill when the task touches:

- utility composition
- responsive layout classes
- design tokens and CSS variables
- Tailwind v4 usage

## Core Rules

1. Prefer existing tokens and utility conventions before inventing new ones.
2. Keep class composition readable.
3. Use responsive rules intentionally, not by piling prefixes without structure.
4. Let the design system drive visual consistency.

## Accelerate Guidance

- In React/Tailwind stack profiles, this skill is subordinate to the active
  frontend stack skill and `tailwind-design-system`.
- Tailwind decisions should respect UI layer/z-index architecture and existing
  CSS variable usage.

## Review Checklist

- Is the class stack readable?
- Are tokens reused instead of reinvented?
- Does the responsive behavior match the actual component role?
