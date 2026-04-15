# Prompt Hardening

## Purpose

This document is the native core home for the prompt-hardening gate.

## Gate Rule

Run prompt hardening before execution when the request is:

- long
- ambiguous
- multi-objective
- multi-phase
- architecture-heavy
- likely to drift into issue work, planning, runtime proof, or cross-surface
  execution

## Output Contract

When the gate is active, the run must visibly expose:

- `Prompt A`
- `Prompt B`
- material changes
- bounded scope
- explicit non-goals
- next branch or persona route

## Important Clarification

Prompt size and workflow size are not the same thing.

A run may still become trivial after hardening. That does not make the gate
optional.

## Authority

The detailed legacy reference still lives in:

- `references/prompt-hardening-gate.md`

