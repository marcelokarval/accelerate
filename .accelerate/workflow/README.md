# Accelerate Dogfood Workflow

This directory stores the Accelerate repository's committed dogfood workflow control-plane state.

## Lifecycle Semantics

- `adapter.yaml` is the local workflow-adapter summary index for the committed dogfood surface.
- `active-work-item.yaml` points at the currently selected dogfood work item, which may be the last accepted cycle when no newer implementation cycle has been committed.
- Provider exports, event streams, screenshots, browser captures, and raw MCP/API payloads are generated/private and must stay ignored.

For RC24..RC27, this directory records an accepted last cycle, not an unfinished active implementation run.

Validation note: this committed workflow directory is covered by `onboarding/local-workspace/validate-dogfood-v2-subset.sh` through the dogfood contract. The full generated V2 validator, `onboarding/local-workspace/validate-v2.sh`, remains reserved for generated workspaces with the complete workflow event, topology, and work-item files.
