# Issue-Driven Mutation Stack

## Purpose

This document is the native core contract for mutation-time issue discipline in
the pre-agents phase.

## Core Rule

When work mutates code, docs, workflow seeds, or runtime governance, the issue
stack is mandatory unless a narrow no-issue exception is explicitly approved.

## Minimum Stack

1. `accelerate`
2. `Issue Bootstrap Gate`
3. active workflow adapter
4. planning artifact
5. execution
6. proof stack
7. `AI Review Report`
8. root closure mode

## Execution Rule

Mutation must not jump directly from request to implementation.

If issue bootstrap succeeded but no post-bootstrap planning artifact exists for
non-trivial work, execution is still blocked.

## Visibility Rule

Issue-driven runtime packets must make visible:

- governing issue
- issue lifecycle state
- metadata completeness
- next lifecycle gate
- planning artifact status
- whether the run is still blocked on issue/plan hygiene

## Current Default Adapter

The current default workflow backend is still Linear-shaped.

That remains a distribution fact, not a permanent law of the core.

