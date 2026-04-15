# Operational Calibration

Use this module when the main question is how much process, evidence, or
structure is proportional to the slice.

## Cost-Of-Orchestration And Effort Budgeting

Estimate the coordination burden before loading the full stack.

Ask:

- how much ceremony is justified here?
- is PRD-lite necessary or excessive?
- would persona switching add clarity or only narration?
- would a subagent save time or create review drag?

Prefer the smallest valid process that still protects correctness.

## Branch-Specific Exit Criteria

Each branch closes on different proof:

- implementation branch -> code, tests, and contract correctness
- visual branch -> runtime evidence and fidelity judgment
- product-critical surface branch -> backend truth completeness, wireframe or
  visual contract fidelity, runtime behavior, and product-quality judgment
- governance branch -> clear decision and evidence trail
- hygiene branch -> repo state and policy alignment
- spec branch -> bounded execution-ready definition

Do not use generic "looks done" closure language.

## Runtime Evidence Normalization

Be explicit about what evidence counts for each branch.

Examples:

- browser truth for runtime and product behavior
- tests for deterministic logic
- code and contract inspection for integration boundaries
- issue and artifact comparison for scoped delivery

Use the strongest relevant evidence, not the most convenient one.

## Artifact Discipline

Put the artifact in the right place:

- issue comment for execution and review history
- planning file for active bounded planning
- doc viva for durable project behavior
- napkin for recurring heuristics only
- local transient notes for disposable exploration

Do not let durable guidance hide in ephemeral artifacts.

## Failure Mode Catalog

Watch for:

- over-orchestration
- premature implementation
- false closure
- delegated theater
- truth drift
- doc drift
- browser-free narrative confidence
- technical-repair-presented-as-product-solution
- card-soup
- reference-as-moodboard
- private-hub-leakage
- fake-brand-drift
- backend-truth-too-thin-for-ui
- frontend-safe-but-amateur
- cta-dilution
- flat-hierarchy
- premium-surface-treated-as-safe-ui
- design-system-as-component-bin
- implementation-first-on-premium-surface
- visually-correct-spacing-but-no-direction
- severity-softening-language

Name the failure mode when it appears.

### `severity-softening-language`

Use this smell when a hard problem is described as discretionary or low-pressure
even though the correction is not optional.

Typical signals:

- `se quiser`
- `posso fazer`
- `se preferir`
- `talvez valha`
- optional framing for bugs, regressions, security drift, contract drift, or
  enforcement failures

Corrective action:

- restate the problem directly
- state why it passed
- state the next correct step
- state the ROI of fixing it now

## Operational Profiles

Useful profiles:

- `hotfix mode`
- `product feature mode`
- `product-critical surface mode`
- `visual refinement mode`
- `governance audit mode`
- `repo hygiene mode`
- `specification mode`

Profiles are simplifiers. They are not replacements for actual evidence.

## Long-Running Work Management

For multi-session work:

- restate the active phase
- restate the active branch
- restate unresolved blockers
- restate what remains bounded for the current slice

Do not restart discovery from zero when the issue is continuity, not ambiguity.
