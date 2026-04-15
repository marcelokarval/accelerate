# Workflow Adapter Contract

## Purpose

This document defines the common contract all workflow adapters must satisfy in
the standalone pre-agents phase.

## Current Reality

This repository does not yet have a fully implemented native workflow backend.

So this contract currently defines:

- what a real workflow adapter must eventually satisfy
- what the root control plane is already allowed to assume
- what must not be faked before a backend is actually implemented

Until a backend is concretized, planning artifacts and architecture docs remain
the governing execution surfaces.

## Every Workflow Adapter Must Support

- issue bootstrap
- issue hierarchy or an explicit substitute model
- metadata hygiene
- lifecycle state transitions
- AI review reporting
- closure traceability

## Shared Concepts

Every adapter must express:

- governing issue
- lifecycle state
- parent/child or equivalent hierarchy
- labels/tags classification
- assignee / ownership
- review handoff
- final closure traceability

## Pre-Agents Minimum Contract

Even before a backend is fully implemented, the control plane may already rely
on these workflow concepts:

- there is a governing work item or an explicit substitute execution artifact
- the run has a visible lifecycle state
- planning exists before non-trivial mutation
- review and closure are traceable

What pre-agents must not do is fake a concrete backend API or pretend that a
workflow system is operational when it is only conceptually modeled.

## Anti-Fake-Adapter Rule

Do not claim an adapter exists just because the architecture already names it.

In the pre-agents phase:

- `linear` may exist as the current default-shaped doctrine
- `github` may exist as a peer architectural target
- neither should be treated as enforced runtime truth for this repo until the
  backend is actually implemented and adopted here

The root may still choose issue topology, lifecycle shape, and planning gates
without pretending that the adapter backend is already alive.

## Adapter Selection Rule

Workflow adapters are siblings, not exceptions to each other.

The selection order is:

1. root control-plane laws remain fixed
2. the active repo chooses or discovers the honest workflow backend
3. the selected adapter expresses the common contract in its own backend
4. the repo may still remain root-only while that backend is absent or
   unsettled

## Adapter Reality

The current default backend is still Linear-shaped, but the contract is not
Linear-only.

GitHub is the first intended peer adapter.

## Transition Rule

This contract becomes stricter when a real workflow backend is adopted in this
repo.

At that point, the repo should define:

- which adapter is active runtime truth
- what issue bootstrap means concretely
- what lifecycle states are canonical
- what metadata is mandatory
- how AI review reporting is attached
- what counts as real closure in that backend
