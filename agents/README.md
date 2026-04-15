# Agent Factory

This directory is the future native home of the standalone `accelerate`
agent-factory.

## Current Stage

This layer already exists in the `standalone pre-agents` phase, but it is not
yet a fully promoted runtime agent system.

That means:

- the platform already has real doctrine for bounded agents
- the control plane already reasons about fit, gaps, and optionality
- the repo does not require promoted `*.toml` agents to operate coherently
- the native `agent-factory` is still being rehomed out of inherited doctrine

The goal is to rehome the currently imported `references/codex-agents/`
doctrine into a first-class module that owns:

- ontology
- capability matrix
- pooling model
- skill envelopes
- promotion criteria
- authority boundary

The first native doctrine rehome now lives under:

- `doctrine/ontology.md`
- `doctrine/capability-matrix.md`
- `doctrine/selection-policy.md`
- `doctrine/gap-detection.md`
- `doctrine/authority-boundary.md`
- `doctrine/pooling-model.md`
- `envelopes/skill-envelopes.md`
- `promotion/execution-contract.md`

The runtime configuration artifact `openai.yaml` remains here because it is
already part of the current surface.

## What Is Already Real

At the current phase, this layer already owns real architectural concerns:

- agent optionality
- suggestion vs promotion distinction
- authority boundary between root and bounded agents
- family/gap reasoning as part of control-plane design
- the future shape of envelopes, templates, and promotion policy

The current system must already be able to say:

- no agent is needed
- no honest family fit exists
- a gap exists but should remain only a suggestion
- the repo should remain root-only for now

## What Is Not Real Yet

This layer must not pretend that it already has:

- a full promoted runtime agent catalog
- required `*.toml` agents
- automatic promotion
- enforced installation workflow
- a finished native rewrite of all imported `codex-agents` doctrine

Pre-agents means the agent-factory is already architecturally meaningful, but
not yet operationally complete as a runtime promotion system.

## Operational Reading Order

For a fresh session trying to understand the agents layer, read in this order:

1. `../AGENTS.md`
2. `../SKILL.md`
3. `README.md`
4. `doctrine/README.md`
5. `doctrine/ontology.md`
6. `doctrine/capability-matrix.md`
7. `doctrine/selection-policy.md`
8. `doctrine/gap-detection.md`
9. `promotion/README.md`
10. `promotion/execution-contract.md`
11. `envelopes/README.md`
12. `envelopes/skill-envelopes.md`
13. `templates/README.md`

If deeper doctrine is needed before the native rehome is complete, continue
into:

- `../references/codex-agents/README.md`

## Current Output Contract

Even before real runtime promotion exists, this layer should already leave
clear truth for later sessions:

- whether the run is root-only or agent-eligible
- whether a family fit is honest or weak
- whether a gap was merely detected
- whether a future agent should be suggested
- whether promotion is still out of scope

That output truth matters now, even before `*.toml` becomes a normal runtime
surface.

When a deeper path from gap detection to future promotion is needed, continue
into:

- `../planning/promotion/README.md`
