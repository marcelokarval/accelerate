# Workflow Catalog Post-Correction Rerun Result

## Purpose

This artifact records the post-correction benchmark cycle for the `workflow
catalog` surface.

It preserves the comparison outcome after the local catalog absorbed the
benchmark rerun / result-registration lane.

## Benchmark Packet

- surface: `workflow catalog`
- local authority:
  - `core/workflows/catalog.md`
  - `core/control-plane/quick-invocation-map.md`
  - `core/control-plane/parity-replacement-gate.md`
- legacy comparison surface:
  - global/runtime `accelerate` workflow-selection behavior
- objective:
  - prove whether the local catalog now selects the correct workflow family for
    benchmark rerun and durable result registration
- comparison axes:
  - benchmark lane selection
  - distinction between standard comparative evidence and lighter synthetic
    evidence
  - issue/bootstrap or explicit no-backend posture for durable registration
  - planning-artifact requirement for non-trivial durable mutation
  - docs-sync and forensic-closure requirements
  - promotion discipline under `parity-replacement-gate`
- evidence strength:
  - mixed
  - strong enough to prove the local written routing correction
  - not yet strong enough to promote behavioral parity

## Issue And Planning Posture

This registration mutates durable executive artifacts.

The repository is still in the standalone pre-agents / pre-adapter phase, so
there is no implemented workflow backend to create a real governing issue in
this repository.

Current posture:

- `Issue-Bootstrap`: explicit `pre-adapter/no-backend` exception
- planning substitute:
  - this artifact
  - `workflow-catalog-parity-decision.md`
  - `near-parity-promotion-queue.md`
- closure gate:
  - no promotion claim unless the evidence packet satisfies
    `core/control-plane/parity-replacement-gate.md`

## Runs

### 1. Standard Local Vs Legacy Comparison

Local run:

- selected benchmark result registration for the target surface
- distinguished living-doc registration from read-only benchmarking
- still under-called some legacy-sharp composition before correction:
  - weaker tie to `Parallel-Discovery` / `Governed Multi-Subagent`
  - weaker tie to `Planning-Artifact`
  - weaker explicit distinction between standard side-by-side evidence and
    synthetic rerun evidence

Legacy run:

- selected `Entry-Shaping`
- selected `Governance-Audit`
- selected `Parallel-Discovery` when independent local / legacy outputs are
  part of the benchmark
- required `Issue-Bootstrap` for durable living-doc registration
- required planning artifact discipline for non-trivial registration
- distinguished standard comparative benchmark evidence from weaker synthetic
  reruns

Result:

- legacy still exposed a sharper behavioral edge
- local needed another catalog correction before promotion could be considered

### 2. Local Explicit Post-Correction Rerun

After patching `core/workflows/catalog.md`, the local rerun selected:

- `Benchmark-Rerun / Result-Registration`
- `Governance-Audit`
- `Parallel-Discovery` or `Governed Multi-Subagent` for independent local /
  legacy outputs
- `Docs-Sync`
- `Forensic-Closure`
- `Issue-Bootstrap` or explicit `pre-adapter/no-backend` exception for durable
  registration
- `Planning-Artifact` for non-trivial durable registration unless a documented
  substitute applies

Result:

- the written local route now matches the missing legacy-sharp composition
- promotion was still blocked because the run was read-only and did not itself
  execute a full durable side-by-side registration cycle

### 3. Local Light Post-Correction Rerun

A less over-steered local prompt still classified the request as:

- `orchestrated non-trivial work`
- `benchmark rerun / result registration`
- `architecture / governance doubt`

It required:

- `Entry-Shaping`
- `Prompt-Hardening`
- `Governance-Audit`
- `Benchmark-Rerun / Result-Registration`
- `Parallel-Discovery` or `Governed Multi-Subagent` for standard comparative
  outputs
- `Docs-Sync`
- `Issue-Bootstrap` plus `Planning-Artifact`, or an explicit
  `pre-adapter/no-backend` exception
- `Forensic-Closure`

It also blocked promotion because the parity decision still needs repeated
post-correction proof.

Result:

- the local route now behaves correctly under a lighter prompt
- the promotion gate correctly refused to overstate a single correction cycle

### 4. Full Comparative Post-Correction Rerun

A later full comparative rerun used independent local and legacy/global outputs
for the same durable-registration scenario.

The result is preserved in:

- `workflow-catalog-full-comparative-rerun-result.md`

Local and legacy/global outputs converged on:

- non-trivial benchmark / governance classification
- prompt hardening or entry shaping before execution
- governance audit
- parallel side-by-side evidence for standard comparative proof
- issue/bootstrap posture or explicit `pre-adapter/no-backend` exception
- planning-artifact discipline for durable registration
- docs-sync / durable executive registration
- forensic closure
- conservative no-promotion verdict

Result:

- no new local doctrine gap was found
- the surface remains `near parity`
- the residual gap narrowed to repeated behavioral proof for promotion, not
  missing structure or a known lane omission

## Side-By-Side Finding

What the legacy did better before correction:

- coerced durable benchmark registration into issue/bootstrap and planning
  posture more sharply
- treated local-vs-legacy benchmark outputs as independent evidence requiring
  parallel / governed synthesis
- avoided treating synthetic reruns as promotion-grade proof

What the local now does correctly:

- names benchmark rerun / result registration as a first-class branch and
  workflow lane
- requires explicit standard-vs-weaker evidence classification
- ties durable registration to docs-sync and forensic closure
- ties mutating durable registration to issue/bootstrap or the current
  no-backend exception
- refuses promotion when the evidence is only a routing correction rather than
  repeated behavioral proof

## Verdict

- previous verdict: `near parity`
- current verdict: `near parity`

Reason:

- the concrete catalog defect was corrected
- two post-correction local reruns selected the expected lane family
- one later full local-vs-legacy comparative rerun aligned on the same required
  lane family and the same conservative no-promotion verdict
- the evidence is still not repeated enough to claim legacy-grade behavioral
  coercion under live or promotion-grade durable benchmark registration

## Residual Gap

The remaining gap is behavioral repeatability, not missing local structure.

The next promotion attempt must show one additional promotion-targeted or live
non-synthetic cycle where:

- local and legacy outputs are independently preserved or durably summarized
- the local route selects benchmark registration without over-steering
- the local route keeps issue/bootstrap or the no-backend exception visible
- the local route keeps planning, docs-sync, and forensic closure visible
- the parity decision updates from evidence rather than from document presence

## AI Review Report

Requested vs implemented:

- requested: continue the local-vs-legacy benchmark loop and correct detected
  divergence
- implemented: detected a remaining workflow-catalog under-call, corrected the
  local catalog, and reran explicit plus light local checks

Promised vs delivered:

- promised: compare legacy and local and preserve the result in durable docs
- delivered: durable evidence packet and updated executive decision artifacts

Issue / plan vs landing:

- no external issue exists because this repo is still pre-adapter/no-backend
- the exception is explicit in this artifact
- the landing stays within the active executive parity-convergence plan

Residual risk:

- promotion still depends on repeated real comparative runs, not on this
  document-only correction cycle
