# V2 Materialization Contract

## Purpose

This document defines how the standalone `accelerate` product should materialize
the `V2 Small And Useful` `.accelerate/` workspace inside a governed target
repository.

Use this alongside:

- `../../docs/architecture/accelerate-project-local-workspace-executive-plan-v2-small-and-useful.md`
- `../../docs/architecture/accelerate-project-local-workspace-v2-contract.md`

## Canonical Product Surface

The canonical product-side implementation surface is:

- `onboarding/local-workspace/`

The first safe materialization entrypoint is:

- `onboarding/local-workspace/emit-v2.sh`
- `onboarding/local-workspace/validate-v2.sh`

The canonical emitted target surface is:

- `.accelerate/`

## Materialization Rule

When `accelerate` performs real onboarding in a governed repository, it should:

1. decide whether the run is `greenfield` or `adoption`
2. create `.accelerate/` if it does not exist
3. emit the minimum V2 tree
4. populate the YAML files with the minimum schema
5. populate markdown files with bounded, human-readable truth
6. keep `.accelerate/state.yaml` as a summary index
7. keep subfiles as detailed local authorities

For planning, that means emitting the full local artifact ladder even when some
artifacts are initially marked `not required yet`.

The first implementation entrypoint may emit placeholder values that honestly
represent `not_started`, `unknown`, or empty states. It must not claim
completed onboarding by default.

That emitted tree becomes real only after bounded project-local truth is
written into it.

Validation should happen immediately after materialization and again whenever
the local workspace has been materially updated.

The first entrypoint already distinguishes:

- `greenfield`
- `adoption`

and writes that distinction into `.accelerate/state.yaml`.

## Template Rule

The template tree under `v2-template/.accelerate/` is the canonical starting
shape for first materialization.

It should be copied and then specialized with project-local truth.

Do not leave placeholder-only output in a repository after onboarding is
claimed as real.

## Output Rule

The emitted `.accelerate/` workspace must remain:

- versioned
- canonical
- human-readable
- machine-readable where structured state is needed
- free of secrets and noisy session logs

The local workspace must persist project-specific control-plane state, not a
copy of standalone `accelerate` doctrine.

## Directory Allowlist

The emitted `.accelerate/` workspace is schema-governed. New directories are not
free-form. The currently allowed directories are:

| Directory | Purpose |
| --- | --- |
| `.accelerate/` | Workspace root containing `README.md` and `state.yaml`. |
| `.accelerate/onboarding/` | Discovery, decisions, onboarding status, and visual config discovery. |
| `.accelerate/status/` | Readiness dashboard, evidence registry, timeline, and durable learnings. |
| `.accelerate/status/checkpoints/` | Context checkpoints for session restore and interruption recovery. |
| `.accelerate/planning/` | Current plan and local planning ladder. |
| `.accelerate/planning/history/` | Archived or historical planning references. |
| `.accelerate/review/` | Review, closure, proof, forensic, and handoff artifacts. |
| `.accelerate/review/componentization/` | Deep componentization audit reports. |
| `.accelerate/review/componentization/pages/` | Per-page componentization reports. |
| `.accelerate/agents/` | Local agent status/candidates/gaps for pre-agent readiness. |
| `.accelerate/workflow/` | Local workflow adapter state, events, work items, and topology. |
| `.accelerate/proof/` | Small local proof packets referenced by the evidence registry. |

Temporary captures, screenshots, traces, logs, and scratch files belong under the
target repository `.tmp/`, not under `.accelerate/`.

Any new `.accelerate/` directory must be added to this contract and
`check-workspace-layout.sh` in the same change.

## GStack-Inspired Operational State

The workspace persists Accelerate-native versions of the useful gstack operating
patterns without adopting gstack as authority:

| File | Purpose |
| --- | --- |
| `.accelerate/status/questions.jsonl` | Append-only question log with door type and source. |
| `.accelerate/status/question-preferences.json` | Trusted low-risk question preferences. |
| `.accelerate/status/privacy-map.yaml` | Privacy/export classification map. |
| `.accelerate/status/safety-overlay.yaml` | Current careful/freeze/guard overlay state. |
| `.accelerate/planning/task-ledger.md` | Durable task execution state. |
| `.accelerate/planning/review-pipeline.md` | Required/contextual review lane state. |
| `.accelerate/review/findings.jsonl` | Structured review findings. |
| `.accelerate/review/qa-report.md` | Structured QA/browser proof report. |
| `.accelerate/review/design-feedback.json` | Design feedback packet. |
| `.accelerate/review/design-approved.json` | Design approval packet. |
| `.accelerate/review/design-baseline.json` | Design baseline packet. |

## Scope Boundary

The V2 materialization must not silently expand into V3.

Before V3 is explicitly adopted, do not add persisted local surfaces for:

- workflow mapping
- runtime capability registry
- profile overrides
- long-form local memory beyond the minimal `status/` layer
- cache, tmp, browser traces, or session-noise folders
