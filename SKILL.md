---
name: accelerate
description: Use as the root workflow classifier for engineering work. Route each run through semantic implications, proportional planning, proof, and closure before implementation.
metadata:
  category: orchestration
  origin: standalone-native-router
---
# Accelerate

`accelerate` is the root control plane for engineering work in this repository.
Read `AGENTS.md` first. This root file stays at repository root; it is the
activation and routing layer, while [the full preserved procedure](references/full-procedure.md)
holds detailed inherited doctrine.

## Scope and Authority

The repository is in the `standalone capability-portable` phase. Repository
sources govern: `SKILL.md`, `README.md`, `core/`, `adapters/`, `profiles/`,
`onboarding/`, `planning/`, `skills/`, and `references/`. Runtime mirrors and
user-home catalogs are projections or forbidden authority, never source truth.

External material may inform a comparison, but must be imported, adapted,
registered, and enforced here before it can govern behavior. A generated export
never supersedes its repository source.

The root always owns:

- classification and prompt-hardening decisions
- response locale, issue topology, lane order, and delegation budget
- truth ownership, risk enforcement, proof ordering, AI review, and closure
- `Done`; a bounded executor never inherits root closure authority

Use `core/control-plane/authority-set-gate.md` and
`core/control-plane/truth-ownership-check.md` whenever ownership is unclear.

## Mandatory Entry Sequence

For every engineering run:

1. decide whether the request is engineering work; conversational/no-op work
   stops without engineering ceremony;
2. preserve the user's response locale using
   `core/control-plane/response-locale-gate.md`;
3. run Stage A of the mandatory [Semantic Implication Gate](references/core/semantic-implication-gate.md):
   a bounded pre-scan that determines whether micro or full hardening is safe;
4. micro-harden a clearly bounded task; use full hardening for ambiguity,
   multiple phases, architecture, sensitive data, auth, billing, governance,
   runtime, external effects, or product/visual acceptance;
5. run Stage B of the Semantic Implication Gate: the full receipt after
   hardening and before classification;
6. resolve governed-target local workspace entry with
   `core/control-plane/local-workspace-entry-gate.md` before mutation;
7. classify, select route, state outcome and stop rules, then open only the
   needed branch gates and artifacts;
8. keep packets and proof visible until root closure.

Prompt length, file count, apparent simplicity, UI presence, and agent
availability are non-authoritative classification signals. The Semantic
Implication Gate first exposes possible domain, capability, invariant, seam,
and effect implications, then expands them into risk, route, proof, and
escalation output after hardening. A sensitive invariant,
cross-boundary seam, irreversible effect, or unresolved authority blocks a
trivial classification until resolved.

## Execution Routes

Classify as exactly one of:

- `conversational / no-op`
- `trivial bounded engineering work`
- `orchestrated non-trivial work`

Then select one execution route:

- `direct-fast-path`: one known, reversible, low-risk surface with focal proof.
  Never use for auth, billing, permissions, sensitive data, migrations, secrets,
  irreversible external calls, or runtime truth.
- `scoped`: a bounded lane with at most one valuable sidecar for discovery,
  current research, or independent proof.
- `orchestrated`: material uncertainty, cross-surface risk, or independent
  lanes require explicit ownership, reconciliation, and proportionate proof.

`direct-fast-path`, `scoped`, and `orchestrated` are an execution route, not a
classification or execution mode.

Use `core/control-plane/branch-enforcement-matrix.md` and
`core/control-plane/quick-invocation-map.md` for exact branch selection. Open
`core/hardening/prompt-hardening.md` for hardening depth and
`core/control-plane/outcome-preamble-gate.md` for goal, criteria, constraints,
expected output, and stop rules.

## Mutation, Planning, and Delegation

Any mutation to code, living docs, workflow seeds, or runtime governance needs
the issue stack unless a narrow explicit no-issue exception exists. Start at
`core/issue-topology/issue-driven-mutation-stack.md`; do not invent an absent
remote workflow adapter.

Use `planning/README.md` to choose a story, PRD-lite, SDD, or task breakdown.
The semantic gate feeds an SDD, optional selected OpenSpec mode, task graph, or
active Domain Gauntlet only when their governing contracts require them; it
does not claim their runtime is installed or authorize execution.

### Standing Multi-Agent V2 Delegation Request

For `execution_route=orchestrated`, requested execution, and `TASKS_READY`,
physical dispatch is mandatory before task-owned mutation when collaboration is
available. Root retains hardening, task graph, fan-in, integration-only repairs,
review-of-review, promotion, and closure. A virtual packet or
`single-threaded exception` is a blocking exception receipt, not permission. Only explicit
user opt-out, unavailable collaboration, or operator-authorized spawn failure
can waive dispatch. Every assignment declares `model`, `reasoning_effort`, and
`fork_turns`; read `references/delegation-dispatch-gate.md` and
`core/delegation/subagent-model.md` before dispatch.

## Product, UI, and Risk Routing

For structural UI uncertainty, open visual-contract discipline before editing.
For design-system, premium, or broad visual work, follow
`core/control-plane/ui-mutation-ladder.md`; do not begin broad premiumization at
page level without a bounded exception. Use
`core/control-plane/design-system-rollout-entry-gate.md` for rollout entry and
`core/control-plane/design-implementation-proof-gate.md` when artifacts mutate
real UI. For structural system graphs, use the Visual Modeling Gate; an
optional typed renderer must obey `core/control-plane/archify-visual-adapter.md`
and never become architecture or runtime authority.

Open the applicable high-risk branch before classification is finalized for
financial/refund effects, auth/authorization, sensitive data, migrations,
source-of-truth ownership, irreversible external effects, or unbounded
user-visible contracts. Full hardening and proportionate issue/specification,
review, and proof gates are required; short wording never justifies the fast
path. This gate does not authorize deploy, provider call, promotion, migration,
or closure.

Use `core/risk/enforcement-surfaces.md` for risk controls and
`core/review/product-critical-surfaces.md`,
`core/review/ux-ui-fullstack-surface.md`, or
`core/review/premium-interface-production.md` when frontend quality and backend
truth are jointly closure-critical.

## Runtime Visibility and Proof

Non-trivial packets expose at least active branch and skills, authority set
(`Authority Set`),
local workspace state, readiness/timeline, gate ledger, phase/SDLC, issue stack,
proof lanes, browser and persistent-E2E status, review/closure action, and
blockers. Use `core/runtime-packets/templates.md` and
`core/runtime-packets/cadence.md`; do not substitute opaque progress prose.

Proof order is:

1. implementation proof
2. backend/frontend QA proof
3. browser truth
4. persistent regression proof
5. forensic closure

Use `core/runtime-packets/qa-proof-stack.md`. Generic "tested" is insufficient:
prove the exposed seam/effect, rerun relevant tests, inspect logs and browser
console/network where applicable, include accessibility and responsive proof for
UI semantics, and reproof in-scope defects after correction. Browser truth
precedes Playwright when the flow is not stable.

Use `core/delegation/assignment-ontology.md` to keep Tester/verifier, QA proof
discipline, adversarial posture, independent review, technical surfaces, and
domain paths orthogonal. For long execution, `core/task-graph/` defines the
source-only graph/currentness heartbeat boundary; heartbeat is observation,
never authorization, lease, approval, Git repair, or closure.

For local `.accelerate/` reentry, read `.accelerate/review/handoff-summary.md` first; use
`onboarding/local-workspace/read-local-handoff.sh` only when it is missing or
template-shaped. For review/closure, prefer the canonical
`onboarding/local-workspace/prepare-review.sh` and `prepare-closure.sh` flows
unless debugging that layer itself.

## One-Hop Router

Open the smallest governing source for the active branch:

- entry/authority: `core/control-plane/authority-set-gate.md`,
  `core/control-plane/truth-ownership-check.md`,
  `core/control-plane/local-workspace-entry-gate.md`
- meaning/routing: `references/core/semantic-implication-gate.md`,
  `core/control-plane/branch-enforcement-matrix.md`,
  `core/control-plane/quick-invocation-map.md`
- hardening/plan: `core/hardening/prompt-hardening.md`, `planning/README.md`,
  `planning/architecture/sdd-template.md`, `planning/execution/task-breakdown-template.md`
- issue/delegation: `core/issue-topology/issue-driven-mutation-stack.md`,
  `references/delegation-dispatch-gate.md`, `core/delegation/subagent-model.md`,
  `core/delegation/assignment-ontology.md`
- proof/closure: `core/runtime-packets/qa-proof-stack.md`,
  `core/workflows/operational-calibration.md`,
  `references/release-update-governance.md`
- graph/currentness: `core/task-graph/README.md`,
  `core/task-graph/heartbeat-reanalysis-contract.md`
- detailed inherited behavior: `references/full-procedure.md`

When native authority is thin or comparison is the purpose, use the remaining
`references/` corpus as supporting detail only. Do not let it override native
core, accepted planning artifacts, or root laws.
