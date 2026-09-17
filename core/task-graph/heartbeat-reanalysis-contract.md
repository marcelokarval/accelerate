# Development Heartbeat and Reanalysis Contract

A `development-heartbeat/v1` is an observation and reconciliation record. It
never supplies authorization, a lease/fence, approval, dispatch, transition,
or closure; those remain owned by their respective contracts, including the
Domain Gauntlet where active.

The heartbeat separates `graph_baseline` (which must equal the graph's exact
`delta-baseline`) from `observed_repository_snapshot` (the current repository
observation), advances its sequence, and reports the graph's state. A snapshot
includes HEAD, parents, branch or detached mode, upstream divergence, dirty
fingerprints, staged/unstaged/untracked repository-relative path inventories,
and merge/rebase/cherry-pick/revert/conflict operation state.

Changed snapshots and active Git operation state require a typed `git-change`
trigger, `reanalysis.status=required`, matching trigger IDs, and graph state
`STALE_REANALYSIS_REQUIRED`. A `git-change` trigger with no snapshot delta or
operation state is rejected. Other typed triggers cover contract/spec/scope,
runtime/capability, lease/fence, and review/evidence changes and likewise make
the graph stale. A frozen-current graph has no trigger and is `not-required`.
When a merge/rebase conflict path overlaps any node write scope, the graph must
instead be `BLOCKED` (while retaining the required Git trigger and reanalysis);
an operation without such a conflict may remain stale.

The observation also binds a closed physical `subject`: graph `node_id`,
assignment, agent and call IDs, actor epoch, candidate digest, and observed
fence token, plus a dispatch-receipt locator and SHA-256 digest. The locator is
a canonical repository-relative path resolved from the `HEARTBEAT.json` parent;
the validator rejects every symlink component, then reads a regular file and
verifies its digest. Repository paths reject Unicode control category `Cc` but
retain legitimate Unicode text.
The selected
node's assignment and candidate digest must match exactly; candidate may be
`null` before a candidate exists. Agent, call, fence, and candidate fields are
observed identifiers bound to that receipt digest, not independently proven
live by this validator. This makes a spawn subject inspectable without granting
it a lease or authority. `expires_at` must be no more than 15 minutes after
`observed_at`; the validator requires a caller-supplied `NOW_ISO8601` and
rejects observations not yet valid or expired.

Reanalysis is a request to reconstruct planning truth; it does not execute a
repair or alter Git. In particular, no automatic reset, stash, rebase, branch
movement, or worktree serialization is permitted. Git commit identity is only
a delta-baseline component, never spec authority, runtime authority, a
clean-worktree assertion, or authorization.
