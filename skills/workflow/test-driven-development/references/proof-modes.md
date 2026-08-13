# Change-Kind Proof Modes

Choose the row matching the real change. For a hybrid, name and satisfy every
constituent contract.

| Change kind | Required pre-change baseline | Correction proof |
| --- | --- | --- |
| feature | observed failing behavior (Red) | minimal complete Green, refactor, focused and affected regression |
| bug | failing reproduction of the reported defect | focused regression proving the same scenario now passes |
| refactor | passing characterization of behavior to preserve | same characterization plus affected regressions |
| docs/governance | semantic validator with valid and invalid fixtures | both fixtures produce their specified results |
| migration | forward, compatibility, integrity, and rollback contract | forward and rollback proof on representative state |
| security | trust-boundary and abuse/negative baseline; safe-PoC disposition | negative proof and regression without unsafe exploitation |
| UI | focused behavior/QA baseline and interaction contract | browser truth before persistent end-to-end regression |
| external provider | contract/sandbox fixture, failure and idempotency scenarios | authorized readback when live effects are in scope |
| hybrid | every applicable constituent baseline | every constituent proof contract |

## Baseline Classification

- A feature test that passes immediately is not Red; confirm whether behavior
  already exists or whether the assertion is weak.
- An environment or syntax error is not behavioral Red; repair the harness and
  rerun before changing production behavior.
- A post-implementation test is valuable regression proof, but not TDD history.
- Characterization is intentionally passing evidence and must not be relabelled.
- Fixture or sandbox evidence must remain distinguishable from live browser or
  provider readback.

Never choose a mode to make the evidence easier. Choose from the change kind and
risk owner.
