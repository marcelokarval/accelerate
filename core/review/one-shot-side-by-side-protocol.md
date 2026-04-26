# One-Shot Side-By-Side Protocol

## Purpose

Use this protocol when a mutation-bearing run explicitly asks for an executive
plan, tasks, one-shot execution, side-by-side review, auto-correction, delegated
correction when useful, and final forensic closure.

It turns a strong prompt pattern into native Accelerate governance.

## Activation

Open the `One-Shot Side-By-Side Gate` when the request includes any strong
combination of:

- executive plan plus task execution
- one-shot execution
- review 1:1 or side-by-side review
- auto-correction
- subagent correction handoff
- final forensic review

Do not apply this gate to truly trivial bounded edits unless the user explicitly
requests the technique.

## Required Chain

The required chain is:

1. create or identify the executive plan
2. create a task ledger
3. execute the bounded tasks in the one-shot execution batch
4. perform side-by-side task review for each task
5. compare requested vs implemented for each task
6. record defects, gaps, and drift
7. perform auto-correction for every in-scope defect
8. run reproof after each correction
9. hand correction back to a subagent only when the correction is bounded and
   delegation lowers risk or latency
10. perform final forensic side-by-side reconciliation before closure

## Per-Task Review Rule

Each task must have a side-by-side judgment that compares:

- requested outcome
- implemented evidence
- expected proof
- actual proof
- defects found
- correction owner
- reproof evidence
- closure status

The review must classify each requested item as `met`, `partial`, `missed`, or
`not-applicable`.

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
- missing final forensic reconciliation
- validation stack under-run
- subagent success accepted without master integration review

## Packet Surfaces

Use these packet shapes from `../runtime-packets/templates.md`:

- `Requested-Vs-Implemented Packet`
- `Defect Ledger Packet`
- `Correction Loop Packet`
- `One-Shot Side-By-Side Review Packet`
- `Final Forensic Reconciliation Packet`
- `Closure Packet`

## Task Ledger Surface

Use `../../planning/execution/one-shot-task-ledger-template.md` for future run
ledgers that need persistent task-by-task review and correction status.
