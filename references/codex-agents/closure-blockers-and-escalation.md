# Closure Blockers and Escalation

Use this module when `accelerate` must decide whether a slice can proceed
toward closure or must be blocked and escalated.

This file defines blocker semantics.

For the unified per-risk operational table, use:

- `risk-enforcement-matrix.md`

## Blocker Pool

- `proof blocker`
- `trust blocker`
- `lifecycle blocker`
- `contract blocker`
- `rollout blocker`

## Blocker Rules

### Proof blocker

Activate when:

- mandatory evidence is missing
- proof order is wrong
- verification claims are vague

Release when:

- the required proof stack is present and coherent

### Trust blocker

Activate when:

- hostile-path risk is material and unresolved

Release when:

- trust posture is explicitly revalidated

### Lifecycle blocker

Activate when:

- issue shape or acceptance is too unstable for honest closure

Release when:

- lifecycle lane confirms issue truth is clean again

### Contract blocker

Activate when:

- route, prop, identifier, or validation-boundary truth is unresolved

Release when:

- contract correctness is explicitly proven

### Rollout blocker

Activate when:

- migration, data evolution, or staged rollout safety is weak

Release when:

- rollout safety has explicit evidence and recovery posture

## Escalation Rule

When a blocker opens, the slice returns to:

- the owning lane governor
- or to the root when the lane is root-owned

Do not let a bounded agent self-clear its own blocker without explicit root or
lane-governor judgment.
