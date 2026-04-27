# GStack Pattern Adoption Executive Plan

## Purpose

Absorb the high-value operating patterns discovered in `garrytan/gstack` into
the standalone `accelerate` platform without copying gstack's user-home
authority model, provider assumptions, or host-specific behavior.

This plan is a complete adoption program. It covers planning, tasks, execution,
reviews, persistence, browser proof, design proof, safety overlays, adapters,
tests, CI, and closure. Individual implementation slices may be sequenced for
safety, but the target scope is the full operating model described here.

## Source Analysis

Observed source repository:

- `https://github.com/garrytan/gstack`
- local clone: `.tmp/gstack`
- tracked files inspected: `642`
- analyzed surfaces: root docs, skill templates, generated skills, `bin/`,
  `scripts/`, `hosts/`, `browse/`, `design/`, `make-pdf/`, `review/`, `qa/`,
  tests, CI, Supabase/GBrain support, safety overlays, and context/learning
  commands

## Governing Constraint

Accelerate remains the authority for itself.

GStack patterns may influence architecture, artifact contracts, scripts, and
workflow design only after they are adapted into this repository's own surfaces:

- `SKILL.md`
- `README.md`
- `core/`
- `adapters/`
- `profiles/`
- `onboarding/`
- `planning/`
- `skills/`
- `references/`
- `.accelerate/` templates emitted from this repository

Do not make `~/.gstack`, `~/.claude/skills/gstack`, external gstack skills, or
any user-home catalog authoritative for Accelerate behavior.

## Complete Goal

Accelerate should gain a complete artifact-first workflow operating model:

1. classify the request and harden ambiguity
2. create or reuse a durable local work item
3. persist a structured timeline of branch events
4. run product/strategy, architecture, design-system, DX, security, QA, and
   release reviews according to root classification
5. record decisions with one-way/two-way door semantics
6. persist task ledgers, execution status, review findings, defects, fixes,
   reproof, and final forensic closure
7. use browser truth and QA packets as first-class proof when UI or runtime
   behavior matters
8. support context save/restore so work can resume without chat-history
   reconstruction
9. support learnings and retros while keeping canonical doctrine separate from
   operational observations
10. validate all emitted artifacts, generated docs, adapter contracts, and local
    workspace layout through repository-owned tests

## Non-Goals

- Do not vendor gstack into Accelerate.
- Do not depend on gstack binaries for governed Accelerate behavior.
- Do not adopt `~/.gstack` as source of truth.
- Do not make GitHub, Linear, Greptile, Codex, Claude, Supabase, ngrok,
  Playwright, Bun, or browser extensions universal core dependencies.
- Do not claim browser/runtime adapters are live until their contracts and tests
  exist in this repository.
- Do not use auto-commit checkpointing as a default behavior.
- Do not weaken current Accelerate proof gates, design-system authority,
  componentization enforcement, or `.accelerate/` layout governance.

## Adoption Architecture

### Core Layer

Core owns provider-neutral governance:

- decision taxonomy
- one-way-door policy
- review finding schema
- QA report packet schema
- context checkpoint contract
- timeline event contract
- learning record contract
- safety overlay contracts
- review readiness dashboard contract
- browser truth contract
- generated-doc freshness rules
- CI/test enforcement requirements

### Workflow Adapter Layer

Workflow adapters own executable process mappings:

- local `.accelerate/` work-item lifecycle
- review pipeline orchestration
- ship readiness orchestration
- land/deploy orchestration when backend-specific adapters exist
- provider-backed issue/PR comment persistence when available

### Runtime Adapter Layer

Runtime adapters own concrete tool surfaces:

- browser automation
- model voices/subagents
- GitHub/GitLab/Linear/Jira/Notion
- PDF/doc generation
- telemetry/export if explicitly enabled
- host exports for Codex, Claude, OpenCode, Hermes, and others

### Planning Layer

Planning owns durable human-readable artifacts:

- executive plans
- task ledgers
- design/architecture/DX/security review plans
- decision audit trails
- context checkpoints
- acceptance and proof expectations

### Local Workspace Layer

The emitted `.accelerate/` workspace owns per-target operational state:

- current state
- readiness dashboard
- timeline
- work items
- review findings
- QA reports
- proof packets
- context checkpoints
- learnings
- question logs

Every new `.accelerate/` path must be allowlisted in the V2 materialization
contract and layout validator.

## Workstream 1: Decision Taxonomy And Question Registry

### Objective

Make root-owned decision handling explicit and persistent.

### Deliverables

- `core/control-plane/decision-taxonomy.md`
- `core/control-plane/question-registry.md`
- `core/control-plane/one-way-door-policy.md`
- `core/runtime-packets/decision-audit-trail.md`
- `.accelerate/status/questions.jsonl` in the local workspace template
- `.accelerate/status/question-preferences.json` in the local workspace template
- `onboarding/local-workspace/log-question.sh`
- `onboarding/local-workspace/check-question-preferences.sh`

### Required Semantics

- Every recurring question has a stable ID.
- Every recurring question declares category, options, default recommendation,
  and door type.
- One-way-door questions cannot be suppressed by preferences.
- User-stated preferences may suppress only reversible, low-risk questions.
- Tool-output-derived or web-page-derived preferences are never trusted.
- Decision audit trails record recommendation, selected option, rationale,
  source, rejected alternatives, and affected artifacts.

### Required One-Way Door Categories

- destructive filesystem operations
- force push or history rewrite
- production deploy or rollback
- schema migration or data deletion
- auth/session/security behavior
- billing/payment behavior
- PII export/import/deletion
- external API/provider write
- scope expansion
- user-visible behavior change with ambiguous intent
- skipping required proof

### Tests

- preferences cannot suppress one-way-door questions
- invalid question IDs fail validation
- question logs require source and selected option
- decision audit trails must name affected artifacts

## Workstream 2: Persistent Timeline And Operational State

### Objective

Persist branch/run state as append-only operational memory without making chat
history or user-home state authoritative.

### Deliverables

- `core/runtime-packets/timeline-event-schema.md`
- `core/runtime-packets/learning-record-schema.md`
- `.accelerate/status/timeline.jsonl`
- `.accelerate/status/learnings.jsonl`
- `.accelerate/status/checkpoints/`
- `onboarding/local-workspace/log-timeline-event.sh`
- `onboarding/local-workspace/read-timeline.sh`
- `onboarding/local-workspace/log-learning.sh`
- `onboarding/local-workspace/search-learnings.sh`
- updates to `check-workspace-layout.sh`
- updates to `validate-v2.sh`

### Required Timeline Events

- classification started/completed
- local workspace entry decision
- work item created/transitioned/linked
- plan opened/updated/approved
- task ledger created/updated
- review started/completed/stale
- defect found/fixed/reproofed
- browser proof captured
- QA report created
- closure packet created
- handoff summary updated

### Required Learning Fields

- type: `pattern`, `pitfall`, `preference`, `architecture`, `tool`,
  `operational`, `design-system`, `workflow`
- key
- insight
- source: `user-stated`, `observed`, `inferred`, `cross-review`
- confidence: `1-10`
- trust status
- evidence path or rationale
- decay/review date when applicable

### Doctrine Boundary

Learnings are operational observations. They do not override repo doctrine until
promoted into governed docs through an explicit plan or code change.

### Tests

- invalid timeline JSON fails
- unknown event types fail
- learning records require source/confidence
- untrusted learnings cannot become doctrine automatically
- `.accelerate/status/checkpoints/` is allowlisted and validated

## Workstream 3: Context Save And Restore

### Objective

Allow any session to reconstruct active work from durable artifacts rather than
conversation memory.

### Deliverables

- `core/runtime-packets/context-checkpoint-packet.md`
- `onboarding/local-workspace/save-context.sh`
- `onboarding/local-workspace/restore-context.sh`
- `.accelerate/status/checkpoints/README.md`
- updates to `handoff-summary.md` generation

### Required Checkpoint Fields

- timestamp
- branch
- active work item
- current phase
- source request
- governing plan
- task ledger
- files changed summary
- decisions made
- blockers
- remaining work
- proof already captured
- proof still required
- unsafe assumptions
- next recommended action

### Restore Behavior

- reads newest checkpoint by default
- supports work item or branch-specific restore
- reports stale checkpoint if HEAD changed since save
- never mutates code
- points to exact artifacts to read next

### Tests

- checkpoint creation includes all required fields
- restore fails clearly on missing checkpoint
- stale HEAD is reported
- restore never writes outside `.accelerate/status/checkpoints/`

## Workstream 4: Planning Review Pipeline

### Objective

Convert gstack's office-hours/autoplan/plan-review ladder into Accelerate's own
root-governed planning pipeline.

### Deliverables

- `core/planning/review-pipeline.md`
- `core/planning/strategy-review-contract.md`
- `core/planning/engineering-review-contract.md`
- `core/planning/design-system-review-contract.md`
- `core/planning/devex-review-contract.md`
- `core/planning/security-review-contract.md`
- `planning/execution/review-pipeline-task-ledger-template.md`
- `.accelerate/planning/review-pipeline.md` in V2 template

### Required Review Lanes

- Strategy/Product
- Engineering/Architecture
- Design-System/Premium UI
- Developer Experience
- Security/Risk
- Data/State/Persistence
- QA/Browser Proof
- Ship/Release Readiness

### Required Plan Sections

- source request
- user value and acceptance
- non-goals
- existing system leverage
- assumptions
- scope mode
- decision audit trail
- architecture/data-flow notes
- failure modes and rescue map
- test matrix
- browser proof expectations
- design-system contract expectations
- task ledger link
- review dashboard link
- closure requirements

### Scope Modes

- reduce scope
- hold scope
- selective expansion
- expansion

Scope change requires an explicit decision record.

### Tests

- plans with scope expansion require decision audit trail
- UI plans require design-system review lane
- developer-facing plans require DX lane
- security-sensitive plans require security lane
- plans missing proof expectations fail validation

## Workstream 5: Task Ledger And Execution State

### Objective

Make tasks executable, traceable, and reviewable across interruption,
subagents, correction loops, and closure.

### Deliverables

- `core/runtime-packets/task-ledger-schema.md`
- `planning/execution/full-task-ledger-template.md`
- `.accelerate/planning/task-ledger.md` in V2 template
- `onboarding/local-workspace/update-task-ledger.sh`
- validation in `validate-v2.sh`

### Required Task Fields

- stable task ID
- parent work item
- status
- owner/root/subagent
- source requirement
- files or surfaces expected
- proof required
- review required
- implementation notes
- defects found
- correction/reproof status
- closure status

### Required Statuses

- pending
- in_progress
- blocked
- implemented
- under_review
- needs_correction
- reproof_required
- accepted
- closed

### Tests

- invalid status fails
- closed task requires proof reference
- needs_correction requires defect reference
- subagent-owned task requires root integration review

## Workstream 6: Review Finding Schema And Review Packets

### Objective

Persist review findings as structured, deduplicable, evidence-backed records.

### Deliverables

- `core/runtime-packets/review-finding-schema.md`
- `core/review/fix-first-taxonomy.md`
- `.accelerate/review/findings.jsonl`
- `.accelerate/review/review-summary.md`
- `onboarding/local-workspace/log-review-finding.sh`
- `onboarding/local-workspace/check-review-findings.sh`
- updates to `prepare-review.sh`
- updates to `prepare-closure.sh`

### Required Finding Fields

- finding ID
- fingerprint
- severity
- confidence
- category
- path and line when applicable
- summary
- evidence
- exploit/repro scenario when applicable
- recommended fix
- classification: `auto-fix`, `ask`, `blocker`, `informational`
- reviewer or specialist
- status
- linked task or defect

### Required Categories

- security
- ownership/auth
- data migration
- API contract
- performance
- test gap
- maintainability
- design-system
- accessibility
- browser behavior
- documentation drift
- workflow/persistence

### Fix-First Policy

- mechanical, localized, low-risk findings may be auto-fixed
- security, data loss, production behavior, scope change, schema change,
  billing, auth, and user-visible ambiguity require explicit approval
- large fixes require a task ledger entry
- every auto-fix requires reproof

### Tests

- findings require fingerprint and confidence
- blocker findings require evidence
- ask findings cannot be marked fixed without decision reference
- duplicate fingerprints are detected
- closure fails with unresolved blocker findings

## Workstream 7: Review Readiness Dashboard

### Objective

Make closure readiness visible, stale-aware, and tied to branch/work-item truth.

### Deliverables

- `core/runtime-packets/review-readiness-dashboard.md`
- `.accelerate/status/readiness-dashboard.md` schema update
- `onboarding/local-workspace/render-readiness-dashboard.sh`
- integration with review findings, QA report, browser proof, and closure packet

### Required Dashboard Rows

- Classification
- Work Item
- Plan
- Task Ledger
- Strategy/Product Review
- Engineering Review
- Design-System Review
- DX Review
- Security Review
- QA/Browser Review
- Regression Proof
- Docs/Release Notes
- Closure Packet
- Handoff Summary

### Required Status Values

- not_required
- required_missing
- ready
- stale
- blocked
- accepted

### Staleness Rules

- review predates relevant code change
- QA predates relevant UI/runtime change
- plan predates scope change
- closure predates unresolved finding

### Tests

- stale reviews block closure
- required missing rows block closure
- dashboard references existing artifacts
- dashboard updates during prepare-review and prepare-closure

## Workstream 8: QA Report Packet And Browser Proof

### Objective

Turn browser truth into a structured QA artifact consumed by review and closure.

### Deliverables

- `core/runtime-packets/qa-report-packet.md`
- `.accelerate/review/qa-report.md` in template
- `.accelerate/review/browser-proof.md` schema update
- `onboarding/local-workspace/check-qa-report.sh`
- updates to `check-evidence-artifacts.sh`
- updates to `check-evidence-gate.sh`

### Required QA Fields

- target URL or local route
- branch and commit
- pages/flows tested
- environment
- screenshots/captures
- console evidence
- network evidence
- accessibility observations when applicable
- responsive evidence when applicable
- issues found
- fixes applied
- before/after evidence
- regression tests
- residual risks
- ship readiness

### Required Browser Truth Contract

- screenshot-only proof is insufficient for UI/runtime behavior
- console and network evidence are required unless explicitly not applicable
- proof paths must exist under target repo `.tmp/` or be explicit external/manual
  exceptions
- browser proof precedes persistent regression proof for unstable flows

### Tests

- QA report missing console/network evidence fails
- browser proof with nonexistent `.tmp/` paths fails
- design implementation proof without browser proof fails
- ship readiness cannot be ready with unresolved critical QA issues

## Workstream 9: Browser Runtime Adapter Contract

### Objective

Define the complete browser adapter contract inspired by gstack without claiming
an implementation before it exists.

### Deliverables

- `adapters/runtime/browser/README.md`
- `adapters/runtime/browser/capabilities.yaml`
- `adapters/runtime/browser/browser-truth-contract.md`
- `adapters/runtime/browser/command-registry-contract.md`
- `adapters/runtime/browser/security-boundary-contract.md`

### Required Capabilities

- navigate
- snapshot accessibility tree
- element refs
- screenshot
- console capture
- network capture
- form interaction
- responsive viewport capture
- state save/load with explicit sensitivity warnings
- path safety
- URL safety
- untrusted content boundary

### Security Requirements

- localhost-only by default
- scoped tokens for remote/shared sessions
- no root token over tunnel
- command allowlists for remote callers
- metadata IP and unsafe URL blocking
- safe directory model for file reads/writes
- no cookie values in logs

### Tests

- capability manifest validates
- command registry categories are present
- security contract forbids remote root-token command surface
- docs cannot claim a live adapter until executable validation exists

## Workstream 10: Design-System Workflow Adoption

### Objective

Adopt the valuable shape of gstack's design-review/shotgun/html pipeline while
keeping Accelerate's local design-system corpus and token authority.

### Deliverables

- `core/review/design-system-workflow-pipeline.md`
- `core/runtime-packets/design-approval-packet.md`
- `core/runtime-packets/design-feedback-packet.md`
- `core/runtime-packets/design-baseline-packet.md`
- `.accelerate/review/design-feedback.json`
- `.accelerate/review/design-approved.json`
- `.accelerate/review/design-baseline.json`
- updates to design-system artifact consistency checks

### Required Workflow

1. observe rendered truth
2. extract or verify design-system contract
3. compare against local design-system corpus and benchmark influence map
4. record design feedback
5. record approved direction
6. implement through contract owner surfaces
7. verify screenshots at required breakpoints
8. update proof packet and dashboard

### Accelerate-Specific Rules

- use repo-local design-system skills/corpus only as authority
- preserve `--ds-*` artifact token API for generated Accelerate artifacts
- require `Token Alias Map` when target app uses mature non-`--ds-*` token API
- do not clone external brands or use benchmark corpus as direct product UI
- page-level premiumization requires bounded exception if primitives/contracts are
  missing

### Tests

- approved design packet requires feedback source
- design baseline references screenshots
- premium work requires benchmark influence map
- token alias map is validated when target app has local token API

## Workstream 11: Safety Overlays

### Objective

Bring gstack's `careful`, `freeze`, and `guard` concepts into Accelerate as
repo-owned risk overlays.

### Deliverables

- `core/overlays/careful-command-policy.md`
- `core/overlays/edit-freeze-policy.md`
- `core/overlays/guard-policy.md`
- `core/runtime-packets/safety-overlay-state.md`
- `.accelerate/status/safety-overlay.yaml`
- `onboarding/local-workspace/set-safety-overlay.sh`
- `onboarding/local-workspace/check-safety-overlay.sh`

### Required Modes

- careful: warn/require confirmation for destructive commands
- freeze: restrict edits to declared paths
- guard: careful plus freeze

### Required Dangerous Classes

- destructive filesystem deletion
- hard reset/history rewrite
- force push
- database drop/truncate/destructive migration
- production deploy/rollback
- secret printing/export
- broad chmod/chown
- Docker/Kubernetes destructive cleanup
- package manager global mutation

### Tests

- destructive command class is detected
- freeze path outside allowed boundary fails
- guard requires both careful and freeze state
- overlay state cannot mark itself active without owner/path/reason

## Workstream 12: Runtime Adapter Registry

### Objective

Define a typed, declarative adapter registry inspired by gstack's host configs.

### Deliverables

- `adapters/runtime/adapter-registry-contract.md`
- `adapters/runtime/host-export-contract.md`
- `adapters/runtime/model-voice/capabilities.yaml`
- `adapters/runtime/codex/capabilities.yaml`
- `adapters/runtime/claude/capabilities.yaml`
- `adapters/runtime/opencode/capabilities.yaml`
- `adapters/runtime/hermes/capabilities.yaml`
- `onboarding/local-workspace/check-runtime-adapters.sh`

### Required Adapter Fields

- name
- type
- status: `planned`, `available`, `experimental`, `disabled`
- authority boundary
- install/export paths
- allowed tools
- suppressed capabilities
- path rewrites
- runtime files
- validation command
- proof artifacts emitted
- privacy/security notes

### Tests

- adapter manifests validate
- planned adapters cannot be described as live
- host-specific paths cannot appear in core doctrine as authority
- exports are outward/generated only

## Workstream 13: Workflow Adapter Expansion

### Objective

Complete the workflow adapter model using local `.accelerate/` as the reference
implementation and provider adapters as explicit mappings.

### Deliverables

- updates to `adapters/workflow/adapter-contract.md`
- updates to `adapters/workflow/local/`
- `adapters/workflow/github-pr/capabilities.yaml`
- `adapters/workflow/github-issues/capabilities.yaml`
- `adapters/workflow/linear/capabilities.yaml` refinement
- `adapters/workflow/provider-comment-contract.md`
- `adapters/workflow/provider-state-rehydration-contract.md`

### Required Workflow Adapter Capabilities

- create work item
- read work item
- transition lifecycle
- parent/child topology
- link review packet
- link QA packet
- link closure packet
- add correction/reproof comment
- rehydrate state after interruption
- report write failure without pretending success

### Tests

- local adapter remains the concrete reference
- remote adapters are manifest-validated
- planned remote adapters cannot claim write support
- provider comment contract includes review and closure packets

## Workstream 14: Ship And Land Separation

### Objective

Preserve a clean boundary between verified PR/readiness creation and production
merge/deploy behavior.

### Deliverables

- `core/control-plane/ship-readiness-gate.md`
- `core/control-plane/land-deploy-gate.md`
- `core/runtime-packets/ship-readiness-packet.md`
- `core/runtime-packets/deploy-verification-packet.md`
- `adapters/workflow/github-pr/ship-contract.md`
- `adapters/workflow/github-pr/land-deploy-contract.md`

### Ship Readiness Requires

- clean work item state
- no unresolved blocker findings
- tests/proof recorded
- QA/browser proof where applicable
- docs/release notes assessed
- review dashboard ready
- closure packet prepared

### Land/Deploy Requires

- explicit provider adapter
- CI status read
- deploy target identified
- first-run/danger confirmation when needed
- canary proof
- rollback/investigate options on failure

### Tests

- ship readiness cannot merge/deploy
- land/deploy cannot run without provider adapter contract
- stale review or QA blocks ship readiness

## Workstream 15: PDF And Document Export

### Objective

Support durable human-shareable exports of plans, review packets, QA reports, and
closure packets without making PDF generation required for every branch.

### Deliverables

- `adapters/runtime/document-export/README.md`
- `adapters/runtime/document-export/capabilities.yaml`
- `core/runtime-packets/document-export-packet.md`
- `onboarding/local-workspace/render-proof-document.sh`

### Required Export Contract

- stdout emits output path only when scripted
- stderr/progress is separated
- source markdown path is recorded
- generated file path is recorded
- export cannot execute embedded scripts
- external network assets disabled unless explicitly allowed

### Tests

- export packet references source and output
- generated file path must exist
- unsafe embedded HTML/script policy is documented

## Workstream 16: Generated Docs And Drift Prevention

### Objective

Adopt gstack's strongest test idea: generated or contract-derived docs must not
drift from source surfaces.

### Deliverables

- `scripts/check-generated-docs.sh`
- `scripts/check-doc-snippets.sh`
- `tests/generated-docs-integrity.sh`
- `tests/doc-snippet-integrity.sh`
- updates to doctrine integrity suite

### Required Checks

- referenced repo-local paths exist
- mentioned scripts exist and are executable when needed
- generated sections have source headers
- stale generated files fail tests
- governed docs do not cite user-home catalogs as authority
- external references are marked as references, not authority

### Tests

- broken script path in docs fails
- user-home authority reference fails
- stale generated output fails

## Workstream 17: Eval, Golden Fixtures, And Regression Budgets

### Objective

Create deterministic validation first, then optional expensive eval layers for
classification and workflow behavior.

### Deliverables

- `tests/fixtures/classification/`
- `tests/fixtures/review-findings/`
- `tests/fixtures/qa-reports/`
- `tests/classification-golden.sh`
- `tests/review-finding-schema.sh`
- `tests/qa-report-schema.sh`
- `tests/workflow-budget-regression.md`

### Required Fixture Classes

- trivial bounded change
- non-trivial architecture change
- UI/design-system change
- security-sensitive change
- workflow adapter change
- browser-proof-required change
- docs-only change

### Tests

- classification matrix matches expected lanes
- review packet fixtures validate
- QA packet fixtures validate
- optional eval reports record cost/turn/tool budget when model runs exist

## Workstream 18: Privacy, Sync, And Export Boundaries

### Objective

Extract gstack's allowlist/privacy-map idea without introducing hidden sync.

### Deliverables

- `core/control-plane/privacy-classification.md`
- `core/control-plane/export-allowlist-policy.md`
- `.accelerate/status/privacy-map.yaml`
- `onboarding/local-workspace/check-export-allowlist.sh`

### Privacy Classes

- public artifact
- internal operational artifact
- sensitive local proof
- secret-bearing prohibited artifact
- user-private preference
- generated export

### Required Rules

- export is opt-in
- allowlist beats denylist
- secrets never leave local workspace intentionally
- browser cookies/tokens are never exported
- telemetry/export must be explicit and locally visible

### Tests

- prohibited artifact cannot be exported
- unknown artifact class fails closed
- cookie/token patterns are blocked in export fixtures

## Workstream 19: Local Workspace Layout Governance

### Objective

Keep the emitted `.accelerate/` workspace schema-governed while adding the new
state surfaces this plan requires.

### Deliverables

- update `onboarding/local-workspace/check-workspace-layout.sh`
- update `onboarding/local-workspace/v2-materialization-contract.md`
- update `docs/architecture/accelerate-project-local-workspace-v2-contract.md`
- update V2 template directories/files

### Required Directory Additions

- `.accelerate/status/checkpoints/`

All other new state should fit existing allowlisted directories unless this
contract explicitly adds a path.

### Tests

- unknown `.accelerate/` directory fails validation
- required new files are emitted
- layout contract and validator stay in sync

## Workstream 20: CI Integration

### Objective

Make the full adoption enforceable by repository tests.

### Deliverables

- update `tests/doctrine-integrity.sh`
- add focused tests for each new schema/checker
- optional GitHub workflow docs for local CI layering
- validation command list in planning/readme docs

### Required Local Validation

- doctrine integrity
- local workflow adapter tests
- local workspace proof gates
- theme/template portability tests
- profile integrity
- generated docs integrity
- doc snippet integrity
- question registry tests
- review finding tests
- QA report tests
- workspace layout tests

### Required Closure Validation

The adoption is complete only when a full sequential run of `tests/*.sh` passes
and `git diff --check` reports no whitespace issues.

## Integrated Artifact Graph

The target artifact graph is:

```text
source request
  -> classification packet
  -> local work item
  -> timeline event
  -> planning review pipeline
  -> decision audit trail
  -> task ledger
  -> execution events
  -> review findings
  -> defect ledger
  -> QA/browser proof
  -> regression proof
  -> readiness dashboard
  -> closure packet
  -> handoff summary
  -> learning/retro records
```

No artifact in this graph depends on chat history for its truth.

## Required File Changes Summary

### New Core Artifacts

- `core/control-plane/decision-taxonomy.md`
- `core/control-plane/question-registry.md`
- `core/control-plane/one-way-door-policy.md`
- `core/control-plane/privacy-classification.md`
- `core/control-plane/export-allowlist-policy.md`
- `core/control-plane/ship-readiness-gate.md`
- `core/control-plane/land-deploy-gate.md`
- `core/planning/review-pipeline.md`
- `core/planning/strategy-review-contract.md`
- `core/planning/engineering-review-contract.md`
- `core/planning/design-system-review-contract.md`
- `core/planning/devex-review-contract.md`
- `core/planning/security-review-contract.md`
- `core/review/fix-first-taxonomy.md`
- `core/review/design-system-workflow-pipeline.md`
- `core/overlays/careful-command-policy.md`
- `core/overlays/edit-freeze-policy.md`
- `core/overlays/guard-policy.md`

### New Runtime Packets

- `core/runtime-packets/decision-audit-trail.md`
- `core/runtime-packets/timeline-event-schema.md`
- `core/runtime-packets/learning-record-schema.md`
- `core/runtime-packets/context-checkpoint-packet.md`
- `core/runtime-packets/task-ledger-schema.md`
- `core/runtime-packets/review-finding-schema.md`
- `core/runtime-packets/review-readiness-dashboard.md`
- `core/runtime-packets/qa-report-packet.md`
- `core/runtime-packets/design-approval-packet.md`
- `core/runtime-packets/design-feedback-packet.md`
- `core/runtime-packets/design-baseline-packet.md`
- `core/runtime-packets/safety-overlay-state.md`
- `core/runtime-packets/ship-readiness-packet.md`
- `core/runtime-packets/deploy-verification-packet.md`
- `core/runtime-packets/document-export-packet.md`

### New Adapter Contracts

- `adapters/runtime/adapter-registry-contract.md`
- `adapters/runtime/host-export-contract.md`
- `adapters/runtime/browser/README.md`
- `adapters/runtime/browser/capabilities.yaml`
- `adapters/runtime/browser/browser-truth-contract.md`
- `adapters/runtime/browser/command-registry-contract.md`
- `adapters/runtime/browser/security-boundary-contract.md`
- `adapters/runtime/model-voice/capabilities.yaml`
- `adapters/runtime/codex/capabilities.yaml`
- `adapters/runtime/claude/capabilities.yaml`
- `adapters/runtime/opencode/capabilities.yaml`
- `adapters/runtime/hermes/capabilities.yaml`
- `adapters/runtime/document-export/README.md`
- `adapters/runtime/document-export/capabilities.yaml`
- `adapters/workflow/github-pr/capabilities.yaml`
- `adapters/workflow/github-pr/ship-contract.md`
- `adapters/workflow/github-pr/land-deploy-contract.md`
- `adapters/workflow/github-issues/capabilities.yaml`
- `adapters/workflow/provider-comment-contract.md`
- `adapters/workflow/provider-state-rehydration-contract.md`

### New Local Workspace Scripts

- `onboarding/local-workspace/log-question.sh`
- `onboarding/local-workspace/check-question-preferences.sh`
- `onboarding/local-workspace/log-timeline-event.sh`
- `onboarding/local-workspace/read-timeline.sh`
- `onboarding/local-workspace/log-learning.sh`
- `onboarding/local-workspace/search-learnings.sh`
- `onboarding/local-workspace/save-context.sh`
- `onboarding/local-workspace/restore-context.sh`
- `onboarding/local-workspace/update-task-ledger.sh`
- `onboarding/local-workspace/log-review-finding.sh`
- `onboarding/local-workspace/check-review-findings.sh`
- `onboarding/local-workspace/render-readiness-dashboard.sh`
- `onboarding/local-workspace/check-qa-report.sh`
- `onboarding/local-workspace/set-safety-overlay.sh`
- `onboarding/local-workspace/check-safety-overlay.sh`
- `onboarding/local-workspace/check-runtime-adapters.sh`
- `onboarding/local-workspace/render-proof-document.sh`
- `onboarding/local-workspace/check-export-allowlist.sh`

### New Tests

- `tests/question-registry.sh`
- `tests/timeline-event-schema.sh`
- `tests/learning-record-schema.sh`
- `tests/context-checkpoint.sh`
- `tests/task-ledger-schema.sh`
- `tests/review-finding-schema.sh`
- `tests/review-readiness-dashboard.sh`
- `tests/qa-report-schema.sh`
- `tests/browser-runtime-adapter-contract.sh`
- `tests/design-workflow-packets.sh`
- `tests/safety-overlays.sh`
- `tests/runtime-adapter-registry.sh`
- `tests/ship-land-contract.sh`
- `tests/document-export-contract.sh`
- `tests/generated-docs-integrity.sh`
- `tests/doc-snippet-integrity.sh`
- `tests/classification-golden.sh`
- `tests/export-allowlist.sh`

## Execution Order

The implementation should proceed in dependency order:

1. workspace layout and V2 template additions
2. schema documents and runtime packets
3. local scripts that write/read/validate those packets
4. planning review pipeline contracts
5. task ledger integration
6. review findings and readiness dashboard
7. QA/browser proof packet integration
8. safety overlays
9. runtime and workflow adapter manifests
10. document export and privacy/export boundaries
11. generated-doc and snippet validation
12. golden fixtures and regression tests
13. doctrine integrity integration
14. full validation and closure packet

This order is sequencing, not scope reduction. The complete adoption includes all
workstreams above.

## Acceptance Criteria

The adoption is complete when:

- every deliverable listed in all workstreams exists or is intentionally folded
  into a named equivalent file
- V2 local workspace emits and validates all new state surfaces
- `.accelerate/` layout remains allowlisted and schema-governed
- review findings, decisions, QA reports, task ledgers, timeline events,
  learnings, checkpoints, and readiness dashboards validate independently
- core docs do not depend on user-home gstack paths as authority
- planned adapters are clearly marked as planned and cannot be mistaken for live
  behavior
- browser proof and QA packet rules remain stricter than screenshot-only proof
- design-system workflow remains tied to repo-local Accelerate corpus and token
  governance
- `for test_file in tests/*.sh; do bash "$test_file"; done` passes
- `git diff --check` passes

## Residual Risks

- The number of artifacts is large. Mitigate with schema validators and concise
  packet templates.
- Shell-based JSON/YAML validation can become brittle. Keep schemas simple until
  a stronger parser is justified.
- Runtime adapter docs can drift into claims of live behavior. Mitigate with
  manifest `status` fields and tests that block unsupported claims.
- Local operational memory can be confused with doctrine. Mitigate with explicit
  promotion rules for learnings.
- Safety overlays implemented as scripts cannot fully intercept every tool path.
  Treat them as enforceable local checks and policy packets until runtime-native
  hooks exist.

## Final Points

This plan imports the valuable parts of gstack as Accelerate-native governance:

- artifact-first workflow memory
- sequential plan review ladder
- decision audit trail
- one-way-door question registry
- append-only timeline
- structured learnings
- context save/restore
- task ledger execution state
- structured review findings
- fix-first taxonomy
- review readiness dashboard
- QA report packet
- browser truth contract
- design workflow packets
- safety overlays
- runtime adapter registry
- workflow adapter expansion
- ship/land separation
- document export packet
- generated-doc drift prevention
- golden fixtures and regression budgets
- privacy/export allowlist
- `.accelerate/` layout governance
- CI/test enforcement

The plan intentionally excludes direct gstack authority, user-home state as
doctrine, hidden telemetry/sync, and hardcoded provider dependencies.
