# Python UV Adapter

## Purpose

This adapter documents the default Python runtime wrapper for the current
distribution.

## Rule

When Python is active under the default distribution, commands should be run
through `uv`.

## Role

This adapter owns:

- Python command mapping
- validation command mapping
- evidence expectations
- failure handling

## Command Mapping

Use `uv run` for Python commands when the target project declares UV as its
runtime wrapper.

Map validation classes to project-native commands:

- runtime/config check -> framework check command, for example a Django system
  check or equivalent
- schema drift check -> framework migration-generation dry run or documented
  schema drift detector
- pending migration check -> framework migration status/check command
- tests -> project pytest/unittest command with the smallest relevant test scope
- formatting/static checks -> project-configured tools only when they are part
  of the branch proof contract

If the project is Django and follows the default backend layout, the concrete
commands are owned by the active stack profile rather than this generic adapter.

## Failure Handling

- Missing UV project metadata: mark the command `blocked` or switch only when the
  project explicitly documents a different Python runner.
- Schema drift failure: create or update the migration artifact before closure.
- Pending migration failure: reconcile migration state before runtime closure.
- Test failure: preserve the failing test identifier and rerun the smallest
  relevant scope after the fix.
