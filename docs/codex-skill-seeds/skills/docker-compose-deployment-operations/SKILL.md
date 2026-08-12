---
name: docker-compose-deployment-operations
description: Operate Docker Compose deployments safely. Use for service image updates, Compose configuration changes, deployment runbooks, health/readiness checks, backups, smoke tests, observability, selective rollout, rollback planning, and recovery; do not use it to expose secrets or to treat destructive volume removal as rollback.
---

# Docker Compose Deployment Operations

Read [`references/compose-deployment.md`](references/compose-deployment.md)
before a production-like deployment or recovery. Treat the checked-in Compose
files, image registry, environment ownership, and backup mechanism as authority.

## Workflow

1. Render and validate the effective Compose configuration without printing
   secret values. Identify the exact services, image digests/tags, volumes,
   networks, dependencies, and health/readiness conditions.
2. Confirm image compatibility and backup/restore compatibility, especially for
   schema, queue, and persistent-volume changes. Define the rollback point.
3. Deploy only the intended services in dependency-aware order. Avoid unrelated
   recreation or broad lifecycle commands.
4. Verify container state, readiness, application health, required migrations,
   and a bounded smoke flow. Correlate logs and metrics with the release.
5. If proof fails, stop rollout and execute the predeclared rollback or recovery
   path. Re-check health and data integrity after recovery.

## Guardrails

- Never use `docker compose down -v` as an automatic rollback.
- Never print, copy, or add secrets to commands, logs, plans, or reports.
- Do not deploy an image whose migration or persisted-data compatibility is
  unknown.
- Do not call a port-open container healthy without its declared readiness and
  application checks.

## Output Contract

Report rendered configuration proof, exact deployment scope, image and backup
compatibility, health/readiness and smoke evidence, observability correlation,
rollback trigger, rollback outcome when used, and residual risk.

## Resources

- [`references/compose-deployment.md`](references/compose-deployment.md):
  preflight, rollout, proof, and recovery checklist.
- `evals/evals.json`: trigger and output checks.
