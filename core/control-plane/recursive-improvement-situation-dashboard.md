# Recursive Improvement Situation Dashboard

This dashboard is the standing inventory of Accelerate's current internal
recursive-improvement situations. It is intentionally conservative: it tracks
what must improve without promoting blocked, planned, or substitute capabilities
beyond their proof.

Use it with `recursive-self-improvement-loop.md` during recursive audit cycles.
Update rows when proof, manifests, task ledgers, or architecture authority
changes.

## Dashboard Status Vocabulary

| Status | Meaning | Promotion rule |
| --- | --- | --- |
| `native` | The capability or control surface exists in repo-local authority and has enough proof for current use. | Keep proof locator durable; revalidate when dependencies change. |
| `available` | The capability can be used under its current gates with durable proof. | Link live or contract proof. |
| `linked` | The situation is governed through another dashboard, gate, or manifest. | Keep link current; do not duplicate source truth. |
| `planned` | The intended surface exists or is accepted, but decisive proof or implementation is absent. | Do not use as real capability until proof lands. |
| `blocked` | A named blocker prevents honest use or promotion. | Remove blocker and prove through a bounded task before promotion. |
| `substitute` | Local, dry-run, or fallback evidence exists but is not equivalent to provider/runtime truth. | Keep substitute boundary explicit; create live proof task if promotion is desired. |
| `unknown` | Inventory has not yet established the current state. | Run discovery before task shaping. |

## Priority Situations

Required situation keys: GitHub land proof, Linear MCP writes, `.accelerate/`
dogfood, semantic negative gates, runtime adapter maturity, skill sync topology,
agent factory promotion pipeline.

| Situation | Status | Evidence | Residual | Next task | Owner lane |
| --- | --- | --- | --- | --- | --- |
| GitHub land proof | `planned` | `core/control-plane/capability-maturity-dashboard.md` keeps `PR land/merge` and `github-pr-land` as `planned`; live merge proof is absent. | Only dry-run/fail-closed proof exists; no disposable playground PR has been actually landed for this repo's adapter stack. | Create a bounded GitHub PR land/merge live-proof task using a non-sensitive disposable playground PR, closure proof, export approval, and remote CI watch. | workflow adapter implementation subagent + proof sidecar + root review-of-review |
| Linear MCP writes | `blocked` | `core/control-plane/capability-maturity-dashboard.md` keeps Linear create/update, artifact attachment, closure comment, and status transition as `blocked` by `structured_non_llm_mcp_write_binding_required`. | Structured non-LLM MCP write binding is missing; existing evidence is not enough to treat Linear writes as available. | Implement structured non-LLM Linear MCP write binding and prove create/comment/status update on a non-sensitive fixture before any status promotion. | workflow adapter implementation subagent + provider-boundary/governance reviewer |
| `.accelerate/` dogfood | `planned` | Executive plan states local `.accelerate/` workspace exists as target-repo mechanism but is not yet persistently dogfooded in this repo. | Accelerate cannot yet claim persistent self-dogfood of its local workflow adapter state. | Create guarded persistent `.accelerate/` dogfood workspace for this repo with local status, packet, cleanup, and substitute-evidence boundaries. | governance implementation subagent + root integration review |
| Semantic negative gates | `planned` | Recursive plan names weak semantic negative fixture coverage; existing test suite is green but this slice does not add negative fixtures. | Positive-path and presence checks can pass while semantic status-promotion regressions remain possible. | Add contract tests/fixtures that fail if blocked/planned/substitute states are promoted without proof, including dashboard and packet cases. | QA/proof subagent + governance reviewer |
| Runtime adapter maturity | `planned` | Executive plan notes runtime adapter manifests contain many `planned`/`substitute` states. | No dedicated runtime adapter maturity dashboard is established here; maturity gaps are dispersed across manifests and docs. | Build a runtime adapter maturity dashboard that inventories native/planned/substitute runtime capabilities, proof locators, blockers, and promotion conditions. | runtime adapter governance subagent + root review-of-review |
| Skill sync topology | `planned` | Repository instructions require repo-local skill authority and allow external sync/export only as generated deployment from this repo outward. | One-way sync/export topology and drift detection are not yet fully modeled as an operational dashboard or proof contract. | Define skill sync topology: repo-local source of truth, allowed generated exports, drift detection, proof command, and forbidden user-home authority assumptions. | skill governance subagent + reviewer sidecar |
| Agent factory promotion pipeline | `planned` | Architecture docs and repository instructions name agent factory as a target layer; `core/delegation/subagent-model.md` governs bounded delegation. | Agent factory remains architecturally meaningful but not operationally complete; no promotion pipeline proves agent roles into runtime availability. | Create an agent factory promotion pipeline covering candidate role, skill envelope, proof replay, runtime binding, cleanup expectation, and demotion criteria. | agent-factory architecture subagent + root final review |

## Secondary Situation Classes To Inventory Each Cycle

| Situation class | Current handling | Required check |
| --- | --- | --- |
| Manifest/proof drift | Use `manifest-truth-gate.md`, capability manifests, remote write registry, and proof appendices. | Compare dashboards and manifests before promoting any adapter capability. |
| Duplicate doctrine | Use native control-plane homes first; supporting references remain secondary. | If two docs own the same rule, pick authority and leave a pointer. |
| Stale supporting references | Imported references can support migration but are not standalone authority. | Retire, rehome, or annotate stale references through a bounded docs task. |
| Idle subagent/process state | Governed by `core/delegation/subagent-model.md` and `recursive-self-improvement-loop.md`. | Confirm returned agents/processes are closed or retained with reason. |
| Runtime packet gaps | Runtime packet contracts live under `core/runtime-packets/`. | New recurring cycle state should become a packet only through an assigned packet task. |

## Status Honesty Rules

- GitHub land proof remains `planned` until live land/merge proof exists.
- Linear MCP writes remain `blocked` until `structured_non_llm_mcp_write_binding_required` is removed by implementation and fixture proof.
- `.accelerate/` dogfood remains `planned` until persistent repo-local dogfood state exists and is validated.
- Semantic negative gates remain `planned` until negative fixtures prove status-promotion failures are caught.
- Runtime adapter maturity remains `planned` until a dedicated dashboard or equivalent inventory is durable.
- Skill sync topology remains `planned` until repo-local source-of-truth and generated export/drift rules are operationally proven.
- Agent factory promotion pipeline remains `planned` until candidate roles can be promoted, bound, tested, cleaned up, and demoted through a documented pipeline.

Do not replace these statuses with optimistic language such as `available`,
`native`, or `done` unless the proof locator changes and root review-of-review
accepts the promotion.

## Next Queue Seed

The next recursive cycle should prioritize:

1. GitHub PR land/merge live proof.
2. Linear structured MCP write binding.
3. Persistent `.accelerate/` dogfood workspace for this repo.
4. Semantic negative fixtures for packets and gates.
5. Runtime adapter maturity dashboard.
6. Skill sync topology.
7. Agent factory promotion pipeline.

Each queue item must be shaped as a bounded task before execution, with owner
lane, allowed files, forbidden files, proof, reviewer, stop rules, and residual
tracking.
