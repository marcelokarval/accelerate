---
name: legacy-first-protocol
description: Codex-native protocol for consulting donor legacy systems before creating new behavior in domains that already exist.
user-invocable: true
related-skills: front-react-shadcn, django-service-patterns, react-best-practices
---

# legacy-first-protocol

Use this skill before creating new behavior in domains that already exist in a
declared donor legacy system.

## Purpose

Prevent feature drift by forcing explicit consultation of the legacy system
before inventing a new implementation for an existing domain.

The legacy system is reference material for:

- business rules
- user flows
- state handling
- naming and domain coverage
- frontend interaction patterns

## Load When

Load this skill when the task touches:

- new feature work in a domain that has a declared legacy donor
- new services, pages, hooks, or components in domains that existed before
- migrations from a legacy transport/runtime pattern to the active stack

## Core Rules

1. Check whether the feature or domain already exists in the declared legacy
   donor path.
2. Treat the legacy system as product reference, not copy-paste source.
3. Preserve the validated business behavior unless there is an explicit reason
   to diverge.
4. Document what is being ported, what is being improved, and what is being
   intentionally dropped.
5. Adapt to the current stack instead of reproducing outdated infrastructure
   choices.

## Legacy Search Order

1. Check the donor frontend for mature interaction behavior.
2. Check any donor vertical/product-specific app for richer or newer flows.
3. Check the donor backend for domain services and business rules.

## Required Output Before Implementation

Capture at least this mental or written summary:

- feature/domain being touched
- files consulted in legacy
- behavior to preserve
- improvements to introduce
- intentional divergences and why

## Current-Stack Adaptation Rules

- Legacy transport, client cache, or state-management patterns should not be
  copied blindly into the active stack.
- Old UI component libraries should be translated into the current design
  system.
- Backend business rules should be preserved, but implementation should follow
  current service-layer architecture.

## Review Checklist

- Was legacy consulted before creating new behavior?
- Are divergences intentional and justified?
- Was legacy behavior adapted to the current stack rather than duplicated?

## References

- declared legacy donor backend path
- declared legacy donor frontend path
- declared legacy donor vertical/product-specific paths
