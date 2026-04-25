# Executive Planning

Executive planning is the bridge between control-plane judgment and bounded
execution.

Use this sublayer for plans that answer:

- what should happen next
- in what order
- under which constraints
- with which active adapters, profiles, or proof lanes

## Current Stage

In the `standalone pre-agents` phase, executive planning is already mandatory
for onboarding outputs and for non-trivial work that cannot honestly proceed
from discovery straight into mutation.

## Canonical Artifact

The canonical bootstrap template is:

- `bootstrap-plan-template.md`

Use that template when a session must leave a durable executive handoff.

## Active Planning Surfaces

The current active planning surfaces are repo-local and should not depend on
legacy/global runtime material as authority.

Active design-system and premium-surface planning:

- `html-design-system-premium-pipeline-plan.md`
- `html-design-system-premium-enforcement-regression.md`

Active review/correction hardening handoff:

- `../../docs/architecture/accelerate-active-review-and-correction-gap-analysis.md`
- `../../docs/architecture/accelerate-active-review-and-correction-proposal.md`
- `active-review-and-correction-executive-plan.md`

Active standalone hardening plan:

- `standalone-hardening-executive-plan.md`
- `standalone-hardening-execution-ledger.md`

Active stack-profile planning:

- `nextjs-adonis-adminjs-profile-plan.md`

Active planning templates and sublayers:

- `../product/`
- `../architecture/`
- `../execution/`
- `../migration/`
- `../onboarding/`
- `../promotion/`

## Historical Evidence

Earlier parity, harvest, rerun, and legacy/global comparison packets remain in
this directory as evidence of how the standalone repo converged.

They are not current authority when they conflict with:

- `AGENTS.md`
- `README.md`
- `SKILL.md`
- `core/`
- `skills/`
- `planning/README.md`

Use `archive/README.md` as the index for historical evidence categories.

## External Skill Replays

External skill replay documents are provenance unless a later change imports and
adapts the capability into this repository.

The `web-reader` replay has been resolved as a `pattern-only` adaptation:
Accelerate now owns the local `web-content-reader` runtime skill, the
`web-content-reader` adapter contract, and the `source-observer` review surface.
The external Z.ai/GLM implementation remains non-authoritative.

## Operating Rule

Executive plans may cite historical evidence, but they must not make an external
path or user-home runtime mirror a governed dependency. If a plan needs a
capability from outside the repository, the next implementation slice must first
import, adapt, register, and enforce it locally.
