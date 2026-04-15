# Issue Topology Policy

Use this module when `accelerate` must decide the shape of the execution graph
before staffing bounded agents.

## Core Rule

Issue topology is a control-plane decision, not an implementation convenience.

The root must decide the work shape before choosing bounded executors.

## Supported Shapes

### Single issue

Use when:

- one outcome exists
- one dominant acceptance set exists
- the work is bounded enough to remain one execution package

### Sibling issues

Use when:

- the prompt bundles materially distinct problems
- the work has different owners, acceptance criteria, or timing
- closing one should not imply closing the other

### Parent + child issues

Use when:

- one larger outcome exists
- bounded slices can be executed independently
- lifecycle truth benefits from a single parent

### Parent + child + review lane issues

Use when:

- implementation slices exist
- plus an additional review or rollout lane deserves its own execution surface

Examples:

- rollout-sensitive migration
- dedicated proof follow-up
- release-readiness follow-up

## Decision Rules

Choose `single issue` when:

- the root can still reason about the whole change as one clean package

Choose `sibling issues` when:

- the prompt only looked related, but the actual work is not one lifecycle
  package

Choose `parent + child` when:

- one parent outcome exists and bounded slices should report upward into that
  same lifecycle truth

Choose `parent + child + review lane` when:

- the review, rollout, or migration risk deserves separate visibility and
  return contracts

## Topology Anti-Patterns

Do not:

- keep one giant issue because splitting feels administratively expensive
- create sibling issues when one parent outcome clearly exists
- use dependency links as a substitute for real parent/child structure
- let a bounded agent decide topology mid-execution

