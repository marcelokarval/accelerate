# Accelerate Phase 1 Standalone Hardening

## Status

- status: completed one-shot slice
- date: 2026-04-15
- intent: convert the imported standalone repo from "incubator-shaped copy" into
  a clearer platform baseline without attempting a full rehome in one batch

## Objective

This slice had three concrete goals:

1. de-incubator the core language of the product
2. break the core's `linear-first` wording in favor of `active workflow adapter`
3. materialize the first real filesystem shell of the SDD target architecture

## Scope

The slice intentionally touched only:

- live core surfaces
- executive/summary references
- agent metadata
- initial target-architecture shell directories

It intentionally did not try to rewrite:

- bootstrap provenance docs
- the full imported `references/codex-agents/` doctrine
- the complete current-default Linear-shaped backend material

## Files Hardened

- `SKILL.md`
- `README.md`
- `agents/openai.yaml`
- `docs/architecture/accelerate-control-plane.md`
- `references/issue-stack.md`
- `references/workflow-catalog.md`
- `references/executive-operating-matrix.md`
- `references/team-operating-model.md`
- `references/persona-mandatory-skills-matrix.md`
- `references/executive-persona-matrix.md`
- `references/persona-model.md`

## Structure Materialized

The following target-architecture shells now exist:

- `core/`
- `adapters/`
- `profiles/`
- `agents/`
- `onboarding/`
- `overlays/`

These shells are intentionally lightweight and point back to the currently
authoritative imported doctrine until each layer is rehomed properly.

## What This Slice Completed

- the root product no longer identifies itself as a Prop4You-only workflow
- the core/summaries now speak in terms of an `active workflow adapter`
- the repo now has concrete directories for the future layered architecture
- the standalone repo is easier for a fresh session to read as a platform, not
  just as a copied skill tree

## What Still Remains

- fully rehome the imported doctrine from `references/` into the new layered
  directories
- define the first dedicated workflow adapter docs for `linear` and `github`
- turn onboarding from architecture model into operational surface
- re-express project-specific residue as explicit overlays
- evolve `references/codex-agents/` into the standalone native `agent-factory`

## Next Recommended Slice

The next high-ROI slice is:

1. workflow adapter normalization
2. first native onboarding surface
3. first rehoming of control-plane doctrine from `references/` into `core/`
