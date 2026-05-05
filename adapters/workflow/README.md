# Workflow Adapters

Workflow adapters implement the same orchestration concepts for different issue
backends.

## Current Stage

In the `standalone pre-agents` phase, this layer is now moving from documented
contract toward progressive live adapters.

Read it as:

- current contract truth
- inherited distribution context while adapter boundaries stabilize
- future backend targets
- active local adapter foundation for `.accelerate/workflow/`

Do not read local adapter support or one-off remote helpers as proof that
Linear, GitHub, Jira, or Notion are complete live workflow adapters. The local
adapter is the first concrete substitute backend.

Every workflow adapter should support:

- issue bootstrap
- issue topology
- metadata hygiene
- lifecycle state transitions
- AI review reporting
- traceable closure
- backend identity rules
- metadata rehydration
- failure handling and recovery packets
- task ledger creation or linking
- requested-vs-implemented review comments
- defect ledger updates
- correction/reproof evidence attachment
- final forensic reconciliation comments
- closure blocker detection

Some inherited transition material still uses Linear-oriented examples and
operational notes. Treat that material as supporting migration context, not as
a repository-wide default distribution or permanent backend selection.

The intended posture is:

- shared contract first
- adapter-specific backend second
- root control-plane laws above both

Native pre-agents reading order:

1. `adapter-contract.md`
2. `local/README.md`
3. `linear/README.md`
4. `github/README.md`
5. `linear/adapter.md` and `github/adapter.md` as supporting transition notes

## Not-Yet-Implemented Limits

This layer is not yet a complete remote runtime adapter stack. Specific helpers
may be available when their capability manifests and remote-write registry say
so, but the complete adapter stack does not yet provide:

- remote adapter discovery or selection
- backend API clients
- generalized issue, pull-request, status, or comment writers across all
  backends
- automated metadata rehydration
- automated failure recovery
- live one-shot side-by-side execution orchestration
- automatic task-ledger synchronization
- automatic correction/reproof comment flows
- automatic final forensic reconciliation posting

The local adapter provides local work-item identity and lifecycle state. Remote
workflow automation remains intentionally unclaimed except for explicitly named,
capability-registered helpers such as GitHub PR artifact attachment.

In `.accelerate/state.yaml`, `workflow_backend: none-yet` means no remote
workflow backend is selected. It can coexist with `.accelerate/workflow/adapter.yaml`
using `adapter: local`; the former describes remote backend selection, while the
latter describes the local substitute adapter.

## Live Adapter Direction

The `One-Shot Side-By-Side Gate` is now a native core protocol, but it is not yet
backed by a complete live workflow adapter. A future live adapter should map the
same core concepts to concrete systems without changing core doctrine.

Recommended build order:

1. local `.accelerate/` workspace adapter for work-item identity, packets,
   ledgers, readiness, and closure bundles
2. Linear adapter for parent/child issue topology, comments, review state, and
   delivery status
3. GitHub Pull Request adapter for code-review-bound requested-vs-implemented
   packets, checks, and final forensic comments
4. GitHub Issues/Projects adapter for repo-native planning and board fields
5. Jira or Notion only after the shared live-adapter contract is stable

Candidate backends:

- Linear: strongest first target for execution-ready issues and lifecycle state.
- GitHub Issues + PRs: strongest repo-native target for code review and checks.
- GitHub Projects: useful for fielded planning over GitHub issues and PRs.
- Jira: useful for enterprise sprint/release/compliance environments.
- Notion databases: useful as a lightweight artifact index, weaker as strict
  execution truth unless paired with GitHub or Linear.

Until those adapters exist, do not claim live workflow automation. Use planning
artifacts, runtime packets, and tests as the governing surfaces.
