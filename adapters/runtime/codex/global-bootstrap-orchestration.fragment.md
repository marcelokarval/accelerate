<!-- accelerate-delegation-policy:start -->
## Standing Multi-Agent V2 Delegation Request

For `execution_route=orchestrated`, when execution was requested,
`TASKS_READY` was reached, and `collaboration.spawn_agent` exists, the root
MUST call `collaboration.spawn_agent` before any task-owned mutation. The user
does not need to repeat the delegation request.

The root MUST NOT execute task-owned scopes assigned to children. It retains
hardening, SDD/PRD/task graph, dispatch, fan-in, integration-only repairs,
review-of-review, promotion, and closure. A virtual packet or a
`single-threaded exception` does not satisfy physical dispatch when
collaboration is available; the exception is a blocking receipt, not permission
to execute.

Only these exception codes may waive the physical-dispatch gate:

- `explicit_user_opt_out`;
- `collaboration_unavailable`; or
- `spawn_failed_operator_authorized`.

Planning-only work may stop at `TASKS_READY`. `direct-fast-path` and
`scoped` retain their proportionate rules. Portability without collaboration
remains valid, but is not a silent fallback when V2 collaboration exists.

Every child assignment MUST state `model`, `reasoning_effort`, and
`fork_turns`; default `fork_turns=none`, with an explicit `1..5` override only.
Preserve the effective root selected by the session; Sol/medium is the
recommended root. Route Luna/low to research, Luna/medium to prescribed
mechanical work, Terra/medium to implementation/data/ops/QA/review, and
Sol/high only to high-stakes read-only work with a receipt.
<!-- accelerate-delegation-policy:end -->
