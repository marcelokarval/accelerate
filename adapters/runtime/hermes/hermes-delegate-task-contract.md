# Hermes `delegate_task` Adapter Contract

This is a repository-owned, staged adapter contract. It maps the portable
delegation semantic core to Hermes's native `delegate_task` primitive without
claiming that the adapter is installed, active, callable, or promoted.

## Native mapping

- A batch has one `agent_role`; heterogeneous roles are separate batches.
- Child toolsets are inherited from the parent. This adapter does not claim a
  native per-child tool allowlist.
- The requested child role is `leaf` or `orchestrator`; the default maximum
  assignment depth is one. Nested delegation is off unless the root records an
  explicit grant.
- The adapter policy cap is at most three children, even when native runtime
  capacity is higher or unknown.
- `background=true` is never a completion claim. A background request can fall
  back to synchronous execution.
- Native `execution_state` is exactly `completed`, `failed`, `interrupted`, or
  `unknown`. Adapter-only values must be `adapter:<name>` with an explicit
  mapping. Native delivery includes `delivery_intent`, `delivery_unknown`,
  `dead_lettered`, `replay_requested`, `dropped`, and `discarded`; unknown
  state blocks closure.
- Every return records requested and effective provider, model, and reasoning
  effort. Requested values bind to named policy references; effective values
  cite native routing/result evidence. Effective reasoning may be `unknown`,
  never invented.
- Lineage has two proof classes. `static-shape` validates IDs only. A canary
  requires `live-postgres` with parent/unique-child IDs, an evidence locator,
  hash, and readback timestamp. No child may equal its parent.
- Hermes has no native root-write-lock proven by this adapter. The lock is an
  adapter/prompt contract only and must be labelled `unsupported` natively.

## Sync-first canary

Static capability validation accepts only `static-shape` lineage and cannot
claim a live canary. A separate live verifier requires governed runtime truth
and a read-only PostgreSQL parent/child lookup with SHA-256, RFC3339 readback,
and an identifiable locator. Sync is `adapter:sync_result_received`, derived
from combined results and route receipt, never a native delivery ACK. Async
cannot claim this sync-first projection.

The no-argument live-verifier invocation is a normal preflight: it emits a
secret-safe `BLOCKED` reason and exits `3`, never a silent usage result.

## Staged projection and rollback

`scripts/stage-hermes-delegate-task-adapter.py --dry-run` emits the only
authorized pre-install plan and exits `3` (`BLOCKED_PENDING_RUNTIME_TRUTH`).
It never writes into Hermes. Installation,
service restart, database mutation, provider invocation, and promotion are
separate root gates. Before any future install, re-establish runtime truth and
stop if the Hermes source/worktree is dirty or its target is ambiguous.

Rollback before installation is removal of the staged projection from its
declared target after readback. Post-install rollback requires a separately
approved Hermes release/runtime rollback plan; this contract authorizes none.
