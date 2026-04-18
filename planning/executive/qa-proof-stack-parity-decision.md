# Parity Decision: QA / Proof Stack

## Purpose

This artifact is the explicit `parity-replacement-gate` packet for the
`QA / proof stack` surface after the completed 360 rerun.

It records the local doctrine hardening plus the reruns on both sides at:

- `gpt-5.4 medium`
- `gpt-5.4 high`

## Surface Under Judgment

- local native surface:
  - `core/runtime-packets/qa-proof-stack.md`
  - `core/runtime-packets/templates.md`
- legacy comparison surface:
  - legacy/global proof-lane ordering and closure behavior under the same
    benchmark contract

## Why This Surface Matters

This surface governs whether closure:

- keeps proof lanes separate
- respects `Chrome DevTools -> Playwright` ordering
- rejects vague `tested successfully` language
- exposes which lane is actually blocking closure

## Native Authority Proof

The local written authority is now explicit in:

- `core/runtime-packets/qa-proof-stack.md`
- `core/runtime-packets/templates.md`

The local surface now names the concrete closure failures directly:

- `browser truth -> Playwright inversion`
- `packetless proof`
- `lane-collapse closure`

It also requires lane-state exposure in the `Closure Packet`.

## Benchmark Or Run Evidence

### Benchmark Shape

The same target run was judged four ways:

- `local + medium`
- `local + high`
- `legacy + medium`
- `legacy + high`

Target run:

- user-facing self-service flow
- backend tests completed
- frontend `type-check` completed
- Playwright regression authored and run
- no interactive Chrome DevTools browser truth first
- no explicit `QA / Proof Packet`
- closure attempted with generic `tested successfully`

### Local Output Signal

#### Local + Medium

- classified as `runtime / product-heavy flow`
- blocked closure
- named:
  - `browser truth -> Playwright inversion`
  - `packetless proof`
  - `lane-collapse closure`
- compact judgment:
  - `Backend QA=present`
  - `Frontend QA=present`
  - `Browser-Proof=missing`
  - `Persistent E2E=out of order`
  - `blocking lane=Browser-Proof`

#### Local + High

- escalated to `product-critical user surface`
- blocked closure
- preserved the same named failures and lane-state judgment
- treated the self-service flow as closure-sensitive enough to justify the
  stronger branch

Strong points on the local side:

- cleaner naming of what is wrong
- explicit lane-state closure blocking
- stronger branch calibration for self-service runtime-sensitive flows

### Legacy Output Signal

#### Legacy + Medium

- classified as `runtime / product-heavy flow` with `persistent E2E /
  regression authoring` in scope
- blocked closure
- still required browser truth before Playwright and rejected generic closure
- remained less explicit than the hardened local wording

#### Legacy + High

- also blocked closure
- used the same named failures and lane-state framing

Important caveat:

- during the `legacy + high` rerun, the model consulted local-native repo
  surfaces such as `core/runtime-packets/qa-proof-stack.md`
- so this run is not a perfectly isolated read of legacy/global doctrine
- it is still useful evidence, but it lowers confidence in the exact margin of
  comparison

## Comparative Judgment

Winner after the 360 rerun:

- `local`, by small margin

Reason:

- the strongest clean evidence came from the hardened local reruns
- `local + medium` already became sharper than the legacy-medium output
- `local + high` produced the best overall judgment by:
  - escalating the flow to `product-critical user surface`
  - using the named failure model cleanly
  - exposing lane-state closure blocking directly
- the `legacy + high` output converged to the same language, but not under
  clean isolation, because it read local-native repo surfaces during the run

## Residual Gap Statement

Residual gap:

- the doctrinal gap on this surface is now effectively closed
- the remaining caution is evidentiary, not methodological

The caution is:

- the cleanest evidence for the margin comes from the local side and from
  `legacy + medium`
- if stricter benchmarking is needed later, legacy reruns should be forced
  through a cleaner reference-only harness

## Replacement Risk

Low for this surface.

If it regresses, the likely failure mode would be:

- collapsing back to generic blocked-language without named proof failures or
  explicit `blocking lane`

## Decision Proposal

- verdict: `local ahead`

Effect:

- the local QA / proof stack becomes the clearer primary authority for this
  surface
- legacy remains supporting doctrine and comparison material, not the stronger
  operational distribution

## Next Correction

No additional doctrinal correction is required before replacement for this
surface.

The next useful proof would be:

- a different runtime-sensitive category such as auth recovery or upload/import
- to confirm the same branch calibration and lane-state harshness travel beyond
  this self-service slice
