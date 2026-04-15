# Agent Gap Detection

Use this module when `accelerate` must judge whether the current governed pool
of global Codex agents is insufficient.

The purpose is to stop two failure modes:

1. forcing a weak fit because "some agent is better than none"
2. creating new agents too casually because a task felt slightly awkward

## Core Rule

A gap is a repeated missing bounded specialty, not a momentary discomfort.

The root should call a gap only when the current pool cannot cover a stable
class of work without recurring distortion.

## Empirical Replay Rule

Prefer promoting a gap only after replay across representative stack scenarios
shows the same missing specialty more than once or shows one scenario class
with no honest owner at all.

Do not promote a gap from donor aesthetics alone.

## Strong Gap Signals

Treat the pool as insufficient when one or more of these patterns repeat:

### 1. Repeated awkward composition

The same class of task keeps needing three-family composition to behave
honestly.

Examples:

- async workflow changes needing backend mutation, queue correctness, and
  observability judgment every time
- provider-backed flows repeatedly needing contract, runtime, and
  provider-boundary review together

### 2. Repeated root compensation

`accelerate` keeps supplying the same missing specialty manually.

This means the root is acting as an unformalized role instead of merely
classifying and integrating.

### 3. Honest fit never exists

The dominant surface is stable and recurring, but no family can own it without:

- boundary stretch
- repeated partial fits
- write-scope confusion
- poor completion contracts

### 4. Workflow branch has no family coverage

A stable branch in `workflow-catalog.md` remains recurrent, but no governed
family covers it cleanly.

### 5. Misrouting keeps happening

The same kind of task repeatedly gets routed to different families and still
needs correction after start.

That means the ontology is underspecified, not that operators need to "be more
careful."

## Weak Signals That Are Not Enough

Do not call a gap merely because:

- an external donor repo has a nice TOML for that role
- Paperclip has a job title that sounds similar
- a single issue was awkward once
- a role would feel organizationally elegant
- a technology term appears frequently in prompts

## Gap Classification

When a gap is real, classify it before proposing a new family.

### Type A: Surface gap

A recurring dominant surface has no honest owner.

Examples:

- Celery/Redis orchestration correctness
- provider boundary truth
- rollout-sensitive migration stewardship

### Type B: Proof-lane gap

Implementation is covered, but the review/proof lane is repeatedly missing.

Examples:

- repeated need for async runtime verification
- repeated need for provider-facing audit beyond generic trust review

### Type C: Integration gap

The missing role is not implementation or review alone, but a cross-boundary
integration specialist.

Examples:

- external-provider contract normalization
- durable multi-system state alignment

## Recommended First Future Gaps

These are plausible next candidates if the current pool proves insufficient:

- `async-workflow-steward`
  - for Celery/Redis-heavy orchestration, retry semantics, idempotency, and
    queue correctness
- `provider-boundary-auditor`
  - for recurring external-service/source-of-truth/provider leakage work
- `migration-steward`
  - for rollout-sensitive schema/data evolution programs

These are not approved families yet. They are named examples of what a real gap
might produce.

Replay against the current Prop4You scenario matrix strengthens all three as
real candidates:

- `async-workflow-steward`
- `provider-boundary-auditor`
- `migration-steward`

## Response To A Real Gap

When a gap is confirmed:

1. keep the current run honest and do not fake a strong fit
2. record the missing bounded specialty
3. hand the gap to the `codex-agent-architect` capability within `accelerate`
4. evaluate:
   - recurring surfaces
   - recurring risks
   - required write scope
   - required skill envelope
   - whether the new family should be stable or specialist-only

## Promotion Threshold

Prefer creating a new stable family only when all are true:

- the work class is recurring
- the ownership boundary is clean
- the skill envelope is stable
- the role reduces misrouting or awkward composition materially
- the role can stay narrow and opinionated

If one or more of these fail, prefer:

- keeping the work master-owned
- using a composition
- or treating the specialty as advisory instead of agent-worthy
