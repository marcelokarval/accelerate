# Workflow Change Approval Gate

## Purpose

This gate stops silent control-plane mutation.

It is the approval step used by `core/workflows/self-evolution.md` and
`core/workflows/maturity-control.md` when repeated failure evidence is being
promoted into workflow truth.

Use it when a run is proposing to change:

- root orchestration behavior
- branch routing
- mandatory gates
- approval semantics
- workflow enforcement docs
- adjacent workflow-skill responsibilities
- living docs that define workflow truth

Ordinary feature work that merely consumes the workflow does not use this gate.

Typical targets:

- `accelerate`
- adjacent workflow skills
- workflow enforcement docs
- stack-level workflow constitutions
- living docs that determine branch, proof, issue, approval, or closure truth

## Required Evidence Packet

Before approval, make these things explicit:

1. `Failure Capture`
   - what failed
   - where it failed
   - what the user, reviewer, or runtime observed
2. `Root Cause Classification`
   - `missing-rule`
   - `enforcement-failure`
   - `routing-failure`
   - `review-failure`
   - `closure-failure`
   - `execution-drift`
3. `Pattern Test`
   - isolated or repeated
   - previous examples
   - affected branches or surfaces
4. `Promotion Target`
   - root skill
   - adjacent skill
   - living docs
   - constitution
5. `Why This Level`
   - why the change belongs at this layer rather than a smaller one
6. `Validation Plan`
   - how the change will be verified
   - include whether native docs, repo seeds, quick maps, and optional runtime
     exports must all be updated together

## Approval Rule

Workflow-level mutation requires explicit HITL approval before it is fully
authorized.

The approval can be:

- direct user approval in the active session
- explicit approved issue policy already governing the exact mutation, when
  that policy itself traces back to prior explicit human approval

Agent-authored issue creation, issue decomposition, or issue-detail expansion
does not count as approval.

An issue can carry approved policy only when the approval pre-existed the
current mutation and can be traced back to explicit human authorization.

## Closure Rule

This gate is only complete when:

- approval is explicit
- the evidence packet exists
- the change landed
- repo seeds were synchronized with optional runtime exports only when export was
  explicitly in scope
- the updated docs and runtime references agree on the rule
