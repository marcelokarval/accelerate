# Cross-Runtime Bootstrap

The semantic core is common; every runtime adapter owns the concrete primitive,
status, and enforcement claim. Generated mirrors are projections, never source
truth. The repository manifest is
`adapters/runtime/cross-runtime-bootstrap-manifest.json`.

At `TASKS_READY`, use native physical dispatch only when the selected adapter is
both `supported` and freshly callable. `staged-only`, `legacy-reference`, and
`export-only` must report their status and stop: they never silently fall back
to another runtime or a virtual dispatch. The root remains responsible for
task graph, fan-in, integration-only repairs, review-of-review, promotion, and
closure. Adapter bindings map semantic quality classes to their supported model
and effort classes and must return effective receipts.

`scripts/sync-runtime-bootstrap.py` is closed to its internally-derived
canonical runtime paths; it accepts no arbitrary target or stage-output path.
The only apply-eligible adapter is Codex. The manifest is checked against
hard-coded approved invariants and the OpenHands/other-adapter registries.
Dry-run is strictly zero-write and emits its proposed receipt only to stdout;
passing `--receipt` to dry-run is rejected. Apply is write-ahead:
secure exclusive backup and fsynced prepared journal precede the atomic target
replace; `--recover` finalizes an interrupted prepared transaction. Managed
blocks are replaced exactly once while surrounding bytes are preserved.
Rollback remains two phase (`--rollback-preflight`, then `--rollback`) and
removes the backup only after readback. `--test-root` is a marker-gated test
fixture escape hatch, never a production target override. `--stage` prints a
repository projection and never installs it.
