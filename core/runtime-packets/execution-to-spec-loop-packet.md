# Execution-To-Spec Loop Packet

Use this packet when the `Execution-To-Spec Loop Gate` is active.

## Packet

```text
Execution-To-Spec Loop Packet

- user operating mode requested:
- active plan artifact:
- active task ledger artifact:
- one-shot batch scope:
- planned task count:
- implemented task count:
- task-by-task review status: <complete|partial|missing>
- requested-vs-implemented status: <met|partial|missed|blocked>
- QA proof run:
- browser proof run:
- visual proof run: <required-present|required-missing|not-needed>
- defects detected:
- correction loop status: <not-needed|open|complete|blocked>
- corrected-state reproof:
- remaining partial/missed tasks:
- waived/deferred items:
- final forensic reconciliation: <present|missing|blocked>
- loop verdict: <converged|continue-loop|blocked|user-scope-change-required>
```

## Rule

This packet is not a replacement for the detailed task ledger. It is the runtime
control snapshot that proves the execution loop is still honest.

Do not mark `loop verdict: converged` unless:

- task-by-task review is complete
- all in-scope defects are fixed or waived
- corrected defects have reproof
- final forensic reconciliation is present
