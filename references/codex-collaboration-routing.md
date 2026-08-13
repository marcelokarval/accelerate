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
| implementation or design/runtime review | Terra/medium | explicit scope and focal proof |
| mechanical fixer | Luna/medium | mechanically specified bounded write only |
| high-stakes review | Sol/high | read-only and valid reasoning receipt required |

The root must pass model and reasoning effort explicitly on each physical
binding. Otherwise the spawned agent inherits the parent runtime and this
policy has not taken effect.

`explorer` and `librarian` are the only bindings for normalized `research`.
Architecture no longer uses the librarian as a substitute for architectural
judgment. A logical skill profile in the topology is routing metadata; native
collaboration spawn does not load the corresponding `-p` process profile.

Skills, tools, and MCPs are assignment allowlists, not host-enforced isolation.
Use only the items necessary for the assignment; never use a wildcard and never
make an MCP a startup dependency. `context7`, when available, is a librarian
option for one current-documentation assignment, not an orchestrator default.

If the host cannot supply a compatible physical subagent, use scoped root-only
execution or virtual subagent packets. Preserve the selected route; never
downgrade to Direct Fast Path merely because an agent is unavailable. The
`provider-boundary` and `other` role families stay root-owned gaps unless they
are reclassified through normal Accelerate governance. Preserve root ownership
of issue topology, integration, review-of-review, and closure.

Reuse a relevant active context and prohibit duplicate active lanes. An
interrupt is stop-not-rollback: root must inspect and reconcile partial changes
in the shared filesystem before starting a replacement or overlapping writer.
