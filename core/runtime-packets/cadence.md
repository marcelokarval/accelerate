# Runtime Packet Cadence

## Purpose

This document is the native core home of the observability cadence contract.

## Rule

Non-trivial work must not hide the active workflow stack for long stretches.

## Minimum Cadence

- first technical update -> `Branch Entry Packet`
- meaningful stack change -> `Runtime Delta Packet`
- prompt hardening active -> `Prompt Hardening Packet`
- subagent completion -> `Subagent Return Packet`
- QA lane completion -> `QA / Proof Packet`
- pre-close -> `Closure Packet`

## Single-Threaded Exception

If a non-trivial run remains single-threaded, the opening packet must expose an
explicit `single-threaded exception`.

## Authority

The detailed cadence reference still lives in:

- `references/runtime-observability-cadence.md`
