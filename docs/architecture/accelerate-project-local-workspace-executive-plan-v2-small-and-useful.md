# `.accelerate/` Executive Plan V2: Small And Useful

## Purpose

Define the first recommended real rollout of `.accelerate/` inside a project.

This version assumes that `accelerate` is no longer only classifying work in
session memory. It is now persisting onboarding, planning, and local
agent-governance truth.

## Recommendation Status

This is the **current recommended default** for the first real implementation
of `.accelerate/`.

It is small enough to stay teachable and strict enough to preserve continuity
between sessions.

For the hardened operational contract of this recommendation, read:

- [V2 Implementation Contract](./accelerate-project-local-workspace-v2-contract.md)

The first native product implementation surface for this recommendation now
lives in:

- `../../onboarding/local-workspace/`

## Scope

`V2` persists:

- local installation state
- onboarding state and decisions
- current planning state
- local pre-agents status, candidates, and gaps
- minimal branch readiness / continuity / learnings truth
- local handoff / review / closure packet truth

It does not yet persist the wider local control surfaces for:

- workflow mapping
- runtime capability registry
- profile overrides
- long-form local memory beyond the minimal status layer

## Target Shape

```text
.accelerate/
├── README.md
├── state.yaml
├── status/
│   ├── readiness-dashboard.yaml
│   ├── timeline.jsonl
│   └── learnings.jsonl
├── review/
│   ├── review-ready-packet.md
│   ├── ai-review-report.md
│   └── closure-packet.md
│   ├── pre-review-bundle.md
│   └── closure-bundle.md
├── onboarding/
│   ├── status.yaml
│   ├── discovery.yaml
│   ├── decisions.yaml
│   └── executive-bootstrap-plan.md
├── planning/
│   ├── current-plan.md
│   ├── user-story.md
│   ├── prd-lite.md
│   ├── sdd.md
│   ├── executive-plan.md
│   ├── task-breakdown.md
│   ├── open-questions.md
│   └── history/
└── agents/
    ├── status.yaml
    ├── candidates.yaml
    └── gaps.yaml
```

## Why This Is The Default Recommendation

`V2` is the strongest balance between:

- low operational overhead
- high session continuity
- clear planning persistence
- clear pre-agents local governance

It aligns with the current shape of `accelerate` itself:

- onboarding is already a real native layer
- planning is already a real native layer
- agent-factory is already architecturally real in pre-agents

## File Contracts

These file contracts describe the intent of each artifact.

For minimum required schemas, lifecycle transitions, and write thresholds, use
the contract document above.

### `state.yaml`

High-level installation summary and pointer map.

It is the fast local index, not the detailed authority for every subdomain.

Suggested additions beyond `V1`:

```yaml
current_plan: .accelerate/planning/current-plan.md
agents_status_file: .accelerate/agents/status.yaml
```

### `onboarding/status.yaml`

Authoritative state of onboarding progress.

This file is the detailed source of truth for onboarding lifecycle, while
`state.yaml` mirrors it at summary level.

Suggested fields:

```yaml
status: not_started|in_progress|partially_stabilized|completed
reentry_status: clean|light_reentry|partial_reonboarding|structural_reonboarding
last_updated: YYYY-MM-DD
```

### `onboarding/discovery.yaml`

Observed repository signals.

This file is observational, not declarative.

It should capture:

- detected language/runtime/tooling
- framework signals
- workflow tool signals
- docs posture signals
- proof/runtime signals

### `onboarding/decisions.yaml`

Decisions derived from discovery.

This file is the detailed source of truth for onboarding decisions.

It should capture:

- selected workflow backend
- selected profile
- selected runtime posture
- selected docs posture
- explicit non-goals

### `onboarding/executive-bootstrap-plan.md`

The first local bootstrap plan emitted by onboarding.

This file is the bridge from discovery into real local execution.

### `planning/current-plan.md`

The governing local planning index for the active artifact ladder.

It should say:

- which artifact currently governs the slice
- which artifacts are not required vs required-but-missing vs active
- what the next required artifact is
- what still blocks execution or closure

### `planning/user-story.md`

Actor, goal, value, pain, and acceptance framing when needed.

### `planning/prd-lite.md`

Capability-level scope, non-goals, constraints, and success signals when needed.

### `planning/sdd.md`

Technical design authority when architecture or ownership is still unresolved.

### `planning/executive-plan.md`

Sequencing, rollout, proof-lane, and bounded execution-order authority when
needed.

### `planning/task-breakdown.md`

Dependency-aware implementation slices when needed.

### `planning/open-questions.md`

High-impact ambiguities still unresolved across the artifact ladder.

### `planning/history/`

Superseded planning artifacts that are no longer active.

### `agents/status.yaml`

Local agent-governance posture.

This file is the detailed source of truth for local pre-agents status, while
`state.yaml` mirrors only the high-level `agent_mode`.

Suggested fields:

```yaml
agent_mode: root-only|agent-eligible
agent_readiness: pre-agents
promotion_discussion: false
catalog_required: false
```

### `agents/candidates.yaml`

Locally relevant families that seem contextually useful for the project.

This must not imply:

- approval
- promotion
- installation

### `agents/gaps.yaml`

Local recurring missing specialties.

This file exists so the project can accumulate pre-promotion evidence instead
of rediscovering the same gap repeatedly.

## Writing Policy

`accelerate` should be highly autonomous under `V2`.

It may create and update these files automatically when:

- onboarding is real
- discovery is factual
- planning artifacts have been created
- local agent posture is clearly inferable from control-plane behavior

## Upgrade Rule

Upgrade from `V2` to `V3` when the project needs explicit persisted local
surfaces for:

- workflow mapping
- runtime capability registry
- profile overrides
- memory beyond plan and onboarding

## Success Criteria

`V2` succeeds when a fresh session can determine without conversational
reconstruction:

- whether onboarding happened
- what was discovered
- what was decided
- which planning artifact currently governs execution
- which parts of the artifact ladder are active vs not required
- which open questions remain
- whether the repo is still root-only
- which local candidate families and gaps already exist
