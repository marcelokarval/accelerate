# Changelog

## 0.1.0 — published baseline

- Baseline source: `8e3fd1220fde1b841a8a2356b740ca5b04c0769c` on `main`.
- Release housekeeping tracked by GitHub issue #7.
- The release candidate makes the canonical shell-contract suite self-contained
  in CI: immutable governed-drift ancestry is checked out, and mirror fixtures
  are sourced from checked-in repository fixtures. It also keeps the live Codex
  canary outside canonical CI, retaining its offline receipt contract without
  claiming live-runtime proof.

### Baseline limitations

This is a source baseline, not evidence that an optional runtime export is
installed, an external provider is reachable, or a deployment is production
ready. Those claims require their own current, environment-bound proof.

## Versioning policy

Development uses an exact `vMAJOR.MINOR.PATCH` branch; the issue, pull request,
and milestone use that same version, and every new commit references its issue.
`main` changes only through a reviewed pull request. After merge, an immutable
tag with the same version is created from the merged SHA; release operations
must name `refs/heads/<version>` or `refs/tags/<version>` explicitly.

Historical version branches remain separate records: they are never force
renamed or deleted to make a newer release look linear. A release entry names
the source baseline, scope, and limitations needed to avoid treating source
history as runtime proof.
