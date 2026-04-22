---
name: database-design
description: Codex-native schema design guidance for the Django + PostgreSQL monolith, focused on relational quality, constraints, and migration-safe evolution.
user-invocable: true
related-skills: database-architect, postgresql, postgres-best-practices
---

# database-design

Use this skill for practical schema design decisions in the current application.

## Purpose

Provide a database design framework that is pragmatic for a PostgreSQL + Django
monolith, instead of generic multi-database theory.

This skill owns relational schema shape, not broad data architecture or
PostgreSQL feature deep dives.

## Load When

Load this skill when the task touches:

- new tables or major schema changes
- relationship modeling
- normalization vs denormalization decisions
- migration planning with schema impact

Do not use this skill for:

- cross-domain storage strategy or lifecycle planning
- PostgreSQL-specific feature choice such as JSONB/text-search/generated-column
  trade-offs
- index, concurrency, or access-path tuning as the primary question

## Core Rules

1. Design around the actual domain and query paths.
2. Keep relational structure explicit unless there is a strong reason not to.
3. Prefer maintainable schemas over short-term convenience.
4. Plan indexes and constraints together with the table design.
5. Consider migration safety as part of the design, not after it.

## Accelerate Guidance

- If the active stack profile is already committed to Django + PostgreSQL,
  database selection is not the question here; schema quality is.
- Respect the active project's base model, public identifier, ownership, and
  audit conventions.

## Boundary Against Adjacent Skills

- `database-architect`
  - use when the decision spans domains, retention, partitioning, tenancy, or
    storage topology
- `postgresql`
  - use when Postgres-specific types, features, or DDL semantics are the main
    choice
- `postgres-best-practices`
  - use when the schema already exists and the real problem is index strategy,
    concurrency, or operational query posture

## Review Checklist

- What are the entities and relationships?
- What invariants belong in the schema?
- How will this evolve safely?
