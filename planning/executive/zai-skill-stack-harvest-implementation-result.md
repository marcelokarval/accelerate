# Z.ai / GLM Skill Stack Harvest Implementation Result

## Purpose

This artifact records the first implementation pass from the Z.ai / GLM skill
stack harvest into the standalone local `accelerate` architecture.

The intent was to preserve the external platform's operational capability while
translating it into local governance surfaces that can later power bounded
agents through `*.toml` definitions.

## Runtime Packet

- `active branch`: architecture / governance mutation
- `phase`: Plan -> Execute -> Verify
- `issue stack`: pre-adapter / no-backend exception; durable executive artifact
  used as registration
- `workflow lanes`: External-Skill-Vetting, Agent-Browser Runtime,
  Skill-Evaluation-Lab, UI Polishing Observer, Docs-Sync, Forensic-Closure
- `single-threaded exception`: implementation touched tightly coupled doctrine
  surfaces and required root-owned integration judgment; no parallel subagent
  was used

## What Landed

### 1. External Skill Vetting Gate

Native home:

- `core/risk/external-skill-vetting-gate.md`

What it preserves from GLM / Z.ai:

- high-value external skill harvesting
- explicit source inspection
- runtime-power classification
- platform-assumption detection
- reject / sandbox / adapt decisions

Local constraint added:

- external capability is preserved at the correct local layer instead of copied
  as platform-bound doctrine

### 2. Agent-Browser Runtime Adapter Spec

Native home:

- `adapters/runtime/agent-browser/README.md`

What it preserves from GLM / Z.ai:

- high-capability browser automation
- snapshots, screenshots, video, PDF, forms, frames, dialogs, network, JS eval,
  and browser state concepts
- future fit for browser-proof and UI-polishing agents

Local constraint added:

- Chrome DevTools remains discovery truth when flow truth is unstable
- Playwright remains persistent regression proof after scenario stabilization
- browser state access is treated as privileged

### 3. Skill Evaluation Lab

Native home:

- `core/workflows/skill-evaluation-lab.md`

What it preserves from GLM / Z.ai:

- baseline-vs-candidate evaluation
- assertions and rubrics
- blind comparison
- analyst pass
- trigger / no-trigger testing
- promotion decisions based on behavior, not taste

Local constraint added:

- workflow-change approval remains required when the lab result would mutate
  control-plane truth

### 4. UI Polishing Observer

Native home:

- `core/review/ui-polishing-observer.md`

What it preserves from GLM / Z.ai:

- active UI polish loops
- cross-component audit
- visual consistency hunting
- responsive, z-index, navigation, state, and token checks
- future scheduled observer fit

Local constraint added:

- observation is not mutation
- findings need severity classification and issue/executive registration
- premium/product-critical framing still owns product direction

## Connected Surfaces

Updated discovery and routing surfaces:

- `core/risk/README.md`
- `adapters/runtime/README.md`
- `core/workflows/README.md`
- `core/review/README.md`
- `core/workflows/catalog.md`
- `core/control-plane/quick-invocation-map.md`
- `core/runtime-packets/qa-proof-stack.md`
- `core/workflows/self-evolution.md`

## Capability Translation

The local result intentionally does not reduce the GLM capability.

Instead it maps it:

| GLM / Z.ai capability | Local `accelerate` landing |
| --- | --- |
| external skill marketplace / platform skills | external skill vetting gate |
| `agent-browser` browser action power | runtime adapter spec |
| scheduled polishing agents | UI polishing observer lane |
| skill creator eval loop | skill evaluation lab |
| trigger tuning / no-trigger tests | skill evaluation lab trigger tests |
| comparator / analyzer agents | future bounded eval agent roles |
| broad platform stack defaults | stack-profile / pattern-only decision, not root law |

## Current Verdict

This improves `autoresearch / self-evolution` from passive durable capture into
an implementable learning loop.

Recommended status:

- `autoresearch / self-evolution`: `near parity`, with implementation evidence
  now active

Why not promote yet:

- the new gates and lanes are documented and discoverable
- they have not yet been exercised in a second independent harvest, benchmark,
  or agent-backed run
- future `*.toml` agent recipes do not exist yet

## Next Validation

Run one bounded follow-up cycle using the new surfaces:

1. Vet another external skill or adapter through
   `core/risk/external-skill-vetting-gate.md`.
2. Produce a candidate local insertion decision.
3. Use `core/workflows/skill-evaluation-lab.md` to compare baseline vs
   candidate behavior.
4. If browser/UI-related, route through `adapters/runtime/agent-browser/` and
   `core/review/ui-polishing-observer.md`.
5. Register result and rerun the self-evolution parity judgment.

Promotion to `local at parity` should require that second behavioral proof.
