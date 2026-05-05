# Template Promotion Readiness Packet

Use this packet before moving any file under `agents/templates/` beyond
`template-only`.

```text
Template Promotion Readiness Packet

- template path: <agents/templates/name.md>
- base contract reference: <agents/base-agent-contract.md|missing>
- selected role family: <architecture|backend|frontend|qa-regression|security|governance|provider-boundary|product-runtime|other>
- compatible capability family: <family|missing|gap>
- recurring task class: <description|missing>
- required skills / profiles: <...>
- prohibited authority: <...>
- return contract: <Task Execution Return Packet|Skeptical Review Packet|Agent Return Packet|missing>
- cleanup behavior: <closed|completed|retained-with-reason|not-applicable|missing>
- review isolation plan: <description|missing>
- root integration plan: <description|missing>
- runtime adapter binding status: <not-bound|planned|bound>
- physical runtime adapter: <path|missing|not-needed-yet>
- install state: <not-installed|installed|rolled-back>
- export state: <not-exported|exported|rolled-back>
- install/export contract: <agents/promotion/install-export-contract.md|missing>
- host export manifest: <path|n/a>
- empirical replay status: <not-run|fixture-backed|real-work-backed|missing>
- root-only or virtual fallback: <root-only|virtual-subagent-packets|missing>
- promotion state: <doctrine-only|template-only|candidate-defined|contract-approved|runtime-adapter-bound|installed|exported|empirically-replayed|promoted|rolled-back>
- promotion blockers: <items|none>
```

## Rules

- `template-only` is the only valid state without empirical replay.
- `promoted` requires a bound runtime adapter and empirical replay.
- `installed` and `exported` are host/export facts, not promotion states.
- Runtime adapter status `planned` cannot support `promoted`.
- Missing fallback blocks every state after `candidate-defined`.
