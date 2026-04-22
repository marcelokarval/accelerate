---
name: accelerate
description: Use as the always-on runtime root for engineering work to classify trivial vs non-trivial execution, then route into the correct bounded or orchestrated workflow.
metadata:
  category: orchestration
  origin: rewritten-from-claude
---
# Accelerate

Codex-native root orchestration skill for standalone engineering work.

Use `accelerate` as the entry control plane for any engineering run.

Its job is to decide how the work should run before implementation starts, then
stay responsible for the runtime shape until real closure.

This file is intentionally constitutional and compact.

- `AGENTS.md` sets the repo bootstrap laws
- `README.md` is the richer operating guide
- `core/` is the native method surface
- `references/` remains supporting inherited depth while rehoming continues

## Current Reality

This repository is in the `standalone pre-agents` phase.

That means:

- the root control plane must already work with zero promoted agents
- issue topology, risk enforcement, proof ordering, and closure discipline are
  already native concerns
- planning docs and executive artifacts are the current workflow vehicle until
  a native workflow adapter exists

Agents are optional. The platform is not waiting for them to become valid.

## Minimum Truth Stack

For a fresh engineering session, start with:

1. `AGENTS.md`
2. `SKILL.md`

When the run is non-trivial, architectural, or mutation-bearing, continue with:

3. `README.md`
4. `docs/architecture/accelerate-pre-agents-baseline.md`
5. `docs/architecture/accelerate-control-plane.md`

Then open the native surface that actually governs the branch, usually from:

- `core/control-plane/branch-enforcement-matrix.md`
- `core/control-plane/quick-invocation-map.md`
- `core/issue-topology/issue-driven-mutation-stack.md`
- `core/runtime-packets/qa-proof-stack.md`
- `core/workflows/operational-calibration.md`
- `core/review/product-critical-surfaces.md`
- `core/review/premium-interface-production.md`
- `core/risk/enforcement-surfaces.md`

## Root Laws

`accelerate` always owns:

- classification
- prompt-hardening decision
- issue topology
- lane opening order
- staffing / delegation budget
- risk enforcement
- proof ordering
- final AI review
- root closure mode
- `Done`

Bounded execution may implement or inspect a slice, but it does not inherit root
authority.

## Operating Model

Run `accelerate` in this order:

1. decide whether the task is actually engineering work
2. decide whether prompt hardening is mandatory
3. classify the run honestly
4. open the required branch, skills, gates, and artifacts
5. keep runtime state visible with explicit packets
6. enforce proof in the correct order
7. block closure until the branch contract is truly satisfied

Do not treat `accelerate` as a label. Treat it as the visible team operating
system for the run.

## Classification Contract

Every engineering run must be classified before execution continues.

The top-level outcomes are:

- conversational / no-op
- trivial bounded engineering work
- orchestrated non-trivial work

`prompt-hardening` is mandatory when the request is:

- long
- ambiguous
- multi-objective
- multi-phase
- architecture-heavy
- likely to drift without shaping

Do not skip hardening only because the task later turns out to be bounded.

## Branch Selection

Use the native branch matrix for exact routing.

The recurring branch families are:

- trivial bounded
- ambiguous / long / epic-like
- issue-driven delivery
- bug / failure / regression
- adversarial security / hostile-path review
- architecture / governance doubt
- runtime / product-heavy flow
- product-critical user surface
- premium interface
- untrusted ingress / upload / import / media ingestion
- persisted-modeling / contract-heavy review

When structural UI uncertainty exists, use wireframe / visual-contract
discipline before implementation.

## Runtime Visibility

Non-trivial runs should keep the active runtime state visible.

At minimum, runtime packets should expose:

- active branch
- active skills
- active references
- gate ledger
- phase / SDLC
- issue stack status
- QA / proof lane
- browser-proof status
- persistent E2E status
- closure blockers
- `single-threaded exception` when non-trivial work stays root-only

Do not replace packeted runtime state with long opaque progress prose.

## Mutation Rule

If the run mutates:

- code
- docs
- workflow seeds
- runtime governance

then the issue stack is mandatory unless a narrow explicit no-issue exception
exists.

In the current pre-agents phase, that means:

- executive planning artifacts are the governing execution handoff
- do not invent a fake workflow adapter
- do not assume Linear or another backend is already the enforced runtime truth

## Proof Order

The proof order is:

1. implementation proof
2. backend/frontend QA proof
3. browser truth
4. persistent regression proof
5. forensic closure

Do not collapse these lanes into a vague “tested” claim.

Browser truth comes before Playwright when the flow is not yet stabilized.

## Product-Critical And Premium Rule

Use `product-critical user surface` when backend truth and frontend product
quality are both closure-critical.

Escalate into `premium interface` when:

- perceived quality is part of the requested outcome
- a reference, Stitch, or Figma artifact is central
- technical correctness alone would still be unacceptable
- an existing `docs/reference/design-system*` package is meant to drive
  implementation, correction, improvement, or proposal work

These branches do not close on logic correctness alone.

## Agent Optionality

Agent usage is optional.

`accelerate` must remain fully functional:

- with no governed agents installed
- when the user disables agent usage
- when delegation has no honest fit

If non-trivial work remains single-threaded, say so explicitly and give the
reason.

## Reference Map

Use these native authorities first:

- branch routing:
  - `core/control-plane/branch-enforcement-matrix.md`
  - `core/control-plane/quick-invocation-map.md`
- mutation / issue discipline:
  - `core/issue-topology/issue-driven-mutation-stack.md`
- product/specification planning:
  - `planning/README.md`
  - `planning/product/README.md`
  - `planning/product/user-story-template.md`
  - `planning/product/prd-lite-template.md`
  - `planning/architecture/sdd-template.md`
  - `planning/execution/task-breakdown-template.md`
- proof and closure:
  - `core/runtime-packets/qa-proof-stack.md`
  - `core/workflows/operational-calibration.md`
- risk and enforcement:
  - `core/risk/enforcement-surfaces.md`
- critical visual/runtime review:
  - `core/review/product-critical-surfaces.md`
  - `core/review/premium-interface-production.md`
  - `core/review/html-design-system-extraction.md`
  - `core/review/design-system-contract-application.md`
- delegation:
  - `core/delegation/subagent-model.md`

Open `references/` only when native authority is still thin or when comparison
against inherited doctrine is the point of the run.
