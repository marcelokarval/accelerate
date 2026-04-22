---
name: frontend-chunk-ownership-audit
description: Use when Vite or Rollup bundle graphs show unexpected feature-to-feature edges, oversized entry chunks, or shared modules being owned by the wrong feature chunk.
user-invocable: true
related-skills: front-react-shadcn, react-best-practices, frontend-component-hierarchy, architecture
---

# frontend-chunk-ownership-audit

Use this skill when a frontend build graph stops matching source ownership.

This skill is for chunk-graph forensics, not generic performance work. It helps
separate:

- direct source imports
- build-time chunk ownership leakage
- legitimate shared runtime dependencies
- residual follow-ups outside the active slice

## Load When

Use this skill when you see any of these signals:

- `feature-a -> feature-b` edges that look architecturally wrong
- entry chunks growing without an obvious source diff
- `manualChunks` rules turning into ad-hoc exceptions
- barrels or shared folders pulling unrelated feature code into a chunk
- doubts about whether a problem is a source import or a Rollup/Vite ownership
  problem
- a performance issue needs build-graph evidence before implementation

Do not use this skill for:

- backend query tuning
- animation profiling with no build-graph symptom
- component extraction where the chunk graph is not part of the problem

## Core Contract

The skill must prove three things before recommending a fix:

1. what the built graph says
2. whether the edge comes from source imports or ownership leakage
3. which module family actually owns the shared code

Never collapse those into a single guess.

## Classification Contract

Every suspicious edge or oversized chunk must be classified into exactly one
bucket:

### 1. Direct Source Dependency

Use when the feature truly imports another feature in source code.

Typical fixes:

- move the shared logic to a neutral module
- narrow the dependency to a stable contract
- split route-only code from reusable primitives

### 2. Chunk Ownership Leakage

Use when the build graph shows `feature-a -> feature-b`, but the root problem is
coarse chunk attribution or shared module placement.

Typical fixes:

- refine `manualChunks`
- create a neutral shared chunk
- move a "quasi-shared" module to the feature that actually owns it
- replace broad barrel imports with bounded file imports

### 3. Legitimate Shared Runtime Dependency

Use when the edge is valid and should remain, but the build should document or
gate it better.

Typical fixes:

- keep the edge
- verify lazy boundary
- document deferred-heavy ownership

### 4. Out-of-Scope Residual

Use when the audit exposes a real problem outside the active slice.

Typical fix:

- create a follow-up issue with evidence

## Workflow

1. capture a fresh baseline
2. inspect the generated inventory or manifest
3. list suspicious cross-feature edges and oversized chunks
4. trace each edge back to either source imports or ownership leakage
5. map the contaminated modules to their real owner:
   - feature-owned
   - neutral shared
   - vendor/runtime
   - routing or contract shared
6. change chunk ownership, not just symptoms
7. harden tests around chunk classification or forbidden edges
8. rebuild and compare before/after graph deltas
9. register residual drift explicitly

## Fix Patterns

Prefer these patterns in order:

1. move generic contracts, routes, validators, or status helpers into a neutral
   shared chunk
2. assign "quasi-shared" modules to the feature that actually owns them
3. replace broad barrels with bounded imports
4. split heavyweight deferred libraries behind route or modal boundaries
5. leave a valid edge alone if it is truly architectural

## Accelerate Workflow

Use the active frontend stack profile's evidence chain:

- build graph source of truth:
  - generated bundle inventory or Vite/Rollup manifest
- decomposition and baseline:
  - frontend performance baseline and decomposition document
- chunk ownership logic:
  - active `manualChunks` or build graph ownership module
- chunk wiring:
  - active Vite/Rollup configuration

Recommended verification:

```bash
npm run build
npm run type-check
```

## Required References

Read these references when needed:

- `references/diagnosis-playbook.md`

## Output Discipline

Every audit or fix proposal must include:

- suspicious edge or hotspot
- classification
- concrete file evidence
- owner decision
- fix strategy
- verification commands
- residual drift and follow-up decision

## Anti-Patterns

- treating every bad edge as a direct source import
- solving ownership leakage by dumping more code into `shared/`
- adding random `manualChunks` exceptions without a taxonomy
- closing the issue without a fresh before/after graph comparison
- removing dynamic imports just to make the graph look simpler
- accepting a smaller chunk without explaining why the wrong edge existed

## Verification Standard

A complete pass should be able to show:

- which edges were removed
- which chunk sizes changed materially
- which shared chunks were introduced or tightened
- whether dynamic loading still works after the correction
