---
name: postgresql
description: Codex-native PostgreSQL-specific table, column, constraint, and index design guidance.
user-invocable: true
related-skills: postgres-best-practices, database-design, sql-optimization-patterns
---

# postgresql

Use this skill for PostgreSQL-specific table, column, constraint, and index
design decisions.

## Purpose

Keep schema work grounded in PostgreSQL reality rather than abstract SQL advice.

This skill exists for PostgreSQL-specific choices, not generic entity modeling
or broad operational tuning.

## Load When

Load this skill when the task touches:

- new PostgreSQL tables or columns
- constraints and indexes
- JSONB, text search, generated columns, specialized Postgres behavior
- PostgreSQL-specific migration or tuning decisions

Do not use this skill for:

- deciding the business entities and relationships themselves
- cross-domain storage architecture
- generic index or concurrency posture when no PostgreSQL-specific feature
  choice is in question

## Core Rules

1. Use Postgres data types intentionally.
2. Design constraints to enforce business invariants where appropriate.
3. Add indexes for the real query paths and validate them.
4. Use Postgres features because they solve a real problem, not because they
   exist.
5. Keep DDL safety and rollback strategy in view.

## Accelerate Guidance

- The project can benefit from Postgres-specific strengths, but schema clarity
  remains more important than novelty.
- Consider list/detail flows, ownership filters, and reporting queries when
  designing tables.

## Boundary Against Adjacent Skills

- `database-design`
  - use for entity modeling, invariants, and relational structure
- `database-architect`
  - use for multi-domain architecture, lifecycle, and storage strategy
- `postgres-best-practices`
  - use when the real question is access paths, measured performance,
    concurrency, or migration-safety discipline

## Review Checklist

- Is the chosen type or feature truly the right Postgres tool?
- Does the schema enforce the key invariant?
- Was the operational impact considered?
