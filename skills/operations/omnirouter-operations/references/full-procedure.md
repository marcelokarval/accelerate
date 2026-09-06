# Historical Full Procedure (pre-2.3.0)

> Historical preservation copy of the complete former `SKILL.md`, retained before
> the 2.3.0 progressive-disclosure rewrite. It is not current operating policy.
> Use the current `SKILL.md` and its directly linked references; do not infer
> current runtime, provider, model, alias, or version truth from this archive.

---

````markdown
---
name: omnirouter-operations
description: >-
  Use when operating, configuring, auditing, documenting, troubleshooting,
  comparing, or qualifying the local OmniRoute/OmniRouter gateway, including
  providers and OAuth/CLI accounts, aliases/Combos, quotas, resilience,
  routing, API keys, exposed APIs, dashboards, Traffic Inspector,
  compression/cache/memory safety, costs, logs, health, backups, service
  lifecycle, alternatives, canaries, or rollback. Do not use it to classify
  agent work or authorize business actions.
version: 2.2.1
author: Karval/Hermes
license: Proprietary - Karval/Hermes internal use
compatibility: OmniRoute 3.8.50 on Linux with systemd --user, local dashboard/API on port 20128, and Agent Skills-compatible clients.
metadata:
  hermes:
    category: runtime-operations
    tags:
      - omniroute
      - llm-gateway
      - routing
      - resilience
      - observability
      - traffic-inspector
      - compression-safety
    related_skills:
      - accelerate
      - hermes-runtime-truth
      - production-runtime-operations
      - verification-before-completion
    canonical_source: skills/operations/omnirouter-operations
    governed_by: accelerate/root
---

# OmniRoute Operations

Operate OmniRoute as a **minimal governed LLM gateway**, not as an agent-workflow authority or a blanket semantic transformation layer.

## Runtime Contract

- Service: `omniroute.service` (`systemd --user`).
- Dashboard/API: `http://127.0.0.1:20128`.
- Stable release is an exact published version; never infer stability from `main`, `master`, or `--latest`.
- OmniRoute owns provider connectivity, model exposure, aliases/Combos, availability, quota, routing, failover, circuit/cooldown/lockout, transport observability, and cost attribution.
- Thor/Hermes owns task classification, authorization, memory, sessions, agent routing, completion, and governance.
- PostgreSQL is Hermes state authority; OmniRoute's SQLite is only OmniRoute's own control/data plane.

## Required Flow

1. Read `references/runbook.md`.
2. Read the narrow reference matching the operation.
3. Capture live health/version/settings and create a restricted rollback backup.
4. Use the supported API/UI/CLI; do not edit OmniRoute SQLite directly.
5. Make the smallest coherent change.
6. Read back effective state and run positive, negative, tool, routing, and prompt-integrity proof as applicable.
7. Roll back on health, authorization, routing, tool, prompt-integrity, redaction, or observability regression.

Never print provider keys, OAuth tokens, cookies, complete authorization headers, raw customer prompts, or captured traffic bodies in reports.

## Resource Router

- `references/runbook.md` — runtime preflight, backup, supported mutation, canary, rollback, and closure.
- `references/minimal-governed-configuration.md` — target Keep/Enable/Disable policy and exact invariants.
- `references/dashboard-route-map.md` — sidebar and direct dashboard routes, including known 404/loading gaps.
- `references/api-and-settings-map.md` — exposed protocol surfaces, management APIs, settings methods, and 3.8.50 contract gaps.
- `references/compression-safety.md` — mandatory for endpoint calls, benchmarks, cache/memory isolation, or compression changes.
- `references/traffic-inspector.md` — internal solo-developer capture model, redaction, HTTP proxy, sessions, HAR, replay prohibition, and rollback.
- `references/provider-antigravity-agy.md` — distinction between `antigravity` IDE/OAuth provider and `agy` CLI/provider, health, discovery, and admission gates.
- `references/combo-modeling-and-admission.md` — workload taxonomy, current curated aliases, Vision/Research contracts, rejected/deferred candidates, capability matrix, and fallback proof requirements.
- `references/redis-rate-limit-backend.md` — Redis environment projection, API-key rate-limit persistence proof, and the separate `agy` Bottleneck lifecycle.
- `references/feature-classification.md` — proven core, situational features, experiments, conflicts with Hermes, and product-sprawl exclusions.
- `references/alternatives.md` — evidence-based comparison boundaries for FreeLLMAPI and OrcaRouter Lite.

## Non-Negotiable Safety Defaults

For generic critical calls that must preserve exact input:

```http
X-OmniRoute-Compression: off
X-OmniRoute-No-Cache: true
X-OmniRoute-No-Memory: true
```

Global invariants:

```text
compression.enabled=false
compression.defaultMode=off
compression.activeComboId=null
compression.engines.ccr.enabled=false
memory.enabled=false
outputStyles=[]
credentialRedactionEnabled=true
mcpEnabled=false
a2aEnabled=false
customSystemPromptEnabled=false
comboAutoPromoteEnabled=false
```

Prompt/provider native caching is distinct from OmniRoute semantic-response caching. Preserve provider-native cache behavior unless a frozen test requires isolation; keep semantic replay out of critical calls with the request header.

## Verification

Completion requires fresh evidence for:

- exact version, service PID/state/restarts, health and recent logs;
- settings readback and rollback artifact integrity;
- model/provider/alias enumeration and one real tool call on governed aliases;
- intended primary plus a supported non-destructive fallback proof;
- no CCR marker or unexplained cache/memory injection in prompt-integrity tests;
- Traffic Inspector redaction and bounded capture behavior when enabled;
- recursive skill validation and mirror parity across configured client catalogs.
````
