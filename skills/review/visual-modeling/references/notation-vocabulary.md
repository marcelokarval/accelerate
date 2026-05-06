# Notation Vocabulary

Use a small, consistent ASCII vocabulary. Prefer clarity over cleverness.

## Core Symbols

```text
╔════╗ / ╚════╝   authoritative system/entity/major container
┌────┐ / └────┘   regular component/entity/state
╭────╮ / ╰────╯   user-facing/card-like surface
│                 containment or lane boundary
→                 normal direction
━━━━━━━━→          critical path
- - - →            async/eventual/loose handoff
═══→              return/result
×                 blocked/prohibited path
⚠                 risk/warning
✓                 accepted/success path
[1]               callout marker
```

## Cardinality

```text
1 ─── 1       one-to-one
1 ─── *       one-to-many
* ─── *       many-to-many
0..1 ─ *      optional one to many
```

## Boundaries

```text
╔════════════════ SECURITY / TRUST BOUNDARY ════════════════╗
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

Use explicit labels for:

- tenant boundary
- auth boundary
- provider boundary
- browser/server boundary
- queue boundary
- agent authority boundary

## Arrows

Label arrows when the payload or transition matters:

```text
User ━━ submit lead form ━━→ Web App
App  - - enqueue job - - → Worker
Stripe ══ webhook result ══→ Backend
```

## Callout Discipline

Use callouts for:

- hidden ownership
- non-obvious cardinality
- sensitive payloads
- async guarantees
- idempotency points
- closure authority
- residual ambiguity
