# HERMES-238 — Plane MCP Source-Promotion SDD

## Hardened Prompt

### Prompt A

Perform the authorized review and source promotion of the reconciled Plane MCP
candidate.

### Prompt B

Create one local, isolated Git commit from base
`5273a7250dc1166381f306f43245817ac80251e6` on a new dedicated branch,
containing exactly the 29-path reconciled Plane MCP import plus the reviewed
P04 test-contract/README patch. Reprove the committed tree and obtain an
independent review. Preserve the shared Hermes worktree and all unrelated work.
Do not push, merge, alter runtime, restart services, refresh MCP injection,
call Plane, update external catalogs or retry CODEX-26.

## Authority and route

- User authorization: explicit source-promotion approval.
- Classification: orchestrated non-trivial source-promotion work.
- Issue: HERMES-238.
- Base: `5273a7250dc1166381f306f43245817ac80251e6`.
- Candidate source: `/tmp/hermes238-p04.ETJwpi/candidate` and its frozen
  manifests/receipt.
- Destination branch: `codex/hermes-238-plane-mcp-import`.
- Physical dispatch: executor creates the isolated candidate/commit; an
  independent reviewer validates the immutable commit; root performs
  review-of-review and closure.

## Scope

- exact 29 paths from `source-manifest.tsv`;
- P04 changes to `README.md` and `tests/test_plane_skill_parity_v2.py`;
- local branch, commit, commit readback and committed-tree proof only.

## Non-goals

- no shared-index/worktree mutation, staging, cleanup, reset, checkout or
  branch switch;
- no push, PR, merge, rebase, tag or remote mutation;
- no source import beyond the frozen 29-path denominator;
- no runtime promotion/restart/canary, provider mutation, external-catalog hash
  update, HERMES-238 closure or CODEX-26 retry.

## Acceptance

1. Isolated worktree has the specified base and new destination branch.
2. Commit tree path set equals the exact candidate denominator, plus no hidden
   generated/secret content.
3. Commit parent is the frozen base; commit ID and tree ID are read back.
4. The committed worktree passes sync, lock, wheel, installed-wheel import and
   full normal hermetic suite; external audit remains separate and visible.
5. Independent reviewer accepts the committed snapshot with no shared-worktree
   drift.
6. Root closure records local source promotion and the remaining non-promotion
   gates.

## Tasks

| Task | Owner | Result |
| --- | --- | --- |
| TASK-Q01 | root | source-promotion SDD, base/branch collision readback |
| TASK-Q02 | executor | isolated worktree, exact file transplant, local commit and proof |
| TASK-Q03 | independent reviewer | immutable commit forensic/source review |
| TASK-Q04 | executor | correction loop, maximum three generations if Q03 fails |
| TASK-Q05 | root | review-of-review, commit readback and closure packet |

## Stop conditions

- candidate path or hash differs from frozen P04 receipt;
- branch collision or base drift;
- attempt to alter shared Hermes worktree/index;
- additional file, generated artifact or secret enters commit;
- any push/merge/runtime/provider action;
- hermetic suite regression or external parity audit silently removed.
