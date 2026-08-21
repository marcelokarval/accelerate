<!-- generated from hermes-delegate-task.manifest.json; do not treat as runtime proof -->
# Hermes Delegate Task Adapter (Staged)

Use the repository-owned `hermes-delegate-task` contract only after runtime
truth identifies the active Hermes checkout, profile, and PostgreSQL authority.
Keep each batch homogeneous by `agent_role`, inherit the parent toolsets, cap
children at 3, and use `leaf` or `orchestrator` with depth 1 by default.
Nested delegation is forbidden unless the root records an explicit grant.

Start with effective synchronous delivery. A background request may become
synchronous; async cannot claim sync-first and is allowed only after delivery
ACK, reconciliation, and live PostgreSQL lineage. Return requested/effective
provider, model, and reasoning-effort receipts, policy references, and native
routing/result evidence. `unknown` delivery/execution blocks closure.
Do not claim a native root-write-lock: it is adapter/prompt-only and native
enforcement is unsupported. This fragment neither installs nor activates
anything in Hermes.
