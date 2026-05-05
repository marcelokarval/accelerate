# Template Promotion Readiness

## Purpose

Use this contract when an agent template is being considered for promotion into a
candidate or physical runtime agent.

Templates are not promoted agents. A template is only a governed shape until it
passes readiness, runtime binding, and empirical replay.

## Readiness States

Every template promotion candidate must declare exactly one state:

- `template-only`
- `candidate-defined`
- `contract-approved`
- `runtime-adapter-bound`
- `installed` (host deployment fact; not promotion)
- `exported` (generated outward copy; not authority)
- `empirically-replayed`
- `promoted`

The default state for every file under `agents/templates/` is `template-only`.

## Minimum Readiness Packet

A template can leave `template-only` only when a Template Promotion Readiness
Packet exists with:

- template path
- base contract reference
- selected role family
- compatible capability family
- recurring task class
- required skills / profiles
- prohibited authority
- return contract
- cleanup behavior
- review isolation plan
- root integration plan
- runtime adapter binding status
- install/export contract status
- install state
- export state
- empirical replay status
- root-only or virtual fallback
- promotion state

## State Transition Rules

### `template-only` -> `candidate-defined`

Allowed only when the packet proves:

- recurring task class exists
- selected role family is valid
- compatible capability family is mapped
- base agent contract is referenced
- prohibited authority preserves root closure
- return contract is explicit
- cleanup behavior is explicit

### `candidate-defined` -> `contract-approved`

Allowed only when the orchestrator records:

- why root-only execution is no longer enough
- what measurable risk, latency, or cognitive load improves
- which tasks the candidate must never own
- what remains root-owned
- how executor/reviewer/orchestrator separation is enforced

### `contract-approved` -> `runtime-adapter-bound`

Allowed only when a concrete runtime adapter exists and is not merely planned.

The binding must name:

- physical runtime
- launch mechanism
- available tools
- write/read-only boundary enforcement
- return packet collection mechanism
- cleanup mechanism
- fallback when unavailable

### `runtime-adapter-bound` -> `installed` / `exported`

Allowed only as a deployment/export fact under
[`install-export-contract.md`](./install-export-contract.md). These states must
name source artifact, target host, target path, privacy classification,
validation command, rollback, and fallback mode. They do not imply empirical
replay or promotion.

### `runtime-adapter-bound` -> `empirically-replayed`

Allowed only after replay proves:

- scope remained bounded
- write scope was enforced
- return packet was complete
- final closure was not claimed
- residual risk was surfaced
- cleanup completed or retained-with-reason was recorded
- root review-of-review could catch misses

### `empirically-replayed` -> `promoted`

Allowed only after the root records that the candidate improves at least one
measurable dimension compared with root-only or virtual packet execution.

## Closure Blockers

Do not promote when:

- template path is missing
- base contract reference is missing
- selected role family is missing or invalid
- compatible capability family is missing
- prohibited authority is missing
- return contract is missing
- cleanup behavior is missing
- runtime adapter is `planned` or `not-implemented-yet`
- install/export contract status is missing when `installed` or `exported` is claimed
- install or export is described as promotion
- empirical replay is missing
- root-only or virtual fallback is missing
- template claims final closure or `Done`

## Failure Labels

- `template-promoted-without-readiness-packet`
- `template-promoted-without-base-contract`
- `template-promoted-without-capability-family`
- `template-promoted-with-planned-runtime`
- `template-installed-treated-as-promoted`
- `template-exported-treated-as-authority`
- `template-promoted-without-replay`
- `template-promoted-without-fallback`
- `template-claims-root-authority`
