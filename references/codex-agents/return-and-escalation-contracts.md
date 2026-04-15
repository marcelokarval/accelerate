# Return and Escalation Contracts

Use this module when `accelerate` must define who receives the next decision
after a bounded slice completes or fails.

## Core Rule

Return routing follows constitutional ownership, not edit recency.

## Return Patterns

### Specialist -> lane governor

Use when:

- the specialist executed or reviewed a bounded slice
- the next decision is still within the same lane

Examples:

- implementation worker -> technical lane governor
- runtime reviewer -> proof lane governor
- trust reviewer -> trust lane governor

### Lane governor -> root

Use when:

- lane-local work is complete
- the next decision affects global integration, closure, or staffing

### Implementation -> lifecycle lane

Use when:

- implementation changed acceptance truth
- child work reveals parent issue drift

### Implementation -> design-contract lane

Use when:

- execution exposed unresolved interface ambiguity

### Proof or trust -> implementation

Use when:

- findings require bounded remediation
- the request is still valid but the slice is incomplete

### Any lane -> root

Use when:

- topology must change
- staffing must change
- a new blocker class opened

## Reentry Rule

Reentry into the parent issue is mandatory when:

- acceptance changes materially
- child set no longer matches the parent
- closure of a child would misrepresent the state of the parent outcome

