# OmniRoute API and Settings Map — 3.8.50

## Inference Surfaces

Primary endpoints advertised by the live dashboard:

```text
POST /v1/chat/completions
POST /v1/responses
POST /v1/messages
POST /v1/completions
POST /v1/embeddings
POST /v1/images/generations
POST /v1/images/edits
POST /v1/audio/transcriptions
POST /v1/audio/speech
POST /v1/music/generations
POST /v1/videos/generations
POST /v1/search
POST /v1/rerank
POST /v1/moderations
POST /v1/batches
POST /v1/files
GET  /v1/models
```

Registry presence is not provider coverage. Qualify each used protocol with its real client payload, streaming mode, tools, structured output, errors and response metadata.

## High-Value Management Reads

```text
GET /api/health
GET /api/monitoring/health
GET /api/storage/health
GET /api/settings
GET /api/settings/compression
GET /api/settings/memory
GET /api/resilience
GET /api/providers/quota-windows
GET /api/usage/provider-limits
GET /api/providers/client
GET /api/rate-limits
GET /api/providers
GET /api/cache
GET /api/sessions
GET /api/db-backups
GET /api/tools/traffic-inspector/capture-modes
GET /api/tools/traffic-inspector/requests
GET /api/tools/traffic-inspector/sessions
```

The Provider Quota dashboard uses `/api/providers/quota-windows`,
`/api/usage/provider-limits`, and `/api/providers/client`. `/api/rate-limits`
describes rate-limit protection/concurrency state and is not the quota balance/window
authority. Provider responses contain masked credentials and identity metadata. Reduce
them to non-secret fields before saving evidence.

## Supported Settings Mutations

```text
PATCH /api/settings             partial general settings
PUT   /api/settings/compression partial compression settings
PUT   /api/settings/memory      partial memory settings
PATCH /api/resilience           partial resilience settings
POST  /api/rate-limits           enable/disable protection for one connection
GET   /api/webhooks              list webhook definitions
POST  /api/webhooks              create a webhook
PUT   /api/webhooks/{id}         update events/enabled/configuration
DELETE /api/webhooks/{id}        delete a webhook
POST  /api/webhooks/{id}/test    signed test delivery
POST  /api/webhooks/validate-url validate destination/SSRF boundary
```

Use authenticated management-session/API access. Submit only fields in scope and immediately read back the whole affected denominator.

### General fields relevant to Karval

```text
credentialRedactionEnabled
mcpEnabled
a2aEnabled
customSystemPromptEnabled
comboAutoPromoteEnabled
debugMode
logToolSources
requestRetry
maxRetryIntervalSec
requireLogin
idempotencyWindowMs
```

Do not change login/auth, retry budgets, or listener exposure incidentally.

### Compression fields

```text
enabled
defaultMode
activeComboId
engines
outputStyles
contextBudget
exclusions
```

In 3.8.50, `defaultMode=off` alone is not an adequate global disable when explicit engines remain enabled. Use `enabled=false`, retain `defaultMode=off`, `activeComboId=null`, `CCR=false`, and no output styles.

## Traffic Inspector APIs

```text
GET    /api/tools/traffic-inspector/capture-modes
POST   /api/tools/traffic-inspector/capture-modes/http-proxy
POST   /api/tools/traffic-inspector/capture-modes/system-proxy
POST   /api/tools/traffic-inspector/capture-modes/tls-intercept
GET    /api/tools/traffic-inspector/requests
DELETE /api/tools/traffic-inspector/requests
GET    /api/tools/traffic-inspector/requests/{id}
POST   /api/tools/traffic-inspector/requests/{id}/replay
PUT    /api/tools/traffic-inspector/requests/{id}/annotation
GET    /api/tools/traffic-inspector/export.har
GET    /api/tools/traffic-inspector/sessions
POST   /api/tools/traffic-inspector/sessions
PATCH  /api/tools/traffic-inspector/sessions/{id}
DELETE /api/tools/traffic-inspector/sessions/{id}
GET    /api/tools/traffic-inspector/sessions/{id}/export.har
```

The HTTP proxy action body is `{"action":"start"}` or `{"action":"stop"}`.

The running listener is not evidence that OmniRoute/provider calls are globally proxied. Verify service environment, `/api/settings/proxy`, per-provider proxy fields and system-proxy state separately. In 3.8.50, recent logs can emit repeated `ProxyFetch` timeout warnings targeting `localhost:8080`; correlate timestamps/request IDs before attributing them to provider routing, and never suppress the signal by enabling system proxy or TLS interception.

## Webhook Boundary

`POST /api/webhooks/validate-url` rejects loopback/private destinations (`reason=blocked_private`) and accepts valid public HTTPS destinations. Custom payloads use HMAC-SHA256 over the raw body; the UI states a 10-second delivery timeout and up to five exponential-backoff retries. Do not create a persistent webhook until destination ownership, events, deduplication and alert-noise policy are explicit.

## Known Contract Gaps

- `POST /api/db-backups` is documented/CLI-generated as “Create database backup”, but the live 3.8.50 handler rejected an empty request requiring `backupId`, behavior consistent with restore semantics. Use a restricted SQLite online backup until upstream behavior is fixed/qualified.
- The API catalog reports hundreds of routes; that count is not acceptance evidence.
- Some dashboard links are 404 while the related engine/registry entry exists.
- API key request counters, billing attribution and request logs may use different denominators; reconcile before audit claims.

## Safe Evidence Shape

Persist only:

```text
status/version/timestamp
setting names and booleans/non-secret thresholds
provider identifier, auth type, active/test state, masked account label
alias, requested/effective model, attempts, status, latency, token counts
request IDs and redaction proof
```

Never persist raw `/api/providers`, export-all, database dumps, cookies, auth headers, token values or captured bodies outside restricted rollback storage.
