---
name: python-pro
description: Codex-native modern Python 3.12+ guidance for typed, maintainable, project-aligned backend and tooling code.
user-invocable: true
related-skills: django-service-patterns, python-testing, celery-tasks
---

# python-pro

Use this skill for Python 3.12+ code quality, typing, structure, and pragmatic
backend implementation choices in this project.

## Purpose

Provide a modern Python baseline without drifting away from the actual project
stack. This skill complements `django-service-patterns`, not replaces it.

## Load When

Load this skill when the task touches:

- Python modules under `src/`
- typing, dataclasses, helpers, utilities, exceptions
- modern Python syntax or refactors
- code quality and maintainability decisions

## Core Rules

1. Use Python 3.12-compatible patterns.
2. Add type hints to public functions and service methods.
3. Keep functions and files within project size guidance when possible.
4. Prefer standard-library solutions before adding dependency complexity.
5. Use `uv run ...` for Python commands in this repo.
6. Never use raw `python`, `pytest`, `pip`, or `source .venv/bin/activate`.
7. Follow project formatting, docstring, and architecture constraints.

## Accelerate Guidance

- Django architecture decisions come from `django-service-patterns`, the active
  stack profile, and project docs first.
- Async or concurrency patterns must fit the existing runtime and deployment
  model, not just generic Python advice.
- Favor readability and domain clarity over abstract cleverness.

## Review Checklist

- Are types clear and useful?
- Is the code aligned with Python 3.12 and project conventions?
- Is there any unnecessary framework-agnostic abstraction?

## References

- `pyproject.toml`
- `src/`
- `AGENTS.md`
