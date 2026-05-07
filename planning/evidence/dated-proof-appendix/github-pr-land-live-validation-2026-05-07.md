# GitHub PR Land Live Validation — 2026-05-07

Date: 2026-05-07
Capability: `github-pr-land` / GitHub PR production merge land gate
Adapter command: `onboarding/local-workspace/land-github-pr.sh`
Proof repository: `marcelokarval/accelerate-playground`

## Summary

A real, non-sensitive, disposable GitHub pull request was landed in the persistent playground repository through the repo-local Accelerate GitHub PR land adapter. This proof promotes only the GitHub PR land/merge capability. It does not promote Linear writes, deploy execution, or any broader production-release automation.

## Adapter Command Proven

```bash
ACCELERATE_ALLOW_LAND=1 onboarding/local-workspace/land-github-pr.sh \
  /tmp/accelerate-gpl2-land-proof-20260507T230535Z-395964 \
  .accelerate/review/ship-readiness.json
```

The merge was executed by the adapter path, not by a raw bypass command. The adapter performed its guarded live path with the explicit `ACCELERATE_ALLOW_LAND=1` opt-in.

## Durable Remote Evidence

- Repository: `marcelokarval/accelerate-playground`
- Disposable proof PR: https://github.com/marcelokarval/accelerate-playground/pull/2
- PR number: `#2`
- Final PR state: `MERGED` / API `closed` with `merged: true`
- Proof branch: `accelerate/land-proof-2026-05-07-230537-395964`
- Head SHA before merge: `132763f7b594c40565403e6fe986921ddd68a327`
- Merged at: `2026-05-07T23:21:43Z`
- Merged by: `marcelokarval`
- Merge commit SHA: `251039ffaa4784327de5b9bed9fa25b44bc29ba1`
- Remote `main` tip after merge: `251039ffaa4784327de5b9bed9fa25b44bc29ba1`
- Remote proof branch cleanup: proof branch deleted/absent after merge

## PR #1 Preservation

The pre-existing playground fixture PR remained open and untouched by this proof slice:

- Preserved PR: https://github.com/marcelokarval/accelerate-playground/pull/1
- State after proof: `OPEN`
- Head branch: `accelerate/live-proof-2026-05-05`
- Head SHA: `fbfd89bc85e7a27954a40776247aed5049112af2`

This proof intentionally used PR `#2` and did not merge, close, delete, or otherwise mutate PR `#1`.

## Blockers / Fixes Encountered During Live Proof

Three adapter hardening fixes were required before the live land proof could complete safely:

1. `check-ship-readiness.sh` now treats empty-string or JSON `null` `reviewDecision` as no review requirement when checks are otherwise passing. This matches repositories where GitHub returns no review requirement instead of `APPROVED`.
2. `land-github-pr.sh` now refreshes ship readiness before refusing a stale `ready=false` artifact, so provider-current readiness can replace stale local status before later land gates run.
3. `check-ship-readiness.sh` now preserves `closure_comment_proof` and `closure_artifact` metadata when refreshing readiness, so proof/export metadata is not lost during provider refresh.

Focused regression coverage for these fixes is in `tests/check-ship-readiness-review-decision.sh` and `tests/github-pr-adapter-safety.sh`.

## Proof Boundary

This appendix proves only:

- the GitHub PR land/merge adapter can perform a real guarded merge in the playground repository;
- the adapter honors the explicit live-write opt-in;
- the disposable proof branch/PR path can be merged and cleaned up;
- durable, non-sensitive evidence can be located after the fact.

This appendix does not prove:

- Linear create/comment/status writes;
- deploy execution or application runtime rollout;
- general permission to land arbitrary production PRs without the adapter gates;
- any mutation outside the stated GitHub playground proof scope.

Linear remains blocked by `structured_non_llm_mcp_write_binding_required` until a separate structured non-LLM write binding and fixture proof exist.

## Non-Sensitive External Mutation Scope

Allowed external mutation for this proof was limited to `marcelokarval/accelerate-playground`:

- create one disposable proof branch;
- open one disposable proof PR (`#2`);
- land that proof PR through `land-github-pr.sh`;
- delete the disposable proof branch after merge.

No sensitive payloads, credentials, private customer data, production environment changes, Linear writes, or non-playground repository mutations are part of this evidence.
