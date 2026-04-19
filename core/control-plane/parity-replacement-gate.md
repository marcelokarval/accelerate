# Parity Replacement Gate

## Purpose

This gate decides whether a local/standalone `accelerate` surface is actually
ready to replace the legacy/global runtime as the primary operational
distribution.

It exists to stop two bad outcomes:

- calling parity because the local repo is cleaner or better organized
- preserving the legacy forever because no explicit replacement decision was
  ever made

This gate is governed by the repo-wide replacement rule:

- the local platform only replaces the legacy when it is **superior or equal in
  operational value**, ignoring the future-agent layer

## When To Use This Gate

Use it when a session is claiming one of these:

- `local at parity`
- `ready to replace legacy`
- `good enough to make local primary`
- `this surface is no longer a breach`

Do not use it for ordinary documentation landings alone.

Landing a native surface is a prerequisite, not proof of replacement readiness.

## Required Evidence Packet

Before this gate can pass, make these explicit:

1. `Surface Under Judgment`
   - exact native local surface
   - exact legacy comparison surface
2. `Why This Surface Matters`
   - what engineering behavior it governs
3. `Native Authority Proof`
   - where the local surface lives
   - where local root docs or control-plane docs point to it as primary
4. `Benchmark Or Run Evidence`
   - real runs, not wording-only comparison
   - include whether the evidence came from a benchmark battery, live execution,
     or both
5. `Residual Gap Statement`
   - what the legacy still does better, if anything
6. `Replacement Risk`
   - what could regress if the local becomes primary too early
7. `Decision Proposal`
   - `still below legacy`
   - `near parity`
   - `local at parity`
   - `local ahead`

## Decision Ladder

Use these verdicts strictly.

### 1. `still below legacy`

Use when:

- the legacy still produces materially better operational outcomes
- or the local still misses important defect classes, proof shapes, or closure
  discipline

Effect:

- no replacement claim
- gap remains open
- next correction must be explicit

### 2. `near parity`

Use when:

- the local now has the native surface
- the method coverage is close
- but the benchmark or live run still shows a meaningful behavioral edge for
  the legacy

Effect:

- do not call replacement yet
- treat the residual gap as mostly behavioral or proof-related
- queue the next correction and rerun

### 3. `local at parity`

Use when:

- the local surface has native authority
- real benchmark or run evidence shows no meaningful operational deficit
- any remaining differences are editorial, packaging, or preference-level

Effect:

- the local surface can be treated as a valid primary authority for that class
- the legacy reference becomes supporting doctrine, not the primary method

### 4. `local ahead`

Use when:

- the local preserves the useful legacy method
- and now performs better in real runs for the judged surface

Effect:

- replacement is justified
- the executive/gap docs should say so clearly

## What Does Not Count As Parity Proof

These are insufficient on their own:

- cleaner directory layout
- clearer naming
- a new native file existing
- a README pointer without benchmark or runtime evidence
- stylistic preference for the local wording
- partial shell artifacts
- one-off narrative claims without preserved evidence
- chat-only, `/tmp`-only, or untracked scratch evidence

## What Does Count As Strong Proof

Prefer evidence in this order:

1. repeated benchmark battery wins or stable ties on the same task class
2. live runs where the local no longer misses the defect/proof class that
   legacy previously caught better
3. side-by-side document comparison showing no remaining method gap, but only
   when backed by real runs

## Replacement Blockers

Do not pass this gate if any of these are true:

- the local still depends on `references/` as the primary operational method
- the benchmark result is still driven by prompt over-steering rather than
  stable local behavior
- the local still misses a defect class that the legacy catches reliably
- the local still under-runs required workflow output shapes
- the parity claim ignores residual risk that matters operationally
- the evidence exists only in conversational memory and not in durable docs
- benchmark or arbitration outputs influenced the verdict but were not
  preserved or summarized in a durable executive or architecture artifact

## Closure Rule

This gate is only complete when:

- the evidence packet exists
- the verdict is explicit
- the relevant executive plan and gap matrix are updated
- the residual gap, if any, is named concretely
- the next correction is named if the verdict is not `local at parity` or
  `local ahead`

Source outputs may start in transient files during local benchmarking, but the
decision packet must preserve the relevant comparison before this gate closes.

## Anti-Illusion Rule

When in doubt, prefer:

- `still below legacy`
- or `near parity`

Do not spend replacement claims early.

The local should become primary because it proved operational value, not
because the migration has already taken too long.
