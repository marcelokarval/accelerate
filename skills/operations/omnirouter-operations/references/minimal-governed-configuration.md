# OmniRoute Minimal Governed Configuration

## Target Architecture

```text
Hermes/apps
  -> OmniRoute minimal gateway
       -> API-key isolation
       -> providers and authenticated connections
       -> aliases/Combos with explicit ordering
       -> quota-aware routing
       -> circuit breaker / cooldown / model lockout
       -> request, proxy, cost and health observability
       -> providers
```

OmniRoute does not own Hermes sessions, memory, task routing, agent orchestration, governance, completion, or business authorization.

## Keep and Use

| Capability | Policy | Acceptance |
|---|---|---|
| OpenAI Chat/Responses and Anthropic Messages ingress | keep | protocol smoke plus tools/streaming |
| providers and connection health | keep | active state and masked readback |
| API keys per consumer | keep | isolation, allowed models/Combos, rotation path |
| governed aliases/Combos | keep | explicit ordered members and fallback proof |
| quota dashboard/API | keep | freshness, reset window and account attribution |
| resilience | keep | account cooldown, provider breaker and model lockout |
| request/proxy logs | keep | request ID, requested/effective model, latency, tokens, attempts |
| pricing/cost/budget | keep with verification | pricing coverage and consumer attribution |
| webhooks | candidate | HTTPS destination, HMAC and delivery canary before production use; loopback/private destinations are blocked |
| Traffic Inspector | enable bounded internal mode | redaction, explicit proxy, no system proxy/TLS intercept |
| curated Vision alias | keep with bounded contract | real image + streaming proof; do not promise audio/video/PDF or fallback tool parity |
| curated Research alias | keep with bounded contract | two pinned DeepSeek Search accounts and independently fetchable citations; no Gemini Interactions support or provider-diverse fallback promise |
| Redis API-key rate-limit backend | keep | isolated `REDIS_URL` projection, persistent counter proof across OmniRoute restart, no fresh in-memory warning |
| Headroom | qualification-only | explicit per-request use for known homogeneous tabular JSON |

## Disable or Keep Out of the Default Path

```text
global compression and output styles
CCR, relevance, aggressive, ultra, LLMLingua and OmniGlyph
OmniRoute memory
semantic replay for critical traffic
MCP and A2A unless a named integration requires them
Conductor, Cloud Agents, ACP orchestration
AgentBridge/TLS interception
system-wide proxy
Discovery scans
Quota Sharing beta
Chaos/MoA runtime features
community, rewards, tokens and gamification
custom system-prompt injection
automatic Combo promotion
```

Disabling a concept does not always have one global toggle. Some features are simply left unconfigured and excluded from the production denominator.

## Sidebar Operational Profile

For this single-developer internal deployment, keep the UI broad enough for
operations but hide inactive/experimental noise. The applied profile keeps:

- OmniProxy core: Endpoints, API Keys, Providers, Combos, Provider Quota.
- Compression Context: Settings and qualified Headroom only.
- Tools: Traffic Inspector only.
- Integrations: API Endpoints and Webhooks; keep Proxy visible for diagnosis.
- Analytics, Costs, Monitoring, Configuration and Help.
- Costs: Overview, Pricing, Budget, Free-Tier Budget and Rankings; hide Radar
  while its route is 404.

Hide Quota Sharing beta, unqualified compression engines, Conductor,
AgentBridge, Discovery, inactive Agentic/Other/Gamification/Batch surfaces,
and specialized audits with their backing feature disabled.

In 3.8.50, `hiddenSidebarSections` is ignored by the settings handler/readback.
Use `hiddenSidebarItems` with every child ID; an empty section then disappears
from the rendered sidebar. Verify critical settings after PATCH because a
settings update may normalize unrelated sidebar fields.

## Required Invariants

```json
{
  "compression": {
    "enabled": false,
    "defaultMode": "off",
    "activeComboId": null,
    "ccr": false,
    "outputStyles": []
  },
  "memory": {"enabled": false},
  "general": {
    "credentialRedactionEnabled": true,
    "mcpEnabled": false,
    "a2aEnabled": false,
    "customSystemPromptEnabled": false,
    "comboAutoPromoteEnabled": false,
    "debugMode": false,
    "logToolSources": false
  },
  "trafficInspector": {
    "httpProxy": false,
    "httpProxyPolicy": "bounded-on-demand",
    "systemProxy": false,
    "tlsIntercept": false,
    "customHosts": 0
  }
}
```

`compression.enabled=false` removes the ambiguity where `defaultMode=off` coexists with explicitly enabled engines. Engine configuration may remain stored for future explicit qualification, but no implicit pipeline may run.

## Cache Distinction

- Provider-native prompt caching reduces cost without replaying a prior answer; it may remain enabled.
- OmniRoute semantic cache can replay semantically similar completions; critical calls use `X-OmniRoute-No-Cache: true`.
- Do not globally destroy useful provider cache economics merely to isolate one benchmark.

## Resilience

Preserve the three failure denominators:

1. model-level lockout;
2. connection/account-level cooldown;
3. provider-level circuit breaker.

Keep `failover before retry` for aliases. Do not increase retries merely to hide a bad provider. Inject failures only through a supported non-secret test path; never invalidate a live credential to prove fallback.

## Residual Decisions

- Webhook alerts have a working JSON API and HMAC/retry UI contract, but `validate-url` blocks loopback/private destinations. Production activation requires an explicit public HTTPS destination, selected events, idempotency/deduplication and a signed test delivery.
- Budget APIs are per API key and require the key denominator plus explicit numerical limits; do not invent them.
- Provider quota preflight thresholds require corpus evidence before enforcement.
- `agy` is admitted only while active, refreshed and passing a real tool canary. The governed secondary connection stores `maxConcurrent=2` and `rateLimitProtection=true`; its Bottleneck runtime manager returns `enabled=false` after service restart and must be explicitly re-enabled through `POST /api/rate-limits` with readback. Redis-backed API-key counters are a separate limiter and do not fix this process-local Set. Do not hide the gap in an unreviewed daemon.
- The OmniRoute service receives Redis through a minimal `0600` projection containing only `REDIS_URL` and `REDIS_KEY_PREFIX`; never attach the full Hermes `.env`. Require a counter `1 → restart → 2` proof and canary cleanup.
- `p1-best-vision-curated` is admitted for image understanding only. Full invalid-primary/429/5xx fallback remains unproved and must not be claimed from configuration alone.
- `p1-best-research-curated` is admitted for cited web research via two pinned DeepSeek Flash Search accounts. Gemini Deep Research is excluded because it requires the Interactions API; provider-diverse fallback remains unproved.
