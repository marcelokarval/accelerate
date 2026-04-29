# Manual Review Contradiction Gate

## Purpose

Use this gate when a later manual review, code review, QA review, or operator
audit contradicts a prior `done`, `complete`, `all implemented`, or `loop
converged` claim.

This gate treats the contradiction as evidence of a closure failure until each
finding is reconciled against the original task criteria.

## Activation

Activate this gate when:

- a reviewer says a completed task is incomplete or only partial
- a manual review finds missing routes, views, states, or data cases after broad
  coverage was claimed
- visual/browser proof existed but missed logic, data, localization, or
  cross-view behavior bugs
- temporary specs/artifacts remain after persistence/replacement was claimed
- task status appears optimistic compared with code evidence
- executor self-review was treated as acceptance proof
- reviewer and executor were not separated and no isolation exception was stated

## Rule

Do not defend the previous `done` claim by citing general proof. Convert the
review into a contradiction ledger and reconcile finding by finding.

Each finding must be classified as:

- `valid-reopen`
- `valid-new-defect`
- `already-covered-with-evidence`
- `false-positive`
- `out-of-scope`
- `blocked`

`valid-reopen` and `valid-new-defect` findings reopen the loop. The original
task must not remain `done`; mark it `partial`, `reopened`, or equivalent until
fresh proof closes the specific contradiction.

## Coverage Reconciliation Requirements

When the contradiction involves broad coverage, require explicit reconciliation
against the task scope:

- routes required vs routes inventoried
- views or modes required vs views inspected
- modals/popups/dialogs required vs inspected
- source/data cases required vs tested
- temporary artifacts required to be removed vs still present
- browser proof coverage vs logic/data proof coverage

Browser screenshots do not prove data truth or business logic unless the packet
names the data case and the code/runtime evidence behind it.

## Review Isolation Requirement

When a manual review contradicts a done claim, inspect the review chain itself:

- who executed the task
- who reviewed the task
- whether the reviewer was independent from the executor
- whether the final orchestrator performed review-of-review

If the executor was also the reviewer, classify the prior closure as suspect
unless a documented isolation exception exists with residual risk.

## Closure Blockers

Do not close when:

- a manual review finding remains unclassified
- a `done` task has valid contradictory evidence
- broad inventory claims do not enumerate missing residual routes/views
- cross-view parity was claimed but only one view was fixed
- absent data was fixed in one component but not analogous components
- temporary specs remain after persistent replacement was claimed
- final reconciliation does not say which tasks were reopened
- executor self-review was the only acceptance evidence
- orchestrator did not perform review-of-review

## Failure Labels

- `done-optimism-contradicted`
- `manual-review-finding-unclassified`
- `broad-inventory-overclaim`
- `browser-proof-missed-logic`
- `cross-view-parity-missed`
- `temporary-artifact-left-behind`
- `task-reopened-without-status-change`
- `executor-reviewed-own-work`
- `orchestrator-trusted-review-unchecked`
