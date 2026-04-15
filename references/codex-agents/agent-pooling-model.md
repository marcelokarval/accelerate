# Agent Pooling Model

Use this module when `accelerate` must reason about the governed agent pool as
a living system instead of a flat list of available roles.

The purpose is to make pooling explicit:

- which families are always available to the root
- which families are conditional or specialist
- how the root should score fit before delegation
- how to avoid both role explosion and weak generic fallback

## Core Rule

The pool is a control-plane asset.

It is not a marketplace catalog and it is not an invitation to use agents
whenever one sounds approximately relevant.

The root should think in layers:

- manager lane pool
- core pool
- risk detection pool
- closure blocker pool
- issue topology pool
- evidence pool
- conditional pool
- future-gap pool

## Pool Layers

### 1. Manager Lane Pool

These are root-owned macro lanes, not runtime families:

- executive routing lane
- technical lane governor
- lifecycle lane governor
- design-contract lane governor
- proof lane governor
- trust lane governor

Use them to decide the next class of decision before choosing bounded
families.

### 2. Core Pool

These families cover the majority of recurring Prop4You work and should be the
first place `accelerate` looks for an honest fit:

- `lifecycle-product-manager`
- `django-inertia-technical-planner`
- `django-domain-implementer`
- `inertia-react-ui-implementer`
- `django-inertia-contract-integrator`
- `runtime-proof-auditor`
- `trust-anti-abuse-reviewer`

These roles are stable because they map directly to:

- the dominant stack
- recurring workflow branches
- recurring proof lanes
- recurring contract and abuse risks

### 3. Risk Detection Pool

These are continuous root lenses:

- decomposition-risk detector
- staffing-risk detector
- contract-risk detector
- proof-risk detector
- trust-risk detector
- lifecycle-risk detector
- rollout-risk detector

### 4. Closure Blocker Pool

These are formal blockers, not families:

- proof blocker
- trust blocker
- lifecycle blocker
- contract blocker
- rollout blocker

### 5. Issue Topology Pool

These are structural work shapes:

- single issue
- sibling issues
- parent + child
- parent + child + review lane

### 6. Evidence Pool

These define proof classes:

- implementation evidence
- backend/frontend QA evidence
- browser-truth evidence
- persistent regression evidence
- forensic closure evidence

### 7. Conditional / Specialist Pool

These families are valid, but should not be treated as default choices:

- `legacy-truth-analyst`

The root should activate them only when the branch genuinely needs the
specialty.

### 8. Future-Gap Pool

These are not approved families yet. They are likely future additions if the
pool proves insufficient:

- async workflow stewardship
- provider-boundary auditing
- migration stewardship

Treat them as placeholders for gap analysis, not pre-approved runtime roles.

## Fit Scoring Dimensions

Before delegating, the root should score candidate families on these
dimensions:

### Surface fit

Does the family own the dominant technical or runtime surface?

Examples:

- backend mutation -> `django-domain-implementer`
- shell churn or redirect truth -> `runtime-proof-auditor`
- contract drift between backend and page -> `django-inertia-contract-integrator`

### Phase fit

Is the family right for the current phase?

Examples:

- planning role during `Plan`
- mutation role during `Execute`
- runtime proof role during `Prove`

### Risk fit

Does the family know how to judge the real risk center?

Examples:

- abuse-sensitive flow -> `trust-anti-abuse-reviewer`
- contract-sensitive flow -> `django-inertia-contract-integrator`

### Write-scope fit

Is the write posture honest?

Examples:

- evidence-only reviewer should usually stay read-only
- bounded implementation worker must have clear write scope

### Integration cost

Will this delegation reduce burden, or merely shift it back to the root with
extra coordination?

If integration cost is high and fit is only partial, that is often a sign to
keep the work local or classify it as a gap.

## Pooling Rules

### Prefer the core pool first

If a core family has a strong fit, prefer it over:

- a specialist family
- a future-gap placeholder
- a generic conceptual role from an external donor

### Do not bypass a better fit because of title language

If the task says "backend" but the real problem is a backend/frontend contract,
the pool should choose `django-inertia-contract-integrator`, not the least-wrong
backend worker.

### Keep specialist roles cold by default

Specialist families should not become routine choices just because they exist.

Repeated activation of a specialist for common work is a signal that either:

- a core family is underspecified
- or a new core family is needed

## Pool Health Signals

The pool is healthy when:

- manager lanes open predictably before family selection
- most recurring tasks land on one core family or one clean two-family
  composition
- the root rarely needs to compensate manually for missing specialty
- specialist families stay truly exceptional
- the same branch does not oscillate between different families across runs

The pool is unhealthy when:

- manager-lane work is silently pushed into bounded families
- common work keeps needing three-family compositions
- specialist families become routine
- the root repeatedly patches missing semantics in commentary
- families overlap so much that routing becomes arbitrary

## Relationship To Gap Detection

Pooling and gap detection are related but different.

- pooling asks: what is the best fit in the current pool?
- gap detection asks: is the current pool itself insufficient?

Use `agent-gap-detection.md` only after the pool has been evaluated honestly and
no strong fit exists.

## Replay-Backed Pressure Points

Scenario replay shows the current pool behaves well for:

- issue shaping
- backend mutation
- frontend mutation
- contract correction
- runtime/browser proof
- trust review
- legacy truth extraction

Scenario replay also shows three repeatable pressure points that the current
pool should treat as future-gap candidates instead of weak fits:

- Celery/Redis-heavy async workflow correctness
- provider-boundary truth and leakage review
- rollout-sensitive schema/data migration stewardship
