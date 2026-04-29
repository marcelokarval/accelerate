# Prompt Upgrade Approval Packet

Use this packet when the `Prompt Upgrade Approval Gate` is active.

## Packet

```text
Prompt Upgrade Approval Packet

- raw prompt source:
- target repo / project:
- stack basis:
- active Accelerate gates inferred:
- ambiguity removed:
- scope added:
- non-goals added:
- proof lanes added:
- persisted artifacts required:
- approval boundary phrase:
- improved prompt presented: <yes|no>
- approval status: <waiting|approved|rejected|rework-requested>
- post-approval artifacts:
- execution authorization: <not-requested|requested|approved|blocked>
- commit/push authorization: <not-requested|requested|approved|blocked>
```

## Rule

This packet is a boundary marker. Until approval status is `approved`, the run
may improve the prompt but must not execute it.
