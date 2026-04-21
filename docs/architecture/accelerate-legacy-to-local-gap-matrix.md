# Accelerate Legacy-To-Local Gap Matrix

## Purpose

This document tracks the remaining methodological gaps between the governed
legacy/global `accelerate` runtime and the standalone local repository.

It exists to stop two bad outcomes:

- claiming parity too early because the local platform already looks cleaner
- preserving the legacy indefinitely because the remaining gaps were never made
  explicit

The active executive handoff for this convergence track lives in:

- `planning/executive/legacy-to-local-benchmark-convergence-plan.md`
- `planning/executive/legacy-vs-local-harvest-plan.md`
- `planning/executive/legacy-benchmark-battery-harvest-matrix.md`
- `planning/executive/zai-skill-stack-harvest-analysis.md`
- `planning/executive/zai-skill-stack-harvest-implementation-result.md`
- `planning/executive/zai-skill-stack-post-implementation-benchmark-result.md`
- `planning/executive/web-reader-external-skill-replay-result.md`
- `planning/executive/self-evolution-web-reader-replay-parity-result.md`
- `planning/executive/maturity-control-post-self-evolution-rerun-result.md`
- `planning/executive/subagent-model-scenario-benchmark-result.md`
- `planning/executive/maturity-control-post-subagent-rerun-result.md`
- `planning/executive/maturity-control-loop-stop-agent-factory-transition-result.md`
- `planning/executive/maturity-control-final-promotion-result.md`
- `docs/architecture/accelerate-comparative-benchmark-persisted-modeling-battery.md`
- `docs/architecture/accelerate-comparative-benchmark-persisted-modeling-model-comparison.md`

## Replacement Rule

The local platform should only replace the legacy as the primary operational
distribution when it is **superior or equal in operational value**, ignoring the
future-agent layer.

The comparison should not ask only whether the local repo has better structure.
It must ask whether the local repo can already execute the same engineering
method with equal or better quality.

## Comparison Axes

The gap hunt should classify each surface as:

- `native`
  - local has a first-class native surface
- `reference-backed`
  - local still depends mainly on `references/`
- `breach`
  - legacy still has a material operational advantage

## Current Matrix

| Surface | Legacy/global status | Local status | Verdict | Why it still matters |
| --- | --- | --- | --- | --- |
| root control plane | strong | native | local at parity | root law is already local and usable |
| prompt hardening | strong | native | local at parity | gate is already native |
| issue topology | strong | native | local at parity | topology laws already exist locally |
| risk enforcement | strong | native | local at parity | risk matrix already exists locally |
| closure authority | strong | native | local at parity | closure law already exists locally |
| runtime packet schema | strong | native | local ahead | focused schema benchmark showed the local core can now emit all packet shapes without reference fallback and is richer than the inherited reference schema after a small subagent-cadence correction |
| persona activation | strong | native | local at parity | recently rehomed into `core/personas/` |
| review architecture | strong | native | local at parity | recently rehomed into `core/review/` |
| persisted-modeling review | implicit but strong in practice | native | local ahead | bounded benchmark rerun after the defect-bias harvest showed the local winning this class on both method and directly actionable defect capture |
| current enforcement surfaces | strong | native | local ahead | the original billing/self-service benchmark plus the later upload/import rerun both showed the local side applying the harvested enforcement clauses more explicitly across different trust-sensitive categories |
| issue stack | strong | native | local ahead | rerun after native hardening showed the local side keeping the benchmark slice itself in calibration mode while expressing the shaping-first mutation order more cleanly than the legacy/reference-backed path |
| QA / proof stack | strong | native | local ahead | the 360 rerun after local hardening showed the local side naming proof-order failures more explicitly, exposing lane-state closure blocking directly, and escalating `high` runs to `product-critical user surface`; legacy remained strong but the cleanest strongest signal favored the hardened local |
| subagent model | strong | native | local at parity | initial focused benchmark exposed a real local gap in concrete family routing and provider-boundary future-gap semantics; after adding fit scoring, no-honest-family handling, scenario routing, and role-specific return expectations, both post-correction local and legacy/global judges promoted bounded delegation governance to parity while excluding provider-boundary ownership, scheduled observers, future `*.toml` agents, and `local ahead` |
| branch enforcement matrix | strong | native | local ahead | focused branch-enforcement benchmark showed the local side matching legacy harshness on issue/planning/validation blockers while applying the richer native cross-surface gate set more precisely |
| workflow catalog | strong | native | local at parity | focused retest exposed and corrected a real under-call around benchmark result registration; explicit/light reruns, a full independent local-vs-legacy rerun, and a promotion-targeted legacy/global judge now show no material remaining operational deficit |
| operational calibration | strong | native | local at parity | rerun after native hardening showed the local side choosing the same smallest valid bounded process as legacy while doing so from cleaner native authority and without reopening the old ceremony-inflation failure mode |
| autoresearch / self-evolution | strong | native | local at parity | the Z.ai / GLM harvest created the first external workflow-learning capture, the local implementation landed the missing vetting/evaluation surfaces, and the independent `web-reader` replay plus local and legacy/global judges now show no meaningful operational deficit for document-backed external workflow learning |
| external skill harvest / GLM capability translation | implicit / inferable | native | local ahead | post-implementation benchmark showed the legacy can infer this through generic governance, agent pooling, browser proof, and premium UI doctrine, but the local now has first-class external skill vetting, `agent-browser`, skill-evaluation lab, and UI polishing observer surfaces |
| maturity control | strong | native | local at parity | final promotion arbitration after two direct behavior cycles promoted bounded parity: the local stopped low-value promotion pressure, redirected work to real structural surfaces, corrected the smallest owning home, avoided maturity-control doctrine bloat, and kept `local ahead`, live agent runtime, provider-boundary ownership, scheduled observers, and future `*.toml` claims out of scope |
| workflow-change approval gate | strong | native | local at parity | focused retest showed both local and reference-backed paths block workflow-doctrine mutation without explicit HITL approval for the exact change |
| parity / replacement gate | implicit but effective | native | local at parity | focused rerun showed the explicit local gate now matches legacy effective behavior by promoting evidence-backed surfaces and blocking wording-led, transient, or behavior-thin claims; remaining risk is future-session monitoring, not a replacement blocker |
| benchmark run versioning | implicit memory in practice | native | local ahead | native benchmark artifacts now preserve run evolution, model-comparison policy, and correction-to-result traceability durably |
| product-critical surface discipline | strong | native | local ahead | the auth-recovery rerun already cleared parity, and the later onboarding-critical visual/composition rerun showed the local side producing the sharper product-critical closure judgment with stronger native failure-mode naming and cleaner branch focus |
| premium interface discipline | strong | native | local ahead | the premium billing recovery / upgrade rerun showed both sides blocking closure, but the local side used the sharper premium failure-mode vocabulary and kept the benchmark focused on the real premium blockers rather than inflating unrelated process weight |
| quick invocation / operating map | strong | native | local at parity | native quick invocation map now exists |

## Native Landings

### 1. Enforcement Inventory

Closed by:

- `core/control-plane/branch-enforcement-matrix.md`
- `core/risk/enforcement-surfaces.md`

### 2. Proof Stack

Closed by:

- `core/runtime-packets/qa-proof-stack.md`

### 3. Delegation Governance

Closed by:

- `core/delegation/subagent-model.md`

### 4. Workflow Map

Closed by:

- `core/workflows/catalog.md`
- `core/control-plane/quick-invocation-map.md`

### 5. Calibration And Self-Evolution

Closed by:

- `core/workflows/operational-calibration.md`
- `core/workflows/self-evolution.md`
- `core/workflows/maturity-control.md`
- `core/control-plane/workflow-change-approval-gate.md`

### 6. Product-Critical Branch

Closed by:

- `core/review/product-critical-surfaces.md`
- `core/review/premium-interface-production.md`

## Status

The phase-11 breach set is now natively implemented, and the remaining
workflow-governance harvest has been brought over almost wholesale. Comparative
retesting is still running.

Landing a native surface is not the same thing as proving parity. Recent
benchmark and document-comparison work showed that workflow-governance surfaces
were still too compressed after their first local landing, which is why the
native block was rewritten side by side against the legacy references.

The reference layer has now also been rationalized explicitly:

- `references/README.md` names which files are native-backed and supporting
  only
- high-traffic duplicated reference files now carry local-authority banners

That cleanup reduced authority confusion without reopening a behavioral gap in
the premium rerun that followed it.

Inherited `references/` modules remain readable as supporting doctrine and
comparison material, not as the primary authority for the surfaces above.

## Acceptance Rule

A breach is only considered closed when:

1. a native local surface exists
2. `SKILL.md`, `README.md`, or the relevant core/adapter layer point to it as
   primary authority
3. the local surface is at least as operationally useful as the legacy one for
   real runs
4. the remaining inherited reference is supporting doctrine, not the primary
   method

## Anti-Illusion Rule

Do not mark parity because:

- the local repo is cleaner
- the local repo has better directory architecture
- the local repo has partial shells or README placeholders

Parity means the local platform can already execute the method with equal or
better practical quality.
