---
name: accelerate
description: Use as the always-on runtime root for engineering work to classify trivial vs non-trivial execution, then route into the correct bounded or orchestrated workflow.
metadata:
  category: orchestration
  origin: standalone-global-runtime
---
# Accelerate

Portable root orchestration skill for engineering work.

Use `accelerate` as the entry control plane before implementation starts.

Its job is to:

- classify the run honestly
- decide which gates and adjacent skills are required
- keep runtime state visible
- enforce proof order
- block closure until the active branch is truly satisfied
- for repeated broad work, freeze a wave denominator and close each wave by proof/coverage gates before advancing

This runtime bundle is intentionally portable. Repo-local `AGENTS.md` and
workspace docs remain authoritative after entry classification.

## Root Laws

`accelerate` always owns:

- classification
- prompt-hardening decision
- local workspace entry decision when governed repo state exists
- issue topology
- lane opening order
- staffing / delegation budget
- risk enforcement
- proof ordering
- final AI review
- root closure mode

Bounded execution may implement or inspect a slice, but it does not inherit
root authority.

## Reasoning Effort Contract

Select prompt-hardening depth and reasoning effort independently before opening
expensive lanes. Use the Codex-native machine authority at
`assets/reasoning-effort-policy.json`, the strict receipt shape at
`assets/reasoning-decision-receipt.schema.json`, and the human contract at
`references/reasoning-effort-policy.md`. Validate operational receipts with
`scripts/validate_reasoning_receipt.py`.

- Prefer deterministic scripts/commands for pure mechanics.
- Use `low` for bounded clear work.
- Keep `medium` for non-trivial work when repo-local authority, observability and
  acceptance are sufficient.
- `high` is fail-closed without an objective trigger and complete receipt.
- Issue priority, user emphasis, task size and multi-agent use are not triggers.
- `xhigh|max|ultra` require separate explicit scope, budget, eval and stop rule.

This skill never rewrites global `config.toml` per task. Repo-local `AGENTS.md`
may impose a stricter compatible boundary and remains authoritative.

## Operating Model

Run `accelerate` in this order:

1. decide whether the task is actually engineering work
2. decide whether prompt hardening is mandatory
3. when a governed target repository is in scope, decide local workspace entry
   state first
4. classify the run honestly
5. open the required branch, skills, gates, and artifacts
6. keep runtime state visible with explicit packets
7. enforce proof in the correct order
8. block closure until the branch contract is truly satisfied

## Fable Method Composition

Fable is an optional reasoning/reporting overlay, never another root workflow.
When Fable is considered, classify `fable_overlay` as `required`, `useful`, or
`not-needed` and persist a short basis in the existing runtime packet:

- `required` when the user explicitly names Fable inside an Accelerate run;
- `useful` for conflicting authorities, material intent ambiguity, or an
  outcome-first audit/report;
- `not-needed` when a specialist skill already defines mechanics and proof.

Accelerate retains branch, staffing, risk, proof order and root closure. Fable
feeds the outcome preamble, Authority Set, scope decision, proof lane and final
report. Do not duplicate packets, ledgers, proof or closure. Load
`references/fable-method-composition.md` for the self-contained repo-local
contract; user-home skill catalogs are not authority.

## Classification Contract

Every engineering run must be classified before execution continues.

The top-level outcomes are:

- conversational / no-op
- trivial bounded engineering work
- orchestrated non-trivial work

## Execution Routes

Choose one route after classification:

- `direct-fast-path`: known, one-surface, low and reversible-risk work with
  focal proof; root executes directly with micro-hardening and zero physical or
  virtual subagents. Never use it for auth, billing, permissions, sensitive
  data, migrations, secrets, irreversible external calls, or runtime truth.
- `scoped`: one bounded lane may use at most one sidecar for independent
  discovery, current research, or proof when its value exceeds handoff cost.
- `orchestrated`: material uncertainty, cross-surface risk, or two or more
  independent lanes require ownership, reconciliation, and proportionate proof.

These are an execution route, not a classification or execution mode. They do
not override stricter repository authority. Do not escalate only because work
touches multiple files, includes UI, or an agent is available.

Escalate out of `direct-fast-path` when the target stops being known, proof
becomes broad or runtime-facing, risk is material, or a genuinely independent
lane appears.

When a run is design-system-driven, premium, or broadly visual, default to the
UI Mutation Ladder:

1. token authority
2. derived token wiring
3. shared primitives
4. shared composites
5. registry / examples / reference package
6. shells / layouts
7. pages / feature consumers

When design-system extraction or premium artifacts already exist and rollout
planning enters the picture, open
`core/control-plane/design-system-rollout-entry-gate.md` before using an
executive plan as an implementation entrypoint. The handoff is incomplete if it
does not explicitly name the required pre-read set, immutable contract
authority, primary implementation driver, and execution slicing artifact.

Do not start broad premiumization at page level unless a bounded exception is
explicitly packeted.

### Bounded Trivial Branch

For bounded trivial work, still enforce:

- `accelerate`
- `Truth Ownership Check`
- `Stack Adherence`
- minimum relevant adjacent stack skill when needed
- compact `Branch Entry Packet`
- honest verification before closure

If the trivial branch mutates:

- code
- living docs
- workflow seeds
- runtime governance

then apply the issue bootstrap discipline before execution unless a narrow
explicit no-issue exception exists.

### Non-Trivial Branch

Non-trivial work should:

- use prompt hardening when ambiguity is real
- keep packeted runtime visibility
- default to multi-agent execution when there is an honest fit
- emit a `single-threaded exception` reason when staying root-only
- keep proof and closure lanes visible until real completion

Agent usage is optional. `accelerate` must remain functional with zero promoted
agents.

## Local Workspace Rule

When a governed target repository uses a local `.accelerate/` workspace, root
classification must resolve that state before issue bootstrap or deeper branch
execution.

The runtime should decide one of:

- no local workspace required yet
- first local install required
- existing local workspace can be reused
- light reentry required
- partial reonboarding required
- structural reonboarding required

Do not let mutation-bearing work skip this decision.

## Runtime Visibility

For engineering runs, keep visible:

- active branch
- active skills
- authority set (governing authorities, supporting references, decision artifacts,
  backend authority, generated exports, and forbidden authority exclusions)
- local workspace status / action
- readiness status
- timeline checkpoint status
- learning disposition
- gate ledger
- phase / SDLC
- issue stack status
- QA / proof lane
- browser-proof status
- persistent E2E status
- local review / closure action
- closure blockers
- `single-threaded exception` when non-trivial work stays root-only

Use explicit packet shapes rather than long opaque progress prose.

## Proof Order

The proof order is:

1. implementation proof
2. backend/frontend QA proof
3. browser truth
4. persistent regression proof
5. forensic closure

Backend/frontend QA proof is governed by `references/qa-proof-stack.md`. When
backend or frontend behavior is in scope, do not close from a generic `tested`
claim. Revalidate relevant tests and coverage when configured; backend QA must
capture and scan logs; frontend/browser QA must inspect DevTools console and
network, capture screenshots, check ARIA/accessibility when UI semantics are in
scope, compare against the active framework/design-system rules, and run the
3x3 mobile/tablet/desktop viewport matrix for visual or responsive UI work.
When risk exists, QA must also prove or explicitly rule out Negative Path,
Security/Auth/Ownership, Concurrency/Idempotency, Performance Minimum, External
Resilience, Clean State/Cleanup, and Observability Correlation. For full QA
coverage, also cover Test Data, Contracts, Observability, Compatibility, Deep
Accessibility, Internationalization, Migration/Rollback, Dependency Audit, and
Snapshot/Golden Master when applicable.

Browser truth comes before Playwright when the flow is not yet stabilized.

When the active repository has `.accelerate/` local status and the run is
entering review or closure, prefer the canonical composed local commands:

- `prepare-review.sh`
- `prepare-closure.sh`

These composed commands now represent the full local handoff preparation flow:

- persisted review / closure artifacts
- persisted pre-review / closure bundles
- persisted `Branch Entry Packet`
- persisted `Runtime Delta Packet`
- persisted `handoff-summary.md`

When a compact local reentry read is needed, prefer `handoff-summary.md` first,
then expand into the individual packet and bundle surfaces only as needed.

If that file is missing or still only template-shaped, fall back to:

- `read-local-handoff.sh`

Only bypass this with an explicit manual-debug exception for the local
workspace layer itself.

## Wave-Gated Execution

Use wave-gated mode when broad work has a repeatable target set or a measurable coverage denominator.

Default shape:

```text
class: orchestrated non-trivial work
mode: wave-gated
```

Required gates:

- freeze the denominator before mutation;
- emit a Wave Packet;
- run implementation and proof gates;
- compute coverage with `scripts/wave_gate_report.py`;
- require >=95% coverage unless explicitly overridden;
- open correction/reproof loop before advancing when the gate fails;
- close with a Wave Closure Packet.

Do not use wave-gated mode for tiny one-off changes or large one-shot features without repeated target sets.

## Reference Map

Use these bundled references first:

- `references/prompt-hardening-gate.md`
- `references/reasoning-effort-policy.md`
- `references/branch-enforcement-matrix.md`
- `references/full-invocation-map.md`
- `references/local-workspace-entry-gate.md`
- `references/ui-mutation-ladder.md`
- `references/issue-stack.md`
- `references/runtime-packet-templates.md`
- `references/runtime-observability-cadence.md`
- `references/workflow-catalog.md`
- `references/workflow-change-approval-gate.md`
- `references/qa-proof-stack.md`
- `references/product-critical-surfaces.md`
- `references/premium-interface-production.md`
- `references/specification-layer.md`
- `references/subagent-model.md`
- `references/persona-mandatory-skills-matrix.md`
- `references/codex-collaboration-routing.md`
- `references/codex-collaboration-role-policy.json`
- `references/wave-gated-execution.md`
- `references/fable-method-composition.md`

When the active repository has stronger local doctrine, use this runtime root
to classify and then defer to that repo-local authority.

## Resource Router

References:

- `references/skill-catalog-truth-gate.md`: require fresh runtime discovery and a declared coverage class before skill thinning, specialist selection, or capability claims.

- `references/reasoning-effort-policy.md`: select and audit prompt-hardening depth and the minimum sufficient Codex effort; machine authority is `assets/reasoning-effort-policy.json`.
- `references/codex-collaboration-routing.md`: map Codex execution roles to supported collaboration model and reasoning parameters.
- `references/codex-collaboration-role-policy.json`: machine-readable role policy consumed by the Codex collaboration adapter.
- `references/wave-gated-execution.md`: use for broad repeated work with frozen denominators, coverage gates, correction loops, and wave-by-wave closure.
- `references/fable-method-composition.md`: classify and apply Fable as an optional reasoning/reporting overlay without duplicating Accelerate root authority.

Scripts:

- `scripts/validate_reasoning_receipt.py`: validate a non-secret reasoning decision receipt against the local policy and schema.
- `scripts/wave_gate_report.py`: compute denominator coverage and emit JSON or a Wave Closure Packet.

Assets:

- `assets/reasoning-effort-policy.json` and `assets/reasoning-decision-receipt.schema.json`: machine policy and receipt shape for the reasoning-effort contract.

Templates:

- `templates/wave-packet.md`: use when freezing a denominator before a wave.
- `templates/wave-closure-packet.md`: use when closing or correcting a wave after proof.

Evals:

- `evals/evals.json`: use when checking trigger behavior for trivial, bounded, large one-shot, repeated, and multitask prompts.
