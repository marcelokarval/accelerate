# Design-System Contract Application Implementation Result

## Executive Summary

This slice adds the missing downstream lane after HTML design-system extraction:
using the generated `docs/reference/design-system*` package as implementation
law for UI implementation, correction, improvement, proposal, recomposition, and
theme generation.

The extraction pipeline already knew how to create source-truth and premium
direction artifacts. The gap was that later agents could still treat those
artifacts as inspiration or screenshots instead of a binding contract.

## Decision

Create a separate governed skill and native Accelerate review module:

- skill: `apply-design-system-contract`
- native module: `core/review/design-system-contract-application.md`

Do not overload `extract-html-design-system-v2` with implementation behavior.
Extraction creates the evidence package. Application consumes it.

## New Operating Rule

When `docs/reference/design-system*` artifacts already exist and the user asks
to implement, correct, improve, propose, premiumize, or generate UI from them,
Accelerate must route through the Design-System Application / Recomposition
workflow.

The workflow requires:

- contract-first reading
- source showcase inspection
- premium artifact inspection when active
- target app component/token/route inventory
- source-observed / code-available / premium-proposed / not-approved-yet map
- component anatomy vs theme token split
- runtime comparison against the design-system artifacts
- residual drift registration

## Surfaces Updated

- `docs/codex-skill-seeds/skills/apply-design-system-contract/SKILL.md`
- `~/.codex/skills/apply-design-system-contract/SKILL.md`
- `docs/codex-skill-seeds/skills/extract-html-design-system-v2/SKILL.md`
- `~/.codex/skills/extract-html-design-system-v2/SKILL.md`
- `core/review/design-system-contract-application.md`
- `core/review/html-design-system-extraction.md`
- `core/review/premium-interface-production.md`
- `core/review/README.md`
- `core/workflows/catalog.md`
- `core/control-plane/quick-invocation-map.md`
- `core/control-plane/branch-enforcement-matrix.md`
- `SKILL.md`
- `docs/architecture/accelerate-pre-agents-baseline.md`
- `planning/executive/html-design-system-premium-pipeline-plan.md`
- `docs/codex-skill-seeds/skills/README.md`

## Validation Expectation

Future UI work should no longer stop at:

- extracted design-system artifacts
- premium direction HTML
- screenshots
- subjective visual assessment

It must carry the artifacts into implementation with explicit mapping and
runtime proof.
