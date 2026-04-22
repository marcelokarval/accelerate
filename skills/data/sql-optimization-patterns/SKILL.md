---
name: sql-optimization-patterns
description: Codex-native SQL optimization guidance for slow queries, execution plans, ORM query shape, and index-backed performance improvements.
user-invocable: true
related-skills: postgres-best-practices, postgresql, database-design
---

# sql-optimization-patterns

Use this skill for slow queries, execution-plan review, and index/query shape
optimization.

## Purpose

Focus on turning vague "database is slow" symptoms into concrete changes backed
by query-path analysis.

This skill is one of the primary supporting skills behind the workflow lens
`Backend Query Correctness`.

## Load When

Load this skill when the task touches:

- slow SQL
- N+1 patterns
- large joins
- missing indexes
- execution plan analysis
- any review where `Backend Query Correctness` is mandatory

## Core Rules

1. Start from the slow query and the real access pattern.
2. Check whether the issue is query shape, missing index, row explosion, or ORM
   behavior.
3. Use `EXPLAIN` or equivalent evidence before making large claims.
4. Prefer targeted fixes over speculative "optimization".

## Accelerate Guidance

- In Django flows, inspect ORM-generated queries when list or detail pages get
  heavy.
- Distinguish service-layer correctness from SQL-level inefficiency.
- Treat N+1 and missing prefetch/select-related patterns as part of the same
  performance surface.
- Name query-shape drift explicitly instead of hiding it behind generic
  "performance" language.

## Review Checklist

- What is actually slow?
- Was the execution plan inspected?
- Is the fix query-side, schema-side, or ORM-side?
