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

## Classification Contract

Every engineering run must be classified before execution continues.

The top-level outcomes are:

- conversational / no-op
- trivial bounded engineering work
- orchestrated non-trivial work

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
- active references
- local workspace status / action
- gate ledger
- phase / SDLC
- issue stack status
- QA / proof lane
- browser-proof status
- persistent E2E status
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

Browser truth comes before Playwright when the flow is not yet stabilized.

## Reference Map

Use these bundled references first:

- `references/prompt-hardening-gate.md`
- `references/branch-enforcement-matrix.md`
- `references/full-invocation-map.md`
- `references/local-workspace-entry-gate.md`
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

When the active repository has stronger local doctrine, use this runtime root
to classify and then defer to that repo-local authority.
