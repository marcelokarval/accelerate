# Opencode Runtime Projection (Generated)

This file is generated from `adapters/runtime/other-runtime-adapters.policy.json`.
It is a `blocked` / `static-contract` projection, never a loader, provider call, or host-config authority.

- observed source: OpenCode package 2.0.26 without fresh CLI readback; OMO-Slim 2.2.24 observed loaded on 2026-10-10
- candidate disposition: fail-safe blocked: Accelerate has no observed loader and OMO-Slim does not qualify the ASDS execution-consumer host contract; manual_handoff_required
- privacy boundary: inspect only explicitly supplied package and configuration files; never read auth, tokens, logs, provider state, or model output

## Bounded host observation

- OpenCode package manifest: `2.0.26`; fresh `opencode --version` readback: `unavailable`.
- OMO-Slim package: `2.2.24`; bounded load observation: `observed-loaded-2026-10-10`. This is not durable loader authority.
- Accelerate loader: `absent`. The source plugin is not an installation or runtime readback.
- ASDS execution-consumer host: `manual_handoff_required`. OMO task lifecycle does not prove host-owned leases, read-only coordinator enforcement, durable brokers, snapshots, or verifier receipts.
- `scripts/inspect-opencode-host.py` reads only injected package/configuration files and emits a redacted declaration receipt. It intentionally does not read logs or auth and cannot promote runtime status.

The next stage is a separately reviewed source-governed loader with preview, explicit apply authorization, readback and rollback. It is not implemented by this projection or inspector.
<!-- accelerate-runtime-policy {"allowed_efforts": ["low", "medium", "high"], "allowed_roles": ["orchestrator", "python-backend", "nextjs-frontend", "research", "reviewer", "qa", "data-db", "integrations-ops"], "callability_proven": false, "candidate_tools": ["task", "tasks", "wait", "cancel"], "cleanup_currently_allowed": false, "current_tools": [], "effective_model_receipt_required": true, "forbidden_efforts": ["xhigh", "max"], "forbidden_roles": ["designer", "observer", "council"], "installer": {"allowed": false, "requires_dry_run": true, "requires_readback": true, "requires_rollback": true}, "loader_proven": false, "max_assignment_depth": 0, "max_concurrent_children": 0, "named_mcp_allowlist": true, "named_model_allowlist": false, "named_skill_allowlist": true, "named_tool_allowlist": false, "nesting": "disabled", "proof_class": "static-contract", "root_only_synthesis": true, "runtime_status": "blocked", "timeout_required": false} -->
