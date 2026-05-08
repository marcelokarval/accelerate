# Accelerate Dogfood Workspace

This directory is the minimal committed `.accelerate/` workspace used by the Accelerate repository to dogfood its own local workspace model.

## Boundary

Committed files in this directory are non-secret control-plane fixture/state files only. They may point to public repository planning artifacts, local contract tests, and status dashboards.

Generated or private proof outputs must not be committed here. In particular, keep these as generated/private artifacts:

- `.accelerate/review/*.json`, `.accelerate/review/*.jsonl`, screenshots, and browser captures
- `.accelerate/workflow/*.json`, `.accelerate/workflow/*.jsonl`, provider responses, and live workflow exports
- `.accelerate/status/generated/`
- `.accelerate/proof/` and `.accelerate/tmp/`

The generated/private boundary is enforced by `.accelerate/.gitignore` and by `tests/dogfood-workspace-contract.sh`.

## Current Dogfood Cycle

- cycle: recursive cycle 13..17
- governing plan: `planning/executive/2026-05-08-recursive-cycle-13-17-executive-plan.md`
- task ledger: `planning/executive/2026-05-08-recursive-cycle-13-17-task-ledger.md`
- execution model: root orchestrator with bounded subagent implementation/review packets
- local status: `.accelerate/status/readiness-dashboard.yaml`
- active work item: `.accelerate/workflow/active-work-item.yaml`

This workspace is not a provider cache and must not contain tokens, private provider payloads, screenshots, or customer data.
