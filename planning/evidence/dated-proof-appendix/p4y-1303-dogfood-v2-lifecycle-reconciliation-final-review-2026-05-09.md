# P4Y-1303 Dogfood V2 + Lifecycle Reconciliation Final Review — 2026-05-09

Governing issue: P4Y-1303
Branch: `marcelokarval/p4y-1303-reconcile-accelerate-dogfood-lifecycle-and-v2-workspace`
Root reviewer: Claw

## Requested vs Implemented

### Request

Reconcile the Accelerate repository's committed `.accelerate/` dogfood state with two accepted recommendations:

1. remove ambiguity between the accepted RC24..RC27 cycle and an apparently unfinished `active` lifecycle;
2. reconcile the repository dogfood workspace with the V2 workspace contract without committing generated/private provider proof outputs.

### Implemented

- Added `.accelerate/state.yaml` as the committed dogfood summary index.
- Added `.accelerate/workflow/adapter.yaml` as the committed local workflow-adapter index.
- Added `.accelerate/workflow/README.md` to document selected-work-item semantics and generated/private workflow boundaries.
- Updated `.accelerate/README.md` to describe the repository-safe V2 summary/local-adapter subset rather than a full generated V2 template tree.
- Changed RC24..RC27 dogfood lifecycle from `active` to `accepted` in:
  - `.accelerate/status/readiness-dashboard.yaml`
  - `.accelerate/workflow/active-work-item.yaml`
- Changed RC24..RC27 scope wording from pending/root-acceptance phrasing to accepted root-final-review phrasing.
- Updated `.accelerate/.gitignore` to keep the newly committed V2 summary/local-adapter files trackable while preserving generated/private ignores.
- Strengthened `tests/dogfood-workspace-contract.sh` to require:
  - `.accelerate/state.yaml`
  - `.accelerate/workflow/README.md`
  - `.accelerate/workflow/adapter.yaml`
  - tracked status for required committed dogfood files
  - accepted lifecycle markers
  - no top-level `status: active` regression in committed dogfood lifecycle files.

## Review Notes

A separate review pass found four issues in the first implementation draft:

1. new V2 files were untracked;
2. wording could imply full `validate-v2.sh` template compliance rather than a repository-safe subset;
3. the test did not enforce that required files were tracked;
4. residual README wording still called the accepted cycle active.

Root corrected all four before final verification.

## Evidence

Targeted gates:

```txt
bash tests/dogfood-workspace-contract.sh
bash tests/recursive-self-improvement-contract.sh
git diff --check
```

Result: passed.

Full suite:

```txt
bash tests/all.sh
```

Result: `all tests passed`.

## Residuals

- The dogfood workspace intentionally does not claim full generated V2 template materialization; it commits the repository-safe V2 summary-index and local workflow-adapter subset only.
- `onboarding/local-workspace/validate-v2.sh .` remains a full generated-workspace validator and is not promoted as a gate for this committed dogfood subset.
- Linear OAuth MCP remains host-authenticated/conditional; this issue does not promote the Linear API-key GraphQL fallback or portable CI provider writes.
- Generated/private provider exports, screenshots, browser captures, and raw MCP/API payloads remain ignored and uncommitted.

## Next Queue

1. If the Accelerate repo should eventually validate its dogfood subset with a dedicated validator, add a separate `validate-dogfood-v2-subset.sh` instead of weakening `validate-v2.sh`.
2. Keep full generated V2 workspace validation scoped to emitted target workspaces.
3. Continue the next recursive improvement queue from `core/control-plane/recursive-improvement-situation-dashboard.md`.

## Root Decision

Accepted for commit/push readiness after targeted gates, full suite, and review correction.
