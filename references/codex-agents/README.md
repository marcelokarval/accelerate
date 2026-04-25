# Codex Agents Module

Use this module when the question is not merely "should we use subagents?" but
"what governed agent ecosystem should `accelerate` own for Prop4You?"

This module belongs to `accelerate`.

It is not a parallel architecture and it is not a free-floating docs bundle.

Its job is to give the root control plane explicit intelligence for:

- agent ontology
- macro control-plane mapping
- manager lanes and authority boundaries
- issue topology and staffing rules
- empirical replay against real stack scenarios
- agent pooling and fit scoring
- risk enforcement and active detection
- gap detection
- skill-envelope assignment
- sandbox-to-runtime promotion for global Codex agents

## Canonical Scope

Read this module when the work involves one or more of:

- designing global Codex agents for `~/.codex/agents/*.toml`
- deciding whether a role should be master-owned or delegate-possible
- mapping `accelerate` personas/workflows into stable agent families
- deciding which skills a family should carry
- deciding whether the current pool has a real gap

This module does not replace:

- `docs/architecture/accelerate-control-plane.md`
- `frontends/docusaurus/docs/ai/accelerate-based-codex-agents.md`
- the root `accelerate` skill body

Those remain the public and canonical explanations of the control plane.

This module is the governed runtime-facing design layer owned by `accelerate`.

## Reading Order

Read in this order:

1. `agent-ontology.md`
2. `agent-capability-matrix.md`
3. `control-plane-org-map.md`
4. `manager-lane-map.md`
5. `lane-governance-model.md`
6. `root-vs-agent-authority-boundary.md`
7. `issue-topology-policy.md`
8. `agent-execution-contract.md`
9. `staffing-and-decomposition-policy.md`
10. `risk-enforcement-model.md`
11. `risk-enforcement-matrix.md`
12. `active-risk-detection-signals.md`
13. `closure-blockers-and-escalation.md`
14. `return-and-escalation-contracts.md`
15. `agent-empirical-replay.md`
16. `agent-pooling-model.md`
17. `agent-selection-policy.md`
18. `agent-gap-detection.md`
19. `agent-skill-envelopes.md`
20. future modules:
   - `agent-sync-protocol.md`

## Core Rule

`accelerate` remains the root orchestrator.

The global agents derived here are subordinate execution units, not a
replacement for the control plane.

The intended shape is:

```text
User request
-> accelerate classifies
-> accelerate chooses issue topology and lane openings
-> accelerate selects the minimum valid branch and skill stack
-> accelerate decides staffing and delegation budget
-> accelerate decides whether the current agent pool has a fit
-> bounded global agent executes or audits the slice
-> accelerate revalidates and closes
```

## Runtime Target

Runtime agent exports are optional deployment artifacts generated from
repo-owned agent definitions when export is in scope.

The repo sandbox remains the authoring source of truth.

Do not treat any user-home runtime export as the authoring surface for governed
Accelerate agents.

## Replay Rule

Do not treat this module as donor-driven theory only.

When family boundaries, fit rules, or gap promotion are in doubt, validate them
against `agent-empirical-replay.md` before widening a family or proposing a new
one.
