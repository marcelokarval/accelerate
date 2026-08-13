# Accelerate Dogfood Workspace

This directory is the committed `.accelerate/` dogfood workspace used by the Accelerate repository to dogfood its own local workspace model.

It now materializes the repository-safe V2 summary-index and local workflow-adapter subset for the repository itself while still committing only non-secret control-plane state. This is not the full generated V2 template tree; generated runtime outputs remain ignored/private.

Use `bash onboarding/local-workspace/validate-dogfood-v2-subset.sh .` to validate this committed dogfood V2 subset. Use `bash onboarding/local-workspace/validate-v2.sh <target-repo>` only for a full generated V2 workspace that includes the complete onboarding, planning, status, review, workflow, and agents tree.

## Boundary

Committed files in this directory are non-secret control-plane fixture/state files only. They may point to public repository planning artifacts, local contract tests, and status dashboards.

Generated or private proof outputs must not be committed here. In particular, keep these as generated/private artifacts:

- `.accelerate/review/*.json`, `.accelerate/review/*.jsonl`, screenshots, and browser captures
- `.accelerate/workflow/*.json`, `.accelerate/workflow/*.jsonl`, provider responses, and live workflow exports
- `.accelerate/status/generated/`
- `.accelerate/proof/` and `.accelerate/tmp/`

The generated/private boundary is enforced by `.accelerate/.gitignore`, `onboarding/local-workspace/validate-dogfood-v2-subset.sh`, and `tests/dogfood-workspace-contract.sh`.

## Last Accepted Dogfood Cycle

- cycle: linear OAuth MCP + runtime proof gates, RC24..RC27
- lifecycle: accepted by root final review; retained as the selected dogfood work item until a newer cycle supersedes it
- governing Linear parent: `P4Y-1298`
- governing Linear child for this handoff: `P4Y-1302`
- governing plan: `planning/executive/2026-05-08-linear-oauth-runtime-proof-executive-plan.md`
- task ledger: `planning/executive/2026-05-08-linear-oauth-runtime-proof-task-ledger.md`
- execution model: root orchestrator with bounded subagent implementation/review packets
- local status: `.accelerate/status/readiness-dashboard.yaml`
- selected work item: `.accelerate/workflow/active-work-item.yaml`
- local workflow adapter: `.accelerate/workflow/adapter.yaml`

## Current Planning Overlay

The accepted May dogfood cycle above remains historical accepted evidence; it
is not the current implementation plan. A light reentry on 2026-08-12 selected
the following non-secret CODEX-3 overlay without rewriting the accepted cycle's
adapter or provider evidence:

- governing issue: `CODEX-3`
- current plan/SDD:
  `planning/architecture/2026-08-13-codex-agent-routing-hardening-sdd.md`
- current task ledger:
  `planning/execution/2026-08-13-codex-agent-routing-hardening-task-breakdown.md`
- canonical traceability:
  `planning/specification/2026-08-13-codex-agent-routing-hardening-traceability.md`
- handoff: `.accelerate/review/handoff-summary.md`
- current status: `generation-11-closed-plane-finish-readback-observed`
- review finding: `G7-F1` P1 — sync followed by a supported standalone logical
  reinstall rewrites only the logical receipt, changes `installed_digest`, and
  invalidates schema-4 rollback
- review finding: `G9-F1` P2 — logical fast path accepts a receipt-updated
  renamed backup within CODEX_HOME/backups and mode `0666`, unlike catalog
  exact-identity validation
- correction: target-bound exact backup identity and mode `0600` across
  validators; rename/swap/suffix/hardlink/symlink/missing/outside matrix passed
- concurrent preservation: `playwright-patterns` source/runtime remained
  byte-exact and the 112-route index was regenerated
- correction: G10-F1 transactional cleanup, G10-F2 exact receipt identity and
  G10-F3 unique rollback-directory identity each have separate RED then GREEN
- runtime boundary: G10 full proof, sync/mirror, mode-0600+nlink1 identities and
  fresh root plus seven-specialist runtime passed at capture time
- G11-F1 documentary correction: dashboard, traceability and ledger reconciled;
  JSON/YAML/link/whitespace static proof passed at documentary generation `11/11`
- G11-F2 recovery: external drift changed root effort to `low`; G10 receipt is
  historical, G11 governed resync restored Sol/`medium`, mirror and fresh root
  plus seven passed
- closure review: two independent `ACCEPTED` verdicts, zero P0-P3 findings,
  root review-of-review and forensic closure passed; evidence at
  `planning/evidence/dated-proof-appendix/codex-agent-routing-hardening-independent-review-2026-08-13.md`
- Plane closure: REVIEW, Done transition, FINISH and final provider readback
  passed; no CODEX-3 closure action remains
- residual boundary: the cooperative lock governs participating mutators only;
  direct noncooperating same-user filesystem writers remain outside its boundary

This overlay is a local planning/reentry truth. Plane remains the governed
external issue authority through the injected runtime adapter; no private Plane
payload is copied into `.accelerate/`.

## Previous Dogfood Cycle Pointer

The prior dogfood cycle was `recursive cycle 18..22` and used:

- previous cycle id: `recursive-cycle-2026-05-08-18-22`
- previous governing plan: `planning/executive/2026-05-08-recursive-cycle-18-22-executive-plan.md`
- previous task ledger: `planning/executive/2026-05-08-recursive-cycle-18-22-task-ledger.md`

This pointer exists only to keep historical contract tests and migration traceability readable; the accepted cycle above remains the selected dogfood reference until a newer cycle supersedes it.

This workspace is not a provider cache and must not contain tokens, private provider payloads, screenshots, or customer data. It is a no secrets surface for committed governance state.
