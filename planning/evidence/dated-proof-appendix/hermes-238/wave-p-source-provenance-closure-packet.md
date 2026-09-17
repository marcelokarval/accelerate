# HERMES-238 — Wave P Source-Provenance Closure Packet

## Closure decision

`GO_SOURCE_PROMOTION_REVIEW`

Wave P establishes a replayable, isolated and independently reviewed candidate
for the complete Plane MCP initial-import denominator. This is intentionally
not a source promotion, commit, push, merge, runtime promotion, restart, MCP
refresh, provider action or CODEX-26 lifecycle retry.

## Gate ledger

| Gate | Result | Evidence |
| --- | --- | --- |
| TASK-P01 denominator | pass | 29-path source manifest, exact roles/dispositions |
| TASK-P02 isolated construction | pass with P02-01 | wheel/import plus external parity defect identified |
| TASK-P03 adversarial review | fail | P1 test-contract split and replayable receipt required |
| TASK-P04 correction | pass | hermetic suite green; external audit retained |
| TASK-P05 independent review | pass | complete manifest, package closure and no shared drift |
| TASK-P06 root review-of-review | pass | fresh candidate suite and exact status receipt reconciled |

## Root revalidation

The frozen receipt has two 29-row manifests and matching source/candidate,
patch, machine-receipt and wheel hashes. Root reran the normal test lane in
the candidate itself:

```text
uv run pytest -q -p no:cacheprovider
# 133 passed, 5 skipped, 1 third-party AuthlibDeprecationWarning
```

The apparent porcelain fingerprint discrepancy was reconciled rather than
ignored: the first root command used Git's default untracked-file collapse,
which reports `docs/`; the receipt used `--untracked-files=all`. Re-running
with the receipt's mode produced the exact captured fingerprint:

```text
54a9263f9c5b8d23265291f44caa18b38427000c3780f989549497d4081667af
```

Selected sparse-lifecycle source hashes still match the previous local
candidate freeze. No shared target source or index mutation was observed.

## Accepted bounded residual

The opt-in external parity audit still reports one stale OpenCode destination
hash (`1 failed, 4 passed`). It is retained, fail-closed and explicitly outside
the normal hermetic package-proof lane. It is not accepted as a runtime or
catalog health claim; it requires its own owner disposition before any external
catalog or runtime assertion.

## Next allowed task

The next task may perform a separate **source-promotion review** against the
exact manifests and isolated patch. That task must decide candidate ownership,
staging strategy, commit/PR authority and reproof against the staged snapshot.
It must preserve every unrelated shared-worktree change. It is separately
authorized only when an operator explicitly approves source promotion.

## Explicitly closed gates

- shared-index mutation;
- commit, push, merge or rebase;
- runtime promotion/restart/fresh injected-tool validation;
- Plane provider mutation or lifecycle comment;
- CODEX-26 Phase-1 closure and Phase-2 intake;
- external catalog hash update.
