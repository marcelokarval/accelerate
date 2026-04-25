# Runtime Proof Fixtures

## Purpose

Runtime proof fixtures provide reusable packet templates for proof lanes that
need runtime evidence but should not bind core doctrine to one command or tool.

Use these fixtures from stack profiles or runtime adapters when a branch needs a
repeatable proof artifact.

## Fixtures

- `runtime-proof-packet-template.md`
- `browser-truth-template.md`

## Rules

- Browser truth and persistent regression proof are separate lanes.
- A runtime proof packet must name scope, evidence, result, and residual gaps.
- Tool-specific commands belong in the adapter/profile that executes the packet.
- Generated packets are evidence artifacts, not source-of-truth doctrine.

## Relationship To Core

Core owns the proof order and packet expectations in
`core/runtime-packets/qa-proof-stack.md`. This adapter directory owns reusable
runtime-facing fixture shapes.
