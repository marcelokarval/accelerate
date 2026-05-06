# Visual Modeling Packet

## Purpose

This packet turns an ASCII diagram into an Accelerate contract artifact. Use it
when a branch depends on structural truth: data relationships, lifecycle states,
actor responsibility, provider ordering, trust boundaries, agent authority, or
issue/proof topology.

A diagram alone is not proof. This packet records why the diagram exists, what
source truth it models, what implementation or review surface it constrains, and
what ambiguity remains.

## When Required

Use this packet when `Visual Modeling Gate` is active for:

- ERD / database / schema / table relationship decisions
- ORM lifecycle or service-boundary decisions
- class/module/function relationship decisions
- sequence diagrams for providers, webhooks, auth, queues, payments, or agents
- state machines for lifecycle/status transitions
- swimlane/journey maps for user, lead, owner, operator, provider, or agent paths
- trust boundary/dataflow diagrams for security-sensitive paths
- deployment/runtime/queue topology
- governance/issue/proof topology

## Packet Template

```md
# Visual Modeling Packet

## Scope

- branch/slice:
- diagram type:
- decision surface:
- target audience:

## Source Truth

- files/docs/code/issues inspected:
- assumptions:
- explicit non-sources:

## Included / Excluded

- included:
- excluded:

## Diagram Artifact

```text
...
```

## Callouts

- [1]
- [2]

## Binding

- implementation surface constrained:
- review surface constrained:
- related packet/gate:

## Decisions

- accepted:
- rejected:
- deferred:

## Residual Ambiguity

- unknowns:
- risks:
- follow-up required:
```

## Blocking Conditions

Do not close a branch requiring visual modeling when:

- no source truth is named;
- the diagram family does not match the decision surface;
- the artifact is prose-only or not fenced as `text`;
- cardinality, state transitions, async paths, trust boundaries, or agent authority
  are relevant but absent;
- implementation or review binding is missing;
- residual ambiguity is hidden.

## Closure Rule

Closure should state:

- `Visual Modeling=<present|not-required|blocked>`
- `diagram type=<family>`
- `source truth=<files/docs/code/issues or assumption>`
- `blocking residual=<gap or none>`
