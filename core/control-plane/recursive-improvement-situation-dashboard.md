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
| GitHub land proof | `available` | `planning/evidence/dated-proof-appendix/github-pr-land-live-validation-2026-05-07.md` proves PR `#2` in `marcelokarval/accelerate-playground` was landed through `land-github-pr.sh`; `core/control-plane/capability-maturity-dashboard.md` records `PR land/merge` as `native` and `github-pr-land` as `available`. | Proof is bounded to guarded GitHub PR land/merge in the playground repository; it does not prove deploys, Linear writes, or ungated production merges. | Preserve proof locator and keep land execution behind `ACCELERATE_ALLOW_LAND`, readiness, closure, export, production-readiness, and head revalidation gates. | workflow adapter maintenance + root review-of-review |
| Linear MCP writes | `planned` | `core/control-plane/capability-maturity-dashboard.md` records repo-local structured non-LLM GraphQL helper shape for read/create/artifact-comment paths and keeps live availability unpromoted; closure comment and status transition remain `blocked` stubs. | No non-sensitive live Linear fixture proof has been recorded; `structured_non_llm_mcp_write_binding_required` is cleared only for helper shape, not for provider availability. | Prove read/create/artifact-comment on a non-sensitive Linear fixture, then implement/prove closure comment and status transition before any `available` promotion. | workflow adapter implementation subagent + provider-boundary/governance reviewer |
| `.accelerate/` dogfood | `available` | Contract test proof: `bash tests/dogfood-workspace-contract.sh`; committed non-secret workspace files exist under `.accelerate/` and point to this cycle's plan/ledger. | Generated/private proof outputs remain ignored and must not be committed. | Keep dogfood workspace current when recursive cycle state changes. | governance implementation subagent + root integration review |
| Semantic negative gates | `available` | Contract test proof: `bash tests/semantic-negative-fixtures.sh`; negative fixtures reject blocked/planned/substitute optimistic promotion without proof. | Fixture coverage is bounded to markdown status rows and must expand as new dashboards are added. | Keep negative fixtures aligned with new status surfaces. | QA/proof subagent + governance reviewer |
| Runtime adapter maturity | `linked` | `core/control-plane/runtime-adapter-maturity-dashboard.md` inventories runtime adapter statuses, proof locators, blockers, promotion/demotion criteria, drift detection, and cleanup rules. | The dashboard is a governance inventory; it does not prove remote runtime adapters or autonomous runtime availability. | Keep the dashboard linked and run `bash tests/control-plane-rc4-rc6.sh` before promoting any runtime adapter beyond its proof locator. | runtime adapter governance subagent + root review-of-review |
| Skill sync topology | `linked` | `core/control-plane/skill-sync-topology.md` defines repo-local source of truth, repo-outward generated export direction, forbidden user-home authority, drift detection, sync boundaries, and promotion criteria. | Generated skill bundles remain `planned` until reproducible export proof exists; user-home catalogs remain non-authoritative. | Use the topology as the controlling reference for skill import/export and run `bash tests/control-plane-rc4-rc6.sh` for drift-policy checks. | skill governance subagent + reviewer sidecar |
| Agent factory promotion pipeline | `linked` | `core/control-plane/agent-factory-promotion-pipeline.md` and `core/delegation/agent-factory-promotion-pipeline.md` define candidate intake, skill envelope, proof replay, runtime binding, cleanup/idle-agent handling, demotion criteria, and status vocabulary. | The pipeline is scaffolded governance only; this cycle does not create or promote an autonomous runtime. | Replay one bounded candidate role through the pipeline with repo-local skill envelope, negative fixtures, runtime cleanup proof, and root acceptance before availability. | agent-factory architecture subagent + root final review |

## Secondary Situation Classes To Inventory Each Cycle

| Situation class | Current handling | Required check |
| --- | --- | --- |
| Manifest/proof drift | Use `manifest-truth-gate.md`, capability manifests, remote write registry, and proof appendices. | Compare dashboards and manifests before promoting any adapter capability. |
| Duplicate doctrine | Use native control-plane homes first; supporting references remain secondary. | If two docs own the same rule, pick authority and leave a pointer. |
| Stale supporting references | Imported references can support migration but are not standalone authority. | Retire, rehome, or annotate stale references through a bounded docs task. |
| Idle subagent/process state | Governed by `core/delegation/subagent-model.md` and `recursive-self-improvement-loop.md`. | Confirm returned agents/processes are closed or retained with reason. |
| Runtime packet gaps | Runtime packet contracts live under `core/runtime-packets/`. | New recurring cycle state should become a packet only through an assigned packet task. |

## Status Honesty Rules

- GitHub land proof is `available` only within the 2026-05-07 proof boundary and guarded adapter path; do not generalize it to deploys or ungated merges.
- Linear MCP writes remain `planned` for repo-local read/create/artifact-comment helper shape until live non-sensitive fixture proof exists; closure comment and status transition remain `blocked` until dedicated structured bindings and proof exist.
- `.accelerate/` dogfood is `available` only within the committed non-secret fixture/state boundary validated by `bash tests/dogfood-workspace-contract.sh`; generated/private proof outputs remain out of scope.
- Semantic negative gates are `available` for markdown status-row promotion checks validated by `bash tests/semantic-negative-fixtures.sh`; expand fixtures before relying on new status surfaces.
- Runtime adapter maturity is `linked` to its dedicated dashboard; individual runtime adapters remain bounded by that dashboard and must not be promoted without proof.
- Skill sync topology is `linked` to its dedicated topology; generated skill bundles remain unpromoted until reproducible export proof exists.
- Agent factory promotion pipeline is `linked` to its dedicated pipeline; autonomous runtime availability remains blocked until runtime binding proof exists.

Do not replace these statuses with optimistic language such as `available`,
`native`, or `done` unless the proof locator changes and root review-of-review
accepts the promotion.

## Next Queue Seed

The next recursive cycle should prioritize:

1. Linear live fixture proof: prove repo-local read/create/artifact-comment helpers against a non-sensitive Linear fixture, then implement and prove closure comment/status transition bindings.
2. Persistent `.accelerate/` dogfood workspace for this repo.
3. Semantic negative fixtures for packets and gates.
4. Runtime adapter maturity dashboard follow-through: prove or demote individual runtime adapters using the linked dashboard.
5. Skill sync topology follow-through: implement reproducible generated export proof from repo-local source.
6. Agent factory promotion pipeline follow-through: replay one bounded candidate role without claiming autonomous runtime.

Each queue item must be shaped as a bounded task before execution, with owner
lane, allowed files, forbidden files, proof, reviewer, stop rules, and residual
tracking.
