# Z.ai / GLM Skill Stack Post-Implementation Benchmark Result

## Purpose

This artifact records the first local-vs-legacy benchmark after landing the
Z.ai / GLM harvest implementation surfaces.

It tests whether the local standalone `accelerate` now handles the external
skill-stack stimulus better than the legacy/global runtime.

## Runtime Posture

- repository phase: standalone pre-agents
- workflow backend: pre-adapter / no-backend
- issue stack posture: approved no-backend executive-artifact exception
- proof lane: read-only benchmark judges plus durable executive registration
- model / effort:
  - `gpt-5.4`
  - `high`
- benchmark prompts:
  - local judge: `/tmp/accelerate-local-zai-benchmark.md`
  - legacy judge: `/tmp/accelerate-legacy-zai-benchmark.md`
- judge outputs:
  - local judge: `/tmp/accelerate-local-zai-benchmark.out`
  - legacy judge: `/tmp/accelerate-legacy-zai-benchmark.out`

## Scenario

The external stimulus was a GLM / Z.ai skill stack containing:

- `agent-browser`
- skill creation / eval / comparator / analyzer patterns
- skill vetting
- active browser polishing agents, potentially scheduled every 15 minutes

The user requirement was to preserve the external platform's extreme operational
capability for future `*.toml` agents without blindly copying GLM platform
assumptions.

## Judge Results

| Judge | Verdict | Reason |
| --- | --- | --- |
| local standalone judge | `near parity` | the local has the right native surfaces, but they still need a second independent harvest or benchmark before promoting `autoresearch / self-evolution` |
| legacy/global judge | `local ahead` | the legacy has strong control-plane instincts, but lacks first-class workflows for external skill vetting, skill eval labs, `agent-browser`, and scheduled UI polishing observers |

## Root Arbitration

The two results are not contradictory. They judged different effective
questions:

- the local judge answered the broader self-evolution promotion question
- the legacy judge answered the specific new-capability comparison question

Arbitrated verdicts:

- `external skill harvest / GLM capability translation`: `local ahead`
- `autoresearch / self-evolution` as a whole: `near parity`

## What Local Now Does Better Than Legacy

The local standalone repo now has explicit first-class surfaces for:

- external skill / adapter / agent recipe vetting
- `agent-browser` runtime adapter posture
- skill and workflow evaluation lab behavior
- trigger / no-trigger evaluation
- blind comparison and analyst pass
- UI polishing observer lane
- scheduled observer guardrails
- future bounded agent role mapping for these surfaces

The legacy/global runtime can infer several of these from generic governance,
agent pooling, browser proof, premium UI, and autoresearch doctrine. It does not
name them as first-class workflows in the benchmarked authority set.

## What Legacy Still Does Well

The legacy/global runtime remains strong on:

- root orchestration authority
- future `~/.codex/agents/*.toml` optionality
- bounded agent pooling
- gap detection
- Chrome DevTools before Playwright proof ordering
- product-critical and premium interface discipline
- avoiding weak generic external donor roles

Those strengths are now preserved locally and extended by the new native
surfaces.

## Why Self-Evolution Is Not Promoted Yet

`autoresearch / self-evolution` remains `near parity` because the new surfaces
have been implemented but not yet exercised in a second independent behavioral
cycle.

Promotion still needs a run that proves the loop itself:

```text
external artifact
  -> external skill vetting gate
  -> insertion decision
  -> skill evaluation lab
  -> durable result
  -> rerun-backed self-evolution judgment
```

## Decision

Promote the specific GLM-harvest capability comparison to:

- `local ahead`

Do not promote the broader `autoresearch / self-evolution` surface yet.

Current broad surface status:

- `autoresearch / self-evolution`: `near parity`

## Next Test

Use a second independent external artifact as the controlled replay.

The best next candidate should be a skill or adapter not already harvested in
this cycle, then force the local runtime to:

1. vet it through `core/risk/external-skill-vetting-gate.md`
2. classify insertion target
3. compare baseline vs candidate through `core/workflows/skill-evaluation-lab.md`
4. if browser/UI-related, route through `adapters/runtime/agent-browser/` and
   `core/review/ui-polishing-observer.md`
5. register the decision durably
6. rerun the self-evolution parity judgment

If that loop succeeds without manual reconstruction, promotion from
`near parity` to `local at parity` becomes defensible.

## AI Review Report

### Self-Review

The result does not over-promote the whole self-evolution surface. It separates
the new native capability edge from the broader repeated-behavior requirement.

### Self-Forensic Review

Main overclaim risk:

- treating `local ahead` on the specific GLM-harvest capability as proof that
  all self-evolution behavior is now at parity

Mitigation:

- broad surface remains `near parity`
- next proof requires an independent replay through the new lanes
