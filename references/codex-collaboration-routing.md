# Codex Collaboration Routing

Use this reference only when the host exposes `collaboration.spawn_agent` and
Accelerate has already selected a real sidecar route.

The source policy is the repository-local
`adapters/runtime/codex-collaboration/role-policy.json`. Its byte-identical
runtime export is `references/codex-collaboration-role-policy.json`; use that
file when the full role bindings are needed. This page preserves the decision
summary needed during a Codex session:

| Route or role | Default binding | Boundary |
| --- | --- | --- |
| direct-fast-path | root keeps its effective session | zero subagents |
| explorer or librarian | Luna/low | read-only, one bounded sidecar at most |
| implementation, data-db, provider-boundary, design/runtime review | Terra/medium | explicit scope and focal proof |
| mechanical fixer | Luna/medium | mechanically specified bounded write only |
| high-stakes review | Sol/high | read-only and valid reasoning receipt required |

The root must pass model, reasoning effort, and fork explicitly on each physical
binding. `none` is the default fork, only an integer from `1..5` is permitted,
and `all` is forbidden with an override. Child bindings never inherit root
settings.

Skills, tools, and MCPs are assignment allowlists, not host-enforced isolation.
Use only the items necessary for the assignment; never use a wildcard and never
make an MCP a startup dependency. `context7`, when available, is a librarian
option for one current-documentation assignment, not an orchestrator default.

`orchestrated` execution requires 2-3 physical executor/reviewer bindings and
a valid [dispatch receipt](delegation-dispatch-gate.md) before the task-owned
write barrier. Direct has zero bindings; Scoped has at most one sidecar and
cannot hide implementation. Virtual work is degradation only after
`collaboration_unavailable` or `spawn_failed_operator_authorized`; it never
satisfies available physical dispatch. A single-threaded exception is a blocker.

Root preserves the user/runtime-selected effective session model; Sol/medium is
the recommended default. Root owns hardening, SDD/PRD, task graph, dispatch,
fan-in, integration-only repairs, review-of-review, and closure; root does not
execute task-owned scopes. Nested Terra-to-Luna is forbidden unless root
authorizes one Luna/medium mechanical leaf with disjoint scopes, Terra
accountability, and an independent reviewer. The total physical budget is
exactly 3 (Terra parent, Luna child, independent reviewer). Luna is a leaf.
