# Topology Policy

## Purpose

This document is the native core policy for choosing the execution graph before
staffing or delegation.

## Supported Shapes

- single issue
- sibling issues
- parent + child
- parent + child + review lane

## Decision Rule

Choose the simplest shape that still tells the truth about:

- outcomes
- acceptance sets
- ownership
- execution sequencing
- review visibility

## Anti-Patterns

Do not:

- keep one giant issue because splitting feels administratively expensive
- create sibling issues when one parent outcome clearly exists
- use dependency links as a substitute for real hierarchy
- let a bounded execution unit decide topology mid-flight

## Authority

The detailed supporting reference still lives in:

- `references/codex-agents/issue-topology-policy.md`

