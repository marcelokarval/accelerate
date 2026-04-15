# Accelerate

`accelerate` is the root orchestration skill for engineering work in the
standalone platform and its supported project distributions.

Use it to decide how work should run before implementation starts, not merely
to narrate that work is happening.

It is the control plane that chooses:

- whether the run is trivial or non-trivial
- whether prompt hardening is required
- which issue topology is honest
- which lanes and skills must be open
- whether delegation is useful at all
- which proof stack is required
- which blockers still control closure

The short constitutional entry file is:

- [SKILL.md](./SKILL.md)

This README is the richer, living guide for how `accelerate` is meant to be understood and used in its current default distribution.

## What It Is

`accelerate` is:

- the root workflow orchestrator
- the visible operating system for engineering teamwork
- a specification-first and issue-aware control plane
- a stack-aware but project-agnostic governance layer
- the owner of topology, staffing, risk enforcement, and closure

It is strongest when work is:

- issue-driven
- cross-surface
- architecture-sensitive
- user-facing or runtime-sensitive
- abuse-sensitive
- ambiguous enough to drift without shaping

## What It Is Not

`accelerate` is not:

- an implementation skill
- a replacement for stack-specific skills
- a requirement that agents must exist before the workflow can operate
- a justification for unnecessary ceremony
- a license for bounded agents to inherit orchestration authority

## Relationship To The Root Skill

Keep the split intentional:

- [SKILL.md](./SKILL.md)
  - short constitutional entry skill
- this README
  - richer operational guide, examples, reading map, and doctrine overview
- `references/`
  - deep modules that hold detailed policy and design layers

The root skill should stay compact.

The README should stay rich enough for onboarding and maintenance.

The references should stay authoritative for deep behavior.

## Pre-Agents Baseline

The standalone repo now has a native pre-agents baseline.

Start here:

- [accelerate-pre-agents-baseline.md](./docs/architecture/accelerate-pre-agents-baseline.md)
- [core/README.md](./core/README.md)
- [adapters/workflow/README.md](./adapters/workflow/README.md)
- [adapters/runtime/README.md](./adapters/runtime/README.md)
- [onboarding/README.md](./onboarding/README.md)
- [planning/README.md](./planning/README.md)

Use `references/` as supporting doctrine while rehoming continues.

## Core Operating Model

At a high level, `accelerate` works like this:

1. classify the run
2. decide whether prompt hardening is mandatory
3. decide the honest issue topology
4. decide which lanes and skills are required
5. decide whether the work should stay root-only or use bounded agents
6. execute with visible runtime packets and active gates
7. force proof in the correct order
8. enter root closure mode before `Done`

The control plane should be visible, not implied.

## Prompt Hardening

`accelerate` must decide whether prompt hardening is required before execution
starts.

Hardening is not cosmetic rewriting. It is a blocking gate when the request is:

- long
- ambiguous
- multi-objective
- multi-phase
- architecture-heavy
- likely to drift into issue creation, planning, runtime proof, or multi-surface
  work

When hardening is active, the run should visibly expose:

- `Prompt A`
- `Prompt B`
- material changes
- bounded scope
- explicit non-goals
- next branch or persona route

See:

- [prompt-hardening-gate.md](./references/prompt-hardening-gate.md)

## Issue-Driven Mutation Stack

When the work mutates code, docs, workflow seeds, or runtime governance, the
issue stack is mandatory.

The minimum mutation path is:

1. `accelerate`
2. `Issue Bootstrap Gate`
3. active workflow adapter
4. planning artifact
5. execution
6. proof stack
7. `AI Review Report`
8. root closure mode

Mutation must not jump directly from request to implementation.

See:

- [issue-stack.md](./references/issue-stack.md)

## Agent Optionality

Agents are a governed capability, not a structural dependency.

`accelerate` must remain fully functional:

- when no `~/.codex/agents/*.toml` exist
- when the user explicitly disables agents
- when the current pool has no honest fit
- when integration cost is higher than the gain from delegation

`accelerate` may:

- suggest a future agent promotion into `~/.codex/agents/*.toml`
- decide that no agent should be used
- keep the run fully root-owned

`accelerate` must not:

- force delegation because a catalog exists
- force delegation because thread budget exists
- treat gap detection as automatic promotion

### Suggestion vs Promotion

These are different actions:

- `suggestion`
  - the root concludes that a repeated missing specialty exists
- `promotion`
  - the governed process later decides to create or sync a real runtime agent

Detecting a gap does not create an agent by itself.

## Root-Only Mode

Root-only mode is a valid operating posture, not a degraded failure state.

Keep work root-only when:

- topology is still unstable
- the dominant need is lane-governor judgment
- the fit for a bounded family is weak
- the user asked for no agents in this run
- the expected integration burden outweighs the delegation gain

## User-Controlled Agent Disable

The user may disable agents explicitly:

- for the whole run
- for one bounded slice

When that happens, `accelerate` still governs the run normally. The only change
is that the execution stays root-owned.

## Recommended Adjacent Skills

`accelerate` should coexist well with these adjacent disciplines:

- `napkin`
  - keeps the recurring runbook and durable tactical guidance fresh
- `using-superpowers`
  - reinforces proper skill discovery and activation discipline

They are recommended operating companions.

They are not the semantic foundation of `accelerate`.

`accelerate` must still make correct control-plane decisions even if the user is
not explicitly talking about those adjacent skills.

## Root Authority

The root owns:

- classification
- prompt-hardening decisions
- issue topology
- lane opening and closing
- staffing shape
- delegation budget
- risk enforcement
- final AI review
- root closure mode
- `Done`

This authority is not delegated by default.

See:

- [root-vs-agent-authority-boundary.md](./references/codex-agents/root-vs-agent-authority-boundary.md)
- [issue-topology-policy.md](./references/codex-agents/issue-topology-policy.md)
- [risk-enforcement-matrix.md](./references/codex-agents/risk-enforcement-matrix.md)

## Future Bounded Agent Authority

Future bounded agents are subordinate execution or review units.

They may:

- accept a bounded slice
- stay inside their write scope
- run required validations
- perform self-review and self-forensic review
- comment on the issue with evidence
- move an issue to `In Review`

They must not, by default:

- decompose the work further
- create issues
- change issue topology
- restaff or respawn the run
- claim closure authority
- move an issue to `Done`

### Accelerate Inside A Bounded Agent

A future bounded agent may still carry `accelerate` as local execution
discipline.

Inside that bounded context, `accelerate` means:

- bounded classification of the assigned slice
- visible runtime state
- honest verification

It does not mean:

- executive routing
- staffing authority
- topology control
- closure authority

## Control-Plane Pools

The control plane reasons through explicit pools before selecting a bounded
family:

- manager lane pool
- issue topology pool
- risk detection pool
- closure blocker pool
- evidence pool
- family pool
- future-gap pool

This means the root should think about:

1. which class of decision is active
2. which lane owns that decision
3. which risk is dominant
4. which evidence class is required
5. only then whether a bounded family is useful

See:

- [agent-pooling-model.md](./references/codex-agents/agent-pooling-model.md)

## Manager Lanes

The current macro model distinguishes explicit manager lanes:

- executive routing
- technical
- lifecycle
- design-contract
- proof
- trust

These are not runtime worker roles by default.

They are root-owned managerial functions that steer the system.

See:

- [manager-lane-map.md](./references/codex-agents/manager-lane-map.md)
- [lane-governance-model.md](./references/codex-agents/lane-governance-model.md)

## Issue Topology

Issue topology is a root decision, not an implementation convenience.

The root should choose between:

- single issue
- sibling issues
- parent + child
- parent + child + review lane

The question is not "how many tickets feel nice".

The question is "what is the honest execution graph for this work".

See:

- [issue-topology-policy.md](./references/codex-agents/issue-topology-policy.md)

## Risk Enforcement

Risk is an active control-plane function.

Material risk must have:

- detector
- signal
- owner
- blocker condition
- release condition

Do not treat risk as a vague narrative warning.

If a risk becomes dominant, the corresponding lane or blocker must activate.

See:

- [risk-enforcement-model.md](./references/codex-agents/risk-enforcement-model.md)
- [risk-enforcement-matrix.md](./references/codex-agents/risk-enforcement-matrix.md)
- [active-risk-detection-signals.md](./references/codex-agents/active-risk-detection-signals.md)

## Root Closure Mode

Final closure is root-owned.

That means:

- bounded agents may return work
- bounded agents may set `In Review`
- only the root performs final revalidation
- only the root enters root closure mode
- only the root can move the issue to `Done`

The final closure question is not "did something happen".

It is "does the requested vs implemented comparison, evidence stack, issue
lifecycle, and residual-risk posture support real closure".

## Examples

### Example 1. Trivial bounded read

User asks a small engineering question with no mutation.

Expected behavior:

- `accelerate` classifies trivial
- no issue bootstrap
- no agents required
- root answers directly with honest evidence

### Example 2. Non-trivial work with no agents available

The repo has no governed `*.toml` catalog yet, but the work is still
cross-surface and issue-driven.

Expected behavior:

- `accelerate` still operates normally
- root chooses topology, lanes, and proof stack
- root executes or coordinates bounded slices locally
- no delegation is forced

### Example 3. User disables agents explicitly

The user says not to use agents for this run.

Expected behavior:

- `accelerate` respects the instruction
- root-only mode becomes active
- issue bootstrap, planning, proof, and closure still happen normally

### Example 4. No honest fit in the current pool

The work repeatedly needs a specialty not covered by the current families.

Expected behavior:

- `accelerate` does not force the least-wrong family
- root keeps the run honest
- gap detection may suggest a future agent
- no promotion happens automatically

### Example 5. Parent + child + review lane

The outcome is one coherent feature, but rollout or proof deserves separate
visibility.

Expected behavior:

- root chooses `parent + child + review lane`
- lifecycle and technical lanes open first
- review lane exists as explicit surface, not an afterthought

### Example 6. Bounded agent returns successfully

A future bounded agent completes a slice.

Expected behavior:

- it returns requested vs implemented
- it returns self-review and self-forensic review
- it comments on the issue
- it moves the issue to `In Review`
- the root still performs final AI review and closure

### Example 7. Ambiguous prompt triggers hardening first

The request is long, multi-phase, and still allows several honest execution
interpretations.

Expected behavior:

- `accelerate` does not jump into implementation
- prompt hardening runs first
- the hardened prompt exposes bounded scope and explicit non-goals
- only then does the root classify topology and staffing

### Example 8. Mutating work cannot skip the issue stack

The request mutates workflow docs, code, or living governance docs.

Expected behavior:

- `accelerate` opens the issue lane first
- issue bootstrap and planning artifact gates become visible
- execution only starts after issue and plan hygiene are satisfied
- closure still requires `AI Review Report` and root closure mode

### Example 9. Agents exist, but root-only is still the cleaner path

Agents are available, but the fit is weak and the dominant need is still root
judgment.

Expected behavior:

- `accelerate` does not delegate by habit
- root-only mode remains active
- `single-threaded exception` is emitted honestly when the run is non-trivial
- the work still follows the same proof and closure standards

## Common Usage Guidance

Use `accelerate` whenever the request may involve:

- repository analysis
- planning
- debugging
- implementation
- review
- workflow mutation
- documentation mutation
- issue lifecycle work
- engineering command execution

Do not bypass it merely because the task looks small.

## Reading Map

Start here:

- [SKILL.md](./SKILL.md)

Then use the local architecture docs when you want the current standalone
forward path:

- [accelerate-control-plane.md](./docs/architecture/accelerate-control-plane.md)
- [accelerate-sdd-v1.md](./docs/architecture/accelerate-sdd-v1.md)

Then use the governed reference tree for supporting authority:

- [team-operating-model.md](./references/team-operating-model.md)
- [executive-operating-matrix.md](./references/executive-operating-matrix.md)
- [subagent-model.md](./references/subagent-model.md)
- [runtime-packet-templates.md](./references/runtime-packet-templates.md)
- [runtime-observability-cadence.md](./references/runtime-observability-cadence.md)
- [branch-enforcement-matrix.md](./references/branch-enforcement-matrix.md)
- [issue-stack.md](./references/issue-stack.md)
- [qa-proof-stack.md](./references/qa-proof-stack.md)

For the governed future-agent ecosystem:

- [codex-agents/README.md](./references/codex-agents/README.md)

## Platform Source Of Truth

For this standalone repository:

- repo source of truth:
  - the files tracked here
- runtime mirror:
  - `~/.codex/skills/accelerate` when global sync is intentionally performed

This README describes the standalone product model first.

Global sync remains a separate step.

Do not treat any runtime mirror as the authoring source for governed
`accelerate` behavior.

## Current Distribution Reality

The current default distribution is still strongly shaped by the incubator
stack that matured `accelerate` first.

That is a distribution and migration fact, not the permanent boundary of the
platform core.

Treat:

- workflow backend assumptions
- stack assumptions
- runtime command assumptions
- project-specific docs posture

as material that will progressively move into adapters, profiles, and overlays.

## Current Repository Shape

The repository is no longer only a transitional import tree.

The first standalone shell of the target architecture now exists:

- `core/`
- `adapters/`
- `profiles/`
- `agents/`
- `onboarding/`
- `overlays/`

These directories currently act as contract-bearing shells while the inherited
doctrine is still being rehomed out of `references/`.

## Repository Bootstrap Context

This repository also carries standalone bootstrap and architecture context for
the extraction and early platform build-out:

- [docs/bootstrap/context-and-origin.md](./docs/bootstrap/context-and-origin.md)
- [docs/bootstrap/decisions-and-final-state.md](./docs/bootstrap/decisions-and-final-state.md)
- [docs/bootstrap/prd-initial-platform-foundation.md](./docs/bootstrap/prd-initial-platform-foundation.md)
- [docs/architecture/accelerate-sdd-v1.md](./docs/architecture/accelerate-sdd-v1.md)
- [docs/architecture/accelerate-classification-matrix.md](./docs/architecture/accelerate-classification-matrix.md)
- [docs/architecture/accelerate-migration-plan.md](./docs/architecture/accelerate-migration-plan.md)
- [docs/architecture/accelerate-onboarding-model.md](./docs/architecture/accelerate-onboarding-model.md)
- [docs/architecture/accelerate-pre-agents-baseline.md](./docs/architecture/accelerate-pre-agents-baseline.md)
