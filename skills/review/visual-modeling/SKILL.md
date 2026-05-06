---
name: visual-modeling
description: Accelerate-native ASCII visual modeling for ERDs, ORM lifecycles, sequence diagrams, state machines, swimlanes, agent communication, trust boundaries, and system topology. Use when a decision needs a structural visual model rather than only prose or UI wireframe.
metadata:
  category: review
  origin: accelerate-native
  related_skills:
    - architecture
    - ascii-wireframe
    - database-design
    - product-runtime-review
    - subagent-governance
    - security-patterns
---

# visual-modeling

Use this skill when the work needs a **model of structure, lifecycle, authority,
or interaction** before implementation or review.

This skill is not about decorative diagrams. An Accelerate visual model is a
contract artifact: it records source truth, decision surface, binding, callouts,
and residual ambiguity.

## Boundary With `ascii-wireframe`

Use `ascii-wireframe` for UI/product surfaces: pages, modals, overlays,
responsive structure, before/after UI, and visual states.

Use `visual-modeling` for non-UI system models:

- ERD / persisted data model
- ORM lifecycle
- class/module/function relationships
- sequence diagrams
- state machines
- swimlanes / journeys
- agent communication and team topology
- C4 / architecture topology
- deployment/runtime topology
- queue topology
- trust boundary / dataflow
- governance / issue / proof topology

If the UI depends on persisted truth, lifecycle, provider order, actor
responsibility, or agent authority, draw the system model first, then draw the UI
wireframe as a companion.

## Mandatory Protocol

When invoked for a diagram/modeling task:

1. Identify the model type.
2. Name the source truth being modeled.
3. Choose one primary diagram family.
4. Draw the visual artifact in a fenced `text` block.
5. Add callouts for non-obvious authority, risk, cardinality, ordering, or
   ownership.
6. State what the diagram constrains and what remains ambiguous.

Prohibited:

- text-only answers when a diagram was requested
- hybrid blobs that mix ERD, sequence, UI, and deployment without a reason
- diagrams that do not identify source truth
- diagrams that imply unverified runtime facts

## Required References

Read the relevant references before drawing:

- `references/diagram-selection.md`
- `references/notation-vocabulary.md`
- `references/diagram-quality-bar.md`
- `references/stack-trigger-matrix.md`

Use templates from `references/templates/` for the concrete diagram family.

## Diagram Families

| Family | Use when |
| --- | --- |
| ERD | tables/entities/cardinality/constraints/tenant ownership are changing |
| ORM lifecycle | model/query/service/presenter boundaries are unclear |
| class/module | code ownership, imports, classes, or function relationships matter |
| sequence | actor/system ordering matters: webhooks, auth, payment, queues, agents |
| state machine | lifecycle transitions and terminal states matter |
| swimlane/journey | actor responsibility over time matters |
| agent communication | delegation, return contracts, and closure authority matter |
| trust boundary/dataflow | sensitive data crosses auth/provider/upload/payment boundaries |

## Output Packet Shape

For any non-trivial model, include:

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
- [2]

### Decisions / Residuals
- accepted:
- deferred:
- residual ambiguity:
```

## Accelerate Guidance

- Prefer one strong diagram over one overloaded drawing.
- If two truths matter, draw two diagrams and name their relationship.
- For database/schema work, default to ERD first.
- For provider/webhook/payment/queue work, default to sequence first and add a
  state machine when lifecycle changes.
- For user/lead/operator paths, default to swimlane/journey.
- For subagent work, default to agent communication topology.
- For security-sensitive paths, default to trust boundary/dataflow.

## Verification

Before finishing, verify:

- Does the diagram type match the decision?
- Is the source truth named?
- Is the artifact inside a fenced `text` block?
- Are callouts present when authority/risk/order/cardinality is non-obvious?
- Is binding to implementation/review surface explicit?
- Are residual ambiguities named instead of hidden?
