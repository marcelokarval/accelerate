# Changelog

## 0.1.0 — published baseline

- Baseline source: `8e3fd1220fde1b841a8a2356b740ca5b04c0769c` on `main`.
- Release housekeeping tracked by GitHub issue #7.
- The release candidate makes the canonical shell-contract suite self-contained
  in CI: immutable governed-drift ancestry is checked out, and mirror fixtures
  are sourced from this repository's `global-runtime/accelerate` projection.

### Baseline limitations

This is a source baseline, not evidence that an optional runtime export is
installed, an external provider is reachable, or a deployment is production
ready. Those claims require their own current, environment-bound proof.

## Versioning policy

Published versions use immutable Git tags after a reviewed pull request reaches
`main`. The next unreleased body of work is prepared on its own version branch;
it does not change the published baseline retroactively. A release entry names
the source baseline, scope, and any limitations needed to avoid treating source
history as runtime proof.
