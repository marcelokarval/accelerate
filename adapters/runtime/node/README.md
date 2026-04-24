# Node Adapter

## Purpose

This adapter documents the Node runtime layer for supported frontend and tool
surfaces.

## Role

This adapter owns:

- package/runtime wrapper posture
- frontend validation command mapping
- evidence expectations
- failure handling

## Command Mapping

Resolve the package manager from the target project before running frontend
proof:

- `pnpm-lock.yaml` -> `pnpm`
- `yarn.lock` -> `yarn`
- `bun.lock` or `bun.lockb` -> `bun`
- `package-lock.json` -> `npm`
- no lockfile -> use the project-documented package manager; otherwise mark the
  command as `blocked` until the operator chooses one

Map validation classes to project scripts when available:

- TypeScript or contract check -> `type-check`, `typecheck`, or documented
  equivalent
- lint/static check -> `lint` or documented equivalent
- production build -> `build`
- unit/component tests -> `test`, `test:unit`, or documented equivalent

For workspace or monorepo packages, run through the package manager's native
workspace/filter syntax or an explicit package path. Record the resolved command
in the proof packet instead of hiding it behind the generic class name.

## Failure Handling

- Missing script: record `blocked` with the missing script name and package path.
- Wrong package manager: stop and resolve the lockfile/package-manager mismatch.
- TypeScript failure: treat as a contract failure, not formatting cleanup.
- Build failure: preserve the first runtime-relevant error and rerun after the
  fix.
