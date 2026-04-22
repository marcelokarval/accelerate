---
name: django-pro
description: Codex-native broader Django engineering guidance for framework-level architecture, ORM use, middleware, and project-structure concerns.
user-invocable: true
related-skills: django-service-patterns, django-inertia-integration, python-pro
---

# django-pro

Use this skill for broader Django engineering decisions that go beyond a single
service or view pattern.

## Purpose

Provide a modern Django quality baseline while staying subordinate to the
project's own architecture and service-layer conventions.

This skill supports `Backend Query Correctness` whenever framework-level ORM,
middleware, or project-structure choices influence query shape and access
behavior.

## Load When

Load this skill when the task touches:

- larger Django architecture decisions
- ORM usage and query behavior
- settings and project structure decisions
- middleware, admin, async boundaries, and framework-level concerns
- any backend review where `Backend Query Correctness` is mandatory and the
  issue is broader than one service

## Core Rules

1. Let project architecture rules override generic Django advice.
2. Use the ORM intentionally and inspect query behavior where it matters.
3. Keep app structure explicit and maintainable.
4. Prefer framework-native capabilities before adding complexity.
5. Align with the current deployment/runtime reality instead of abstract Django
   maximalism.

## Accelerate Guidance

- Service layer, ownership boundaries, public identifiers, and Inertia
  integration are stack-profile rules when the active project uses the
  Django/Inertia profile.
- This skill is a broad Django support layer, not a replacement for
  `django-service-patterns` or `django-inertia-integration`.

## Review Checklist

- Is the decision really framework-level?
- Does it reinforce, rather than fight, the existing project architecture?
