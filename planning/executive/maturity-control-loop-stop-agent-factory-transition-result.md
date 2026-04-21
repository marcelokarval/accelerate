# Maturity Control Loop Stop And Agent Factory Transition Result

## Purpose

Register the first post-split maturity-control action after
`maturity-control-post-subagent-rerun-result.md`.

The operator asked to continue. The maturity-control question was whether to
force another maturity benchmark or stop the low-value promotion loop and move
to the next real structural surface.

## Runtime Posture

- date: 2026-04-21
- repository phase: standalone pre-agents
- workflow backend: pre-adapter / no-backend
- issue stack posture: approved no-backend executive-artifact exception
- proof lane: document comparison plus bounded doctrine rehome
- mutation scope: agent-factory docs and executive/architecture registration

## Decision

Stop the maturity-control promotion loop for now.

Do not:

- add a new maturity-control rule
- create another maturity-specific benchmark artifact only to chase promotion
- promote `maturity control` on one split direct cycle
- pretend future agents already exist

Do:

- move to the next structural surface from the migration plan
- rehome a real missing agent-factory doctrine piece
- preserve `maturity control` as `near parity` pending one more direct cycle

## Structural Surface Chosen

The next useful surface is:

- native `agent-factory`

Reason:

- the migration plan names agent-factory doctrine as the next major post
  pre-agents phase
- the recent `subagent model` work made family fit and future-gap handling
  operationally important
- the native `agents/` layer already existed, but empirical replay was still
  only available as inherited `references/codex-agents/` doctrine

## Correction Landed

Added:

- `agents/doctrine/empirical-replay.md`

Updated:

- `agents/README.md`
- `agents/doctrine/README.md`
- `docs/architecture/accelerate-pre-agents-baseline.md`
- `docs/architecture/accelerate-migration-plan.md`

## What Was Rehomed

The native replay now captures:

- representative real-work scenarios
- confirmed families
- tightened family meanings
- future-gap candidates
- packet expectations
- the rule that replay can say "do not create an agent; shrink, stop, or
  relocate the work first"

## Maturity-Control Evidence

This is the second direct maturity-control behavior:

- the loop did not add more maturity doctrine
- the loop did not chase another promotion-only benchmark
- the work moved to the smallest real structural surface
- useful inherited doctrine was rehomed into the native layer instead of being
  left as commentary

This strengthens the case for future bounded `maturity control` promotion, but
this artifact does not itself promote it. A separate promotion arbitration can
decide whether this second direct cycle is enough.

## AI Review Report

### Self-Review

The change is bounded and does not claim runtime agent promotion.

### Self-Forensic Review

The main failure risk is using agent-factory rehome to imply live agents. The
new replay file explicitly keeps future-gap candidates out of approved runtime
family status.
