---
name: validation-governance
description: Codex-native validation governance. Use when deciding what belongs in backend validation versus frontend convenience validation, especially around schemas, Inertia forms, local parsing, password rules, and domain-sensitive business validation.
---

# validation-governance

Use this skill when validation boundaries matter.

## Core Rule

Backend is the final authority for domain validation and write acceptance.

## Allowed Frontend Role

Frontend validation may exist to:

- improve UX
- reduce unnecessary round-trips
- block trivial invalid input
- protect the backend from noisy obvious failures
- support local interactive state

## Forbidden Drift

Do not let frontend validation become:

- canonical domain schema
- business-rule authority
- leak of sensitive business logic
- competing source of contract truth

## Frontend Schema Rule

Frontend schema libraries are acceptable as helpers for local parsing, UI
validation, and interaction state. They are not the canonical domain contract
unless the active architecture explicitly says so.

## Review Questions

- Is backend still the final validator?
- Is frontend validation intentionally partial?
- Is the frontend schema layer still only a bounded helper?
