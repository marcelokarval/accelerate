# Workflow Adapters

Workflow adapters implement the same orchestration concepts for different issue
backends.

## Current Stage

In the `standalone pre-agents` phase, this layer is documented natively but not
yet fully implemented as a runtime backend.

Read it as:

- current contract truth
- current default distribution shape
- future backend targets

Do not read it as proof that a concrete workflow backend is already enforced in
this repository.

Every workflow adapter should support:

- issue bootstrap
- issue topology
- metadata hygiene
- lifecycle state transitions
- AI review reporting
- traceable closure

The current imported doctrine still reflects a strong Linear-shaped default.
That material remains valid as the current default distribution, but it is no
longer the only acceptable architectural target.

The intended posture is:

- shared contract first
- adapter-specific backend second
- root control-plane laws above both

Native pre-agents reading order:

1. `adapter-contract.md`
2. `linear/adapter.md`
3. `github/adapter.md`
