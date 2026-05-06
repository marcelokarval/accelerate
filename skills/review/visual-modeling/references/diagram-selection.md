# Diagram Selection

Use this reference to choose the primary visual model before drawing.

## Selection Ladder

1. Identify the decision surface.
2. Identify source truth.
3. Choose one primary diagram family.
4. Add companion diagrams only when a second truth would otherwise be hidden.

## Decision Surface Matrix

| If the decision is about... | Primary diagram | Companion when needed |
| --- | --- | --- |
| tables, entities, constraints, relationships | ERD | ORM lifecycle, trust boundary |
| model/query/service/presenter ownership | ORM lifecycle | ERD, sequence |
| class, function, module, import direction | class/module or function call graph | sequence |
| ordered interaction across systems | sequence | state machine, trust boundary |
| lifecycle/status transitions | state machine | sequence, swimlane |
| user/lead/operator/provider journey | swimlane/journey | UI wireframe, state machine |
| agent delegation and return authority | agent communication | governance topology |
| sensitive data crossing boundaries | trust boundary/dataflow | sequence |
| queue/job/retry/failure routing | queue topology | sequence, state machine |
| runtime/container/provider topology | deployment/topology | trust boundary |
| issue/proof/control-plane truth | governance topology | agent communication |

## Multi-Diagram Rule

Draw two diagrams when two truths would otherwise conflict:

```text
Payment provider change
├─ sequence: browser → app → Stripe → webhook → ledger
└─ state machine: trialing → active → past_due → canceled
```

Do not draw a single overloaded diagram unless the request explicitly asks for a
small overview.

## Source Truth Examples

- database models/migrations/schema files
- service/controller/task code
- provider API docs or webhook contract
- product journey description
- Linear/GitHub issue topology
- Accelerate branch/runtime/closure packets
- security or privacy policy
