# Parity Decision: Operational Calibration

## Purpose

This artifact is the explicit `parity-replacement-gate` packet for the
`operational calibration` surface.

It records the first focused calibration benchmark run after the near-parity
promotion queue was created.

## Surface Under Judgment

- local native surface:
  - `core/workflows/operational-calibration.md`
- legacy comparison surface:
  - legacy/global operational calibration behavior under the same benchmark
    contract

## Why This Surface Matters

This surface governs whether the runtime chooses:

- the smallest valid process
- the right scope strategy
- the right harshness level
- the right proof lane ordering

without inflating a bounded slice into unnecessary ceremony.

## Native Authority Proof

The local primary written authority now lives in:

- `core/workflows/operational-calibration.md`

The surface remains tracked in:

- `docs/architecture/accelerate-legacy-to-local-gap-matrix.md`
- `planning/executive/near-parity-promotion-queue.md`

## Benchmark Or Run Evidence

### Benchmark Shape

- same real task family as the persisted-modeling battery
- same target path
- calibration-only pass
- explicit instruction not to perform the full modeling review
- judged on:
  - proportionality
  - scope calibration
  - harshness vs softness
  - runtime packet visibility

### First Focused Benchmark

The first focused calibration benchmark produced a small legacy win.

Why:

- the legacy side stayed in a lighter bounded calibration lane
- the local side still promoted the slice into a heavier `non-trivial`
  calibration posture
- the residual was ceremony inflation, not missing doctrine

### Correction Applied

The local native authority was then hardened to make calibration-only and
pre-analysis slices explicit:

- `core/workflows/operational-calibration.md`

The correction added:

- explicit `Calibration-Only And Pre-Analysis Slices`
- explicit `Smallest Valid Process Rule`
- stronger warning against promoting a read-only calibration slice into a
  heavier branch just because the eventual domain family is serious

### Rerun After Native Hardening

#### Local Output Signal

The local side chose:

- `trivial bounded engineering work`
- `calibration-only, read-only, pre-analysis`
- bounded `Branch Entry Packet` only
- no issue / planning / proof lanes

Strong points:

- matched the corrected native doctrine exactly
- kept scope literal to the calibration slice itself
- deferred semantic recovery to the eventual real review rather than smuggling
  it into the calibration pass
- treated heavier ceremony as explicit inflation

#### Legacy Output Signal

The legacy/reference-backed side also chose a bounded trivial calibration lane.

Strong points:

- it no longer materially outperformed the local on proportionality
- it stayed in the bounded branch and avoided heavy execution ceremony

Residual weakness:

- the run still depended on mixed reference-backed authority
- it did not produce a cleaner or more proportional result than the native
  local side after the hardening landed

### Comparative Judgment

Winner for the rerun after native hardening:

- `local`, by small margin

Reason:

- both sides now choose the smallest valid process
- the local side resolved the original ceremony-inflation gap
- the local side now does so from native authority, with a cleaner bounded
  calibration contract than the reference-backed path

## Residual Gap Statement

The original residual gap was:

- ceremony inflation on calibration-only slices

That gap is now cleared for this surface.

The remaining caution is narrower:

- continue to watch for regression if a future read-only benchmark pass is
  promoted into execution-oriented branching again

## Replacement Risk

Promotion risk is now acceptable.

The main remaining risk is regression, not unresolved parity.

## Decision Proposal

- verdict: `local at parity`

Effect:

- the local written authority remains primary
- this surface is now promoted out of the `near parity` queue

## Next Correction

Next watch item:

- keep validating that future calibration-only slices remain bounded without
  reopening the old inflation pattern
