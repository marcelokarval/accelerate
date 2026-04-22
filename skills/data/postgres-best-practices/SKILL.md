---
name: postgres-best-practices
description: Codex-native PostgreSQL best practices for schema quality, indexing, concurrency, and migration-aware database decisions.
user-invocable: true
related-skills: postgresql, sql-optimization-patterns, database-design
---

# postgres-best-practices

Use this skill for PostgreSQL best practices around schema quality, indexing,
query paths, concurrency, and operational safety.

## Purpose

Provide a Postgres-first baseline for the current project, which relies on
PostgreSQL-specific patterns and Django ORM behavior.

This skill supports `Backend Query Correctness` when the real issue is not
only ORM code shape but also index strategy and relational access-path design.

This skill is about operational posture: access paths, concurrency, migration
safety, and measured performance. It is not the primary place for entity
modeling or feature-by-feature Postgres selection.

## Load When

Load this skill when the task touches:

- schema design
- indexes
- constraints
- query performance
- PostgreSQL-specific data types and behavior
- any review where `Backend Query Correctness` reaches index or access-path
  concerns

Do not use this skill for:

- deciding the core business entities and relationships
- cross-domain storage architecture
- choosing specialized Postgres features when that feature choice itself is the
  main question

## Core Rules

1. Design indexes for real access paths, not guesswork.
2. Add indexes for foreign keys where query paths justify them.
3. Normalize first, denormalize only with evidence.
4. Use proper types for money, timestamps, and identifiers.
5. Validate major performance assumptions with `EXPLAIN` or measured behavior.
6. Plan migrations and rollbacks before destructive DDL.

## Accelerate Guidance

- Keep public opaque IDs separate from internal PK design concerns.
- Consider ownership filters, tenancy, and common list/detail flows when
  planning indexes.
- Align with Django migration safety and deployment realities.

## Boundary Against Adjacent Skills

- `database-design`
  - use for relational structure, entities, and schema invariants
- `postgresql`
  - use when JSONB, generated columns, text search, or other PostgreSQL-native
    features are the primary design question
- `database-architect`
  - use when the problem spans domains, lifecycle, or storage topology

## Review Checklist

- What are the actual filters, joins, and sorts?
- Which indexes already exist?
- Is the data type enforcing the real invariant?
