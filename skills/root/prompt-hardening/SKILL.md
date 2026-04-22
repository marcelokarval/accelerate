---
name: prompt-hardening
description: Use when a software-engineering request is long, ambiguous, multi-phase, architecture-heavy, or likely to drift unless it is converted into a bounded execution-ready prompt.
metadata:
  category: root
  origin: accelerate-native
---

# Prompt Hardening

Use this skill to turn a broad request into a prompt that is safe to execute
without interpretation drift.

## When to Use

Use this skill when the input is:

- long
- ambiguous
- multi-surface
- multi-phase
- epic-like
- architecture-heavy
- likely to split into several issues, phases, or review lenses

Do not use it for:

- tiny bounded edits
- single-bug fixes with a clear repro and obvious owner
- direct factual questions

## Core Principle

Do not execute a complex request in its raw form when the wording still allows
multiple reasonable interpretations.

`prompt-hardening` exists to produce:

- bounded phases
- explicit goals
- explicit non-goals
- clearer ownership
- a safer execution order

## Output Contract

The hardened result should make these things explicit:

1. what problem is actually being solved
2. what is in scope now
3. what is not in scope now
4. which phases or slices exist
5. which follow-ups are expected instead of being silently absorbed
6. which quality lenses are likely mandatory

When the gate is active, the visible artifact must also make the transformation
itself explicit:

7. `Prompt A`
   - the raw or minimally normalized input prompt being hardened
8. `Prompt B`
   - the bounded execution-ready prompt that will govern the run

When `prompt-hardening` is actually triggered as a gate, the run should expose
one visible artifact before normal execution continues:

- `Hardened Prompt`
- `Execution-Ready Prompt`
- `Execution-Ready Prompt Packet`

Naming the gate without surfacing one of these artifacts is a workflow failure,
not a stylistic omission.

## Workflow

### 1. Separate Intent From Surface Noise

Extract:

- the real user goal
- the visible surfaces involved
- the hidden architectural concerns
- the likely misunderstanding vectors

### 2. Bound the Problem

Rewrite the request into:

- a primary goal
- bounded sub-goals
- clear non-goals

### 3. Identify Workflow Shape

Decide whether the next step should route into:

- `brainstorming`
- `systematic-debugging`
- the active workflow adapter
- `planning-with-files`
- `executing-plans`

### 4. Name the Quality and Review Expectations

When relevant, call out:

- `Product Correctness`
- `Anti-Abuse`
- `Contract Correctness`
- micro-review checkpoints during execution
- final recursive forensic review before closure

### 5. Produce an Execution-Ready Prompt

The result should be usable as:

- a discussion driver
- a spec seed
- an issue seed for the active workflow backend
- a plan-opening prompt for `accelerate`

The result should be visible enough that another operator could point to the
artifact and say: "this is the bounded prompt we are executing now."

At minimum, the visible artifact should include:

- `Prompt A`
- `Prompt B`
- primary problem being solved
- bounded scope now
- explicit non-goals
- next branch or skill route
- mandatory quality lenses if already known

`Prompt B` must be materially more execution-ready than `Prompt A`.

If the artifact only rephrases the prompt at the same abstraction level or only
lists a summary without showing the before/after transformation, treat the gate
as unsatisfied.

## Relationship To Accelerate

For non-trivial work, `prompt-hardening` is a gate inside `accelerate`, not a
competing entry skill.

The chain is:

```text
accelerate
  -> prompt-hardening when request shape requires it
  -> task classification
  -> downstream execution workflow
```

When this branch is active, `accelerate` should not treat the gate as passed
until the hardened artifact is visible in the run.

The visible artifact should normally be rendered in this shape:

```text
Hardened Prompt
- Prompt A: ...
- Prompt B: ...
- Non-goals: ...
- Mandatory quality lenses: ...
```

The artifact should surface before normal execution continues, typically in the
first technical update or immediately after the execution manifest.

## Verification

This skill is being used correctly if:

- the revised prompt removes obvious ambiguity
- the phases are bounded
- non-goals are explicit
- the next skill branch becomes clear
- the hardened prompt reduces the chance of drifting implementation
- the run visibly exposes the hardened artifact instead of only naming the gate
