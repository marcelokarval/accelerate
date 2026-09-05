# Runtime Packet Cadence

## Purpose

This document is the native core home of the observability cadence contract.

## Rule

Non-trivial work must not hide the active workflow stack for long stretches.

## Minimum Cadence

- first technical update -> `Branch Entry Packet`
- before `DISPATCH_REQUIRED` task-owned execution -> `Delegation Dispatch Receipt`
- meaningful stack change -> `Runtime Delta Packet`
- prompt hardening active -> `Prompt Hardening Packet`
- subagent completion -> `Subagent Return Packet`
- QA lane completion -> `QA / Proof Packet`
- pre-close -> `Closure Packet`
- graph drift observation -> `development-heartbeat/v1` (observation and
  reconciliation only; see `core/task-graph/heartbeat-reanalysis-contract.md`)

The heartbeat records the graph's `delta-baseline` Git inventory and signals
that reanalysis is required after Git, contract/spec/scope, runtime/capability,
lease/fence, or review/evidence drift. It never authorizes a lease, approval,
dispatch, transition, or closure, and it never performs reset, stash, rebase,
or automatic worktree serialization.

When a governed target repository already has `.accelerate/`, the opening
`Branch Entry Packet` should prefer the compact local handoff read first:

- `review/handoff-summary.md`
- otherwise `read-local-handoff.sh`

## Single-Threaded Exception

If a non-trivial run remains single-threaded, the opening packet must expose an
explicit `single-threaded exception`; after `DISPATCH_REQUIRED` it is a blocker,
not authorization to execute task-owned work at root.

## Authority

The detailed cadence reference still lives in:

- `references/runtime-observability-cadence.md`
