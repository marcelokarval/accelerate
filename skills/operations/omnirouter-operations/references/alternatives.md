# OmniRoute Alternatives — Comparison Boundary

## Candidates Confirmed

- FreeLLMAPI: `https://github.com/tashfeenahmed/freellmapi`
- OrcaRouter Lite: `https://github.com/Continuum-AI-Corp/OrcaRouter-Lite`

Recheck current releases and documentation before comparison.

## Current Preliminary Position

1. OmniRoute minimalized: best continuity and richest proven local provider/observability surface.
2. FreeLLMAPI: closest challenger for free-provider aggregation, profiles, routing, modalities and tools; its own README characterizes it as personal experimentation rather than production.
3. OrcaRouter Lite: cleaner architecture and Postgres option, but narrower documented provider/protocol coverage and dependence on hosted fallback for its safety-net story.

## Required Frozen Benchmark

Use identical authorized providers/models and a corpus covering:

```text
Chat Completions
Responses API
Anthropic Messages where needed
streaming and TTFT
tool calling
structured JSON
large context
images/audio/embeddings if consumed
429, timeout, 5xx and invalid model
quota exhaustion and credential expiry classification
ordered fallback and no duplicate completion
restart, backup, restore and rollback
CPU/RSS, p50/p95, tokens and cost per completed operation
logs sufficient to explain every attempt
```

## Elimination Gates

Reject a candidate that cannot provide:

- explicit aliases/profiles with deterministic ordering;
- provider/account/model failure separation;
- tool-call and streaming fidelity;
- secret-safe key storage and consumer key isolation;
- health plus request-attempt observability;
- recoverable state and rollback;
- required OAuth/web/CLI provider coverage.

“OpenAI-compatible” alone is not parity.

## Migration Rule

Run challengers isolated on different ports and state directories. Do not place one gateway permanently behind another merely to avoid a cutover decision. A temporary bridge is allowed for qualification; final architecture should have one primary gateway and one explicit rollback target.
