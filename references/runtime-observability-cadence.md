# Runtime Observability Cadence

## Local Authority Status

Primary local authority lives in:

- `../core/runtime-packets/cadence.md`

Use this reference for supporting doctrine and comparison depth.

If the native local file and this reference disagree, prefer the local file.

Use this module when the question is not what packet fields exist, but when they
must be emitted.

## Rule

Non-trivial work must not hide the active workflow stack for long stretches.

## Cadence

### Opening

- first technical update -> `Branch Entry Packet`

### On meaningful stack change

- branch change -> `Runtime Delta Packet`
- persona change -> `Runtime Delta Packet`
- skills change -> `Runtime Delta Packet`
- ADR/reference set change -> `Runtime Delta Packet`
- gate status change -> `Runtime Delta Packet`
- QA/proof lane change -> `Runtime Delta Packet`

### On prompt hardening

- when hardening is active -> `Prompt Hardening Packet`

### On subagent completion

- each subagent return -> `Subagent Return Packet`

### On QA lane completion

- backend QA complete -> `QA / Proof Packet`
- frontend QA complete -> `QA / Proof Packet`
- browser-proof complete -> `QA / Proof Packet`
- persistent E2E complete -> `QA / Proof Packet`

### On closure

- pre-close -> `Closure Packet`

## Anti-Opaque Rule

If a non-trivial run emits long sequences of progress updates without packeted
state, treat that as observability drift.

## Single-Threaded Exception Rule

If a non-trivial run does not spawn subagents, the opening packet must include a
`single-threaded exception` reason.
