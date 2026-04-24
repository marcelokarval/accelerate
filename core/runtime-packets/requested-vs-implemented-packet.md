# Requested-Vs-Implemented Packet

## Purpose

This packet makes slice-level side-by-side judgment explicit during real runs.

It is the runtime form of:

- `core/review/requested-vs-implemented.md`

## Use

Emit this packet when a bounded slice, batch, or delegated return must show
whether the assigned target was actually satisfied.

Use it for:

- bounded root-owned execution batches
- subagent returns
- contract-heavy review slices
- design-system or premium implementation slices

## Template

```text
Requested-Vs-Implemented Packet

- slice / batch id: <id>
- assigned scope: <bounded scope>
- actual scope touched: <scope actually landed>
- files / evidence touched: <...>
- authority source:
  - <path|artifact|contract>
- requested items:
  - <item>
  - <item>
- implemented items:
  - <item>
  - <item>
- comparison judgment:
  - <requested item> -> <met|partial|missed>
  - <requested item> -> <met|partial|missed>
- variance notes: <...>
- promotion posture: <promotable|blocked|follow-up-required>
```

## Rule

Do not compress this packet into "implemented as requested" unless the
comparison is genuinely that clean.

When the branch is visual or contract-governed, authority sources should name
the governing artifact explicitly.

## Design-System / Premium Use

When design-system artifacts govern the slice, the authority source should name:

- `design-system.contract.md`
- the active premium direction artifact
- the active sprint or rollout artifact when one exists
