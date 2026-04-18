# Reference Layer Rationalization And Rerun Result

## Purpose

This artifact records the one-shot cleanup that:

1. rationalized the `references/` layer
2. tightened adjacent entry guidance
3. reran a representative legacy-vs-local benchmark after the cleanup

## Governing Problem

The local platform had already moved many surfaces into `core/`, but the
reference layer still looked visually flat.

That created an avoidable confusion risk:

- older reference files could still be mistaken for first authority
- the cleaned root `SKILL.md` and `README.md` could say “native first” while
  the reference layer itself still did not say so loudly enough

## Mutations Applied

### 1. Reference Authority Map

Created:

- `references/README.md`

This file now states:

- when to prefer native `core/` surfaces
- which reference files are now native-backed
- which reference files remain reference-first
- the intended entry order across `AGENTS.md`, `SKILL.md`, `README.md`,
  native `core/`, and only then matching `references/`

### 2. High-Traffic Reference Banners

Added explicit `Local Authority Status` banners to the high-traffic duplicated
reference files so they no longer present themselves as silent co-equal
authority.

### 3. README Alignment

Updated:

- `README.md`

The root README now points explicitly to `references/README.md` for the
reference-layer authority map.

## Rerun After Cleanup

Representative rerun chosen:

- premium interface discipline 2x2

Reason:

- this family is sensitive to branch focus, artifact sufficiency, visual
  doctrine, and closure blockers

## Rerun Result

The rerun did not expose a local regression.

It preserved the earlier result:

- `premium interface discipline = local ahead`

Operational reading:

- both sides still blocked closure
- the local side remained sharper and cleaner in premium failure-mode naming
- the reference cleanup did not weaken local branch focus or closure harshness

## Global Read

The reference-layer cleanup improved governance clarity without reopening a
behavioral gap.

That matters because the repo is now stronger in two ways at once:

- native authority is clearer
- the benchmarked local behavior still holds after the cleanup

## Next Recommended Follow-Up

The next useful continuation is not another flat reference cleanup.

It is:

1. pruning or slimming low-value inherited reference files that are now mostly
   dead duplication
2. continuing cross-surface reruns only where a real `near parity` residual
   still exists
