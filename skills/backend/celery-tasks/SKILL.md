---
name: celery-tasks
description: Codex-native Celery task patterns for queue selection, retry behavior, idempotency, and thin task-to-service delegation.
user-invocable: true
related-skills: django-service-patterns, python-pro, security-patterns
---

# celery-tasks

Use this skill for background jobs, queues, retries, and asynchronous task
design in the Django backend.

## Purpose

Keep Celery usage thin, service-oriented, and operationally safe.

## Load When

Load this skill when the task touches:

- `src/**/tasks/`
- background jobs
- retries and failure behavior
- queue assignment
- periodic jobs

## Core Rules

1. Tasks transport work; services own business logic.
2. Pass simple IDs or primitive payloads, not ORM objects.
3. Keep task bodies thin and import heavy domain logic lazily when needed.
4. Choose the queue intentionally.
5. Define retry behavior according to failure class.
6. Avoid long opaque task bodies with embedded business rules.

## Accelerate Guidance

- Domain, messaging, analytics, billing, import/export, and integration queues
  should remain explicit when the active project uses those surfaces.
- Sensitive tasks should be idempotent where repeated delivery is possible.
- Queue choice and retry semantics are architecture decisions, not defaults.

## Review Checklist

- Should this be async at all?
- Is the task delegating to a service?
- Is the queue correct?
- Is retry behavior safe?
