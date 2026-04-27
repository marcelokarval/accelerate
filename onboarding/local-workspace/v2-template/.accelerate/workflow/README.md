# Local Accelerate Workflow

This directory stores local workflow adapter truth for the governed repository.

It is the local substitute work-item backend until a remote workflow adapter such
as Linear or GitHub is selected and implemented.

## Files

- `adapter.yaml`: local adapter status and active work-item pointer
- `active-work-item.yaml`: rehydratable active work-item packet
- `work-items.jsonl`: append-only work-item creation and update ledger
- `events.jsonl`: append-only workflow lifecycle event log
- `topology.jsonl`: append-only parent/child/related/ledger-link event log

Do not edit these files casually. Use the local workflow scripts when possible.
