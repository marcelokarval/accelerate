# Physical Agent Runtime Adapter

## Purpose

Use this adapter contract when Accelerate can delegate to a real physical agent
runtime instead of only using virtual subagent packets.

This adapter is not a claim that a promoted runtime catalog already exists. It is
the contract a runtime must satisfy before physical agents can replace virtual
assignment packets for a bounded slice.

## Authority Boundary

The physical agent runtime is subordinate to Accelerate.

It must not own:

- run classification
- issue topology
- task ledger authority
- role-family selection
- review-of-review
- final forensic closure
- `Done`

Those remain root-owned.

## Required Inputs

Every physical assignment must preserve the base assignment fields:

- task id
- selected role family
- compatible capability family
- physical agent id or runtime handle
- assigned scope
- required skills / profiles
- write scope or read-only scope
- required evidence
- prohibited authority
- return contract
- cleanup expectation after return

The selected capability family must be compatible with
`agents/doctrine/capability-matrix.md#role-family-compatibility-map`.

## Lifecycle

A conforming physical runtime adapter must expose these lifecycle phases:

1. `discover-capabilities`
   - enumerate available physical agents and capability families
   - declare unavailable families honestly
2. `bind-assignment`
   - bind a normalized role family to a compatible physical agent
   - preserve scope, skills, evidence, and prohibited authority
3. `start-or-resume`
   - start the bounded task or resume a retained agent intentionally
   - do not reuse idle state silently
4. `collect-return`
   - collect `Task Execution Return Packet`, `Skeptical Review Packet`, or
     equivalent `Agent Return Packet`
   - capture evidence roots and residual risks
5. `classify-return`
   - mark the return as accepted-for-integration, needs-review,
     needs-correction, conflicts-with-other-return, rejected-out-of-scope, or
     blocked
6. `close-or-retain`
   - close/complete returned idle agents
   - or record `retained-with-reason`
7. `fallback-if-unavailable`
   - when no compatible physical agent exists, use virtual subagent packets
   - do not invent a physical agent or weaken review isolation

## Required Proof Packet

Physical agent use must leave a proof packet containing:

- runtime adapter: physical-agent
- physical runtime: <name|unknown>
- task id: <id>
- selected role family: <...>
- compatible capability family: <...>
- physical agent id / handle: <...>
- assignment source: <packet/path>
- scope preserved: <yes|no>
- write scope enforced: <yes|no|read-only>
- required skills / profiles passed: <yes|no>
- prohibited authority passed: <yes|no>
- return packet received: <path|inline|missing>
- return classification: <accepted-for-integration|needs-review|needs-correction|conflicts-with-other-return|rejected-out-of-scope|blocked>
- cleanup result: <closed|completed|retained-with-reason|not-applicable|blocked>
- fallback used: <no|virtual-subagent-packets>
- residual risk: <...>

## Closure Rules

Physical agent proof supports closure only when:

- scope was preserved
- write scope was enforced
- prohibited authority was passed
- return packet was received
- return classification is not blocked
- cleanup result is closed, completed, retained-with-reason, or not-applicable
- Accelerate performed review-of-review

## Blockers

Block closure when:

- no compatible capability family exists and no virtual fallback was used
- physical agent id / handle is missing
- the runtime reused idle state silently
- write scope is unknown
- return packet is missing
- agent claims final closure
- cleanup result is blocked or missing
- review-of-review is missing

## Failure Labels

- `physical-agent-runtime-unavailable`
- `physical-agent-capability-mismatch`
- `physical-agent-scope-unbounded`
- `physical-agent-write-scope-unknown`
- `physical-agent-return-missing`
- `physical-agent-claims-closure`
- `physical-agent-left-idle`
- `physical-agent-fallback-missing`
