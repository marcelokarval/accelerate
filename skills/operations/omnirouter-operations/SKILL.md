---
name: omnirouter-operations
description: Use for OmniRoute operations, model research, audits, qualification, and bounded comparisons; not agent dispatch or business authorization.
metadata:
  version: 2.5.1
  author: Karval/Hermes
  license: Proprietary - Karval/Hermes internal use
  compatibility: OmniRoute 3.8.50 on Linux with systemd --user and Agent Skills-compatible clients
  hermes:
    category: runtime-operations
    tags: [omniroute, llm-gateway, routing, resilience, observability]
    related_skills: [accelerate, hermes-runtime-truth, production-runtime-operations, verification-before-completion]
    canonical_source: skills/operations/omnirouter-operations
    governed_by: accelerate/root
---

# OmniRoute Operations

Operate OmniRoute as a minimal governed LLM gateway.
It is not an agent-workflow authority or semantic transformation layer.

## Scope and authority

OmniRoute owns provider connectivity, exposed models, aliases/Combos, quotas,
routing, failover, cooldowns, transport observability, and cost attribution.
Thor/Hermes owns task classification, authorization, sessions, memory, agent
routing, completion, and governance.

PostgreSQL is Hermes state authority.
OmniRoute SQLite is only OmniRoute control/data-plane state.
This skill informs role hypotheses; it does not assign agents or authorize work.

The production listener may intentionally bind its authorized private LAN.
Do not rebind it, label it defective merely for non-loopback binding, or infer
Internet exposure; use loopback URLs for same-host probes.

Stable authority is an exact published release, not `main`, `master`, or `--latest`.
The compatibility line is a documented baseline, not live runtime truth.

## Choose the mode

First identify the narrowest mode and load only its listed references.

| Mode | Read before acting | Live mutation/proof |
|---|---|---|
| Documentation or route map | dashboard/API/reference named by request | none unless explicitly requested |
| Research-only role hypothesis | [research method](references/model-research-method.md) | prohibited |
| Controlled small role comparison | [comparison contract](references/model-role-comparison.md) | frozen task only; no gateway change |
| Runtime diagnosis or audit | [runbook](references/runbook.md) plus narrow reference | fresh readback as requested |
| Settings/provider/alias mutation | runbook plus governing reference | backup, supported mutation, readback, proof |
| Provider/model qualification | [capability battery](references/model-capability-battery.md) and runbook | frozen battery and applicable gates |

Documentation and research-only work do not require a service call, backup,
paid test, provider access, or runtime claim.
Do not use an archived source as a substitute for live readback.

## Required operational flow

For runtime diagnosis, audit, qualification, or mutation:

1. Read [runbook](references/runbook.md) and the narrow governing reference.
2. Establish source/version/service/settings truth at the requested scope.
3. Before a mutation, create the restricted rollback backup required by runbook.
4. Use the supported API, UI, or CLI; never directly edit OmniRoute SQLite.
5. Only in mutation scope, make the smallest authorized change.
6. Read back the complete affected denominator.
7. Run the applicable positive, negative, routing, tool, and integrity proof.
8. Roll back on health, authorization, routing, tool, integrity, redaction, or
   observability regression.

For research and comparison modes, use their reference contract instead.
Research cannot mutate aliases or replace qualification.
Comparison cannot promote a model, provider, or Combo.

## Safety defaults

Critical calls that must preserve exact input send:

```http
X-OmniRoute-Compression: off
X-OmniRoute-No-Cache: true
X-OmniRoute-No-Memory: true
```

Keep these global invariants unless a named authorized operation changes one:

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

Provider-native prompt caching is not OmniRoute semantic response caching; preserve
it unless a frozen isolation test requires otherwise.
Keep semantic replay out of critical calls with the request header.

Never print provider keys, OAuth tokens, cookies, complete authorization
headers, raw customer prompts, or captured traffic bodies.
Never corrupt a credential to prove fallback.

## Model-role evidence boundary

The dated [2026-09-05 archive](references/model-research-2026-09-05.md) is a
historical hypothesis set, not current provider, model, route, cost, tool, or
runtime evidence. It cannot change a Combo, executor policy, or admission.

Use [model-research-method.md](references/model-research-method.md) for current
source research. Record source date, model version, effort, route, harness,
task class, and whether support is direct, partial, or absent.
Do not invent consensus from vendor positioning and unrelated evaluations.

Do not generalize a `max` result to `medium`, a tool harness to no-tools Web,
one account to another, or an archived result to current availability.
Only fresh candidate-bound proof supports a runtime capability claim.

## No-tools DeepSeek Web proposals

No-tools means no local workspace inspection, modification, execution, or test.
A no-tools DeepSeek Web response may propose a patch, function, edge case,
counterexample, or diagnosis from supplied minimum context.
It cannot prove it applied or tested code, inspected the repository, or
qualified a provider.

A governed executor applies any selected proposal and supplies real proof.
Do not credit hidden executor repair to the proposal.
Provider-native search is distinct from local tool execution.
This rule does not change the existing DeepSeek Search alias for grounded,
cited web research; read [admission](references/combo-modeling-and-admission.md).

## Controlled small comparisons

Use [model-role-comparison.md](references/model-role-comparison.md) before a
small task comparison. Freeze one reversible task, repository snapshot,
acceptance test, budget, and stop rule before requests.

Declare model version, route, effort, tool availability, prompt detail,
executor, and reviewer for every candidate.
Different declared efforts/configurations are comparable configurations; they
are not automatically invalid. Isolate a prompt-detail experiment rather than
silently changing multiple variables.

Treat exit 0 and HTTP 200 as transport observations, not semantic success.
Retain accepted, quality-fail, infra-fail, empty-success, stopped, and
inconclusive rows. Compare total accepted-change cost, including context, repair,
review, and retries—not response speed alone.

The existing Luna/medium deterministic-battery executor policy in the runbook
is a normative local harness default, retained under active root authority.
It is not an empirical conclusion from the archived model-role research.
Do not replace it through this skill or a comparison result.

## Resource router

- [runbook](references/runbook.md), [configuration](references/minimal-governed-configuration.md), and [API/settings](references/api-and-settings-map.md): runtime operation.
- [dashboard](references/dashboard-route-map.md), [compression](references/compression-safety.md), and [traffic](references/traffic-inspector.md): observability.
- [Antigravity/agy](references/provider-antigravity-agy.md), [admission](references/combo-modeling-and-admission.md), and [rate limits](references/redis-rate-limit-backend.md): provider policy.
- [feature classification](references/feature-classification.md) and [alternatives](references/alternatives.md): scope and comparison.
- [research method](references/model-research-method.md), [role comparison](references/model-role-comparison.md), and [capability battery](references/model-capability-battery.md): model evidence.
- [allowlist lifecycle](references/provider-allowlist-lifecycle.md): connection state.
- [archive](references/model-research-2026-09-05.md) and [pre-2.3.0 procedure](references/full-procedure.md): provenance only.

## Verification and reporting

Documentation/research closure names sources, date, scope, and unknowns.
It makes no runtime, provider, availability, or promotion claim.

Comparison closure keeps the full frozen denominator, receipt rows, independent
review result, and the accepted-change-cost basis. A saved result is not a
provider qualification or role-policy promotion.

Runtime mutation closure requires fresh evidence for:

- exact version, service PID/state/restarts, health, and recent logs;
- settings readback and restricted rollback artifact integrity;
- affected provider/model/alias enumeration and required real tool proof;
- intended primary plus a supported non-destructive fallback proof;
- no CCR marker or unexplained cache/memory injection where integrity applies;
- Traffic Inspector redaction/bounded capture when it was enabled; and
- skill validation plus configured-client mirror parity when promotion is scoped.

Historical aliases and reference observations require live readback before use.
Do not claim a green dashboard, `GET /v1/models`, HTTP 200, or a saved skill as
provider/downstream capability proof.
