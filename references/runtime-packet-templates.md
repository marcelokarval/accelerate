# Runtime Packet Templates

## Local Authority Status

Primary local authority lives in:

- `../core/runtime-packets/templates.md`

Use this reference for supporting doctrine and comparison depth.

If the native local file and this reference disagree, prefer the local file.

Use this module when `accelerate` must not leave packet shape to operator taste.

## Rule

For non-trivial work, use explicit packet templates.

Do not replace these with vague prose or compressed narrative when the run is
mutating code, docs, workflow seeds, or runtime governance.

## 1. Branch Entry Packet

```text
Branch Entry Packet

- classification: <trivial|non-trivial>
- active branch: <branch name>
- active persona: <persona>
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
- persona handoff artifact: <packet/artifact>
- mandatory gates: <gates>
- required artifacts: <artifacts>
- closure blockers: <blockers>
- QA / proof lane: <lane>
- issue stack status: <status>
- browser-proof intensity: <status or n/a>
- persistent E2E status: <status or n/a>
- local review / closure action: <none|prepare-review|prepare-closure|manual-debug-exception>
- single-threaded exception: <reason or n/a>
```

## 2. Runtime Delta Packet

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
- local workspace transition: <A -> B>
- readiness transition: <A -> B or n/a>
- timeline checkpoint transition: <A -> B or n/a>
- learning disposition transition: <A -> B or n/a>
- local review / closure action transition: <A -> B or n/a>
- persona transition: <A -> B>
- phase transition: <A -> B>
- QA / proof lane transition: <A -> B>
- browser-proof intensity transition: <A -> B or n/a>
```

## 3. Prompt Hardening Packet

```text
Prompt Hardening Packet

- hardened artifact: <present|missing>
- Prompt A: <raw/minimally normalized prompt>
- Prompt B: <execution-ready prompt>
- full artifact location: <path/issue/comment or n/a>
```

## 4. Subagent Return Packet

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

## 5. QA / Proof Packet

```text
QA / Proof Packet

- lane: <Backend QA|Frontend QA|Browser-Proof|Persistent E2E>
- scope covered: <...>
- intensity / depth: <...>
- evidence used: <...>
- failures found: <...>
- residual gaps: <...>
- readiness impact: <none|moved-to-review-ready|still-blocked>
- next canonical local action: <prepare-review|prepare-closure|manual-debug-exception|n/a>
```

## 6. Closure Packet

```text
Closure Packet

- requested vs implemented: <...>
- promised vs delivered: <...>
- issue scope vs landing: <...>
- readiness summary: <status + next blocking gate>
- timeline closure checkpoint: <present|missing|n/a>
- learning registration status: <none|ephemeral|candidate|durably-registered|required-before-closure>
- local review / closure preparation: <prepare-review used|prepare-closure used|manual-debug-exception|n/a>
- residual risk: <...>
- recommendation: <done|partial|follow-up|blocked>
```
