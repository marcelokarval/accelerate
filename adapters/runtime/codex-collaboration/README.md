# Codex Collaboration Runtime Adapter

Use this adapter when Accelerate delegates a bounded `scoped` or
`orchestrated` lane through the Codex collaboration runtime.

It is an experimental binding contract, not a replacement for root ownership
or a claim that Codex enforces per-agent tool isolation.

## Binding Rule

The root selects the execution route and normalized role family before binding.
Resolve the role through `role-policy.json`, then pass its model and reasoning
effort explicitly to `collaboration.spawn_agent`. An omitted override inherits
the parent runtime and does not satisfy this policy.

The role policy is a minimum sufficient default:

- `direct-fast-path` binds no agent; root retains its effective session model
  and effort.
- bounded discovery and documentation use Luna/low.
- normal implementation, architecture, governance, and runtime proof use
  Terra/medium.
- Luna/medium is reserved for a mechanically specified bounded fix.
- Sol/high is review-only for an objective high-risk trigger and requires the
  existing Accelerate reasoning receipt.

Do not rewrite global Codex model settings per task. The policy chooses an
explicit subagent override only after route, role, scope, and proof are known.

## Capability Boundary

`tool_policy`, `skill_allowlist`, and `mcp_allowlist` are assignment contracts
that the root must put in the task packet and audit in the return. The current
host does not technically enforce a per-subagent tool or MCP allowlist.

Therefore:

- never describe these allowlists as host-enforced isolation;
- never use `*` for skills, MCPs, or tools;
- activate skills and MCPs only when the assigned task needs them;
- omit a remote MCP unless it is necessary for that one assignment;
- do not make `context7` a startup dependency; it is librarian-only and
  on-demand when current library documentation is needed.

## Assignment Preconditions

Before binding, require all of the following:

1. route is `scoped` or `orchestrated`, never `direct-fast-path`;
2. role family has an allowed profile in the policy;
3. assignment has a bounded read/write scope and expected return;
4. each writer has a non-overlapping write scope;
5. a `high` profile has a valid reasoning decision receipt;
6. root retains issue topology, integration, review-of-review, and closure.

If a compatible physical agent is unavailable, use the declared fallback. Do
not invent a binding or stretch a role to make delegation happen. Preserve the
selected route: a failed Scoped or Orchestrated binding never falls back to
`direct-fast-path`. The normalized `provider-boundary` and `other` roles have
no physical binding; root must reclassify them, keep them root-owned, or use a
virtual packet.

The normalized `research` role is deliberately separate from architecture. It
binds only `explorer` for bounded local discovery or `librarian` for current
official/source research. Their existence in this policy does not create a
Codex process profile or load a logical skill profile into a native spawn.

## Active Session And Interruption

Reuse an active agent context only when it is still relevant to the same task,
role, and bounded lane. Do not create a duplicate active lane while that context
can be resumed or followed up honestly.

An interruption is not a rollback. It stops agent execution but can leave
partial edits in the shared worktree.
Do not start a replacement writer until root has inspected and reconciled partial shared-filesystem changes.
This same
root reconciliation is required before any next writer enters the affected
scope. Cancellation, cleanup, and a replacement spawn do not erase filesystem
effects.

## Return and Cleanup

Require the standard Subagent Return Packet plus the selected policy profile,
model/effort actually requested, assignment-contract allowlists, and whether
the host could enforce them. Root must reconcile the return, then close the
agent by completion or record why it remains retained.

The profile's `return_contract` and `return_fields` add bounded evidence to the
standard return: explorer paths/lines and gaps; librarian sources/version and
official-vs-community status; architecture options/trade-offs/uncertainty;
writers files/behavior/validation/skips; and runtime/review profiles evidence,
findings, severity, and blockers. Every profile also returns self-review,
self-forensic review, residual risks, and the root closure boundary.

Block closure when an agent claims final closure, writes outside its scope,
uses a `high` profile without a receipt, or presents assignment contracts as
technical enforcement.
