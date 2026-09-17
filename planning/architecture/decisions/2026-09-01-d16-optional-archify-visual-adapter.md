# D16 — Optional Archify Visual Adapter

- Status: deferred implementation; source-only boundary accepted
- Date: 2026-09-01
- Governing proposal SHA-256: `79473c41e77c626a0c849d0ff385be7c140e7f66cfbf047e55ba5ccfe05cd067`
- Evaluated source: [`tt-a1i/archify` at `7a16d30322f5bd09c832386faa95d8c9a933f0c0`](https://github.com/tt-a1i/archify/tree/7a16d30322f5bd09c832386faa95d8c9a933f0c0), inspected 2026-09-01

## Decision

Archify may later be adapted only as an **optional** renderer over an
Accelerate-owned typed intermediate representation (IR). Permitted model kinds
are `architecture`, `workflow`, `sequence`, `dataflow`, and `lifecycle`. A
render is a standalone output accompanied by source locators, input digest,
IR version, renderer/version pin, and deterministic validation result.

The typed IR and deterministic validator are authoritative for this narrow
rendering contract; a diagram is not. The adapter must not auto-extract
repository structure, infer impact/risk, claim runtime truth, select source
authority, or advance a gate. Its output is an aid to human implementation and
review, subject to the existing Visual Modeling Gate.

```text
verified source facts ──> typed IR ──> deterministic validation ──> renderer
       authority stays here        │                                 │
                                      └──── standalone diagram <──────┘
```

## Gates and non-authorization

Before any adoption: approve the IR schema and allowlist, pin and provenance,
deterministic positive/negative fixtures, output digest/readback, accessibility
of standalone output, and independent review. A diagram mismatch blocks the
diagram claim; it never silently repairs source facts.

No Archify installation, vendoring, copying, invocation, package dependency,
runtime adapter registration, global sync, or promotion is authorized by this
decision. The pin documents an inspected external source, not a dependency or
an endorsement of its runtime behavior.
