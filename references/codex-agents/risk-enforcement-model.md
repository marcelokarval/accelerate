# Risk Enforcement Model

Use this module when `accelerate` must treat risk as an active control-plane
function rather than as narrative caution.

This file defines the rule set.

The operational per-risk table now lives in:

- `risk-enforcement-matrix.md`

## Core Rule

Relevant risk must always have:

- detector
- signal
- owner
- blocker condition
- release condition

If one of these is missing, the risk is not yet operationalized.

## Risk Classes

### Decomposition risk

The work is split incorrectly or not split when it should be.

### Staffing risk

The selected family or composition creates integration burden, boundary drift,
or pseudo-fit.

### Contract risk

Backend/frontend truth, identifiers, props, routes, or validation authority are
misaligned.

### Proof risk

Evidence is missing, weak, or the wrong proof layer was used.

### Trust risk

Misuse-path, replay, enumeration, abuse, auth, billing, recovery, export, or
similar hostile-path risk is under-reviewed.

### Lifecycle risk

Acceptance, issue shape, parent/child truth, or non-goals are unstable.

### Rollout risk

Migration, rollout, release, or data-evolution safety is materially weak.

## Enforcement Rule

When a risk class becomes dominant, the corresponding lane or blocker must
activate.

Do not merely mention the risk and continue normally.

Use the matrix to decide the exact owner, blocker, release condition, and lane.
