# OpenHands Native Subagent Registry SDD

State: accepted by operator direction and root review; implementing (reentry 2)
Issue: CODEX-10
Owner: root orchestrator
Independent acceptor: review lane after implementation

## Objective

Make the governed OpenHands specialist profiles available as real native
subagents to one canonical chat parent, `default`, preserving approved LLM
bindings and excluding ACP profiles from native delegation.

## Requirements and traceability

| ID | Requirement | Task | Planned proof |
| --- | --- | --- | --- |
| OH-SA-1 | Materialize each governed native specialist as a user file-based `AgentDefinition`. | Add a repo-owned idempotent materializer. | Unit test plus live `/api/sub-agents` inventory. |
| OH-SA-2 | Preserve each role's approved OpenHands LLM profile. | Generate `model` from the parity TOML. | Exact model comparison in unit and parity validators. |
| OH-SA-3 | Prevent recursive delegation and exclude ACP/provider-only lanes. | Never grant `task` to children; validate exclusions. | Negative contract tests and live tool inventory. |
| OH-SA-4 | Bound iteration, budget, permissions, and tool scope. | Require limits and role-specific tools in the registry. | Schema/semantic tests and API readback. |
| OH-SA-5 | Prove canonical-parent delegation and consolidation. | Run a bounded `default` canary after structural proof. | Parent/child conversation or task events and final parent response. |
| OH-SA-6 | Make `default` the sole canonical chat parent. | Remove delegation and routing suffix from `orchestrator` while retaining its profile. | Profile parity validator and live profile readback. |
| OH-SA-7 | Make governed workflow knowledge available to the chat parent. | Materialize repo-owned `accelerate` under the canonical OpenHands user skill path. | Safe materializer unit test, skill API readback, and fresh chat parent state. |
| OH-SA-8 | Make the canonical OpenHands root use the operator-selected Sol/medium lane without losing native delegation. | Materialize a native ChatGPT-subscription LLM profile and bind `default` to it. | Profile schema/load smoke, authenticated provider canary, and fresh root-to-two-child E2E. |
| OH-SA-9 | Establish governed candidate lanes for DeepSeek Flash/Pro and Luna efforts without leaking credentials or claiming unsupported “reasoning off”. | Materialize named LLM profiles from the parity authority; sync only API-key lanes from ENV. | Unit safety tests, readback, capability smoke, and comparative executor evaluation. |

## Design

`cross-runtime-agent-parity.toml` remains machine authority. A dedicated
materializer renders deterministic Markdown definitions into the canonical
user location `~/.agents/agents`. OpenHands 1.42.1 discovers those definitions and
conversation-local registration makes them visible to `TaskToolSet`.

Only `default` retains `enable_sub_agents=true`; `orchestrator` is preserved as
a non-root, non-delegating profile for compatibility. Children are not given
the task tool, so delegation depth is one. `codex` and
`gemini-flash` are ACP launch profiles and are excluded. `deepseek` remains an
explicit low-cost native child role, as required by the operator's fleet policy.
Provider/model lanes never become personas implicitly; an explicit governed
role definition such as this `deepseek` child is required.

The canonical parent receives an explicit decomposition and routing suffix:
delegate independent bounded slices before locally investigating them, use at most four children, preserve
root integration/closure, choose agents by registered role descriptions, and
prefer governed user-defined specialists over built-ins when a role fits.

The repo-owned `global-runtime/accelerate` skill is materialized into the
preferred user skill location `~/.agents/skills/accelerate`. OpenHands discovers
user skills by default; `default` is explicitly instructed to use Accelerate
for engineering entry. The materializer rejects symlinks and unmanaged targets,
so it never overwrites a user-owned skill.

Gemini remains available only through its governed ACP launch profile. It is
excluded from automatic native specialist routing because the operator reports
recurring availability instability; no Gemini-bound specialist role is part of
the target state.
This is an LLM routing policy with behavioral canary coverage, not a
deterministic classifier.

### Reentry 2 — subscription root and child-lane evaluation

The operator selected `Sol/medium` as the canonical root. OpenHands 1.42.1 has
native ChatGPT subscription support: `auth_type=subscription`,
`subscription_vendor=openai`, and persisted `is_subscription=true` cause the
SDK to use its own OAuth credential store and the Codex responses endpoint.
Subscription profiles require `stream=true`. OpenHands 1.42.1's active
`TaskManager`, however, overwrites every native child's stream setting to
`false`; the Codex endpoint rejects those child requests. This is an upstream
runtime blocker, not a credential or profile-materialization defect. We do not
carry a local OpenHands fork: subscription profiles are callable for direct
chat roots, but native child bindings use DeepSeek API profiles until an
upstream release removes or makes that override provider-aware.
This is deliberately separate from `OPENAI_API_KEY`; the materializer never
copies an API key or Codex credential into a profile. A concrete provider
canary established that the generic `gpt-5.6` identifier is rejected for a
ChatGPT subscription by the Codex endpoint. It is therefore deliberately not
materialized as a selectable profile. `chatgpt-sol-medium` is the valid native
root binding.

The governed profile registry also defines candidate profiles for Luna
low/medium/high, Terra medium/high, Sol high, and DeepSeek Flash/Pro at low and
high effort. “Fast” is explicitly the lowest supported effort, **not** a claim
that DeepSeek reasoning is disabled. Provider smoke must prove an actual
reasoning-off mode before any profile receives that label.

Gemini is excluded from this evaluation and from automatic routing because of
provider instability. Its ACP profile is retained only as an explicit manual
launch compatibility surface. Until the upstream streaming blocker is fixed,
DeepSeek Flash/low serves research and mechanical work, Flash/high serves
focused test implementation, and Pro/high serves bounded implementation and
skeptical review. Luna low/medium/high, Terra medium/high, and Sol high stay
materialized/direct-callable lanes but are excluded from native child bindings.
The canonical parent and subordinate `orchestrator` both use Sol/medium, with
delegation enabled only on `default`.

`write_mode` and `recursive_delegation` are governance metadata used by our
validator and prompts; OpenHands does not enforce those keys directly. Actual
runtime controls are least-capability tool lists, confirmation policy, omission
of `task_tool_set`, bounded iterations/budget, and the child system prompt.
Terminal/browser access is powerful and therefore must not be described as a
hard read-only sandbox.

The E2E canaries exposed stale literal provider credentials in the OpenHands
LLM profiles. A separate secret-safe synchronizer reconciles only DeepSeek
profiles from governed `DEEPSEEK_API_KEY`, preserves mode `0600`, and never
emits the value. Subscription profiles rely on the native OAuth credential
store; rollback is restoration of prior profile files from the operator's
private configuration backup.

## Dispositions

- ADR: consolidated here; no new cross-runtime architecture boundary.
- Product/UI design: not applicable; Agent Canvas consumes the existing API.
- Test Design: unit contract, drift validator, live discovery, then canary.
- Agent staffing: one read-only contract investigator and one independent reviewer.
- Rollout: repo proof, dry-run, materialize, live discovery, bounded canary.
- Subscription auth: use OpenHands-managed ChatGPT OAuth only; profile presence
  means configured, not authenticated or callable.
- Rollback: remove only files carrying the Accelerate managed marker or restore
  the previously captured directory snapshot; Agent Profiles remain intact.
- Observability: inventory count/names/models plus conversation/task event IDs.
- Governing docs: parity TOML and this SDD; no AGENTS mutation required.

## Stop conditions

- OpenHands runtime version/schema differs from the inspected 1.42.1 contract.
- A generated child receives `task` or an ACP profile enters the registry.
- Materialization would overwrite an unmanaged user definition.
- Live canary cannot prove child execution distinctly from a single-agent turn.
- Subscription OAuth is absent/expired or the selected ChatGPT model is not
  callable through the native OpenHands transport.
