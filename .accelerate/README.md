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

## Previous Dogfood Cycle Pointer

The prior dogfood cycle was `recursive cycle 18..22` and used:

- previous cycle id: `recursive-cycle-2026-05-08-18-22`
- previous governing plan: `planning/executive/2026-05-08-recursive-cycle-18-22-executive-plan.md`
- previous task ledger: `planning/executive/2026-05-08-recursive-cycle-18-22-task-ledger.md`

This pointer exists only to keep historical contract tests and migration traceability readable; the accepted cycle above remains the selected dogfood reference until a newer cycle supersedes it.

This workspace is not a provider cache and must not contain tokens, private provider payloads, screenshots, or customer data. It is a no secrets surface for committed governance state.
