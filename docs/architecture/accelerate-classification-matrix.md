# Accelerate Classification Matrix

## Purpose

This matrix classifies the current upstream `accelerate` material into the
target layers of the standalone platform.

It is intentionally practical. It exists to stop migration from becoming
guesswork or blind copying.

## Classification Legend

- `core`
  - non-negotiable reusable platform laws
- `workflow adapter`
  - issue/ticket backend implementation layer
- `runtime adapter`
  - concrete command/toolchain layer
- `stack profile`
  - opinionated technology posture
- `agent factory`
  - bounded-agent doctrine and promotion logic
- `planning`
  - formal planning artifacts that bridge discovery and execution
- `overlay`
  - project-specific deployment truth
- `publication adapter`
  - public-doc rendering layer

## Matrix

| Upstream Artifact | Current Location | Target Layer | Migration Note |
| --- | --- | --- | --- |
| root `SKILL.md` | `skills/accelerate/SKILL.md` | `core` | Keep as the compact constitutional entrypoint. |
| root `README.md` | `skills/accelerate/README.md` | `core` | Keep as operational guide; update links after extraction. |
| `accelerate-control-plane.md` | `docs/architecture/accelerate-control-plane.md` | `core` | Becomes canonical platform architecture source or is merged into core architecture docs. |
| bootstrap PRD / SDD / architecture docs | `docs/bootstrap/*`, `docs/architecture/*` | `planning` + `core` | Architecture reasoning remains durable docs; execution-facing planning should gain native planning homes. |
| `prompt-hardening-gate.md` | `references/prompt-hardening-gate.md` | `core` | Move under `core/hardening/`. |
| `issue-stack.md` | `references/issue-stack.md` | `core` | Move under `core/control-plane/` or `core/issue-topology/`. |
| runtime packet templates | `references/runtime-packet-templates.md` | `core` | Move under `core/runtime-packets/`. |
| runtime observability cadence | `references/runtime-observability-cadence.md` | `core` | Move under `core/runtime-packets/`. |
| trivial branch contract | `references/trivial-branch-contract.md` | `core` | Keep as branch contract under control-plane doctrine. |
| `subagent-model.md` | `references/subagent-model.md` | `core` + `agent factory` | Split root law vs future-agent specifics. |
| `current-enforcement-surfaces.md` | `references/current-enforcement-surfaces.md` | `core` | Reframe as enforcement inventory in the platform. |
| `executive-operating-matrix.md` | `references/executive-operating-matrix.md` | `core` | Keep as executive summary of platform laws. |
| `autoresearch-and-self-evolution.md` | `references/autoresearch-and-self-evolution.md` | `core` + `onboarding` | Root self-evolution law stays core; onboarding discovery hooks may reference it. |
| `codex-agents/README.md` | `references/codex-agents/README.md` | `agent factory` | Rehome as `agents/README.md` or equivalent. |
| `agent-ontology.md` | `references/codex-agents/agent-ontology.md` | `agent factory` | Move into doctrine. |
| `agent-capability-matrix.md` | `references/codex-agents/agent-capability-matrix.md` | `agent factory` | Move into doctrine. |
| `control-plane-org-map.md` | `references/codex-agents/control-plane-org-map.md` | `core` + `agent factory` | Root macro model should stay visible in core; family mapping can live in agents. |
| `manager-lane-map.md` | `references/codex-agents/manager-lane-map.md` | `core` | This is root-lane doctrine. |
| `lane-governance-model.md` | `references/codex-agents/lane-governance-model.md` | `core` | This is root governance law. |
| `root-vs-agent-authority-boundary.md` | `references/codex-agents/root-vs-agent-authority-boundary.md` | `core` + `agent factory` | Root law plus agent subordination. |
| `issue-topology-policy.md` | `references/codex-agents/issue-topology-policy.md` | `core` | Root-owned topology remains core. |
| `agent-execution-contract.md` | `references/codex-agents/agent-execution-contract.md` | `agent factory` | Bounded-agent execution law. |
| `staffing-and-decomposition-policy.md` | `references/codex-agents/staffing-and-decomposition-policy.md` | `core` + `agent factory` | Root law with agent selection implications. |
| `risk-enforcement-model.md` | `references/codex-agents/risk-enforcement-model.md` | `core` | Core law. |
| `risk-enforcement-matrix.md` | `references/codex-agents/risk-enforcement-matrix.md` | `core` | Core law. |
| `active-risk-detection-signals.md` | `references/codex-agents/active-risk-detection-signals.md` | `core` | Core enforcement details. |
| `closure-blockers-and-escalation.md` | `references/codex-agents/closure-blockers-and-escalation.md` | `core` | Core closure and escalation law. |
| `return-and-escalation-contracts.md` | `references/codex-agents/return-and-escalation-contracts.md` | `core` + `agent factory` | Root return law plus bounded-agent return contract. |
| `agent-empirical-replay.md` | `references/codex-agents/agent-empirical-replay.md` | `agent factory` + `profiles` | Replay should be profile-aware over time. |
| `agent-pooling-model.md` | `references/codex-agents/agent-pooling-model.md` | `agent factory` | Pooling and fit scoring. |
| `agent-selection-policy.md` | `references/codex-agents/agent-selection-policy.md` | `agent factory` | Selection logic. |
| `agent-gap-detection.md` | `references/codex-agents/agent-gap-detection.md` | `agent factory` | Gap detection and suggestion law. |
| `agent-skill-envelopes.md` | `references/codex-agents/agent-skill-envelopes.md` | `agent factory` | Skill-envelope doctrine. |
| executive bootstrap plan template | `onboarding/planning/executive-bootstrap-plan-template.md` | `planning` | Canonical ownership should move into `planning/executive/`. |
| `linear-pm` references and assumptions | mixed skills/docs | `workflow adapter` + `overlay` | Shared orchestration concepts become adapter; Prop4You naming/details become overlay. |
| GitHub workflow skill assumptions | mixed skills/docs | `workflow adapter` | Formal peer of Linear adapter. |
| `uv run ... manage.py ...` examples | mixed skills/docs | `runtime adapter` + `stack profile` | Abstract to Python wrapper capability plus profile-specific command mapping. |
| `front-react`, Django, Inertia, shadcn assumptions | mixed skills/docs | `stack profile` | Becomes default profile, not universal law. |
| Chrome DevTools and Playwright proof ordering | mixed skills/docs | `runtime adapter` + `core` | Ordering law stays core; tool specifics are adapters. |
| Docusaurus docs | `frontends/docusaurus/docs/ai/*` | `publication adapter` + `overlay` | Public-doc output path, optional. |
| Prop4You brand-specific language | mixed docs | `overlay` | Keep out of reusable core whenever possible. |

## Immediate Extraction Guidance

The safest early moves are:

1. extract `core` doctrine first
2. institute `planning` as a native layer
3. extract `agent factory`
4. define the first `stack profile`
5. then define workflow/runtime adapters
6. leave overlays and publication adapters for later phases

## Explicit Split Warnings

### Core vs Stack Profile

Do not let these leak into core:

- repo-specific paths
- package manager flags
- framework-specific validation commands

### Core vs Overlay

Do not let these leak into core:

- project brand naming
- project-specific issue conventions that are not part of the shared workflow
  model
- local documentation publishing paths

### Core vs Agent Factory

Keep in core:

- root authority
- topology law
- risk law
- closure law

Keep in agent factory:

- families
- templates
- envelopes
- promotion logic

## Next Use

This matrix should be used directly by the migration plan.
