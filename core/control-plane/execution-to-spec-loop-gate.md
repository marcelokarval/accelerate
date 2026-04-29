# Execution-To-Spec Loop Gate

## Purpose

Use this gate when the user asks for a complete execution loop rather than a
single edit or a loose plan.

It turns the prompt pattern "create the full executive plan, create full tasks,
implement in one shot, use browser proof, detect failures, correct them, and
continue until the planned outcome is delivered correctly" into native
Accelerate governance.

## Rule

When this gate is active, the run is not complete after initial implementation
or after the first passing test command.

Closure requires the loop to converge:

1. plan created or identified
2. task ledger created
3. one-shot implementation batch executed
4. QA/browser proof run against the plan
5. failures and visual/product drift detected
6. in-scope defects corrected
7. corrected state reproved
8. task-by-task side-by-side review completed
9. final forensic reconciliation completed

If any in-scope task remains `partial` or `missed`, the loop remains open unless
the user explicitly accepts a narrowed scope or a documented deferral.

## Activation

Activate this gate when the user request includes a strong combination of:

- complete executive plan
- complete task breakdown
- one-shot implementation
- browser proof or runtime proof
- loop / iterate / keep correcting
- detect failures and fix them
- deliver exactly what was planned
- forensic review or final reconciliation

Do not activate it for truly trivial bounded edits unless the user explicitly
asks for this operating mode.

## Required Sources

When active, this gate composes these native surfaces:

- `core/review/one-shot-side-by-side-protocol.md`
- `planning/execution/one-shot-task-ledger-template.md`
- `core/runtime-packets/qa-proof-stack.md`
- `core/runtime-packets/browser-proof-packet.md`
- `core/control-plane/visual-regression-proof-gate.md` when UI is changed
- `core/runtime-packets/correction-loop-packet.md`
- `core/runtime-packets/templates.md` packet shapes

## Execution Loop

```text
Plan -> Tasks -> Implement -> QA/Browser Proof -> Compare -> Defects
  ^                                                          |
  |                                                          v
  +------------------ Correct <- Classify <- Register <------+

Then: Reproof -> Side-by-side review -> Final forensic reconciliation -> Close
```

## Required Loop Packet

Use the `Execution-To-Spec Loop Packet` from
`core/runtime-packets/execution-to-spec-loop-packet.md` or include the same
fields in the active handoff artifact.

## Non-Negotiable Checks

- every planned task has status and proof
- each task is classified as `met`, `partial`, `missed`, or `not-applicable`
- backend/frontend QA appropriate to the slice was run or explicitly blocked
- browser proof inspected runtime behavior when UI/runtime is in scope
- visual proof inspected before/after findings when UI was mutated
- every in-scope defect has correction status and reproof
- final forensic reconciliation states what remains and why

## Loop Exit Conditions

The loop may close only when one of these is true:

1. all planned tasks are `met` with proof
2. remaining tasks are explicitly `not-applicable` due to discovered scope truth
3. remaining defects are explicitly waived by user or documented as out of scope
4. execution is blocked by missing credentials, unavailable runtime, failing
   dependency, or external system, and the blocker is packeted

## Closure Blockers

Do not close when:

- plan exists but task ledger is missing
- tasks exist but no task-by-task side-by-side review exists
- implementation was done but QA/browser proof was skipped
- browser proof found issues but no correction loop was opened
- corrected defects lack fresh reproof
- UI work has screenshots but no written visual comparison
- the final answer summarizes effort instead of reconciling plan vs landing
- the loop stops because the first attempt was "good enough" without comparison

## Failure Labels

- `loop-stopped-after-first-proof`
- `plan-without-task-ledger`
- `task-ledger-without-side-by-side-review`
- `browser-proof-not-fed-into-correction`
- `correction-without-reproof`
- `final-forensics-missing`
- `planned-outcome-not-reconciled`
