# Nx/NestJS Operational Checklist

## Discovery

- Read `nx.json`, root `package.json`, `pnpm-workspace.yaml`, the affected
  `project.json` files, and CI target invocations.
- Inspect project dependencies and tags before moving code or adding imports.
- State which target owns the API, library, worker, realtime consumer, and
  migration; do not infer it from a directory name.

## Change and Proof

- Use the repository's pnpm/Nx version and existing target names.
- Run a generator with explicit flags and dry-run/noninteractive mode when the
  installed generator supports it; inspect generated configuration before use.
- Preserve dependency constraints. Export public APIs from their owning library;
  avoid deep imports across ownership boundaries.
- For Fastify, verify plugin registration/order, request validation, error
  mapping, serialization, and adapter-specific integration tests.
- For workers and realtime, make event versioning, idempotency, retry policy,
  ordering, and poison-message handling explicit.
- For migrations, keep deployment and rollback compatible with old and new
  application versions. Backfills and destructive operations need a separate
  rollout plan.
- Use affected lint/test/build targets first; expand to direct target tests when
  graph impact or executor configuration makes affected proof insufficient.

## Report

List affected projects, targets run, graph impact, compatibility decisions, and
unproven risks. Nx Cloud and an Nx MCP server are not prerequisites.
