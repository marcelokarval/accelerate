# Accelerate Pre-Agents Baseline

## Status

- status: active baseline
- phase: pre-agents
- date: 2026-04-15

## Purpose

This document declares what must already be true before the platform begins
real agent-factory promotion work.

## A Standalone Repo Is Pre-Agents Ready When

1. the root control plane is natively documented
2. prompt hardening is a native gate
3. issue-driven mutation discipline is native
4. topology, lanes, risk, and closure are native core concepts
5. workflow adapters are documented as peers, not accidents
6. runtime adapters are documented as capabilities-to-tooling layers
7. onboarding has a native operational surface
8. the repo remains fully functional with zero promoted agents

## Current Native Baseline

The current native pre-agents baseline now includes:

- `core/control-plane/root-laws.md`
- `core/hardening/prompt-hardening.md`
- `core/issue-topology/issue-driven-mutation-stack.md`
- `core/issue-topology/topology-policy.md`
- `core/lanes/manager-lane-model.md`
- `core/risk/risk-enforcement-matrix.md`
- `core/closure/authority-boundary.md`
- `core/runtime-packets/templates.md`
- `core/runtime-packets/cadence.md`
- `adapters/workflow/adapter-contract.md`
- `adapters/workflow/linear/adapter.md`
- `adapters/workflow/github/adapter.md`
- `adapters/runtime/adapter-contract.md`
- runtime adapter shells
- onboarding A&Q, discovery, planning, and recommendation docs

## What Pre-Agents Does Not Require Yet

- promoted `*.toml` agents
- full rehome of all imported doctrine
- full adapter implementation breadth
- full overlay cleanup

## Next Phase After Pre-Agents

Once this baseline is stable, the next major phase is:

1. rehome more doctrine from `references/` into native layers
2. normalize the default distribution as explicit profile + adapters
3. evolve `references/codex-agents/` into the native `agent-factory`
