# HERMES-238 — Plane MCP Initial-Import Provenance Reconciliation SDD

## Hardened Prompt

### Prompt A

Open a broad, unrestricted reconciliation wave for the complete Plane MCP
import, with executor/reviewer loops and root review.

### Prompt B

Reconcile the complete runnable denominator of
`~/.hermes/apps/mcp-servers/plane-mcp-karval` into an attributable,
independently reviewed source candidate without changing the shared index until
the denominator, ownership and exact candidate construction are proven. Use a
bounded executor–reviewer loop and root review-of-review. Preserve all
pre-existing work, prove the candidate from an isolated construction, and keep
commit, push, merge, runtime promotion, restart, live MCP refresh and CODEX-26
lifecycle retry as separate gates.

## Classification and authority

- Classification: orchestrated non-trivial, wave-gated source-provenance work.
- Plane work item: `HERMES-238` /
  `0422f8c3-4c7b-48e8-8018-682ae32c4229`.
- Target source: `~/.hermes/apps/mcp-servers/plane-mcp-karval`.
- Root owns packet, denominator freeze, task graph, dispatch, fan-in,
  review-of-review, promotion decision and closure.
- Plane remains governed-MCP-only; direct HTTP and copied credentials are
  forbidden.

## Objective

Establish one exact, runnable import denominator and an isolated candidate
construction whose content, provenance and proof can be reviewed without
absorbing unrelated shared-worktree changes.

## Non-goals

- no `git reset`, `checkout`, `clean`, deletion, or overwrite of shared work;
- no commit, push, merge, rebase, branch switch, runtime promotion, restart,
  service change, MCP refresh, or provider mutation;
- no CODEX-26 retry or Plane lifecycle close;
- no claim that untracked/staged content already has source provenance.

## Frozen initial denominator hypothesis

The preflight found no target-app tree in `HEAD` `5273a725…`. The shared index
contains a 21-file initial import and the worktree has additional untracked and
unstaged target files. The denominator is therefore the full runnable package,
not merely the sparse lifecycle delta. TASK-P01 must replace this hypothesis
with an exact manifest, including file path, index/worktree disposition,
content hash, import/packaging role and provenance classification.

## Acceptance

1. Full runnable denominator is enumerated and frozen by path and hash.
2. Every file is classified as tracked base, staged import, unstaged delta,
   untracked candidate, or excluded unrelated material; unknown ownership is a
   blocker rather than guessed away.
3. A disposable isolated construction reproduces the full intended candidate
   without modifying the shared index/worktree.
4. Package/import and focused tests run against that isolated candidate.
5. Adversarial and independent reviews verify no shared-worktree mutation,
   no denominator omission, no secret inclusion and no hidden dependency on
   excluded content.
6. Root emits either `GO_SOURCE_PROMOTION_REVIEW` or a precise NO-GO. A GO is
   not a commit, push or runtime authorization.

## Tasks and loop

| Task | Owner | Scope | Exit |
| --- | --- | --- | --- |
| TASK-P01 | executor | read-only denominator/provenance manifest | exact file inventory and dependency map |
| TASK-P02 | executor | isolated, disposable candidate construction and proof | reproducible construction receipt |
| TASK-P03 | adversarial reviewer | read-only attack on manifest/construction | pass or prioritized defects |
| TASK-P04 | executor | correct P01/P02 defects, max 3 generations | reproof receipt |
| TASK-P05 | independent reviewer | blind read-only source-promotion readiness review | GO/NO-GO |
| TASK-P06 | root | review-of-review and wave closure packet | exact next gate |

## Loop and stop rules

- TASK-P03 rejection returns only actionable defects to TASK-P04.
- Maximum three material correction generations. A fourth defect escalates as
  a blocked receipt; it does not invite scope expansion.
- The denominator is frozen before isolated construction; a changed file set
  invalidates downstream proof and restarts P01.
- Any request to mutate the shared index/worktree, include a secret, or touch
  runtime/provider state stops the worker and returns control to root.

## Quality lenses

- source provenance and ownership;
- package/import closure;
- deterministic construction and test reproducibility;
- state/receipt safety of the prior sparse lifecycle correction;
- non-destructive hygiene and shared-worktree isolation.
