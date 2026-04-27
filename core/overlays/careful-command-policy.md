# Careful Command Policy

Careful mode requires explicit warning or approval before dangerous commands.

## Dangerous Classes

- destructive deletion
- hard reset or history rewrite
- force push
- database drop, truncate, or destructive migration
- production deploy or rollback
- secret export or printing
- broad chmod/chown
- Docker or Kubernetes destructive cleanup
- global package manager mutation

Careful mode is a safety overlay. It does not replace root one-way-door policy.
