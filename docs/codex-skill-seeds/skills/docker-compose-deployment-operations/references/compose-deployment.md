# Compose Deployment Checklist

## Preflight

- Resolve the effective configuration with the repository's Compose files and
  environment mechanism; redact values in any captured output.
- Identify service scope, image versions/digests, networks, volumes, dependency
  order, healthchecks, readiness endpoints, migrations, and persistent data.
- Verify that the candidate image and any schema/queue/data change are
  compatible with the backup and recovery procedure.
- State rollback trigger, command scope, expected data state, and owner before
  rollout begins.

## Rollout and Proof

- Pull/build only the approved images and recreate only intended services.
- Wait for declared readiness, then verify application health, migrations, and a
  bounded smoke path. Correlate release time with structured logs and metrics.
- Stop when a health, readiness, smoke, or observability signal fails; capture
  the failure without exposing configuration values or credentials.

## Recovery

- Prefer the explicit previous image/configuration and the approved restore
  procedure. Confirm data integrity and readiness after recovery.
- Never use `docker compose down -v` as automatic rollback; removing volumes is
  destructive and requires a separately approved, explicit recovery decision.
