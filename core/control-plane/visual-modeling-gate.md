# Visual Modeling Gate

Use this gate when a branch, issue, plan, or review needs a structural model
before implementation or closure.

## Purpose

Prevent implementation from starting when the real decision is still hidden in
unstated structure: data relationships, lifecycle transitions, actor
responsibility, provider order, security boundaries, agent authority, or proof
flow.

## Trigger Matrix

| Trigger | Required model |
| --- | --- |
| schema/database/table/constraint change | ERD |
| ORM/data-access/service boundary ambiguity | ORM lifecycle |
| provider callback, payment, webhook, queue, auth flow | sequence diagram |
| lifecycle/status/terminal-state change | state machine |
| user/lead/owner/operator/provider path | swimlane/journey |
| multi-agent delegation or lane handoff | agent communication topology |
| security-sensitive auth/upload/export/billing/PII path | trust boundary/dataflow |
| infrastructure/provider/runtime shape | deployment/runtime topology |
| issue/proof/control-plane change | governance topology |
| product-critical UI | UI wireframe, usually after the system model when backend truth constrains UI |

## Required Packet

For non-trivial branches, include a compact Visual Modeling Packet:

```md
## Visual Modeling Packet

- diagram type:
- source truth:
- decision surface:
- binding:
- excluded scope:

```text
...
```

### Callouts
- [1]

### Decisions / Residuals
- accepted:
- deferred:
- residual ambiguity:
```

## No-Diagram Exception

A branch may skip visual modeling only when all are true:

- the change is trivial or mechanically local;
- no schema, lifecycle, provider order, actor responsibility, security boundary,
  or agent authority changes;
- the implementation surface is already constrained by an existing diagram or
  canonical document;
- the exception is stated explicitly in the Branch Entry Packet or review note.

## Review Questions

- Was the correct diagram family selected?
- Does the diagram name source truth?
- Does it bind to implementation/review surfaces?
- Are risk/authority/order/cardinality callouts explicit?
- Are residual ambiguities named?
- If skipped, is the no-diagram exception honest?
