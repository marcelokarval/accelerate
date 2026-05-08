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
| `conditional` | The situation has proof only inside a named host/scope boundary. | Preserve the boundary and do not generalize it to portable runtime/CI availability. |
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
| Linear OAuth MCP lane | `conditional` | `planning/evidence/dated-proof-appendix/linear-mcp-oauth-validation-2026-05-08.md` records sanitized OAuth MCP discovery/read proof for authenticated user presence, team/status discovery, and bounded P4Y-1298 issue reads during this cycle. Dogfood state is aligned to governing parent `P4Y-1298` and child `P4Y-1302`. | Host-authenticated only; not portable CI/script proof and not a repo-local shell helper. Broad provider payloads, emails, tokens, and private issue bodies are not committed. | Keep OAuth MCP operations privacy-gated and bounded to governing issues or explicit fixtures; add a portable MCP capability manifest before claiming script/CI availability. | workflow adapter implementation subagent + provider-boundary/governance reviewer |
| Linear MCP writes (portable/repo-local) | `planned` | Current OAuth MCP proof is read/discovery and host-bound; `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md` remains the repo-local fallback blocker record. | No portable repo-local MCP/write chain or non-sensitive fixture mutation is accepted in this cycle. | Shape a bounded fixture mutation package for P4Y-approved fixture issues before promoting portable Linear MCP writes. | workflow adapter implementation subagent + provider-boundary/governance reviewer |
| Linear API-key GraphQL fallback | `planned` | `core/control-plane/capability-maturity-dashboard.md` records repo-local structured non-LLM GraphQL helper shape plus RC18 credential-safe live preflight; `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md` records fallback proof blocked by missing API-key credential, missing explicit fixture opt-in, and missing safe fixture settings. | No non-sensitive repo-local live Linear fixture proof has been recorded; OAuth MCP host proof does not satisfy the API-key fallback proof gate. | Provide the safe API-key credential, explicit live-fixture opt-in, fixture team, and fixture status outside committed state; pass preflight; then prove read/create/artifact-comment/closure-comment/status-transition on a non-sensitive Linear fixture before any shell-helper `available` promotion. | workflow adapter implementation subagent + provider-boundary/governance reviewer |
| `.accelerate/` dogfood | `available` | Contract test proof: `bash tests/dogfood-workspace-contract.sh`; committed non-secret workspace files exist under `.accelerate/` and point to this cycle's plan/ledger. | Generated/private proof outputs remain ignored and must not be committed. | Keep dogfood workspace current when recursive cycle state changes. | governance implementation subagent + root integration review |
| Semantic negative gates | `available` | Contract test proof: `bash tests/semantic-negative-fixtures.sh`; negative fixtures reject blocked/planned/substitute optimistic promotion and negated proof-locator language across markdown and YAML/status surfaces. | Fixture coverage now includes provider-live, generated-host, agent-runtime, and persistent-regression status surfaces, but must expand as new dashboards/packet schemas are added. | Keep negative fixtures aligned with new status surfaces. | QA/proof subagent + governance reviewer |
| Runtime adapter maturity | `linked` | `core/control-plane/runtime-adapter-maturity-dashboard.md` inventories runtime adapter statuses, proof locators, blockers, promotion/demotion criteria, drift detection, and cleanup rules. | The dashboard is a governance inventory; it does not prove remote runtime adapters or autonomous runtime availability. | Keep the dashboard linked and run `bash tests/control-plane-rc4-rc6.sh` before promoting any runtime adapter beyond its proof locator. | runtime adapter governance subagent + root review-of-review |
| Skill sync topology | `linked` | `core/control-plane/skill-sync-topology.md` defines repo-local source of truth, repo-outward generated export direction, forbidden user-home authority, drift detection, sync boundaries, and promotion criteria; RC21 reconfirmed proof is `planning/evidence/dated-proof-appendix/skill-export-proof-2026-05-08.md` and `bash tests/skill-export-proof.sh`. | Generated skill export is available only for repo-local export proof plus temp/approved generated host-runtime proof; real host/user-home catalogs remain non-authoritative and unpromoted. | Repeat the provenance/drift/rollback proof only against explicitly approved non-user-home generated host targets before any broader host runtime export promotion. | skill governance subagent + reviewer sidecar |
| Agent factory promotion pipeline | `linked` | `core/control-plane/agent-factory-promotion-pipeline.md`, `core/delegation/agent-factory-promotion-pipeline.md`, `agents/promotion/bounded-proof-auditor-replay.md`, and `planning/evidence/dated-proof-appendix/agent-factory-replay-2026-05-08.md` define and prove one fixture-scoped bounded proof-auditor replay. | The bounded role is `proof-replay` only; no runtime binding, persistent agent, installation, or autonomous runtime availability exists. | Add actual runtime binding, lifecycle monitoring, cleanup/idle-agent proof, demotion route, and root acceptance before availability. | agent-factory architecture subagent + root final review |

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
- Linear OAuth MCP lane is `conditional` for the current host only: `planning/evidence/dated-proof-appendix/linear-mcp-oauth-validation-2026-05-08.md` proves sanitized read/discovery through host OAuth MCP, but it is not portable repo-local script or CI proof.
- Linear MCP writes remain `planned` for portable/repo-local write proof; the current OAuth MCP evidence is a host-bound read/discovery lane, not a portable mutation chain.
- Linear API-key GraphQL fallback remains `planned` for repo-local read/create/artifact-comment/closure-comment/status-transition helpers until live non-sensitive fixture proof exists; RC18 preflight evidence is readiness/blocker evidence, not shell-helper availability proof.
- `.accelerate/` dogfood is `available` only within the committed non-secret fixture/state boundary validated by `bash tests/dogfood-workspace-contract.sh`; generated/private proof outputs remain out of scope.
- Semantic negative gates are `available` for markdown status-row promotion checks validated by `bash tests/semantic-negative-fixtures.sh`; expand fixtures before relying on new status surfaces.
- Runtime adapter maturity is `linked` to its dedicated dashboard; individual runtime adapters remain bounded by that dashboard and must not be promoted without proof.
- Skill sync topology is `linked` to its dedicated topology; the repo-local generated export proof path is available only within `scripts/export-skill-proof.sh`, `bash tests/skill-export-proof.sh`, and `planning/evidence/dated-proof-appendix/skill-export-proof-2026-05-08.md`; host runtime/user-home export remains unpromoted.
- Agent factory promotion pipeline is `linked` to its dedicated pipeline; bounded proof-auditor is fixture-scoped `proof-replay` only and autonomous runtime availability remains blocked until runtime binding proof exists.

Do not replace these statuses with optimistic language such as `available`,
`native`, or `done` unless the proof locator changes and root review-of-review
accepts the promotion.

## Next Queue Seed

The next recursive cycle should prioritize:

1. Linear lane follow-through for P4Y-1298/P4Y-1302: keep using `linear-oauth-mcp` only as a host-authenticated, privacy-gated lane for bounded governing issue operations; separately provide a safe API-key credential, explicit live-fixture opt-in, fixture team identifier, and fixture status identifier outside committed state before promoting the repo-local `linear-api-key-graphql` helper chain.
2. Browser/persistent proof: keep RC19 server readiness/capture-failure/cleanup monitoring covered and add a separate persistent E2E regression proof before any persistent Playwright/browser availability claim.
3. Skill sync host export: preserve the RC21 provenance/drift/rollback proof boundary and repeat it only against explicitly approved non-user-home generated host targets before any broader host runtime availability claim.
4. Agent factory runtime binding: keep bounded proof-auditor at fixture-scoped `proof-replay`/runtime-availability blocked until an implemented adapter proves invocation, lifecycle monitoring, idle cleanup, demotion, and root acceptance; the planned physical-agent adapter is not enough.
5. Semantic negative fixtures for new packet/YAML status surfaces, especially provider-live, generated-host, agent-runtime, and persistent-regression rows.
6. Runtime adapter maturity dashboard follow-through: prove or demote individual runtime adapters using the linked dashboard, with no promotion from plan-only or substitute evidence.
7. Dogfood workspace hygiene: keep `.accelerate/` pointed at the active cycle plan/ledger and keep credential names, provider payloads, screenshots, generated workflow JSON/JSONL, and private proof outputs out of committed dogfood state.

Each queue item must be shaped as a bounded task before execution, with owner
lane, allowed files, forbidden files, proof, reviewer, stop rules, and residual
tracking.
