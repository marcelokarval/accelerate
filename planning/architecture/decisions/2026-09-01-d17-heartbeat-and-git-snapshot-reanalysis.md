# D17 — Heartbeat and Git Snapshot Reanalysis Boundary

- Status: accepted architecture for source-only implementation
- Date: 2026-09-01
- Governing proposal SHA-256: `79473c41e77c626a0c849d0ff385be7c140e7f66cfbf047e55ba5ccfe05cd067`

## Decision

A heartbeat and Git snapshot may provide a **delta baseline only**: they help
choose which source facts, candidate outputs, and proof claims need
reanalysis. They do not prove work is current, a process is alive, a runtime
is healthy, a working tree is accepted, or a lifecycle gate can advance.

A source-only heartbeat record is node/assignment/candidate-bound and includes
observed agent/call/fence identifiers, a dispatch-receipt digest binding,
timestamp, bounded expiry, sequence, the exact graph baseline, a current inline
Git snapshot, typed triggers, and explicit reanalysis status. The validator
compares the two closed snapshots and requires a Git trigger when they differ;
it does not emit a separate categorized additions/removals/unknowns report.
Any stale, mismatched, structurally invalid, or ambiguous record fails closed;
live runtime identity still requires separately authorized adapter readback.

## Gates and boundaries

The included source validator has deterministic fixtures for unchanged,
changed, missing, stale, dirty-overlap, wrong-candidate, receipt-digest,
conflict, and structurally mismatched cases represented by the v1 contract.
Runtime truth still requires separately authorized live readback; evidence
freshness and independent review remain separate gates.

This decision adds only a source contract, validator, and fixtures. It does not
add a heartbeat service, Git hook, polling process,
storage, cleanup action, runtime read, or tracker update. It cannot promote a
commit, amend history, or make a snapshot a substitute for Plane lifecycle.
