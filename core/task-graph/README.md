# Task Graph

This source-only contract records a bounded planning graph. It is neither a
scheduler nor a Domain Gauntlet lifecycle: it does not grant leases, approve
work, authorize dispatch, or close an issue.

`task-graph/v1` has only these graph states: `DRAFT`, `FROZEN_CURRENT`,
`STALE_REANALYSIS_REQUIRED`, `SUPERSEDED`, `BLOCKED`, and `CANCELLED`.
Every graph uses a `delta-baseline`, not a commit baseline. Its Git snapshot
records HEAD, parents, branch or detached mode, upstream divergence, staged,
unstaged, and untracked fingerprints and repository-relative path inventories,
plus operation/conflict state. A dirty worktree is allowed only as inventory;
the graph must not overwrite, serialize, reset, stash, rebase, or otherwise
mutate it.

Nodes have unique semantic IDs, resolvable dependencies, and acyclic order.
Overlapping write scopes require dependency serialization. Validate a graph
together with its observation heartbeat:

```bash
python3 scripts/validate-task-graph-heartbeat.py task-graph.json heartbeat.json NOW_ISO8601
```

See [the heartbeat/reanalysis contract](./heartbeat-reanalysis-contract.md)
for invalidation semantics and authority limits.
