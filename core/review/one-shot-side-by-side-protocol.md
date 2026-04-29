# One-Shot Side-By-Side Protocol

## Purpose

Use this protocol when a mutation-bearing run explicitly asks for an executive
plan, tasks, one-shot execution, side-by-side review, auto-correction, delegated
correction when useful, and final forensic closure.

It turns a strong prompt pattern into native Accelerate governance.

When the request also asks the agent to stay in a QA/browser correction loop
until the planned outcome is delivered, this protocol is governed by
`../control-plane/execution-to-spec-loop-gate.md`.

## Activation

Open the `One-Shot Side-By-Side Gate` when the request includes any strong
combination of:

- executive plan plus task execution
- one-shot execution
- review 1:1 or side-by-side review
- auto-correction
- subagent correction handoff
- sequential task execution with parallel subagents where safe
- final forensic review

Do not apply this gate to truly trivial bounded edits unless the user explicitly
requests the technique.

## Required Chain

The required chain is:

1. create or identify the executive plan
2. create a task ledger
3. execute the bounded tasks in the one-shot execution batch
4. perform independent side-by-side task review for each task
5. compare requested vs implemented for each task
6. record defects, gaps, and drift
7. perform auto-correction for every in-scope defect
8. run reproof after each correction
9. hand correction back to a subagent only when the correction is bounded and
   delegation lowers risk or latency
10. perform final forensic side-by-side reconciliation before closure

When `Execution-To-Spec Loop Gate` is active, steps 6 through 9 repeat until the
loop converges, is explicitly narrowed by the user, or is blocked by packeted
external/runtime constraints.

## Sequential / Parallel Execution Rule

Tasks may be executed in parallel only when they are independent, have bounded
write scopes, and do not depend on the same runtime state, files, migrations,
design artifacts, or browser session assumptions.

Sequential dependencies must stay sequential. Parallel subagents may inspect or
implement bounded slices, but each slice still requires its own review,
correction, and reproof before the master integrates it into final closure.

The master owns task ordering, conflict detection, integrated proof, and final
side-by-side reconciliation. Subagent success is never closure by itself.

## Review Isolation Rule

The executor of a task must not be the acceptance reviewer for that same task.

Executor self-review may be collected, but it is not acceptance proof. Each
non-trivial task needs an independent skeptical review or an explicit review
isolation exception with residual risk. The final forensic reviewer is the
orchestrator and must not trust either the executor or the reviewer without
review-of-review.

## Per-Task Review Rule

Each task must have a side-by-side judgment that compares:

- requested outcome
- executor identity/role
- reviewer identity/role
- review independence: <independent|same-agent-exception|missing>
- implemented evidence
- expected proof
- actual proof
- defects found
- correction owner
- reproof evidence
- closure status
- contradiction status from any later manual/code/QA review

The review must classify each requested item as `met`, `partial`, `missed`, or
`not-applicable`.

If later review evidence shows a `met` item is actually partial or missed, update
the task status. The side-by-side packet is not immutable once stronger evidence
arrives.

## Correction Rule

No task may be marked closed while an in-scope defect is open.

Correction without reproof is not closure.

If a defect is waived, the waiver must name the reason, owner, and residual
risk. Waived defects remain visible in final forensic review.

## Delegated Correction Rule

Subagents may correct bounded defects, but they do not own integrated closure.

Any delegated correction must return:

- bounded correction scope
- files changed or surfaces inspected
- self-review
- self-forensic review
- correction/reproof status
- unresolved risk

The master integrates the result, performs review-of-review, and decides whether
fresh proof is sufficient.

## Final Forensic Rule

Final closure requires a side-by-side reconciliation of:

- executive plan vs final landing
- task ledger vs completed work
- requested vs implemented packets
- defects found vs defects fixed, waived, or open
- corrections vs reproof evidence
- validation expected vs validation run
- subagent claims vs master review-of-review
- closure claim vs actual proof

The branch remains blocked when any of these closure blocker conditions are
present:

- open in-scope defects
- corrections without reproof
- missing side-by-side task review
- executor reviewed own work without isolation exception
- missing final forensic reconciliation
- validation stack under-run
- subagent success accepted without master integration review
- skeptical review accepted without orchestrator review-of-review
- parallel tasks wrote overlapping surfaces without master conflict review
- later manual review contradicts `done` status and no task was reopened

## Packet Surfaces

Use these packet shapes from `../runtime-packets/templates.md`:

- `Requested-Vs-Implemented Packet`
- `Defect Ledger Packet`
- `Correction Loop Packet`
- `One-Shot Side-By-Side Review Packet`
- `Final Forensic Reconciliation Packet`
- `Closure Packet`
- `Execution-To-Spec Loop Packet`
- `Manual Review Contradiction Packet`
- `Review Isolation Packet`

## Task Ledger Surface

Use `../../planning/execution/one-shot-task-ledger-template.md` for future run
ledgers that need persistent task-by-task review and correction status.
