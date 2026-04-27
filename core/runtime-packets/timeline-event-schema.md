# Timeline Event Schema

Timeline events are append-only JSONL entries under `.accelerate/status/`.

Required fields:

- `ts`
- `event`
- `phase`
- `work_item`
- `artifact`
- `summary`

Known events include classification, workspace entry, work item lifecycle, plan,
task ledger, review, defect, proof, QA, closure, and handoff events.
