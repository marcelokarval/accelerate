# HERMES-238 — TASK-P03 Adversarial Review

## Verdict

`FAIL_P1_P02_01_AND_FORENSIC_MANIFEST`

No sparse-lifecycle regression, package-resource omission, secret-bearing
candidate file or reviewer-caused source mutation was found. Source-promotion
readiness nevertheless remains blocked by two P1 findings.

## P1-01 — Test contract is not hermetic

The full suite has a reproducible failure in
`test_plane_skill_parity_v2_inventory_is_complete_and_fail_closed`:

```text
('opencode', 'work-item-routing-governance'): stale destination hash
```

The test resolves `Path.home()` and absolute external skill-catalog paths from
the YAML. It is therefore evidence of external runtime drift rather than an
unproven missing wheel file, but it remains a candidate blocker until the test
contract explicitly splits hermetic package proof from external-runtime parity
audit. The stale hash must not simply be blessed.

## P1-02 — Manifest is not independently replayable

The P01/P02 receipt reports correct aggregate topology (29 paths: 21 staged
initial-import entries, eight untracked candidates and six staged files with
unstaged deltas), but does not persist a sorted per-path/hash manifest nor
machine-readable pre/post fingerprints for target porcelain state, index and
selected worktree files. A later reviewer cannot replay the source snapshot or
prove no shared-state drift from that receipt alone.

## Required TASK-P04 correction

1. Build from a persisted, sorted manifest of every selected path, disposition,
   SHA-256, import/package role and wheel inclusion.
2. Record and compare pre/post target porcelain, index-entry and selected-file
   fingerprints.
3. Split normal hermetic package tests from the home-catalog external parity
   audit through injected fixture roots or a separately labeled audit contract.
4. Re-run isolated sync, lock check, wheel build, installed-wheel import and a
   full hermetic suite green. Report external audit drift separately.
5. Keep all correction artifacts in the disposable isolated candidate; do not
   mutate the shared index/worktree, runtime or provider.
