# Codex Collaboration Runtime Adapter

Use this adapter when Accelerate dispatches a bounded `scoped` or
`orchestrated` lane through the Codex collaboration runtime. Read the
Post-Spec Delegation Dispatch Gate and produce its receipt before task-owned
execution.

It is an experimental binding contract, not a replacement for root ownership
or a claim that Codex enforces per-agent tool isolation.

## Binding Rule

The root selects the execution route and normalized role family before binding.
Resolve the role through `role-policy.json`, then pass its model and reasoning
effort explicitly to `collaboration.spawn_agent`. An omitted override inherits
the parent runtime and does not satisfy this policy. Every child gets an
explicit binding: `fork_turns=none` is the default, an integer from `1..5` is
the only override, and `all` is forbidden whenever a model or effort override
is present.

The role policy is a minimum sufficient default:

- root preserves the user/runtime-selected effective session model; Sol/medium
  is the recommended default. Root owns hardening,
  SDD/PRD, task graph, dispatch, fan-in, integration-only repairs,
  review-of-review, and closure; it does not execute task-owned scopes.
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
6. `orchestrated` dispatches 2-3 physical executor/reviewer bindings and a
   dispatch receipt before `DISPATCH_REQUIRED` can advance to execution;
7. root retains issue topology, integration, review-of-review, and closure.

Virtual delegation is permitted only after `collaboration_unavailable` or a
`spawn_failed_operator_authorized` receipt exception (or explicit user opt-out
where execution is not demanded). It never satisfies available physical
dispatch. `single-threaded exception` is a blocker, not a permission. Scoped
uses at most one read-only/discovery/proof sidecar and cannot conceal task-owned
implementation. `data-db` and `provider-boundary` bind explicitly to
Terra/medium implementation; only `other` is a root reclassification gap.

Nested Terra-to-Luna dispatch is forbidden by default. The root may authorize
one Luna/medium mechanical leaf only with exactly three physical participants:
the Terra parent, Luna child, and independent reviewer. Scopes must be disjoint
and Terra remains accountable. Luna never delegates.

## Return and Cleanup

Require the standard Subagent Return Packet plus the selected policy profile,
model/effort actually requested, assignment-contract allowlists, and whether
the host could enforce them. Root must reconcile the return, then close the
agent by completion or record why it remains retained.

Block closure when an agent claims final closure, writes outside its scope,
uses a `high` profile without a receipt, or presents assignment contracts as
technical enforcement.
