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

## Scope Boundary

The V2 materialization must not silently expand into V3.

Before V3 is explicitly adopted, do not add persisted local surfaces for:

- workflow mapping
- runtime capability registry
- profile overrides
- long-form local memory
