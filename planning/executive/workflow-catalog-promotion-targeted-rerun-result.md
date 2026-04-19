# Workflow Catalog Promotion-Targeted Rerun Result

## Purpose

This artifact records the promotion-targeted rerun after the full comparative
registration for the `workflow catalog` surface.

It exists because the promotion-targeted judges split:

- local judge: remain `near parity`
- legacy/global judge: promote to `local at parity`

The root decision below resolves that split using the local
`parity-replacement-gate` decision ladder.

## Benchmark Packet

- surface: `workflow catalog`
- model / effort:
  - `gpt-5.4`
  - `high`
- benchmark shape:
  - local promotion-targeted read-only judge
  - legacy/global promotion-targeted read-only judge
  - same promotion question after durable full comparative registration
- target:
  - decide whether the accumulated evidence now supports `local at parity`
    or whether the surface must remain `near parity`
- prior evidence:
  - `workflow-catalog-post-correction-rerun-result.md`
  - `workflow-catalog-full-comparative-rerun-result.md`
  - `workflow-catalog-parity-decision.md`
  - `near-parity-promotion-queue.md`

## Issue And Planning Posture

This registration mutates durable executive artifacts.

The repository is still in standalone pre-agents / pre-adapter / no-backend
phase.

Current posture:

- `Issue-Bootstrap`: explicit `pre-adapter/no-backend` exception
- planning substitute:
  - this artifact
  - the full comparative rerun artifact
  - the parity decision artifact
  - the promotion queue
- approval posture:
  - direct user continuation approval for the benchmark/promotion loop
  - promotion changes parity status, not workflow routing or gate semantics

## Judge Results

### Local Judge

Verdict:

- remain `near parity`

Reason:

- native authority exists
- benchmark evidence shows the correction worked
- full comparative rerun found no new doctrine gap
- but local judge still treated behavioral repeatability as not
  promotion-grade

Root assessment:

- useful conservative signal
- partly self-referential, because it treated already-existing `near parity`
  documents as a blocker instead of deciding whether the new evidence had
  retired that blocker

### Legacy / Global Judge

Verdict:

- move to `local at parity`

Reason:

- native authority exists
- previous concrete under-call is corrected
- durable full comparative evidence shows no meaningful operational deficit
- remaining differences are wording density and legacy history, not a current
  method gap
- `local ahead` is not justified because live non-synthetic usage remains
  limited

Root assessment:

- decisive because this was the stricter comparison authority the local was
  being measured against
- no material legacy edge was named

## Root Arbitration

The local `parity-replacement-gate` defines:

- `near parity`: local has native surface but benchmark/live run still shows a
  meaningful behavioral edge for legacy
- `local at parity`: local has native authority and real benchmark/run
  evidence shows no meaningful operational deficit

The promotion-targeted legacy/global judge found no material operational
deficit.

The local judge found residual caution, but did not identify a current missing
workflow lane, gate, artifact, or proof shape.

Therefore the correct root decision is:

- promote `workflow catalog` from `near parity` to `local at parity`

This is not `local ahead`.

Reason:

- the local now matches legacy operational value for this surface
- live non-synthetic monitoring remains useful
- no evidence yet proves the local is superior to legacy on this surface

## Residual Risk

Residual risk moves from blocker to monitoring:

- future live sessions could still under-run packet expectations
- future workflow-catalog mutations still require approval discipline
- if a live run regresses into branch-label-only behavior, reopen the surface
  as a workflow-governance failure

## Required Updates

Completed by this promotion slice:

- gap matrix verdict should become `local at parity`
- workflow catalog parity decision should become `local at parity`
- near-parity queue should mark workflow catalog as promoted
- executive README should list the promotion

## AI Review Report

Requested vs implemented:

- requested: continue the benchmark loop
- implemented: full comparative registration, promotion-targeted local and
  legacy/global reruns, and root arbitration

Promised vs delivered:

- promised: compare legacy vs local and use the result to update local truth
- delivered: local promoted only after the legacy/global judge found no
  material remaining deficit

Issue / plan vs landing:

- no external issue exists because the repo is pre-adapter/no-backend
- the exception is explicit
- the executive artifacts are the planning substitute

Residual risk:

- monitor future live sessions for workflow output-shape regressions
