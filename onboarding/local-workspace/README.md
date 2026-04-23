# Local Workspace

This module is the first native implementation surface for the project-local
`.accelerate/` workspace.

Its job is not to make `.accelerate/` part of the standalone product repo.

Its job is to define, template, and emit the `.accelerate/` workspace into
governed target repositories.

## Current Stage

In the current `standalone pre-agents` phase, this module owns:

- the canonical V2 materialization surface
- the generation shape of the emitted `.accelerate/`
- drift-reconciliation rules between summary and detailed local state

It does not yet own:

- a V3 local control surface
- a native workflow adapter backend
- a broad runtime capability registry
- a full automatic installer

## Reading Order

For the first real `.accelerate/` implementation, read in this order:

1. `../../AGENTS.md`
2. `../../SKILL.md`
3. `../../docs/architecture/accelerate-project-local-workspace-executive-plan-v2-small-and-useful.md`
4. `../../docs/architecture/accelerate-project-local-workspace-v2-contract.md`
5. `README.md`
6. `v2-materialization-contract.md`
7. `v2-drift-reconciliation.md`
8. `v2-template/.accelerate/README.md`
9. `emit-v2.sh`
10. `validate-v2.sh`

## Module Rule

This directory is the product-side definition of the local workspace.

The emitted `.accelerate/` tree belongs in governed target repositories.

Do not treat `onboarding/local-workspace/v2-template/.accelerate/` as a second
live source of truth for the standalone repo itself.

It is a materialization template.

## First Entrypoint

Use:

- `./onboarding/local-workspace/emit-v2.sh /path/to/target-repo`
- `./onboarding/local-workspace/detect-signals.sh /path/to/target-repo`
- `./onboarding/local-workspace/classify-project.sh /path/to/target-repo`
- `./onboarding/local-workspace/bootstrap-or-reentry.sh /path/to/target-repo`
- `./onboarding/local-workspace/refresh-readiness.sh /path/to/target-repo`
- `./onboarding/local-workspace/print-status.sh /path/to/target-repo`
- `./onboarding/local-workspace/mark-checkpoint.sh /path/to/target-repo <checkpoint> <summary>`
- `./onboarding/local-workspace/reconcile-readiness.sh /path/to/target-repo review-ready|closure-ready [summary]`
- `./onboarding/local-workspace/sync-plan-status.sh /path/to/target-repo`
- `./onboarding/local-workspace/render-closure-packet.sh /path/to/target-repo`
- `./onboarding/local-workspace/render-ai-review-report.sh /path/to/target-repo`
- `./onboarding/local-workspace/render-review-ready-packet.sh /path/to/target-repo`
- `./onboarding/local-workspace/append-timeline.sh /path/to/target-repo <event> <summary>`
- `./onboarding/local-workspace/record-learning.sh /path/to/target-repo <type> <key> <insight>`
- `./onboarding/local-workspace/validate-v2.sh /path/to/target-repo`

This now supports the minimum deterministic onboarding loop:

- `emit-v2.sh`
  - materializes the canonical V2 tree
  - runs signal detection
  - derives initial decisions and summary state
- `detect-signals.sh`
  - writes observational repo facts into `.accelerate/onboarding/discovery.yaml`
- `classify-project.sh`
  - derives initial profile/backend/runtime/docs posture from discovery signals
- `bootstrap-or-reentry.sh`
  - chooses `init` vs local reentry/reonboarding reconciliation
- `refresh-readiness.sh`
  - refreshes the local readiness dashboard from current workspace truth
- `print-status.sh`
  - prints the local status summary for operator visibility
- `mark-checkpoint.sh`
  - appends a semantic checkpoint into the local continuity timeline
- `reconcile-readiness.sh`
  - promotes the local dashboard into `review-ready` or `closure-ready` when the proof lane is already satisfied
- `sync-plan-status.sh`
  - refreshes readiness and records a semantic phase checkpoint from `planning/current-plan.md`
- `render-closure-packet.sh`
  - renders a local status-backed closure packet for operator/review handoff
- `render-ai-review-report.sh`
  - renders a local status-backed AI Review Report summary
- `render-review-ready-packet.sh`
  - renders a compact review-ready packet from local status and current plan
- `append-timeline.sh`
  - records durable local workspace transitions in the continuity timeline
- `record-learning.sh`
  - records curated durable learnings worth carrying across sessions
- `validate-v2.sh`
  - verifies file presence, schemas, and summary/detail coherence

The validator checks:

- required V2 files
- minimum key presence
- summary drift between `state.yaml` and detailed authorities
- local planning artifact ladder coherence
- readiness dashboard presence and shape
- local status pointers for continuity timeline and learnings
