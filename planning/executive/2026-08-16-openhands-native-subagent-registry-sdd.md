# OpenHands Native Subagent Registry SDD

State: accepted by operator direction and root review; implementing
Issue: CODEX-10
Owner: root orchestrator
Independent acceptor: review lane after implementation

## Objective

Make the governed OpenHands specialist profiles available as real native
subagents to `default` and `orchestrator`, preserving the already approved LLM
bindings and excluding ACP profiles from native delegation.

## Requirements and traceability

| ID | Requirement | Task | Planned proof |
| --- | --- | --- | --- |
| OH-SA-1 | Materialize each governed native specialist as a user file-based `AgentDefinition`. | Add a repo-owned idempotent materializer. | Unit test plus live `/api/sub-agents` inventory. |
| OH-SA-2 | Preserve each role's approved OpenHands LLM profile. | Generate `model` from the parity TOML. | Exact model comparison in unit and parity validators. |
| OH-SA-3 | Prevent recursive delegation and exclude ACP/provider-only lanes. | Never grant `task` to children; validate exclusions. | Negative contract tests and live tool inventory. |
| OH-SA-4 | Bound iteration, budget, permissions, and tool scope. | Require limits and role-specific tools in the registry. | Schema/semantic tests and API readback. |
| OH-SA-5 | Prove parent delegation and consolidation. | Run a bounded orchestrator canary after structural proof. | Parent/child conversation or task events and final parent response. |

## Design

`cross-runtime-agent-parity.toml` remains machine authority. A dedicated
materializer renders deterministic Markdown definitions into the canonical
user location `~/.agents/agents`. OpenHands 1.42.1 discovers those definitions and
conversation-local registration makes them visible to `TaskToolSet`.

Only `default` and `orchestrator` retain `enable_sub_agents=true`. Children are
not given the task tool, so delegation depth is one. `codex` and
`gemini-flash` are ACP launch profiles and are excluded. `deepseek` remains an
explicit low-cost native child role, as required by the operator's fleet policy.
Provider/model lanes never become personas implicitly; an explicit governed
role definition such as this `deepseek` child is required.

The parent profiles receive an explicit decomposition and routing suffix:
delegate independent bounded slices before locally investigating them, use at most four children, preserve
root integration/closure, choose agents by registered role descriptions, and
prefer governed user-defined specialists over built-ins when a role fits.

Gemini remains available through its governed ACP launch profile and the six
approved native specialist bindings. Those native bindings must not be called
runtime-ready until a fresh provider call proves the credential; the
2026-08-16 canary returned `API_KEY_INVALID` before child execution.
This is an LLM routing policy with behavioral canary coverage, not a
deterministic classifier.

`write_mode` and `recursive_delegation` are governance metadata used by our
validator and prompts; OpenHands does not enforce those keys directly. Actual
runtime controls are least-capability tool lists, confirmation policy, omission
of `task_tool_set`, bounded iterations/budget, and the child system prompt.
Terminal/browser access is powerful and therefore must not be described as a
hard read-only sandbox.

The E2E canary exposed stale literal DeepSeek credentials in the OpenHands LLM
profiles. A separate secret-safe synchronizer now reconciles only the two
DeepSeek profiles from the governed `DEEPSEEK_API_KEY` environment authority,
preserves mode `0600`, and never emits the value. Rollback is restoration of
the prior profile files from the operator's private configuration backup.

## Dispositions

- ADR: consolidated here; no new cross-runtime architecture boundary.
- Product/UI design: not applicable; Agent Canvas consumes the existing API.
- Test Design: unit contract, drift validator, live discovery, then canary.
- Agent staffing: one read-only contract investigator and one independent reviewer.
- Rollout: repo proof, dry-run, materialize, live discovery, bounded canary.
- Rollback: remove only files carrying the Accelerate managed marker or restore
  the previously captured directory snapshot; Agent Profiles remain intact.
- Observability: inventory count/names/models plus conversation/task event IDs.
- Governing docs: parity TOML and this SDD; no AGENTS mutation required.

## Stop conditions

- OpenHands runtime version/schema differs from the inspected 1.42.1 contract.
- A generated child receives `task` or an ACP profile enters the registry.
- Materialization would overwrite an unmanaged user definition.
- Live canary cannot prove child execution distinctly from a single-agent turn.
