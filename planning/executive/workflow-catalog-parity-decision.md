# Parity Decision: Workflow Catalog

## Purpose

This artifact is the explicit `parity-replacement-gate` packet for the
`workflow catalog` surface.

It exists to separate:

- the fact that the local repo now has a strong native workflow map

from:

- the stronger claim that the local runtime already selects and enforces that
  map as reliably as the legacy/global runtime in repeated live use

## Surface Under Judgment

- local native surface:
  - `core/workflows/catalog.md`
  - `core/control-plane/quick-invocation-map.md`
- legacy comparison surface:
  - legacy/global named workflow ladder and its runtime selection / packet
    coercion behavior

## Why This Surface Matters

This surface governs whether `accelerate` can:

- expose the full named workflow ladder explicitly
- select the right workflow family instead of treating workflows as labels only
- keep required packet / proof shapes visible during execution
- block closure when the active workflow was under-run or only partially
  invoked

It matters because the local repo was not failing here from lack of structure
alone.

It was failing when the workflow map existed on paper but runtime behavior
still compressed the active lane or skipped its expected output shape.

## Native Authority Proof

The local primary authority now lives in:

- `core/workflows/catalog.md`
- `core/control-plane/quick-invocation-map.md`

The scoreboard records this surface as `near parity` in:

- `docs/architecture/accelerate-legacy-to-local-gap-matrix.md`

The executive convergence track governing this slice lives in:

- `planning/executive/legacy-to-local-benchmark-convergence-plan.md`
- `planning/executive/legacy-vs-local-harvest-plan.md`

## Benchmark Or Run Evidence

### Evidence Family

- side-by-side document harvest against the legacy workflow-governance block
- repeated benchmark reruns where workflow choice and packet discipline
  materially affected the result
- current local scoreboard state after the workflow-governance harvest

### Strong Native Evidence

The local now has a real native workflow map, including:

- the full named workflow ladder
- visible ASCII sequencing
- explicit output expectations for named lanes
- a quick operator map that points sessions toward the right deeper modules

This means the local no longer depends on the legacy references as the primary
written source for the workflow catalog itself.

### Limiting Evidence

The current evidence still stops short of `local at parity` because the
remaining deficit is behavioral:

- benchmark reruns showed that workflow-governance strength was initially too
  compressed in the local repo
- the workflow-governance block was harvested and rewritten side by side
  because runtime behavior had not yet fully matched the stronger legacy
  coercion
- the latest catalog benchmark found a concrete local under-call:
  - the local selected governance, performance/observability, docs-sync, and
    forensic closure
  - the legacy/reference-backed run also required issue bootstrap for living-doc
    registration and distinguished standard comparative benchmark evidence from
    lighter synthetic reruns
- the gap matrix still records the residual for `workflow catalog` as:
  - behavioral selection discipline under benchmark reruns

That means the method is now present natively, but the evidence is not yet
strong enough to claim that the local selects and enforces the catalog with no
meaningful practical deficit.

### Latest Correction

The local catalog has now absorbed the concrete missing lane:

- `Benchmark-Rerun / Result-Registration Workflow`

The quick invocation map also lists:

- `benchmark rerun / result registration`

The native selection rule now says that benchmark result registration into
living docs must be paired with:

- `Issue-Bootstrap`
- or an explicit current `pre-adapter/no-backend` exception

Post-correction local rerun result:

- the local now identifies the right written workflow set for this scenario
- a lighter local prompt also selects the corrected lane family and blocks
  promotion without repeated proof
- the local still should not be promoted beyond `near parity` until repeated
  live or benchmarked runs prove that runtime selection follows the corrected
  catalog without over-steering

The post-correction rerun packet is preserved in:

- `workflow-catalog-post-correction-rerun-result.md`

## Residual Gap Statement

Residual gap for this surface:

- the local still needs repeated live proof that named workflows are selected
  and enforced with legacy-grade coercion, especially when runtime updates
  could otherwise collapse into branch labels or under-specified packet shapes

What the legacy still does better:

- it exposed the issue-bootstrap, planning-artifact, parallel-output, and
  benchmark-evidence distinctions before the local catalog correction
- it still has more demonstrated runtime history coercing the active lane
  behaviorally

What the local now does correctly:

- it names benchmark rerun / result registration as a first-class branch and
  workflow lane
- it distinguishes standard comparative evidence from weaker synthetic reruns
- it ties durable result registration to docs-sync and forensic closure
- it requires issue/bootstrap posture or the current explicit
  `pre-adapter/no-backend` exception before durable mutation
- it refuses promotion when the evidence is only a routing correction rather
  than repeated behavioral proof

## Replacement Risk

If this surface is called `local at parity` too early, sessions may:

- cite the native workflow catalog correctly
- but still under-run packet expectations
- or close work after only partial workflow execution

That would create a false sense of maturity:

- the method would look complete in docs
- while runtime selection discipline would still lag the legacy

## Decision Proposal

- verdict: `near parity`

Effect:

- the local native workflow catalog is already the primary written authority
- but it should not yet be treated as behaviorally superior or fully parity-safe
  without more repeated runtime evidence

## Next Correction

Use future comparative runs and real non-trivial sessions to prove:

- active workflow family was named correctly
- expected packet shapes stayed visible
- closure was blocked when the selected workflow was under-run
- benchmark registration does not omit issue/bootstrap posture
- synthetic benchmark evidence is not overstated as standard side-by-side
  comparative proof

Once those signals are repeated without the legacy showing a stronger
selection/coercion edge, this surface can move from `near parity` to
`local at parity`.
