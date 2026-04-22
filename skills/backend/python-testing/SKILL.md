---
name: python-testing
description: Use when writing or fixing Python tests, especially pytest-based Django/service tests, ownership boundaries, regression coverage, factories, or behavior-focused backend validation.
user-invocable: true
related-skills: django-service-patterns, security-patterns, python-pro
---

# python-testing

Use this skill when writing or fixing Python and Django tests.

## Purpose

Keep test work aligned with the active project's Python test workflow and
backend architecture.

## Load When

Load this skill when the task touches:

- test modules
- domain/service test modules
- service tests
- view tests
- regression coverage for bugs or refactors

## Operating Lens

- tests should prove behavior, not decorate code
- ownership and permission boundaries matter
- regressions should become executable checks

## Context Minimum

Before writing tests, identify:

- the code path or bug being covered
- expected behavior and failure modes
- the test surface: service, view, task, or integration
- the factories or fixtures required

## Core Rules

1. Use `pytest`, not `unittest`, for new work.
2. Use `factory_boy` for test data unless an existing local pattern says
   otherwise.
3. Mark database tests appropriately.
4. Test both happy path and failure path.
5. For private data, test ownership and authorization explicitly.
6. Keep tests readable and tied to real business rules, not implementation
   trivia.
7. Run tests with the active project command, commonly `uv run pytest ...` or
   the project's documented pytest wrapper.

## Testing Priorities For This Project

### Services

- business rules
- ownership boundaries
- transaction-sensitive behavior
- validation outcomes

### Interfaces

- request/response shape
- server-render or redirect behavior when the active stack uses it
- permission and auth gates

### Regressions

- when fixing a bug, add or update a test that would have caught it

## Review Checklist

- Does the test mirror the real business scenario?
- Is ownership covered where relevant?
- Are factories used consistently?
- Is the command compatible with project tooling?

## Handoff And Escalation

- hand off to `django-service-patterns` when missing business behavior blocks
  the test
- hand off to the active frontend stack when the real gap is UI behavior rather
  than backend regression coverage
- pair with `security-patterns` when the risk area is permission- or
  vulnerability-driven

## References

- active test tree
- active domain/service modules
- active Python project config
