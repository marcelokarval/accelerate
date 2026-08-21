# Branch Enforcement Matrix Reference

## Authority

Primary native authority lives in:

- `../core/control-plane/branch-enforcement-matrix.md`

This reference is intentionally a pointer. The full branch matrix was rehomed to `core/` and should not be duplicated here because duplicated rows quickly become stale and ambiguous.

## Use

Open the native file when deciding:

- active branch
- mandatory skills
- mandatory gates
- expected artifacts
- expected evidence
- closure blockers

For orchestrated execution, also open
`../core/control-plane/post-spec-delegation-dispatch-gate.md` before task-owned
writes and validate the `delegation-dispatch-receipt.schema.json` receipt.

If this file and the native file ever disagree, the native file wins.
