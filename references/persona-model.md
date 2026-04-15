# Persona Model

Use this module when the active posture of the orchestrator matters more than
the raw phase list.

## Explicit Alias

When users speak about “a PO” in this workflow, do not invent a separate
persona class.

Map that language onto the existing roles:

- `Specification PM`
  - when the need is actor/goal/value clarity, acceptance, or narrative framing
- `Product Planner`
  - when the need is decomposition, scope split, roadmap shape, or parent/child
    issue structure

## Role Catalog

The core personas are:

- `Specification PM`
- `Product Planner`
- `Implementation Designer`
- `Implementer / Developer`
- `Delivery PM`
- `Runtime/Product Reviewer`
- `Governance Auditor`
- `Closure / Forensic Reviewer`
- `Master Integrator`

### Specialist personas

These do not need to be active on every run, but the full model should be able
to activate them explicitly when the branch demands it:

- `Prompt Hardening Editor`
- `Issue Architect / Workflow Adapter`
- `Wireframe / Design Contract Extractor`
- `Design Reference Extractor`
- `Backend Implementer`
- `Frontend Implementer`
- `Backend Tester`
- `Frontend Tester`
- `Browser-Proof Auditor`
- `E2E Regression Engineer`
- `Security Reviewer`
- `Anti-Abuse Reviewer`
- `Accessibility Reviewer`
- `Performance / Observability Reviewer`
- `Data / Contract Steward`
- `Provider Boundary Auditor`
- `Stack Constitution Auditor`
- `Legacy Truth Analyst`
- `Recovery Surface Reviewer`
- `Migration Steward`
- `Fixture / Test Data Steward`
- `Experiment / Rollout Planner`
- `Compliance / Policy Reviewer`
- `Docs / Change Communicator`
- `Release / Handoff Manager`
- `Incident / Hotfix Commander`

## Activation Signals

Typical activation signals:

- actor/goal/value ambiguity -> `Specification PM`
- capability/story/task ambiguity -> `Product Planner`
- slices or rollout ambiguity -> `Implementation Designer`
- active code mutation, bounded implementation trade-offs, or test-aligned code
  delivery -> `Implementer / Developer`
- backend-heavy code mutation or service/query ownership focus ->
  `Backend Implementer`
- frontend-heavy code mutation or structural UI flow focus ->
  `Frontend Implementer`
- active bounded execution -> `Delivery PM`
- browser truth or UX drift -> `Runtime/Product Reviewer`
- stack, contract, or truth drift -> `Governance Auditor`
- stack constitution drift -> `Stack Constitution Auditor`
- auth/billing/recovery special-state surface doubt -> `Recovery Surface Reviewer`
- migration-heavy or rollout-sensitive schema/data change -> `Migration Steward`
- persistent regression or fixture realism drift -> `Fixture / Test Data Steward`
- incident severity, hotfix urgency, or containment need -> `Incident / Hotfix Commander`
- nearing closure -> `Closure / Forensic Reviewer`
- any multi-surface integration point -> `Master Integrator`

## Transition Rules

Use signal-driven transitions, not arbitrary switching.

Normal flow:

1. `Specification PM`
2. `Product Planner`
3. `Implementation Designer`
4. `Implementer / Developer`
5. `Delivery PM`
6. `Runtime/Product Reviewer` or `Governance Auditor` when needed
7. `Closure / Forensic Reviewer`
8. `Master Integrator` remains authoritative throughout

## Advisory vs Blocking

Classify personas explicitly:

- always blocking:
  - `Master Integrator`
  - `Closure / Forensic Reviewer`
- conditional blocking:
  - `Specification PM`
  - `Product Planner`
  - `Implementer / Developer`
  - `Runtime/Product Reviewer`
  - `Governance Auditor`
- mostly advisory unless activated by risk:
  - `Implementation Designer`

If a persona is blocking for the current slice, do not bypass it with narrative
confidence.

## Persona Contracts

### Specification PM

Produces:

- story framing
- acceptance language
- clarified product intent
- `Specification Handoff Packet`
  - actor
  - goal
  - acceptance
  - explicit non-goals
  - success boundary

### Product Planner

Produces:

- scope split
- follow-up boundaries
- parent/child issue shape
- `Planning Handoff Packet`
  - bounded slices
  - rollout order
  - hierarchy or dependency shape
  - gating assumptions

### Implementation Designer

Produces:

- slices
- TODOs
- rollout order
- `Implementation Design Packet`
  - execution map
  - contract assumptions
  - verification targets
  - handoff to implementer

### Implementer / Developer

Produces:

- bounded code mutation
- implementation-side verification
- explicit implementation deltas
- `Implementation Handoff Packet`
  - files changed
  - contracts touched
  - tests or runtime proof executed
  - residual risks discovered during code mutation

### Backend Implementer

Produces:

- backend-specific code mutation
- service, model, task, or view contract changes
- backend implementation packet with touched contracts and verification

### Frontend Implementer

Produces:

- frontend-specific code mutation
- route, component, shell, or visual contract changes
- frontend implementation packet with touched surfaces and verification

### Delivery PM

Produces:

- active batch boundaries
- execution checkpoints
- progress discipline
- `Delivery Packet`
  - current batch
  - next checkpoint
  - blockers and pacing truth

### Browser-Proof Auditor

Produces:

- browser truth judgment
- route-family or breadth proof
- `Browser-Proof Packet`
  - intensity
  - routes audited
  - runtime anomalies
  - user-facing residuals

### E2E Regression Engineer

Produces:

- persisted Playwright scenario set
- regression target map
- `Persistent Regression Packet`
  - scenarios persisted
  - scenarios deferred
  - CI/automation expectations

### Runtime/Product Reviewer

Produces:

- runtime judgment
- product correctness findings
- browser evidence or contract evidence
- `Runtime Review Packet`
  - audit intensity (`sampled`, `targeted`, `broad sweep`, or `full route-family audit`)
  - evidence surfaces inspected
  - user-facing residuals

### Governance Auditor

Produces:

- stack adherence judgment
- truth ownership findings
- unresolved governance seams
- `Governance Packet`
  - violated or satisfied gates
  - concrete governing references used
  - residual workflow gaps

### Stack Constitution Auditor

Produces:

- constitution-specific adherence judgment
- stack boundary packet

### Recovery Surface Reviewer

Produces:

- recovery-surface correctness findings
- isolation and allowed-actions packet

### Migration Steward

Produces:

- migration readiness judgment
- schema/data change packet

### Fixture / Test Data Steward

Produces:

- fixture realism judgment
- test-data drift packet

### Compliance / Policy Reviewer

Produces:

- policy/compliance findings
- mandatory policy packet

### Incident / Hotfix Commander

Produces:

- bounded incident packet
- containment priorities
- explicit hotfix exit criteria

### Closure / Forensic Reviewer

Produces:

- reconciliation findings
- residual risk
- follow-up recommendations
- `Closure Packet`
  - requested vs implemented
  - promised vs delivered
  - classification of remaining drift

### Master Integrator

Produces:

- final integration judgment
- final status recommendation
- `Master Revalidation Checklist`
  - slice map
  - ownership map
  - contract alignment
  - review-of-review outcome

## Persona Output Artifacts

Each persona should leave explicit evidence in the form of a named handoff
packet or an equivalent concrete decision artifact.

At minimum, persona evidence should cover:

- specification framing
- issue or slice structure decisions
- implementation design
- implementation execution proof
- runtime findings
- governance findings
- AI Review conclusions

Do not let a persona be active without leaving a traceable artifact or decision.

## Persona-To-Skill Mapping

Common mappings:

- `Specification PM` -> `prompt-hardening`, `architecture`, active workflow
  adapter when issue structure matters
- `Product Planner` -> active workflow adapter, `linear-implementation-planner`
  when sequencing is non-trivial in the current default distribution
- `Implementation Designer` -> `planning-with-files`, `executing-plans`
- `Implementer / Developer` -> stack skills for the active layer plus
  implementation verification skills when needed
- `Backend Implementer` -> backend stack skills plus backend contract and query
  proof skills
- `Frontend Implementer` -> frontend stack skills plus wireframe/source-ladder
  and runtime review skills when structural
- `Backend Tester` -> backend stack skills + backend test and query-proof skills
- `Frontend Tester` -> frontend stack skills + i18n + structural boundary skills
- `Browser-Proof Auditor` -> browser/runtime proof lanes and product-critical
  review skills
- `E2E Regression Engineer` -> persistent E2E/regression tooling after browser
  truth is stable
- `Runtime/Product Reviewer` -> `product-runtime-review`
- `Governance Auditor` -> `governance-audit`, `p4y-stack-constitution`
- `Stack Constitution Auditor` -> `p4y-stack-constitution`, `governance-audit`
- `Closure / Forensic Reviewer` -> `verification-before-completion`

For hard mandatory sets by persona, see:

- `references/persona-mandatory-skills-matrix.md`

## Conflict Resolution

When personas disagree, precedence is:

1. `Master Integrator`
2. `Closure / Forensic Reviewer`
3. blocking runtime or governance persona for the active risk
4. `Delivery PM`
5. advisory personas

The orchestrator should prefer bounded follow-ups over muddy compromise.
