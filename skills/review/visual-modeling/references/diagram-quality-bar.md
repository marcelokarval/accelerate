# Diagram Quality Bar

A visual model is acceptable only when it clarifies a decision better than prose.

## Minimum Bar

Every non-trivial diagram must include:

- diagram type
- source truth
- scope included and excluded
- fenced `text` artifact
- meaningful labels
- callouts for ambiguity/risk/authority/order/cardinality
- binding to implementation or review surface
- residual ambiguity

## Good Diagram Characteristics

- one dominant truth per diagram
- visible boundaries
- labeled arrows where payload/transition matters
- cardinality when persistence is modeled
- actor ownership when journeys or agents are modeled
- terminal states when lifecycle is modeled
- failure/retry path when async/provider work is modeled

## Common Failures

| Failure | Why it is bad |
| --- | --- |
| decorative ASCII only | no source truth or decision binding |
| everything in one blob | hides the real decision surface |
| unlabeled arrows | conceals payload, transition, or authority |
| missing cardinality | ERD cannot be reviewed |
| missing actors | journeys and swimlanes become vague |
| missing failure path | provider/queue/security work is under-modeled |
| no residuals | implies certainty not supported by evidence |

## Review Questions

- Could a zero-context implementer use this diagram to avoid a wrong structure?
- Could a reviewer use it to detect drift?
- Does the diagram expose what would break if the model is wrong?
- Is the diagram bounded enough to maintain?
