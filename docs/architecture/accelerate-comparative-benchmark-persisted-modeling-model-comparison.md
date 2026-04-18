# Accelerate Comparative Benchmark: Model Comparison On The Persisted-Modeling Battery

## Purpose

This artifact records the model-comparison extension run against the same
persisted-modeling battery.

It exists to preserve which model should be treated as:

- the main benchmark / governance model
- and which model, if any, should only be used as a secondary sharp auditor

## Compared Models

- `gpt-5.3-codex-spark` at `xhigh`
- `gpt-5.4` at `high`

## Stable Comparison Rule

Both models were used against the same benchmark family:

- persisted-modeling review
- same Prop4You backend target
- same legacy vs local comparison objective

The comparison judged:

- robustness under benchmark context load
- adherence to the benchmark contract
- usefulness of scope recovery
- fitness for doctrine-governance work
- quality of findings

## Versioned Comparison Ledger

| Comparison slice | `gpt-5.3-codex-spark xhigh` | `gpt-5.4 high` | Winner |
| --- | --- | --- | --- |
| context robustness | first legacy run exceeded context and required rerun with shorter prompt | stable | `gpt-5.4` |
| benchmark adherence | drifted toward narrower schema / constraint auditing | stayed closer to the benchmark contract | `gpt-5.4` |
| scope usefulness | more brittle and narrower | better `dual scope` handling and more stable useful recovery | `gpt-5.4` |
| doctrine / persistence / runtime reconciliation | weaker | stronger | `gpt-5.4` |
| micro-risk hunting | sharper on some constraint / race / JSON smells | good, but less spiky on micro-risks | slight edge to `spark` |
| executive usefulness | weaker | stronger | `gpt-5.4` |

## Preserved `spark` Signals

The `spark` runs were not useless.

They were strongest at:

- race-condition suspicion
- constraint posture
- excess JSON / hidden invariant suspicion
- router / guard / `CASCADE` suspicion

But they were weaker at:

- stable benchmark execution
- doctrine-driven comparative review
- broad operational judgment

## Preserved `gpt-5.4` Signals

`gpt-5.4 high` was strongest at:

- holding the benchmark contract together
- honoring the local-vs-legacy method distinction
- producing useful persisted-modeling findings without drifting into generic
  static auditing
- supporting parity / replacement judgment

## Durable Conclusion

For the `accelerate` benchmark / governance workflow:

- `gpt-5.4 high` is the main benchmark model

For narrow, already-planned, code-ready execution slices:

- `gpt-5.3-codex-spark` may still be useful as a fast execution model
- but it should not be the main benchmark or parity-judgment model

## Operational Policy Derived From This Comparison

Use:

- `gpt-5.4` for:
  - benchmark batteries
  - architecture
  - governance
  - planning
  - comparative review

Use `spark` only for:

- narrow execution of an already-closed plan
- fast code-ready slices
- preferably `medium`, at most `high`

Do not use `spark xhigh` as the default model for:

- benchmark batteries
- parity judgment
- architecture convergence work

## Evidence Role

This model-comparison artifact is supporting evidence for future benchmark
interpretation.

The governing benchmark memory for the persisted-modeling battery itself lives
in:

- `docs/architecture/accelerate-comparative-benchmark-persisted-modeling-battery.md`
