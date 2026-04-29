# Agent Promotion Contract

## Purpose

Use this contract when a repeated gap or family shape might become a promoted
Accelerate agent.

Promotion is a governed product decision. It is not automatic, and it is not
required for Accelerate to operate.

## Promotion Ladder

Every candidate must move through these states in order:

1. `gap-detected`
2. `recommendation`
3. `candidate-defined`
4. `contract-approved`
5. `runtime-adapter-bound`
6. `empirically-replayed`
7. `promoted`

Skipping states is promotion drift.

## Candidate Requirements

A candidate can become `candidate-defined` only when it has:

- recurring task class
- bounded ownership
- explicit non-authority boundaries
- required input packet
- required return packet
- skill envelope
- validation/proof expectations
- review isolation plan
- root integration plan
- failure labels

## Approval Requirements

A candidate can become `contract-approved` only when the root records:

- why root-only execution is no longer enough for this task class
- why the candidate lowers risk, latency, or cognitive load
- which tasks it must never own
- what remains orchestrator-owned
- how executor/reviewer/orchestrator separation will be enforced

## Runtime Binding Requirements

A candidate can become `runtime-adapter-bound` only when a concrete runtime can
execute it without inventing behavior.

The runtime binding must name:

- launch mechanism
- available tools
- file/write boundaries
- how packets are returned
- how failures are surfaced
- how the root can refuse or ignore its result

## Empirical Replay Requirements

A candidate can become `promoted` only after replay against real or fixture-backed
work proves:

- it stays inside scope
- it returns the required packet
- it does not claim closure
- it surfaces residual risk
- root review-of-review can catch its misses
- it improves at least one measurable dimension compared with root-only execution

## Root-Only Safety Rule

If no promoted agent exists, Accelerate must still run the branch root-only or
with an explicit `single-threaded exception`.

Do not block a branch because an agent candidate is missing. Missing agents are
planning signals, not runtime blockers.

## Closure Blockers

Do not promote when:

- the candidate lacks a bounded input/return contract
- the candidate can mutate outside assigned scope
- the candidate can claim final closure
- review isolation is unclear
- the runtime adapter is aspirational
- empirical replay is missing
- root-only fallback is not documented

## Failure Labels

- `agent-promoted-from-gap-only`
- `agent-contract-missing`
- `agent-runtime-adapter-aspirational`
- `agent-claims-root-authority`
- `agent-review-isolation-missing`
- `agent-promotion-without-replay`
- `agent-required-for-root-operation`
