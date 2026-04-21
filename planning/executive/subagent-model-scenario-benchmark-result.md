# Subagent Model Scenario Benchmark Result

## Purpose

Register the focused local-vs-legacy benchmark for `subagent model`.

This benchmark tested whether the standalone local model can make the same
delegation decisions as the mature legacy/global runtime without relying on
undocumented inherited doctrine.

## Runtime Posture

- date: 2026-04-20
- phase: standalone pre-agents
- adapter status: pre-adapter / no-backend
- execution mode: read-only benchmark judges, followed by local doctrine
  correction, followed by focused post-correction rerun
- model: `gpt-5.4`
- effort: `high`
- local judge output: `/tmp/accelerate-subagent-local-benchmark.out`
- legacy/global judge output:
  `/tmp/accelerate-subagent-legacy-benchmark.out`
- post-correction local output:
  `/tmp/accelerate-subagent-post-correction-local.out`
- post-correction legacy/global output:
  `/tmp/accelerate-subagent-post-correction-legacy.out`

## Scenario Battery

The benchmark used five delegation-routing scenarios:

- non-trivial backend/frontend feature with separable mutation and runtime
  proof sidecar value
- governance-only parity benchmark where delegation would duplicate root
  judgment
- auth recovery UI regression needing implementation and trust / anti-abuse
  review
- external provider or source-observer idea where no current family honestly
  owns provider-boundary risk
- three small doc-only corrections where coordination overhead exceeds value

The post-correction rerun used a tighter delegation-heavy battery:

- Django + Inertia auth recovery regression needing backend validation repair,
  React form/runtime correction, trust / anti-abuse review, and browser proof
- provider webhook / source-observer proposal with useful external patterns but
  no implemented provider-boundary family
- benchmark governance rerun needing local-vs-legacy judgment and durable
  registration
- small markdown-only correction touching three independent lines

## Judge Results

| Judge | Verdict | Main finding |
| --- | --- | --- |
| local-authority judge | `keep near parity` | local already handles master authority, spawn/no-spawn, output contract, self-review, self-forensic review, and master integration, but under-specifies concrete role families and no-honest-family handling |
| legacy/global judge | `keep near parity` | local handles ordinary delegation decisions, but legacy/global remains stronger on capability-family routing, pooling semantics, trust/anti-abuse specialization, and provider-boundary future-gap treatment |

## Root Arbitration

Decision:

- promote `subagent model` to `local at parity` for bounded delegation
  governance

Why:

- the first local and legacy/global judges independently rejected promotion
  until the local model gained concrete family-routing and no-honest-family
  behavior
- the correction landed before promotion
- the post-correction local and legacy/global judges independently promoted the
  bounded delegation-governance scope
- the local model already has correct compact delegation law for ordinary
  scenarios
- the prior gap around concrete families, risk fit, and no-honest-family
  behavior now changes the actual scenario decisions

The promotion is intentionally bounded. It does not claim that the local repo
has the full legacy/global agent-family catalog or an implemented future
provider-boundary family.

## Correction Landed

The local doctrine was updated in `core/delegation/subagent-model.md` with:

- trust / anti-abuse reviewer in the safe role catalog
- source or provider-boundary observer candidate as a bounded candidate shape
- fit scoring across surface, phase, risk, write scope, and integration cost
- an explicit no-honest-family rule
- a scenario routing matrix covering the full benchmark battery
- role-specific return expectations for implementation, proof, trust,
  source-observer, and governance sidecars

## Bounded Future Promotion Scope

The justified promotion is:

- `local at parity` for bounded delegation governance

That scope includes:

- spawn/no-spawn decision
- root authority preservation
- role-fit scoring
- sidecar/worker budget
- subagent output contract
- self-review and self-forensic review
- master integration
- explicit root-only exception handling

That scope excludes:

- `local ahead`
- actual future `*.toml` agent promotion
- scheduled source observers
- provider-boundary ownership as an implemented family
- richer family catalog claims beyond what is now locally documented

## Post-Correction Rerun Result

| Judge | Verdict | Main finding |
| --- | --- | --- |
| post-correction local judge | `promote local at parity` | corrected local decisions now route auth recovery to bounded implementation plus trust/runtime review, refuse provider-boundary force-fit, keep benchmark governance root-owned, and avoid spawning for small markdown-only corrections |
| post-correction legacy/global judge | `promote local at parity` | local now captures the legacy strengths that mattered for this battery, while legacy remains richer as an implemented family/pooling catalog |

## Residual Risks

- no live spawned-agent run was executed in this repo
- provider-boundary and source-observer behavior is still a candidate/gap lane,
  not an implemented agent family
- future `*.toml` agent files remain out of scope
- the local still has a smaller concrete family catalog than legacy/global

## AI Review Report

No code was mutated.

The correction is governance/documentation-only and intentionally conservative:
it brings the missing legacy strength into the local model without claiming a
new implemented agent runtime.

The post-correction rerun promoted only the bounded governance surface. That
promotion is not evidence for `local ahead`, future-agent installation, or
provider-boundary runtime ownership.
