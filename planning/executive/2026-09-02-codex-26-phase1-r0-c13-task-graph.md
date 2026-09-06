# CODEX-26 R0 + C13 Frozen Task Graph

```text
ROOT: authority + SDD + task graph + dispatch + fan-in + freeze + closure
  ├─ R0 / Terra-medium / write scope A
  │    currentness lineage, local workspace, root-suite wiring
  └─ C13-core / Terra-medium / write scope B
       normative A04 fixture, contracts, Phase-1 behavioral tests
           ↓
       ROOT integration-only checks
           ↓
       fresh tester / Terra-medium / read-only isolated copy
       fresh reviewer / Terra-medium / read-only isolated copy
           ↓
       ROOT review-of-review
```

## Nodes

| Node | Owner | Writable scope | Depends on | Proof |
| --- | --- | --- | --- | --- |
| R0 | Terra/medium | `.accelerate/state.yaml`, `.accelerate/status/readiness-dashboard.yaml`, `.accelerate/workflow/active-work-item.yaml`, `scripts/validate-phase1-entry-currentness.py`, `tests/test_phase1_entry_currentness.py`, `tests/all.sh`, `planning/evidence/dated-proof-appendix/codex-26-phase1/c13-current-status-and-reentry-reconciliation.json` | authorization | currentness and root-suite tests |
| C13-core | Terra/medium | `core/phase1/contracts.py`, `tests/phase1/test_a04_behavioral.py`, `tests/phase1/fixtures/a04-normative-outcomes.json` | authorization | RED/Green semantic matrix |
| fan-in | root | no task-owned code | R0 + C13-core | scope/diff/authority/checks |
| tester | Terra/medium read-only | none | frozen candidate | isolated behavior proof |
| reviewer | Terra/medium read-only | none | frozen candidate | independent normative review |

## Frozen boundaries

- R0 must not edit frozen proposal/acceptance receipts or Phase-1 core.
- C13-core must not edit local workspace/currentness/root-suite surfaces.
- Neither child may spawn children, change Plane, commit, install globally, or
  promote a runtime.
- Root does not edit child-owned code surfaces.
