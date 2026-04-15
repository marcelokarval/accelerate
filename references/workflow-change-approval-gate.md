# Workflow Change Approval Gate

Use this module when a run is proposing to mutate the workflow itself instead
of only delivering product code.

Typical targets:

- `accelerate`
- adjacent workflow skills
- workflow enforcement docs
- stack-level workflow constitutions

## Purpose

This gate exists to stop silent control-plane mutation.

Repeated failures may justify workflow evolution, but they should not jump
directly from operator observation to merged workflow change without explicit
human approval.

## Trigger Conditions

Run this gate when the proposed change would alter:

- root orchestration behavior
- branch routing
- mandatory gates
- approval semantics
- adjacent workflow-skill responsibilities
- living docs that define workflow truth

Do not use it for ordinary feature work that merely consumes the workflow.

## Required Evidence Packet

Before approval, the proposal should make these things explicit:

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
   - whether repo seeds and `~/.codex/skills/` must both be updated

## Approval Rule

Workflow-level mutation requires explicit HITL approval before it can be
considered fully authorized.

The approval can be:

- direct user approval in the active session
- explicit approved issue policy already governing the exact mutation, but only
  when that policy itself is backed by prior explicit human approval

Absent one of those, the proposal may be analyzed and prepared, but should not
be treated as silently authorized.

Agent-authored issue creation, issue decomposition, or issue-detail expansion
does not count as approval by itself.

An issue can carry approved policy only when the approval pre-existed the
current mutation and can be traced back to explicit human authorization.

## Closure Rule

The gate is only complete when:

- the approval is explicit
- the evidence packet exists
- the change landed
- repo seeds and installed runtime mirrors were synchronized when relevant
- the updated docs and runtime references agree on the rule
