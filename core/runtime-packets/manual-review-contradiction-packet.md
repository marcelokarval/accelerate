# Manual Review Contradiction Packet

Use this packet when the `Manual Review Contradiction Gate` is active.

## Packet

```text
Manual Review Contradiction Packet

- prior closure claim: <done|complete|loop-converged|other>
- review source: <manual review|code review|QA|operator audit|other>
- original task ids affected:
  - <id>
- contradiction findings:
  - id: <finding-id>
    task: <task-id|new-defect>
    reviewer claim: <summary>
    evidence cited: <file/line/runtime/path>
    classification: <valid-reopen|valid-new-defect|already-covered-with-evidence|false-positive|out-of-scope|blocked>
    required status change: <reopen|partial|new-defect|none>
    correction proof required: <code|test|browser|data|cross-view|cleanup>
- coverage reconciliation:
  - routes required vs inventoried: <...>
  - views/modes required vs inspected: <...>
  - data cases required vs proved: <...>
  - temporary artifacts expected removed vs present: <...>
- reopened tasks: <ids|none>
- new defects: <ids|none>
- false positives with evidence: <ids|none>
- loop verdict: <reopen-loop|closure-still-valid|blocked|scope-change-required>
```

## Rule

The packet must reconcile every review finding. Do not summarize a review as
"mostly done" while leaving individual contradictions unclassified.
