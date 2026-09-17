# Prompt G Dispatch Witness Disposition

## Witness result

The collaboration dispatch witness correctly found that the first attempted
dispatch lacked a material `TASKS_READY` receipt and persisted per-child
assignment receipts. Root therefore held Agy before mutation and kept Terra on
read-only standby.

## Root disposition

1. **Accepted — missing TASKS_READY receipt.** Corrected by
   `prompt-g-tasks-ready-receipt.json`.
2. **Accepted — missing child assignment receipts.** Corrected by
   `prompt-g-agy-assignment.md` and `prompt-g-terra-assignment.md`.
3. **Qualified — stale C13 local projection.** This is not an undeclared
   pre-dispatch ambiguity. Prompt G freezes its three entry hashes, identifies
   the stale C13 projection as the exact input defect, assigns its correction
   to Agy in `TASK-G04`, bounds the writable surfaces, requires the canonical
   closure preparation flow, and makes any remaining C13-as-current claim a
   stop condition. Root must not pre-correct this task-owned scope.

## Release rule

Agy remains held until an independent recheck confirms that these receipts,
Prompt G, and the task graph collectively satisfy physical dispatch governance.
Terra remains held until root produces the `TASK-G06` immutable candidate
manifest. No receipt here authorizes Plane lifecycle mutation, Phase 2,
promotion, commit, push, merge, deploy, or release.
