# Accelerate v1 tests

Run `bash tests/all.sh` from the repository with the Python dependencies in
`requirements-ci.txt`, Node.js 24 and ripgrep available. The suite is offline:
it does not install Accelerate or ASDS, change the real home configuration,
contact providers, or prove live harness behavior.

`tests/suites.json` explicitly accounts for every top-level shell and Python
test, Phase-1 Python test and JavaScript harness test. The inventory test rejects
missing, duplicate and unknown entries. The canonical runner executes every
active entry and stops on failure. It does not infer scope from filenames.

The v1 acceptance cases cover classification and ASDS handoff, authorization
continuity, source responsibility declarations, release version parity and
OpenCode prompt preservation, worker isolation and idempotency. Reusable
capability regressions remain active even when ASDS now decides when to use
that capability. Passing an optional capability test never makes that capability
a mandatory Accelerate workflow stage.

Entries marked `historical-v0` assert superseded Accelerate-owned orchestration
or old release acceptance. Their reason is recorded individually in the
inventory. They remain at their original paths for interpretation of prior
releases, but do not validate v1 and are not reported as passing. Their retained
files are source history, not deployment copies or rollback backups.

Model-driven routing conformance and real harness invocation are separate from
these deterministic checks; no offline result is a claim that ASDS ran.
