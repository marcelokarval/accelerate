# Combo Modeling and Admission — OmniRoute 3.8.50

## Rule

Create a Combo only when it represents a distinct workload contract. A new name is not useful if Fast, Balanced, Coding, or Reasoning already satisfies the same capability and latency/cost envelope.

Every admitted Combo needs:

```text
workload and exclusions
ordered provider/model/connection members
quota/account denominator
Chat/Responses/streaming/tool/structured-output requirements
failoverBeforeRetry and maxRetries
positive canary, supported negative/fallback canary, request-log readback
rollback/delete path and residue check
```

Keep `strategy=priority`, `failoverBeforeRetry=true`, and `maxRetries=0` for curated aliases unless a bounded evaluation proves another policy.

## Historical Curated Set — Read Live Before Use

The following is an operational snapshot, not current alias/provider truth.
Read the live Combo definition, member order, connection state, and applicable
admission receipts before use; do not promote or route from this table alone.

| Alias | Workload | Primary | Notes |
|---|---|---|---|
| `p0-best-fast-curated` | low-latency conversational/tool traffic | Codex Luna low | general fast path |
| `p0-best-balanced-curated` | default mixed work | Codex Terra medium | default quality/latency balance |
| `p0-best-coding-curated` | repository engineering | Codex Terra medium | tools and code quality |
| `p0-best-reasoning-curated` | difficult analysis | Codex Sol high | expensive/high-reasoning lane |
| `p1-best-vision-curated` | image understanding through Chat Completions image URL/data URL | agy Gemini 3.7 Flash medium | no audio/video/PDF promise; fallback members are Google-family routes |
| `p1-best-research-curated` | grounded web research that must return independently fetchable URLs | DeepSeek V4 Flash Search, connection AGX | second independent account is the same provider/model family; fallback under injected failure remains unproved |

### Vision order

```text
1. agy/gemini-3.7-flash-medium — agy OAuth/CLI connection
2. gemini/gemini-3.5-flash — Gemini API connection A
3. gemini/gemini-3.5-flash — Gemini API connection B
```

Admission proof on 2026-08-30/31:

- direct image canary: red-left/blue-right classified correctly;
- public alias image canary: HTTP 200, effective Gemini 3.7 Flash medium;
- alias streaming: HTTP 200, SSE data and `[DONE]` present;
- `agy` tools: valid forced tool call;
- both Gemini API connections passed image classification and streaming;
- Gemini API fallback tool parity was not proved; do not promise tools after failover;
- a temporary invalid-primary Combo terminated the client connection instead of falling through. Treat full fallback as unproved despite `failoverBeforeRetry=true` and zero retries.

Use Vision only when image input is actually present. Do not route ordinary text to it.

## Rejected / Deferred Candidates

The durable architectural disposition and reopening gates live in:

```text
~/.hermes/apps/references/omniroute/adrs/ADR-001-deferred-and-rejected-capability-candidates.md
```

This operational reference summarizes current behavior; update the ADR whenever a candidate changes status.

### Research

Admitted on 2026-08-30/31 as `p1-best-research-curated`, with this narrow contract:

```text
1. deepseek-web/deepseek-v4-flash-search — AGX account
2. deepseek-web/deepseek-v4-flash-search — Marcelo account
strategy=priority
config.maxRetries=0
config.failoverBeforeRetry=true
```

Evidence:

- both pinned connections returned HTTP 200 independently with a current official `redis.io` URL;
- the public Combo returned HTTP 200 in 26.2 seconds with two independently fetchable official `redis.io` URLs;
- the two source URLs were opened successfully in a browser;
- temporary canary API keys were deleted after each run;
- Gemini `deep-research-preview-04-2026` returned HTTP 400 because it requires the Interactions API, so it is excluded from this Chat Completions Combo;
- fallback after an injected 429/5xx/timeout remains unproved; two accounts on the same provider/model family are account redundancy, not provider diversity.

Use Research only when the task actually requires web retrieval and cited URLs. The consumer must still validate citation reachability and claim-to-source entailment for consequential decisions.

### LongContext

Deferred. No frozen large-context corpus, token ceiling, recall score, latency ceiling, or cost ceiling was proved. Without those, it duplicates Balanced/Reasoning.

### Cheap / Batch

Deferred. A free model shown in the aggregate registry was absent from its live provider connection catalog. Admit only after real model visibility, structured-output/tool tests, sustained throughput, and spend-quality thresholds.

### Emergency

Do not create a static emergency alias. It drifts and may silently weaken capability. Emergency routing should be an incident-time, explicitly authorized temporary Combo with removal/readback.

### Separate Tools or Structured-Output alias

Not currently justified. Tools and JSON are protocol contracts that the existing general aliases should satisfy. Split them only if a model/provider matrix proves a stable incompatibility requiring a separate route.

## Capability Matrix Before Future Admission

Score each candidate on:

```text
provider/account independence
model visibility in live connection catalog
tools and forced tool choice
streaming completion and clean termination
structured JSON invariants
Responses API compatibility when required
image/audio/video/PDF modality actually exercised
p50/p95 and timeout behavior
quota window and refresh behavior
request/effective model and attempt visibility
429/5xx/timeout/cooldown fallback
cost attribution
```

Never claim failover from configuration alone. A request that ends with a browser/network abort is a failed canary even if a dashboard test endpoint reports each member healthy.
