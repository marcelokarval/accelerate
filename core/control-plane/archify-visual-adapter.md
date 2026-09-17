# Archify Visual Adapter Boundary

This is a source-only control-plane contract for the optional adapter selected
by D16. It is not an installation instruction or a runtime capability claim.

## Contract

Input is an Accelerate-owned typed IR with exactly one primary kind:
`architecture`, `workflow`, `sequence`, `dataflow`, or `lifecycle`. Required
metadata is IR version, source locators and digests, bounded scope, excluded
scope, and renderer pin. The adapter validates the IR deterministically, then
emits a standalone diagram plus an output digest and validation receipt.

```text
source authority -> typed IR -> deterministic validator -> optional renderer
       |                 |                |                     |
       |                 +-- reject unknown/malformed nodes      +-- standalone output
       +-- remains authoritative; never inferred from diagram
```

## Non-authority boundary

The diagram is not source authority, automatic repository extraction, impact
analysis, risk analysis, runtime truth, a test result, or a gate receipt. It
may make a structural decision reviewable but cannot manufacture the facts it
depicts. Source disagreement or validation failure blocks the visual claim and
returns to the named source owner.

## Required future gates

1. approve an IR schema/allowlist and exact renderer provenance;
2. prove deterministic validation with positive and negative fixtures;
3. bind output to inputs by digest and preserve it as standalone output;
4. review the result under the Visual Modeling Gate; and
5. separately authorize any dependency, invocation, registration, or
   promotion.

The assessed upstream reference is
[`tt-a1i/archify@7a16d30322f5bd09c832386faa95d8c9a933f0c0`](https://github.com/tt-a1i/archify/tree/7a16d30322f5bd09c832386faa95d8c9a933f0c0),
inspected 2026-09-01. No copy, installation, or adapter invocation occurred.
