# Runtime Adapter Contract

## Purpose

This document defines the common contract for runtime adapters in the
standalone pre-agents phase.

## Every Runtime Adapter Must Define

- capability inventory
- command mapping
- evidence shape
- failure handling
- safety boundaries for privileged runtime powers such as browser state,
  network interception, JavaScript evaluation, filesystem writes, or package
  installation

## Core Rule

The core should speak in capabilities first. Concrete commands belong to
runtime adapters or stack profiles.

Adapters provide evidence. They do not own root closure, issue topology, or
visual authority selection.
