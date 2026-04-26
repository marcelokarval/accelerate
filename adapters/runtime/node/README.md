# Node Adapter

## Purpose

This adapter documents the Node runtime layer for supported frontend and tool
surfaces.

## Role

This adapter owns:

- package/runtime wrapper posture
- frontend validation command mapping
- backend Node validation command mapping
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

For backend Node frameworks such as AdonisJS, also map these classes to
project-native scripts when present:

- server boot/config check -> framework check, dry boot, or documented smoke
  command
- database migration check -> migration status/check/dry-run command
- database connection proof -> project-native DB health or test setup command
- route/controller/service tests -> backend test script or filtered test command
- auth/session proof -> backend security/auth test target
- job/queue proof -> worker/job test target when background work is present

For Next.js + Prisma profiles, also map these classes to project-native scripts
when present:

- Prisma schema proof -> `prisma validate`, `prisma format --check`, or
  documented equivalent
- Prisma migration proof -> `prisma migrate status`, migration dry-run/apply
  command, or documented equivalent
- Prisma generated client proof -> `prisma generate` or project wrapper
- Prisma deploy client-generation proof -> package `postinstall`, build, Docker,
  CI, or deploy hook evidence that runs or preserves generated client output
- Prisma database proof -> project-native DB health, integration test, or seed
  smoke command
- Prisma query/transaction proof -> data-access test target or filtered test
  command covering the changed path

For Next.js + Drizzle profiles, also map these classes to project-native scripts
when present:

- Drizzle schema proof -> TypeScript/schema check or documented Drizzle wrapper
- Drizzle migration strategy proof -> documented choice of `push`,
  `generate+migrate`, `pull`, `export`, external migration tool, or runtime
  migration
- Drizzle migration generation proof -> `drizzle-kit generate` or project
  wrapper
- Drizzle migration apply proof -> `drizzle-kit migrate` or project wrapper
- Drizzle database proof -> project-native DB health, integration test, or seed
  smoke command
- Drizzle SQL/query proof -> data-access test target, migration SQL review, or
  filtered test command covering the changed path

If the framework has no native check command, record the proof class as
`blocked` or satisfy it with a documented project smoke test. Do not invent a
fake framework command.

For workspace or monorepo packages, run through the package manager's native
workspace/filter syntax or an explicit package path. Record the resolved command
in the proof packet instead of hiding it behind the generic class name.

For Vercel-backed Next.js projects, map these classes to project or platform
evidence when present:

- deployment build proof -> local production build, Vercel build log, or CI build
  output
- environment scope proof -> documented local/preview/production env target or
  platform evidence
- runtime mode proof -> project config, route segment config, or platform output
  for Node vs Edge-sensitive code
- cache/revalidation proof -> runtime/browser evidence that changed data appears
  after mutation

For hosted Postgres providers such as Neon or Supabase, map these classes to
project or provider evidence when present:

- connection posture proof -> direct vs pooled connection evidence
- database target proof -> local/preview/production database target evidence
- migration target proof -> Prisma/Drizzle migration command plus provider target
- branch/preview proof -> provider branch/project/environment evidence
- backup/rollback proof -> documented rollback path for destructive schema work

## Failure Handling

- Missing script: record `blocked` with the missing script name and package path.
- Wrong package manager: stop and resolve the lockfile/package-manager mismatch.
- TypeScript failure: treat as a contract failure, not formatting cleanup.
- Build failure: preserve the first runtime-relevant error and rerun after the
  fix.
