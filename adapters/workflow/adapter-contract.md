# Workflow Adapter Contract

## Purpose

This document defines the common contract all workflow adapters must satisfy in
the standalone pre-agents phase.

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

## Adapter Reality

The current default backend is still Linear-shaped, but the contract is not
Linear-only.

GitHub is the first intended peer adapter.

