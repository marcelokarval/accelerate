# Agent Selection Policy

Use this module when `accelerate` must decide:

- whether delegation is justified at all
- which governed family best fits the slice
- whether one family is enough or a paired composition is required
- whether the work should remain master-owned

This policy sits on top of:

- `agent-ontology.md`
- `agent-capability-matrix.md`
- `subagent-model.md`
- `workflow-catalog.md`
- `issue-topology-policy.md`
- `root-vs-agent-authority-boundary.md`
- `lane-governance-model.md`

## Core Rule

Selection is a control-plane decision, not an implementation convenience.

The root should never pick an agent only because:

- the agent name sounds close to the task
- the task mentions a technology keyword
- the root wants to avoid doing classification work

The root should pick the smallest honest fit that preserves:

- bounded ownership
- bounded write scope
- bounded completion contract
- lower integration burden than local execution

## Scenario-First Rule

Before selecting a family, the root should first packet the slice as an
`accelerate` scenario:

- branch
- issue topology
- active lane
- active persona
- active skills
- gates
- proof lane

Do not choose a family first and then backfill a matching persona story.

Selection should follow the observed control-plane posture, not replace it.

## Selection Ladder

Evaluate in this order:

1. Is the slice still master-owned?
2. Which issue topology is honest?
3. Which lane or lanes must be open?
4. Is delegation justified?
5. Which family has the cleanest dominant-surface fit?
6. Does the slice also require a second proof or audit family?
7. Is the current pool insufficient, making this a gap instead of a fit?

Do not skip steps.

## Step 1. Master-Owned Check

Keep the work at the root when the dominant need is:

- global integration judgment
- final closure judgment
- final cross-slice reconciliation
- delivery pacing across the whole run
- lane-governor judgment
- blocker opening or release

These remain master-owned by default:

- `Master Integrator`
- `Closure / Forensic Reviewer`
- `Delivery PM`

If one of these is the real need, do not delegate the slice just to create the
appearance of agent usage.

## Step 2. Delegation Justification Check

Delegation is justified only when all are true:

- the slice is bounded
- the expected output is explicit
- the write scope is clear or read-only
- the root is not blocked on immediate critical-path local action
- the integration burden is lower than the expected gain

When these conditions fail, keep the work local and emit a visible
`single-threaded exception` when the run is otherwise non-trivial.

## Step 3. Dominant-Surface Fit

Pick the family whose dominant surface best matches the real center of gravity:

- issue shape, acceptance, execution-ready structure
  - `lifecycle-product-manager`
- decomposition, planning, cross-stack sequencing
  - `django-inertia-technical-planner`
- backend mutation
  - `django-domain-implementer`
- frontend mutation
  - `inertia-react-ui-implementer`
- contract or boundary repair between backend and frontend
  - `django-inertia-contract-integrator`
- browser/runtime proof
  - `runtime-proof-auditor`
- abuse/trust review
  - `trust-anti-abuse-reviewer`
- legacy truth extraction
  - `legacy-truth-analyst`

If the task title points one way but the risk/ownership points another way,
prefer ownership and risk over the title language.

When replay shows `Data / Contract Steward`, `Runtime/Product Reviewer`, or
`Browser-Proof Auditor` as the real center of gravity, route accordingly even
if the initial prompt used generic technology language.

## Step 4. Composition Rules

Use one family when:

- one dominant surface exists
- the proof lane is obvious and can remain local
- the bounded slice does not cross a major contract boundary

Use two families when:

- one family mutates and another family must prove or audit
- the task is really a contract problem between backend and frontend
- the task needs both framing and bounded execution without granting global
  authority to one role

Preferred pairings:

- `django-domain-implementer` + `runtime-proof-auditor`
- `inertia-react-ui-implementer` + `runtime-proof-auditor`
- `django-domain-implementer` + `trust-anti-abuse-reviewer`
- `inertia-react-ui-implementer` + `trust-anti-abuse-reviewer`
- `django-inertia-technical-planner` + `django-inertia-contract-integrator`
- `lifecycle-product-manager` + `django-inertia-technical-planner`

Avoid three-family compositions unless the slice is clearly worth the
coordination overhead. Repeated need for three-family compositions is a gap
signal.

## Step 5. Gap Instead Of Fit

Treat the task as a pool gap when:

- no family can own it without stretching beyond its boundary
- repeated awkward compositions are required for the same class of work
- the root keeps manually compensating for a missing specialty
- the workflow catalog exposes a stable repeated branch with no honest family

If it is a gap:

- do not force a least-wrong family
- keep the current run honest
- feed the missing specialty into the `codex-agent-architect` capability owned
  by `accelerate`

## Anti-Patterns

Do not:

- choose `django-domain-implementer` for contract work just because backend is
  involved
- choose `inertia-react-ui-implementer` for shell churn that really needs
  runtime proof
- choose `trust-anti-abuse-reviewer` to perform a general code review
- choose `legacy-truth-analyst` for direct implementation ownership
- choose `lifecycle-product-manager` to substitute for root-level master
  planning

## Output Requirement

When a family is selected, the root should make the choice visible in the
delegation packet:

- selected family
- why it is the fit
- bounded scope
- write scope
- required skills
- completion contract
- explicit note that issue topology and lane authority remain root-owned
- explicit note when composition was chosen instead of a single-family fit
