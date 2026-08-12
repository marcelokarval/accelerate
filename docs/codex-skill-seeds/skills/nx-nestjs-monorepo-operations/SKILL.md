---
name: nx-nestjs-monorepo-operations
description: Operate Nx and NestJS commercial monorepos safely. Use for Nx project-graph or target changes, pnpm workspace changes, NestJS Fastify services, generators, workers, realtime flows, migrations, affected tests, and releases; do not use for a standalone application outside an Nx workspace.
---

# Nx/NestJS Monorepo Operations

Use the workspace's checked-in `nx.json`, `project.json`, package manager, and
CI configuration as authority. Read
[`references/nx-nestjs-monorepo.md`](references/nx-nestjs-monorepo.md) before
changing targets, boundaries, generation, or release behavior.

## Workflow

1. Identify the affected app, library, target, ownership boundary, and runtime
   contract. Inspect the project graph before editing dependencies.
2. Use the existing `pnpm` and Nx commands. Prefer affected targets for proof;
   run an explicit target when the graph cannot express the change.
3. Run generators noninteractively and dry-run first when supported. Review
   generated files, tags, import boundaries, and target changes before writing.
4. Keep NestJS HTTP adapters explicit: Fastify plugins, request lifecycle,
   validation, errors, and tests must remain compatible with Fastify.
5. Treat workers, realtime consumers, and migrations as separate deployable
   contracts. Define ordering, retries/idempotency, compatibility, and rollback
   before sharing a schema or event change.
6. Prove the smallest relevant lint, unit, integration, build, and affected
   targets. Record unrun targets and why.

## Guardrails

- Do not introduce Nx Cloud or an Nx MCP dependency merely to perform this work.
- Do not bypass module-boundary rules with deep imports or temporary tags.
- Do not couple an API release to an irreversible migration without a
  compatibility path.
- Do not claim an affected target is safe without inspecting its dependency
  graph and executor configuration.

## Output Contract

Report the affected projects and targets, graph/boundary impact, generator or
migration plan, runtime compatibility for Fastify/workers/realtime, commands
run, and residual deployment risk.

## Resources

- [`references/nx-nestjs-monorepo.md`](references/nx-nestjs-monorepo.md): target,
  generator, Fastify, worker, realtime, and migration checklist.
- `evals/evals.json`: trigger and output checks.
