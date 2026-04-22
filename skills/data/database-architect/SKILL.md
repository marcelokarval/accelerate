---
name: database-architect
description: Codex-native higher-level data architecture guidance for cross-domain schema strategy, lifecycle planning, and migration-aware database decisions.
user-invocable: true
related-skills: database-design, postgresql, postgres-best-practices
---

# database-architect

Use this skill for higher-level data architecture decisions that cross a single
table or feature.

## Purpose

Provide a structured way to reason about data-layer architecture, migration
boundaries, and longer-lived database decisions.

This skill is for macro data decisions, not local table mechanics.

## Load When

Load this skill when the task touches:

- larger domain modeling changes
- cross-domain schema strategy
- archival, retention, partitioning, or multi-tenant concerns
- re-architecture of an existing data area

Do not use this skill for:

- local entity or table modeling
- column, constraint, or index detail
- PostgreSQL feature selection for one schema slice
- query-path tuning on an already chosen schema

## Core Rules

1. Start from domain boundaries and access patterns.
2. Separate schema detail decisions from broader data architecture decisions.
3. Design for maintainability and migration safety, not just theoretical scale.
4. Keep operational complexity proportional to actual needs.

## Accelerate Guidance

- Favor coherent monolith data architecture over premature polyglot persistence.
- Use this skill when the decision spans domains, lifecycle, or storage
  strategy, not for every small table change.

## Boundary Against Adjacent Skills

- `database-design`
  - use for entity, relationship, invariant, and schema-shape decisions inside
    an already chosen data architecture
- `postgresql`
  - use for PostgreSQL-specific features, types, DDL semantics, or specialized
    capabilities
- `postgres-best-practices`
  - use for access-path, index, concurrency, migration, and operational safety
    questions

## Review Checklist

- Is this a local schema issue or a larger architecture issue?
- What migration path exists?
- What operational burden does the decision add?
