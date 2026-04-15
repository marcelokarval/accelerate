# Agent Selection Policy

Selection is a control-plane decision, not an implementation convenience.

Use this policy when the root must decide:

- whether delegation is justified
- which family fits best
- whether composition is better than a single family
- whether the work should remain root-owned

## Core Rule

Pick the smallest honest fit that preserves:

- bounded ownership
- bounded write scope
- bounded completion contract
- lower integration burden than local execution

Do not choose a family only because:

- the title sounds close
- the task mentions a technology keyword
- delegation feels aesthetically cleaner

## Selection Ladder

Evaluate in this order:

1. is the slice still root-owned?
2. which issue topology is honest?
3. which lane or lanes must be open?
4. is delegation justified at all?
5. which family has the cleanest dominant-surface fit?
6. does the slice also need a second proof or audit family?
7. is the current pool insufficient, making this a gap instead of a fit?

## Root-Owned Check

Keep work at the root when the dominant need is:

- global integration judgment
- final closure judgment
- cross-slice reconciliation
- lane-governor judgment
- blocker opening or release

## Delegation Justification

Delegation is justified only when all are true:

- the slice is bounded
- the expected output is explicit
- the write scope is clear or explicitly read-only
- the root is not blocked on immediate critical-path local action
- the integration burden is lower than the expected gain

If these fail, keep the work local and emit a visible single-threaded
exception when the run is otherwise non-trivial.

## Dominant-Surface Fit

Choose based on the real center of gravity:

- issue shape and acceptance -> `lifecycle-product-manager`
- decomposition and planning -> `django-inertia-technical-planner`
- backend mutation -> `django-domain-implementer`
- frontend mutation -> `inertia-react-ui-implementer`
- contract or boundary repair -> `django-inertia-contract-integrator`
- browser/runtime proof -> `runtime-proof-auditor`
- abuse/trust review -> `trust-anti-abuse-reviewer`
- legacy truth extraction -> `legacy-truth-analyst`

Ownership and risk outrank the task title.

## Composition Rules

Prefer two-family compositions only when they materially improve honesty:

- implementation + runtime proof
- implementation + trust review
- technical planning + contract integration
- lifecycle framing + technical planning

If repeated three-family compositions are needed for the same class of work,
treat that as a gap signal.

## Gap Instead Of Fit

If no family can own the slice without boundary stretch:

- do not force the least-wrong role
- keep the current run honest
- feed the gap into the root agent-factory planning path

## Output Requirement

When a family is selected, the root should leave visible truth:

- selected family
- why it fits
- bounded scope
- write scope
- required skills
- completion contract
- explicit note that topology and lane authority remain root-owned
