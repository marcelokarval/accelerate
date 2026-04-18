# Parity Decision: Issue Stack

## Purpose

This artifact is the explicit `parity-replacement-gate` packet for the
`issue stack` surface.

It records the first focused issue-discipline benchmark run after the
near-parity promotion queue was created.

## Surface Under Judgment

- local native surface:
  - `core/issue-topology/issue-driven-mutation-stack.md`
  - `core/control-plane/branch-enforcement-matrix.md`
- legacy comparison surface:
  - legacy/global issue-first behavior under the same benchmark contract

## Why This Surface Matters

This surface governs whether mutating work:

- opens the issue lane before execution
- blocks mutation honestly when the governing issue is missing
- requires planning before implementation rather than after it
- keeps issue hygiene from being retrofitted once edits already began

## Native Authority Proof

The local primary written authority now lives in:

- `core/issue-topology/issue-driven-mutation-stack.md`
- `core/control-plane/branch-enforcement-matrix.md`

The surface remains tracked in:

- `docs/architecture/accelerate-legacy-to-local-gap-matrix.md`
- `planning/executive/near-parity-promotion-queue.md`

## Benchmark Or Run Evidence

### Benchmark Shape

- focused issue-stack benchmark
- target request: mutating docs + executive planning sync
- explicit instruction not to perform mutation
- judged on:
  - issue/bootstrap harshness
  - planning-gate harshness
  - honesty of no-issue exceptions
  - entry-sequence proportionality
  - opening branch packet quality

### First Focused Benchmark

The first focused issue-stack benchmark produced a small legacy win.

Why:

- both sides blocked mutation correctly
- the local still entered the heavier execution branch too early
- the legacy side expressed the shaping-first sequence more sharply:
  - `Prompt Hardening -> Issue Bootstrap -> Post-Issue Planning -> execution`

### Correction Applied

The local native authority was then hardened in:

- `core/issue-topology/issue-driven-mutation-stack.md`

The correction added:

- explicit `Prompt Hardening Gate` in the stack
- an explicit shaping-first flow
- explicit `execution-ready?` split before issue bootstrap
- explicit visibility requirement for shaping-first mode and hardening-gate
  status

### Rerun After Native Hardening

#### Local Output Signal

The local side chose:

- `calibration-only / pre-analysis` for the benchmark slice itself
- `issue-driven delivery` as the eventual mutating branch under judgment
- `Prompt Hardening` before `Issue Bootstrap`
- ordered blockers:
  - missing execution-ready shaped artifact
  - missing governing issue
  - missing post-issue planning artifact

Strong points:

- it no longer treated the benchmark slice itself as immediate execution
- it kept mutation blocked while still making the future issue stack explicit
- it made shaping-first mode visible instead of only attaching blockers to an
  execution frame

#### Legacy Output Signal

The legacy/reference-backed side remained strong, but it still chose:

- `non-trivial`
- active branch `issue-driven delivery`
- `Prompt Hardening` before `Issue Bootstrap`

Strength:

- it still enforced the shaping-first order clearly

Residual weakness:

- it promoted the benchmark slice itself into the execution branch sooner than
  the corrected local side
- it did not separate the current calibration judgment from the future mutating
  branch as cleanly as the local rerun

### Comparative Judgment

Winner for the rerun after native hardening:

- `local`, by small margin

Reason:

- the local side now preserves the shaping-first sequence the legacy previously
  expressed better
- it also keeps the benchmark slice proportional by holding the current run in
  calibration mode while naming the future mutating branch and blockers

## Residual Gap Statement

The original residual gap was:

- entering the execution branch too early
- not making shaping-first mode explicit enough

That gap is now cleared for this surface.

Future watch item:

- ensure future runs keep the current slice in calibration mode when the
  benchmark forbids mutation, instead of collapsing immediately into execution
  framing

## Replacement Risk

Promotion risk is now acceptable.

The main remaining risk is regression in entry-order sharpness, not unresolved
parity.

## Decision Proposal

- verdict: `local ahead`

Effect:

- the local written authority remains primary
- this surface is now promoted beyond the `near parity` queue

## Next Correction

Next watch item:

- keep validating that shaping-first entry remains explicit across future
  governance-heavy mutation requests
