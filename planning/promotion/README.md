# Promotion Planning

Promotion planning exists for future transitions from:

- gap detection
- recommendation
- approval
- promotion
- runtime installation

In the current `standalone pre-agents` phase, this sublayer is conservative.

It should already make clear:

- suggestion is not promotion
- gap detection is not installation
- runtime catalog growth needs explicit planning

It must not imply that promotion is already an active runtime workflow here.

## Current Planning Packets

- `template-promotion-readiness-packet.md`
- `replay-fixtures/`
- bounded proof-auditor replay fixture: `replay-fixtures/bounded-proof-auditor.md`

Use this packet before moving any governed agent template beyond
`template-only`.

Use replay fixtures before claiming `empirically-replayed` for any template.
The bounded proof-auditor fixture is RC10 evidence only: it exercises candidate
intake, skill envelope, positive/negative replay, cleanup, and demotion rules
without claiming autonomous runtime availability.
