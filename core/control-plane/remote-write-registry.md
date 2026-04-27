# Remote Write Registry

Remote writes are external-provider mutations. They are one-way-door operations
unless the provider offers a fully reversible action that is explicitly modeled.

Every remote-write command must be registered in
`adapters/workflow/remote-write-registry.yaml` before it can be referenced by a
workflow adapter manifest or contract.

## Required Fields

Each entry must declare:

- `id`: stable registry identifier
- `command`: repo-local command path
- `provider`: external provider or host
- `operation`: write operation class
- `status`: `available`, `blocked`, or `planned`
- `requires_opt_in`: environment variable required for real writes, or `none`
- `privacy_gate`: `required` when local artifacts leave the repo
- `recovery`: recovery packet command or `none`
- `live_proof`: proof locator or `none`
- `structured_write`: `yes` only when the command calls a structured provider API
  directly, not through an LLM prompt

## Enforcement Rules

- A command that writes external state must not be unregistered.
- A command with `structured_write: no` must be `blocked` or `planned`.
- A command with `status: available` must have either live proof or a documented
  dry-run-only behavior and must fail closed without its opt-in variable.
- Artifact-publishing commands must require the privacy export gate.
- Merge/deploy/land commands must require a readiness artifact and a one-way-door
  opt-in.
