# Agent Promotion Packet

Use this packet when an agent gap is being considered for promotion.

## Packet

```text
Agent Promotion Packet

- candidate family: <...>
- current state: <gap-detected|recommendation|candidate-defined|contract-approved|runtime-adapter-bound|empirically-replayed|promoted>
- recurring task class: <...>
- bounded ownership: <...>
- non-authority boundaries: <...>
- input contract: <present|missing>
- return contract: <present|missing>
- skill envelope: <path|missing>
- review isolation plan: <present|missing>
- runtime adapter binding: <present|missing|not-yet>
- empirical replay evidence: <path|missing|not-yet>
- root-only fallback: <documented|missing>
- promotion verdict: <not-ready|candidate|approved|promoted|blocked>
```

## Rule

This packet records promotion readiness only. It must not imply that a candidate
is already installed, required, or allowed to claim root authority.
