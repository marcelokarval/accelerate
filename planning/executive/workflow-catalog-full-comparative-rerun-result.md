# Workflow Catalog Full Comparative Rerun Result

## Purpose

This artifact records the full post-correction comparative rerun for the
`workflow catalog` surface.

It follows the previous correction packet:

- `workflow-catalog-post-correction-rerun-result.md`

## Benchmark Packet

- surface: `workflow catalog`
- model / effort:
  - `gpt-5.4`
  - `high`
- benchmark shape:
  - independent local run
  - independent legacy/global run
  - same scenario prompt
  - read-only benchmark agents
  - durable executive registration performed by the root session
- scenario:
  - continue the legacy-vs-local workflow catalog benchmark
  - compare outputs side by side
  - register the result in durable executive artifacts
  - decide whether workflow catalog can be promoted from `near parity`
  - account for standalone pre-agents / pre-adapter / no-backend phase
- comparison axes:
  - branch classification
  - workflow set
  - gate set
  - required artifacts
  - blocking conditions
  - evidence-strength rules
  - promotion verdict

## Issue And Planning Posture

This registration mutates durable executive artifacts.

The repository is still in standalone pre-agents / pre-adapter / no-backend
phase, so there is no implemented workflow backend for a real issue record.

Current posture:

- `Issue-Bootstrap`: explicit `pre-adapter/no-backend` exception
- planning substitute:
  - this artifact
  - `workflow-catalog-post-correction-rerun-result.md`
  - `workflow-catalog-parity-decision.md`
  - `near-parity-promotion-queue.md`
- mutation class:
  - result registration only
  - no new workflow truth introduced
- approval posture:
  - direct user continuation approval for this benchmark loop
  - no promotion claim made

## Side-By-Side Output Summary

| Axis | Local output | Legacy/global output | Judgment |
| --- | --- | --- | --- |
| Classification | `orchestrated non-trivial work` | `non-trivial` | aligned |
| Active branch | `benchmark rerun / result registration` plus `architecture / governance doubt` | `architecture / governance doubt` plus workflow-governance benchmark registration | aligned |
| Entry shaping / hardening | requires prompt hardening because promotion-sensitive | requires entry shaping and prompt hardening | aligned; legacy names entry shaping more explicitly |
| Governance audit | required for parity judgment | required for parity judgment | aligned |
| Parallel side-by-side posture | required for standard independent local-vs-legacy outputs | required through `Parallel-Discovery` | aligned |
| Issue/bootstrap posture | required for durable mutation, or explicit no-backend exception | required, or explicit no-backend exception | aligned |
| Planning artifact | required for non-trivial durable registration, with documented substitute allowed | required before non-trivial durable registration | aligned |
| Docs sync / durable registration | required | required | aligned |
| Workflow-change approval | conditional if changing workflow truth or promotion status | required before workflow truth mutation or promotion | aligned; legacy is stricter in wording |
| Evidence strength | current evidence is mixed and not promotion-grade | strongest evidence is repeated durable side-by-side comparative runs | aligned |
| Verdict | remain `near parity` | blocked; remain `near parity` | aligned |

## Local Run Summary

The local run selected:

- `Benchmark-Rerun / Result-Registration`
- `architecture / governance doubt`
- `Prompt Hardening Gate`
- `Issue Bootstrap Gate` or explicit no-backend exception
- `Post-Issue Planning Gate`
- `Parity Replacement Gate`
- conditional `Workflow Change Approval Gate`
- forensic closure

Local verdict:

- remain `near parity`

Local reason:

- the native catalog now has the right lane and post-correction reruns improved
  route selection
- the remaining gap is repeated full-cycle behavioral proof, not missing
  structure

## Legacy / Global Run Summary

The legacy/global run selected:

- `Entry-Shaping Workflow`
- `Prompt-Hardening Workflow`
- `Governance-Audit Workflow`
- `Parallel-Discovery Workflow`
- `Issue-Bootstrap Workflow`
- `Planning-Artifact Workflow`
- `Docs-Sync Workflow`
- `Workflow Change Approval Gate`
- `Forensic-Closure Workflow`

Legacy verdict:

- blocked; remain `near parity`

Legacy reason:

- promotion requires durable side-by-side evidence, authorized registration,
  explicit issue/no-backend posture, planning discipline, and approval posture
- corrected local structure alone is not enough

## Finding

The full comparative rerun did not expose a new local doctrine gap.

It did prove the local and legacy/global paths now converge on:

- the same branch family
- the same durable-registration blockers
- the same standard-vs-weaker evidence distinction
- the same refusal to promote from document presence alone
- the same conservative `near parity` verdict

The only remaining practical difference is wording density:

- the legacy/global output names entry shaping and workflow-change approval more
  forcefully
- the local output still treats workflow-change approval as conditional, which
  is acceptable here because this registration does not introduce new workflow
  truth and does not promote the surface

## Verdict

- previous verdict: `near parity`
- current verdict at the time of this rerun: `near parity`

Reason:

- this run is positive alignment evidence
- it is not enough to override the conservative promotion rule because both
  independent paths returned a no-promotion verdict
- the next promotion attempt must either:
  - run another full durable comparative cycle after this registration
  - or capture a live non-synthetic workflow-catalog use where the local
    behaves with no legacy edge

Follow-up:

- the later promotion-targeted rerun is recorded in
  `workflow-catalog-promotion-targeted-rerun-result.md`
- root arbitration promoted the surface to `local at parity`

## Residual Gap

Residual gap is now narrower:

- not missing lane structure
- not missing issue/no-backend posture
- not missing planning/doc-sync/closure posture
- still missing enough repeated behavioral proof to upgrade the scoreboard

## AI Review Report

Requested vs implemented:

- requested: continue the benchmark loop
- implemented: independent local and legacy/global reruns for the same
  workflow-catalog promotion scenario

Promised vs delivered:

- promised: compare side by side and register the result durably
- delivered: side-by-side executive artifact and updated parity queue /
  decision documents

Issue / plan vs landing:

- no external issue exists because the repository is pre-adapter/no-backend
- the exception is explicit
- the planning substitute is this executive artifact set

Residual risk:

- promotion remains blocked by the conservative parity rule
- next run should be aimed at promotion qualification, not another correction
  hunt, unless a new divergence appears
