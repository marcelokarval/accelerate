# Operational Calibration

Use this module when the main question is how much process, evidence, or
structure is proportional to the slice.

## Purpose

Calibration exists to prevent two opposite errors:

- loading a workflow that is heavier than the work deserves
- under-loading a workflow and then pretending weak proof was enough

## Cost-Of-Orchestration And Effort Budgeting

Estimate the coordination burden before loading the full stack.

Ask:

- how much ceremony is justified here?
- is PRD-lite necessary or excessive?
- would persona switching add clarity or only narration?
- would a subagent save time or create review drag?

Prefer the smallest valid process that still protects correctness.

## Calibration-Only And Pre-Analysis Slices

Some runs are about choosing process, not performing the real work yet.

Typical cases:

- branch-selection questions
- parity or benchmark calibration passes
- pre-analysis shaping runs
- issue-stack or proof-stack audits where mutation is explicitly out of scope

In those cases:

- prefer a bounded calibration packet over a heavier execution packet
- do not front-load personas, subagents, or governance stacks that the slice is
  only evaluating
- keep the run focused on:
  - branch choice
  - gate choice
  - scope choice
  - proof choice

If the slice is read-only and explicitly forbids real execution, do not promote
it into a heavier branch just because the eventual domain is architecture- or
governance-sensitive.

The branch should match the current slice, not the maximum seriousness of the
domain family in the abstract.

## Smallest Valid Process Rule

Use this order when deciding whether the runtime is loading too much process:

1. Can the question be answered by calibration alone?
2. If yes, emit a bounded calibration packet and stop there.
3. Only escalate to execution-oriented branching if the current slice truly
   needs:
   - mutation
   - live planning
   - proof production
   - runtime validation

Signals of unnecessary escalation:

- loading issue, planning, or proof lanes on a read-only calibration slice
- loading architecture or governance personas before the slice proves they add
  decision value
- using `non-trivial` because the family is important, rather than because the
  current slice is operationally heavy

## Branch-Specific Exit Criteria

Each branch closes on different proof:

- implementation branch -> code, tests, and contract correctness
- visual branch -> runtime evidence and fidelity judgment
- product-critical surface branch -> backend truth completeness, wireframe or
  visual contract fidelity, runtime behavior, and product-quality judgment
- governance branch -> clear decision and evidence trail
- hygiene branch -> repo state and policy alignment
- spec branch -> bounded execution-ready definition

Do not use generic `looks done` closure language.

## Runtime Evidence Normalization

Be explicit about what evidence counts for each branch.

Examples:

- browser truth for runtime and product behavior
- tests for deterministic logic
- code and contract inspection for integration boundaries
- issue and artifact comparison for scoped delivery

Use the strongest relevant evidence, not the most convenient one.

For calibration-only slices, the strongest relevant evidence is often:

- the request shape itself
- the gate ledger implied by the request
- the current branch family under test

Do not demand execution proof when the slice is intentionally proving branch
selection rather than implementation truth.

## Scope Calibration

When a requested target is absent literally, do not default blindly to either:

- maximal reinterpretation
- overly narrow literalism

Calibrate scope by asking:

- what was the likely user intent?
- what semantically adjacent target actually exists?
- would a stricter scope preserve correctness but reduce usefulness too much?
- would a broader recovery answer the real request without inventing structures?

Name the scope move explicitly:

- `strict literal scope`
- `semantic scope recovery`
- `dual scope`

Prefer `dual scope` when usefulness and correctness pull in different
directions:

- the literal target still contains a real seam the user pointed at
- the adjacent recovered target is where the fuller business or domain truth
  actually lives

In those cases, using only comparator language is usually too weak. Treat the
adjacent surface as part of the review, not just context.

## Artifact Discipline

Put the artifact in the right place:

- issue comment for execution and review history
- planning file for active bounded planning
- living doc for durable project behavior
- napkin for recurring heuristics only
- transient notes for disposable exploration

Do not let durable guidance hide in ephemeral artifacts.

For benchmark, rerun, or arbitration evidence that affects parity, promotion,
workflow truth, or closure, transient storage is only a staging area. Preserve
the decision-relevant evidence in an executive or architecture artifact before
closing the calibration slice.

When a governed target repository carries `.accelerate/` local status, also
make the readiness impact, current checkpoint, and durable learning
registration posture visible before closing the calibration slice.

## Failure Mode Catalog

Watch for:

- over-orchestration
- premature implementation
- false closure
- delegated theater
- truth drift
- doc drift
- over-literal re-scope
- over-broad semantic recovery
- browser-free narrative confidence
- technical-repair-presented-as-product-solution
- card-soup
- reference-as-moodboard
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
