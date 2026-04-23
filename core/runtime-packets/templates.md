# Runtime Packet Templates

## Purpose

This document is the native core home of the packet schemas used to keep the
control plane visible.

## Packet Set

The platform uses:

- `Branch Entry Packet`
- `Runtime Delta Packet`
- `Prompt Hardening Packet`
- `Subagent Return Packet`
- `QA / Proof Packet`
- `Closure Packet`

## Rule

For non-trivial work, packet shape must not be left to operator taste.

Do not replace packeted runtime state with vague prose when the run is mutating
code, docs, workflow seeds, or runtime governance.

## Branch Entry Packet

```text
Branch Entry Packet

- classification: <conversational|trivial bounded engineering work|orchestrated non-trivial work>
- active branch: <branch name>
- active persona: <persona or root owner>
- active stack: <layers/surfaces>
- active skills: <skills actually active>
- active ADRs / references:
  - <path>
  - <path>
- local workspace:
  - .accelerate=<present|absent|n/a>
  - action=<none|required-init|required-reentry|required-reonboarding|reused>
  - onboarding status=<state|n/a>
  - reentry status=<state|n/a>
  - readiness dashboard=<path|n/a>
  - readiness status=<blocked|ready-for-execution|ready-for-review|ready-for-closure|n/a>
  - timeline=<path|n/a>
  - current checkpoint=<state|n/a>
  - learnings=<path|n/a>
  - learning disposition=<none|ephemeral-only|candidate-for-promotion|durably-registered|n/a>
  - current governing artifact=<path|n/a>
  - local agents status=<path|n/a>
  - drift status=<clean|warning|blocking|n/a>
- gate ledger: <gate=status, gate=status>
- phase / SDLC: <phase / overlay>
- persona handoff artifact: <packet/artifact or n/a>
- product/spec artifact chain:
  - source story=<path|n/a|required-missing>
  - PRD-lite=<path|n/a|required-missing>
  - SDD=<path|n/a|required-missing>
  - task breakdown=<path|n/a|required-missing>
- artifact sufficiency decision: <smallest sufficient artifact / missing blocker>
- mandatory gates: <gates>
- required artifacts: <artifacts>
- closure blockers: <blockers>
- QA / proof lane: <lane or n/a>
- issue stack status: <status or n/a>
- browser-proof intensity: <status or n/a>
- persistent E2E status: <status or n/a>
- single-threaded exception: <reason or n/a>
```

For calibration-only or read-only benchmark slices, keep the packet bounded.
Do not inflate it with execution lanes the current slice is only evaluating.

## Runtime Delta Packet

```text
Runtime Delta Packet

- skills added: <...>
- skills removed: <...>
- ADRs / references added:
  - <path>
- ADRs / references removed:
  - <path>
- gates opened: <...>
- gates passed: <...>
- gates failed: <...>
- local workspace transition: <A -> B or n/a>
- readiness transition: <A -> B or n/a>
- timeline checkpoint transition: <A -> B or n/a>
- learning disposition transition: <A -> B or n/a>
- persona transition: <A -> B or n/a>
- phase transition: <A -> B or n/a>
- product/spec artifact transition: <A -> B or n/a>
- QA / proof lane transition: <A -> B or n/a>
- browser-proof intensity transition: <A -> B or n/a>
- issue stack transition: <A -> B or n/a>
```

Use this packet when the runtime shape changes materially. Do not emit it for
noise.

## Prompt Hardening Packet

```text
Prompt Hardening Packet

- hardened artifact: <present|missing>
- Prompt A: <raw/minimally normalized prompt>
- Prompt B: <execution-ready prompt>
- material changes: <...>
- bounded scope: <...>
- explicit non-goals: <...>
- next branch or route: <...>
- full artifact location: <path/issue/comment or n/a>
```

Use this packet when prompt hardening is active. If hardening is waived, the
Branch Entry Packet should say why.

## Subagent Return Packet

```text
Subagent Return Packet

- scope handled: <bounded scope>
- files changed / surfaces inspected: <...>
- evidence used: <...>
- tests / verification run: <...>
- self-review: <summary>
- self-forensic review: <summary>
- unresolved risks: <...>
- recommendation: <done|partial|follow-up|blocked>
```

Subagent packets never replace root review. They are inputs to root-owned
integration and closure.

## QA / Proof Packet

```text
QA / Proof Packet

- lane: <Backend QA|Frontend QA|Browser-Proof|Persistent E2E>
- scope covered: <...>
- intensity / depth: <...>
- evidence used: <...>
- failures found: <...>
- residual gaps: <...>
- readiness impact: <none|moved-to-review-ready|still-blocked>
```

## Closure Packet

```text
Closure Packet

- requested vs implemented: <...>
- promised vs delivered: <...>
- issue scope vs landing: <...>
- readiness summary: <status + next blocking gate>
- timeline closure checkpoint: <present|missing|n/a>
- learning registration status: <none|ephemeral|candidate|durably-registered|required-before-closure>
- proof lane status:
  - Backend QA=<present|missing|blocked>
  - Frontend QA=<present|missing|blocked>
  - Browser-Proof=<present|missing|blocked>
  - Persistent E2E=<present|missing|blocked|out of order>
- blocking lane: <lane or none>
- residual risk: <...>
- recommendation: <done|partial|follow-up|blocked>
```

## Authority

Inherited reference depth still lives in:

- `references/runtime-packet-templates.md`

This native file is the primary local authority.
