# Specification Lifecycle Contract

## Mode Selection

Evaluate from highest to lowest risk and use the first matching mode.

| Mode | Observable triggers | Minimum materialization |
| --- | --- | --- |
| `critical` | auth, authorization, ownership, billing, PII, secrets, destructive/provider write, irreversible migration, safety-critical behavior | separate accepted SDD, ADR, threat model, Test Design, rollback |
| `hierarchical` | cross-domain ownership, architecture boundary, multi-runtime migration, several independently deployable surfaces, agent promotion | root SDD, explicit child dispositions, separate traceability |
| `standard` | externally visible behavior, bug, risky refactor, multi-file workflow/governance contract, new specialist capability, structural UI | accepted delta SDD, task ledger, explicit Test Design disposition |
| `micro` | known, local, reversible mutation with one owner and one focused proof | non-empty Spec Capsule, complete dispositions, manifest |
| `no-op` | no mutation | read-only outcome without mutation artifacts |

An execution route such as `direct-fast-path` is not an SDD mode. An upward
override records requested mode, observed minimum, reason, approver, and scope.
A downward override is invalid.

## Artifact State

```text
draft -> accepted -> implementing -> superseded
```

- `draft`: may be reviewed but cannot authorize implementation.
- `accepted`: root acceptance permits entry when every other gate passes.
- `implementing`: accepted authority remains active during execution.
- `superseded`: historical only; cannot authorize new work.

The author and sole acceptor must not be the same identity.

## Required Dispositions

Disposition each surface as `separate`, `consolidated`, or `not-applicable`:

- ADR
- product/UI design
- Test Design
- agent contract or staffing
- rollout
- rollback
- observability
- governing AGENTS/docs

`Consolidated` names the owning artifact and locator. `Not-applicable` gives a
scope-specific reason. Empty or generic text such as `none`, `not needed`, or
`N/A` is not a reason.

## Readiness Gate

Fail implementation entry if any of these is true:

- no issue/approved exception or artifact manifest exists
- selected mode is below a deterministic trigger
- design is draft, superseded, self-accepted, or missing
- a required disposition, owner, reason, or locator is absent
- a requirement does not resolve to a known task and planned proof
- observed proof appears before execution or lacks evidence
- Test Design or TDD entry is missing, mismatched, or stale

## Reentry Triggers

Pause the affected implementation scope and reopen specification when new truth
changes behavior, trust boundary, owner, integration, migration, compatibility,
rollout/rollback, observability, or proof mode. Increment the artifact/reentry
generation, mark superseded decisions and proof explicitly, and revalidate only
after the affected chain is coherent again.
