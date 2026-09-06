# OmniRoute Dashboard Route Map — 3.8.50

Treat a route as **UI presence**, not capability proof. A page can exist while its service is disabled, empty, stuck loading, or incompatible with a provider.

## Core Gateway

| Area | Route | Operational use |
|---|---|---|
| Endpoints | `/dashboard/endpoint` | base URLs and protocol surfaces |
| API Keys | `/dashboard/api-manager` | consumer isolation/access |
| Providers | `/dashboard/providers` | connections and health |
| Embedded Services | `/dashboard/providers/services` | optional bridges only |
| Combos | `/dashboard/combos` | ordered fallback aliases |
| Combo Studio | `/dashboard/combos/live` | live Combo attempts over WebSocket |
| Provider Quota | `/dashboard/quota` | account/model windows and resets |
| Quota Sharing | `/dashboard/costs/quota-share` | beta pools; keep empty by default |

## Compression Context

```text
/dashboard/context/settings
/dashboard/context/caveman
/dashboard/context/rtk
/dashboard/context/headroom
/dashboard/context/session-dedup
/dashboard/context/ccr
/dashboard/context/llmlingua
/dashboard/context/lite
/dashboard/context/aggressive
/dashboard/context/ultra
/dashboard/context/omniglyph
/dashboard/context/combos
/dashboard/compression/studio
/dashboard/compression/exclusions
```

Known 3.8.50 broken links:

```text
/dashboard/context/relevance        -> 404
/dashboard/context/codex-responses  -> 404
```

## Analytics, Costs and Monitoring

```text
/dashboard/analytics
/dashboard/analytics/combo-health
/dashboard/analytics/utilization
/dashboard/cache
/dashboard/analytics/compression
/dashboard/analytics/sessions
/dashboard/costs
/dashboard/costs/pricing
/dashboard/costs/budget
/dashboard/free-tiers
/dashboard/free-provider-rankings
/dashboard/audit
/dashboard/audit/mcp
/dashboard/audit/a2a
/dashboard/health
/dashboard/runtime
/dashboard/resilience/connections
/dashboard/memory
```

`/dashboard/radar` is a known 3.8.50 404. Cost pages may be hidden by sidebar personalization while remaining directly accessible.

## Tools and Agentic Surfaces

```text
/dashboard/cli-code
/dashboard/cli-agents
/dashboard/acp-agents
/dashboard/cloud-agents
/dashboard/conductor
/dashboard/tools/agent-bridge
/dashboard/tools/traffic-inspector
/dashboard/discovery
```

Classify loading-only pages as unproved. Conductor is out of the Karval architecture; Thor governs agents. AgentBridge/TLS interception stays off unless separately authorized.

## Integrations and System

```text
/dashboard/api-endpoints
/dashboard/webhooks
/dashboard/system/proxy
/dashboard/settings/general
```

The API Endpoint catalog enumerates management and inference routes. It is not a substitute for protocol smoke tests.

## Low-Value Product Surfaces

Profile/community, leaderboard, token balances, achievements, referrals and rewards are not part of the runtime denominator. Hide or ignore them; do not justify the gateway with these features.

## Browser Investigation Method

1. Authenticate to the dashboard without persisting credentials in artifacts.
2. Expand each sidebar group and record exact hrefs.
3. Navigate directly and capture `main.innerText` plus controls.
4. Distinguish `200 page shell` from loaded functional content.
5. Record 404, stuck loading, empty state, disabled backend, and real data separately.
6. Never submit a form during read-only inventory.
