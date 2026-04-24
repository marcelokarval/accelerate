# `.accelerate/` V2 Implementation Contract

## Purpose

This document hardens the operational contract of:

- [V2 Small And Useful](./accelerate-project-local-workspace-executive-plan-v2-small-and-useful.md)

It exists to reduce ambiguity before the first real implementation of the
project-local `.accelerate/` workspace.

The first native product implementation surface for this contract now lives in:

- `../../onboarding/local-workspace/`

## Contract Scope

This contract defines:

- the minimum required V2 files
- minimum schemas for the YAML files
- planning lifecycle transitions
- autonomy thresholds for local writes

It does not yet define:

- full workflow adapter persistence
- runtime capability registry persistence
- profile override persistence
- long-form local memory persistence beyond a minimal status layer

Those remain V3 concerns.

## Required V2 Files

The minimum V2 implementation must create all of these paths:

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
│   ├── closure-packet.md
│   ├── branch-entry-packet.md
│   ├── runtime-delta-packet.md
│   ├── handoff-summary.md
│   ├── pre-review-bundle.md
│   ├── closure-bundle.md
│   ├── current-slice-review.md
│   ├── current-slice-forensics.md
│   ├── defect-ledger.yaml
│   └── seam-proof.md
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

This is a hard minimum, not a soft suggestion.

## Source-Of-Truth Precedence

When two V2 files appear to overlap, precedence is:

1. `.accelerate/state.yaml`
   - global local-installation summary
2. `.accelerate/status/readiness-dashboard.yaml`
   - local synthesized readiness and closure posture
3. `.accelerate/onboarding/status.yaml`
   - detailed onboarding and reentry state
4. `.accelerate/onboarding/decisions.yaml`
   - declarative onboarding decisions
5. `.accelerate/planning/current-plan.md`
   - current planning index and governing artifact pointer
6. `.accelerate/agents/status.yaml`
   - local pre-agents posture
7. `.accelerate/status/timeline.jsonl`
   - append-only continuity chronology
8. `.accelerate/status/learnings.jsonl`
   - append-only durable learnings
9. `.accelerate/review/*.md`
   - persisted local handoff and closure artifacts derived from current local state

### Precedence Rule

Use `state.yaml` as the fast global index.

Use subfiles as the detailed local authority for their own domain.

Examples:

- if `state.yaml` says onboarding is `completed` but
  `onboarding/status.yaml` says `in_progress`, treat that as drift and prefer
  `onboarding/status.yaml` for onboarding truth
- if `state.yaml` points to `planning/current-plan.md`, that path is the
  pointer, and that file remains the local planning authority over the artifact
  ladder

`state.yaml` should summarize. Subfiles should specialize.

## YAML Schema Rules

### General

All YAML files in `.accelerate/` should:

- include `schema_version: 1`
- prefer explicit keys over free-form prose
- remain small and readable by humans
- avoid storing secrets or runtime noise

### `.accelerate/state.yaml`

Minimum required keys:

```yaml
schema_version: 1
accelerate_stage: standalone-pre-agents
project_onboarded: true
installation_mode: greenfield|adoption
repo_maturity: empty|early|existing|mature
onboarding_status: not_started|in_progress|partially_stabilized|completed
reentry_status: clean|light_reentry|partial_reonboarding|structural_reonboarding
workflow_backend: none-yet|github|linear
workflow_backend_detected: none-yet|github|linear
active_profile: unknown|django-inertia-react|nextjs-tailwind
active_runtime_adapters: []
agent_mode: root-only|agent-eligible
current_plan: .accelerate/planning/current-plan.md
agents_status_file: .accelerate/agents/status.yaml
readiness_dashboard: .accelerate/status/readiness-dashboard.yaml
timeline_file: .accelerate/status/timeline.jsonl
learnings_file: .accelerate/status/learnings.jsonl
evidence_registry: .accelerate/status/evidence-registry.yaml
review_ready_packet: .accelerate/review/review-ready-packet.md
ai_review_report: .accelerate/review/ai-review-report.md
closure_packet: .accelerate/review/closure-packet.md
branch_entry_packet: .accelerate/review/branch-entry-packet.md
runtime_delta_packet: .accelerate/review/runtime-delta-packet.md
handoff_summary: .accelerate/review/handoff-summary.md
pre_review_bundle: .accelerate/review/pre-review-bundle.md
closure_bundle: .accelerate/review/closure-bundle.md
current_slice_review: .accelerate/review/current-slice-review.md
current_slice_forensics: .accelerate/review/current-slice-forensics.md
defect_ledger: .accelerate/review/defect-ledger.yaml
seam_proof: .accelerate/review/seam-proof.md
last_bootstrap_update: YYYY-MM-DD
```

Rules:

- `workflow_backend` is enforced backend posture; in the pre-agents phase it
  should normally remain `none-yet`
- `workflow_backend_detected` may record GitHub/Linear signals without claiming
  that a native adapter is enforced
- `active_runtime_adapters` may be empty in early adoption, but the key should
  exist
- `project_onboarded` should only become `true` after real onboarding output
  exists
- `onboarding_status` here is a summary mirror of
  `.accelerate/onboarding/status.yaml`
- `reentry_status` here is a summary mirror of
  `.accelerate/onboarding/status.yaml`

### `.accelerate/status/readiness-dashboard.yaml`

Minimum required keys:

```yaml
schema_version: 1
current_phase: onboarding|planning|execution|review|closure
governing_artifact_path: docs/...|.accelerate/...
dashboard_verdict: blocked|ready-for-execution|ready-for-review|ready-for-closure
execution_readiness: blocked|ready
review_readiness: blocked|ready
closure_readiness: blocked|ready
required_gates: []
completed_gates: []
blocking_items: []
last_updated: YYYY-MM-DD
```

Rules:

- this file is a local synthesis surface, not a replacement for root packets
- it should stay small and conservative
- it must not claim review or closure readiness without real upstream proof
- it must not promote review or closure readiness unless
  `.accelerate/status/evidence-registry.yaml` satisfies the relevant gate
- it must reset inherited review/closure readiness when the governing artifact
  changes to a new bounded slice

### `.accelerate/status/timeline.jsonl`

This file is mandatory and append-only.

It records meaningful local workspace transitions such as:

- workspace emitted
- project classified
- reentry reconciled
- learning recorded

It must not become a full chat log.

### `.accelerate/status/learnings.jsonl`

This file is mandatory and append-only.

It records durable operational learnings that are worth carrying across
sessions before they are promoted into stronger governing surfaces.

It must stay curated and high-signal.

### `.accelerate/status/evidence-registry.yaml`

This file is mandatory.

It records proof status for readiness promotion. Readiness dashboards and
closure packets must not infer proof presence from phase state alone.

Minimum required keys:

```yaml
schema_version: 1
implementation_proof: missing|present|blocked|not-applicable
qa_proof_lane: missing|present|blocked|not-applicable
backend_qa: missing|present|blocked|not-applicable
frontend_qa: missing|present|blocked|not-applicable
browser_proof: missing|present|blocked|not-applicable
persistent_e2e: missing|present|blocked|not-applicable|out-of-order
ux_ui_fullstack_surface: missing|present|blocked|not-applicable
design_implementation_proof: missing|present|blocked|not-applicable
product_critical_closure: missing|present|blocked|not-applicable
requested_vs_implemented: missing|present|blocked|not-applicable
defect_ledger: clear|open-defects-remain|waived-defects-present|missing|blocked
correction_loop: not-needed|completed|incomplete|missing|blocked
seam_proof: not-needed|present|missing|insufficient|blocked
ai_review: missing|present|blocked|not-applicable
ai_review_rendered: missing|present|blocked|not-applicable
last_updated: YYYY-MM-DD
```

### `.accelerate/review/*.md`

These files are mandatory and human-facing.

They persist the current local:

- review-ready packet
- AI Review Report
- closure packet
- branch entry packet
- runtime delta packet
- handoff summary
- pre-review bundle
- closure bundle

They are derived artifacts, but they are still canonical local handoff outputs
once written.

Within this review surface, `handoff-summary.md` is the compact reentry index.
It does not replace the packet or bundle files; it points the operator back
into them.

### `.accelerate/README.md`

This file is mandatory and human-facing.

Minimum required sections:

- what `.accelerate/` is
- what files here are canonical
- what files here are summaries vs detailed authorities
- what `accelerate` may rewrite autonomously
- where a fresh session should start reading

It should not become:

- a duplicate of repo `AGENTS.md`
- a duplicate of the standalone `accelerate` doctrine
- a session log

The `status/` subtree may exist, but it should remain small and operational
rather than becoming a noisy runtime dump.

### `.accelerate/onboarding/status.yaml`

Minimum required keys:

```yaml
schema_version: 1
status: not_started|in_progress|partially_stabilized|completed
reentry_status: clean|light_reentry|partial_reonboarding|structural_reonboarding
last_updated: YYYY-MM-DD
```

#### Transition Rules

##### `not_started -> in_progress`

Allowed when:

- `.accelerate/` has been created for real onboarding work
- discovery has started or is being written

##### `in_progress -> partially_stabilized`

Allowed when all are true:

- discovery exists
- decisions exist
- executive bootstrap plan exists
- at least one important ambiguity or deferred setup slice still remains

##### `partially_stabilized -> completed`

Allowed when all are true:

- onboarding discovery is sufficiently complete for the current repo phase
- decisions are explicit
- bootstrap plan exists
- no unresolved onboarding ambiguity still blocks normal use of `accelerate`

##### `completed -> partial_reonboarding`

Allowed when:

- a meaningful but bounded structural change happened
- the existing onboarding remains partly valid

##### `completed -> structural_reonboarding`

Allowed when:

- stack profile changed materially
- workflow posture changed materially
- runtime posture changed materially
- existing onboarding assumptions no longer provide honest continuity

### `.accelerate/onboarding/discovery.yaml`

Minimum required keys:

```yaml
schema_version: 1
languages: []
framework_signals: []
workflow_tool_signals: []
docs_posture_signals: []
proof_runtime_signals: []
package_manager_signals: []
repo_notes: []
```

Rules:

- this file is observational, not declarative
- unclear signals should remain signals, not silently become decisions

### `.accelerate/onboarding/decisions.yaml`

Minimum required keys:

```yaml
schema_version: 1
selected_workflow_backend: none-yet|github|linear
selected_workflow_backend_detected: none-yet|github|linear
selected_profile: unknown|django-inertia-react|nextjs-tailwind
selected_runtime_posture: []
selected_docs_posture: default|custom|none-yet
explicit_non_goals: []
```

Rules:

- decisions must be derivable from discovery or explicit user direction
- a missing backend implementation must keep `selected_workflow_backend` at
  `none-yet`; detected backend signals belong in
  `selected_workflow_backend_detected`

### `.accelerate/onboarding/executive-bootstrap-plan.md`

This file is mandatory.

Minimum required sections:

- governing scenario
- selected workflow backend posture
- selected stack profile
- selected runtime posture
- selected docs posture
- recommended adjacent skills
- recommended future agent candidates
- explicit non-goals
- next bounded setup slices
- residual risks or open decisions

This file is the first execution-facing artifact emitted by onboarding.

### `.accelerate/agents/status.yaml`

Minimum required keys:

```yaml
schema_version: 1
agent_mode: root-only|agent-eligible
agent_readiness: pre-agents
promotion_discussion: false
catalog_required: false
```

Rules:

- `agent-eligible` does not mean promoted
- `promotion_discussion: true` does not mean approved

### `.accelerate/agents/candidates.yaml`

Minimum required keys:

```yaml
schema_version: 1
candidates: []
```

Rules:

- candidates are suggestions only
- entries should be family names or structured family notes, not approval
  statements

### `.accelerate/agents/gaps.yaml`

Minimum required keys:

```yaml
schema_version: 1
gaps: []
```

Rules:

- gaps must describe recurring missing specialties
- one awkward issue is not enough to register a strong gap

## Planning Lifecycle Contract

### `planning/current-plan.md`

This is the active local planning index.

It should exist whenever execution is presently governed by local planning
artifacts.

It should summarize:

- active phase
- current governing artifact
- current artifact ladder state
- smallest sufficient artifact decision
- next required artifact
- bounded objective
- residual risks or blockers

### `planning/user-story.md`

Use this file when actor, goal, value, pain, or acceptance criteria are active
local blockers.

If story framing is not required for the current slice, say so explicitly.

### `planning/prd-lite.md`

Use this file when the local work is capability-level, epic-like, or too broad
for safe execution from story framing alone.

If PRD-lite is not required for the current slice, say so explicitly.

### `planning/sdd.md`

Use this file when architecture, data ownership, transport, migration, runtime
adapter choice, or proof posture are still design blockers.

If SDD is not required for the current slice, say so explicitly.

### `planning/executive-plan.md`

Use this file when sequencing, rollout, adapters, proof lanes, or bounded
execution order need an explicit local plan.

If executive planning is not required for the current slice, say so
explicitly.

### `planning/task-breakdown.md`

Use this file when implementation must be decomposed into dependency-aware
slices.

If task breakdown is not required for the current slice, say so explicitly.

### `planning/history/`

Planning artifacts should move into `history/` only after:

- they are no longer active
- a newer artifact superseded them
- the supersession or closure state is recorded honestly

If an artifact is superseded before closure is clean, preserve that fact
explicitly in the archived copy rather than pretending it was fully complete.

### `planning/open-questions.md`

This file captures unresolved high-impact ambiguities that still affect the
governing plan or onboarding posture.

## Autonomy Thresholds

### Level 1. Safe autonomous writes

`accelerate` may write without extra ceremony when the write records:

- observed repository facts
- explicit user direction
- active plan location
- clearly current root-only posture

Examples:

- creating `.accelerate/`
- writing `state.yaml`
- writing discovery facts
- writing the first executive bootstrap plan
- writing the first artifact ladder placeholders
- writing `agents/status.yaml` as `root-only`

### Level 2. Conditioned autonomous writes

`accelerate` may write when evidence is strong and local truth is stable.

Examples:

- changing `selected_profile`
- changing `workflow_backend`
- marking `partial_reonboarding`
- changing which planning artifact is currently governing

### Level 3. Sensitive structural writes

These should be conservative and strongly evidence-backed.

Examples:

- rewriting historical assumptions
- deleting or heavily rewriting history
- asserting strong promotion readiness
- changing local constitutional posture without clear basis

## Meaning Of Key Phrases

### “Onboarding is real”

This means all are true:

- discovery has been performed
- decisions have been recorded
- an executive bootstrap plan exists
- `.accelerate/state.yaml` can be populated honestly

### “Discovery is factual”

This means the signal came from one or more of:

- repository inspection
- tooling inspection
- existing project files
- explicit user direction

It must not be guessed just to complete the file.

### “Local agent posture is clearly inferable”

This means the current control-plane behavior already supports one of these
truths:

- the project is still root-only
- the project is honestly agent-eligible in principle

It does not mean promotion is implied.

## Implementation Success Criteria

The V2 implementation is ready when:

- every required file exists
- every required YAML file satisfies the minimum contract
- a fresh session can resume without reconstructing onboarding and planning
- no file falsely implies a live workflow backend or promoted agent catalog
