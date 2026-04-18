# References Layer

`references/` is the inherited doctrine layer for the standalone `accelerate`
repo.

It remains useful, but it is no longer a flat source of equal authority.

## Rule

When a method surface already has a native home under `core/`, prefer the local
native file as primary authority.

Use the matching reference file for:

- inherited depth
- side-by-side comparison against legacy/global doctrine
- historical traceability while rehoming continues

Do not treat a duplicated reference file as the primary method source merely
because it is older or longer.

## Native-Backed Reference Files

These reference files now have direct native authorities and should be read as
supporting doctrine:

- `branch-enforcement-matrix.md`
  - primary: `../core/control-plane/branch-enforcement-matrix.md`
- `current-enforcement-surfaces.md`
  - primary: `../core/risk/enforcement-surfaces.md`
- `full-invocation-map.md`
  - primary: `../core/control-plane/quick-invocation-map.md`
- `issue-stack.md`
  - primary: `../core/issue-topology/issue-driven-mutation-stack.md`
- `maturity-control.md`
  - primary: `../core/workflows/maturity-control.md`
- `operational-calibration.md`
  - primary: `../core/workflows/operational-calibration.md`
- `persona-mandatory-skills-matrix.md`
  - primary: `../core/personas/mandatory-skills.md`
- `premium-interface-production.md`
  - primary: `../core/review/premium-interface-production.md`
- `product-critical-surfaces.md`
  - primary: `../core/review/product-critical-surfaces.md`
- `qa-proof-stack.md`
  - primary: `../core/runtime-packets/qa-proof-stack.md`
- `review-architecture.md`
  - primary: `../core/review/architecture.md`
- `runtime-observability-cadence.md`
  - primary: `../core/runtime-packets/cadence.md`
- `runtime-packet-templates.md`
  - primary: `../core/runtime-packets/templates.md`
- `subagent-model.md`
  - primary: `../core/delegation/subagent-model.md`
- `workflow-catalog.md`
  - primary: `../core/workflows/catalog.md`
- `workflow-change-approval-gate.md`
  - primary: `../core/control-plane/workflow-change-approval-gate.md`
- `autoresearch-and-self-evolution.md`
  - primary: `../core/workflows/self-evolution.md`
- `persona-model.md`
  - primary: `../core/personas/model.md`
- `executive-persona-matrix.md`
  - primary: `../core/personas/executive-matrix.md`

## Reference-First Material

These are still useful reference-first or support-heavy surfaces:

- `adjacent-skill-trigger-audit.md`
- `executive-operating-matrix.md`
- `linear-execution.md`
- `specification-layer.md`
- `team-operating-model.md`
- `trivial-branch-contract.md`
- `codex-agents/`

Use them when:

- the local native layer is still thinner
- the run is explicitly comparative
- future-agent governance itself is the subject

## Entry Guidance

The intended reading order is:

1. `AGENTS.md`
2. `SKILL.md`
3. `README.md`
4. relevant native `core/` surface
5. only then matching `references/` file when deeper inherited doctrine still
   helps
