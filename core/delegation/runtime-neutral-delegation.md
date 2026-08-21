# Runtime-neutral Delegation Semantic Core

Use this contract to describe delegation before projecting it into a specific
runtime. It is a portable semantic boundary, not a runtime installer, loader,
or claim that a runtime is usable.

Machine authority is
[`runtime-neutral-delegation.schema.json`](./runtime-neutral-delegation.schema.json).
Runtime projections are inventory-only in
[`adapters/runtime/runtime-consumer-registry.json`](../../adapters/runtime/runtime-consumer-registry.json).

## Portable contract

Each run records these portable concerns:

- `run`: the requested work and whether task-owned mutation is intended;
- `policy`: enforcement level and capacity decision;
- `state`: lifecycle state plus transition history;
- `budget` and `assignments`: bounded work, scopes, dependencies, and proof;
- `exceptions`, `fan_in`, and `review`: deviations and evidence reconciliation;
- `root_ownership`: integration, external mutation, review-of-review, and
  closure always remain root-owned;
- `promotion`: explicit evidence and rollback instead of implied activation.

The semantic quality classes are `root-orchestration`, `research-low`,
`mechanical-medium`, `implementation-medium`, `review-medium`, and
`high-stakes-review`. They express work quality needs only; a runtime adapter
chooses any runtime-specific mapping outside this core.

## Capacity and enforcement

`runtime_capacity` is telemetry, `policy_cap` is the policy limit, and
`effective_cap` is the permitted minimum. Unknown telemetry is `null`; it is
never rewritten as zero. The validator enforces
`reserved_slots <= requested_slots <= effective_cap <= policy_cap`, and caps
the policy cap by observed runtime capacity when telemetry is available.

Enforcement is declared honestly as one of:

- `native`: the runtime itself enforces the relevant limit;
- `adapter-enforced`: a repository-owned adapter enforces it;
- `prompt-contract-only`: the limit is a behavioral contract and lacks a
  machine enforcement claim;
- `unsupported`: no assignment may be planned and effective capacity is zero.

## State taxonomy

Positive progression is `draft` → `hardened` → `tasks-ready` →
`dispatch-required` → `dispatched` → `executing` → `fan-in` →
`independent-review` → `root-review-of-review` → `promotion-pending` →
`promoted` → `completed`.

Negative or terminal states are `blocked`, `exception`, `rejected`,
`cancelled`, and `superseded`. The validator permits only declared transitions;
adapters must not silently coerce a negative state into successful completion.

An assignment has a unique ID, dependency IDs, a parent assignment ID, outcome,
and an optional outbound `nested_delegation_grant`. Dependencies and parents
must exist and be acyclic. A non-root parent may create a child only when its
grant is authorized by the root assignment named in `root_ownership`; depth is
bounded by policy. A completed execution run requires successful assignments,
complete fan-in, passed required independent review, no open exception, and an
approved promotion whose proof and rollback references exist and are verified.
`unsupported` makes zero-cap, no-assignment runs representable with a null
fan-in owner.

## Use and proof

Validate one or more run records with:

```bash
python3 scripts/validate-runtime-delegation-semantics.py \
  tests/fixtures/runtime-delegation-semantics/valid-run.json
```

This validates static semantics and registry shape only. It does not install a
consumer, invoke an external runtime, or prove provider/runtime availability.
