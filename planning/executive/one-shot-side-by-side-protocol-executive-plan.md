# One-Shot Side-By-Side Protocol Executive Plan

## Purpose

Add a native Accelerate protocol for mutation-bearing runs where the operator
asks for an executive plan, tasks, one-shot execution, side-by-side task review,
auto-correction, delegated correction when useful, and final forensic review.

The goal is to make this technique enforceable inside the standalone
`accelerate` stack instead of preserving it as an ad hoc prompt pattern.

## Source Request

The user requested a repeatable automation of this structure:

- build the executive plan
- build the tasks
- execute all tasks in one shot
- review each task one-by-one side by side
- verify delivery and auto-correct gaps
- perform a deep final forensic side-by-side review
- pass corrections back to subagents when delegation is useful

## Selected Approach

Use the full governed protocol with a strong test stack.

This includes:

- native review protocol documentation
- execution ledger template
- runtime packet templates
- branch matrix wiring
- gate ownership wiring
- delegation model reinforcement
- doctrine tests for structure, semantics, delegation, and closure behavior

## Non-Goals

- Do not implement a live workflow adapter or issue backend automation.
- Do not invent promoted subagents that do not exist yet.
- Do not require every trivial task to use this protocol.
- Do not replace existing requested-vs-implemented, defect-ledger, correction,
  or forensic review surfaces; compose them.

## Active Branch

- Branch class: orchestrated non-trivial governance/workflow mutation.
- Primary surfaces: `core/review`, `core/control-plane`, `core/runtime-packets`,
  `core/delegation`, `planning/execution`, `tests`.

## Required Artifacts

- `core/review/one-shot-side-by-side-protocol.md`
- `planning/execution/one-shot-task-ledger-template.md`
- runtime packet additions in `core/runtime-packets/templates.md`
- branch matrix gate references
- gate ownership index entry
- subagent model correction handoff rule
- test scripts:
  - `tests/one-shot-protocol-integrity.sh`
  - `tests/one-shot-protocol-semantic.sh`
  - `tests/one-shot-protocol-delegation.sh`
  - `tests/one-shot-protocol-closure.sh`
- doctrine integration from `tests/doctrine-integrity.sh`

## Proof Plan

1. Write failing tests first against the missing protocol surfaces.
2. Implement the smallest local doctrine and templates that satisfy the tests.
3. Run each one-shot protocol test individually.
4. Run the integrated doctrine/profile validation stack.
5. Complete a final side-by-side forensic reconciliation against this plan and
   the task ledger.

## Closure Criteria

Closure requires all of the following:

- every required artifact exists
- branch matrix names the protocol gate where the branch can trigger it
- gate ownership index points to a real owner file
- runtime packet templates include per-task side-by-side and final forensic
  packet shapes
- delegation model preserves master ownership and correction/reproof returns
- tests enforce structure and core semantics
- no in-scope defect remains open without explicit waiver

## Residual Risks

- Tests can enforce structural and semantic anchors, but not full human-quality
  review judgment.
- Future workflow adapters may need concrete command-level automation later.
- The first version should avoid overfitting to any single external issue
  backend.
