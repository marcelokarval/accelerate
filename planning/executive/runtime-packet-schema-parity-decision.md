# Parity Decision: Runtime Packet Schema

## Purpose

This artifact is the explicit `parity-replacement-gate` packet for the
`runtime packet schema` surface.

It records the focused local-vs-reference rerun after the native packet schemas
were moved into `core/runtime-packets/templates.md`.

## Surface Under Judgment

- local native surface:
  - `core/runtime-packets/templates.md`
  - `core/runtime-packets/cadence.md`
- legacy/reference-backed surface:
  - `references/runtime-packet-templates.md`
  - `references/runtime-observability-cadence.md`

## Why This Surface Matters

This surface governs whether non-trivial work exposes auditable runtime state
instead of relying on opaque progress prose.

It is the mechanism behind:

- branch-entry visibility
- runtime-delta visibility
- prompt-hardening visibility
- subagent-return visibility
- QA/proof visibility
- closure visibility

## Native Authority Proof

The local primary written authority now lives in:

- `core/runtime-packets/templates.md`
- `core/runtime-packets/cadence.md`

The inherited reference files remain readable as supporting doctrine only.

## Benchmark Or Run Evidence

### Benchmark Shape

- focused runtime-packet-schema benchmark
- same non-trivial governance/documentation mutation scenario
- local run constrained to native core files
- reference run constrained to inherited reference files
- judged on whether the authority could produce:
  - `Branch Entry Packet`
  - `Runtime Delta Packet`
  - `Prompt Hardening Packet`
  - `Subagent Return Packet`
  - `QA / Proof Packet`
  - `Closure Packet`

### Local Output Signal

The local side concluded:

- native authority is sufficient to produce all six packet shapes
- no reference fallback is needed

Strengths:

- richer branch classification vocabulary:
  - `conversational`
  - `trivial bounded engineering work`
  - `orchestrated non-trivial work`
- `Runtime Delta Packet` includes `issue stack transition`
- `Prompt Hardening Packet` includes material changes, bounded scope,
  explicit non-goals, and next branch/route
- `Closure Packet` includes proof-lane status and blocking lane

Initial local gap found:

- `Subagent Return Packet` had a native schema but no explicit cadence entry

Correction applied:

- `core/runtime-packets/cadence.md` now includes:
  - `subagent completion -> Subagent Return Packet`

### Reference Output Signal

The reference-backed side concluded:

- reference authority is sufficient at baseline
- but weaker than native core on several fields

Weaker points found:

- no `issue stack transition` in `Runtime Delta Packet`
- weaker `Prompt Hardening Packet` fields
- weaker `Closure Packet` fields
- less precise branch classification vocabulary

The reference run also acknowledged that the reference files now defer to native
local authority.

## Comparative Judgment

Winner for this focused benchmark:

- `local`, by clear margin

Reason:

- both sides can emit packet shapes
- the local native schema is now strictly richer
- the only local cadence gap found during the run was corrected immediately
- reference-backed authority now functions as support depth, not primary
  runtime schema authority

## Residual Gap Statement

This surface is no longer `near parity`.

Residual watch item:

- subagent-heavy real runs should prove that `Subagent Return Packet` cadence is
  used behaviorally, not only documented

This does not block promotion because the schema and cadence authority are now
native.

## Decision Proposal

- verdict: `local ahead`

Effect:

- `runtime packet schema` is promoted beyond `near parity`
- local native runtime packet docs become the operational authority
- inherited packet references remain support/comparison material only

## Next Watch Item

Use future delegation-heavy runs to validate that subagent-return cadence is
actually emitted when subagents are used.
