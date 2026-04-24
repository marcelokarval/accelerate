# Runtime Packet Templates

## Purpose

This document is the native core home of the packet schemas used to keep the
control plane visible.

## Packet Set

The platform uses:

- `Branch Entry Packet`
- `Runtime Delta Packet`
- `Prompt Hardening Packet`
- `Requested-Vs-Implemented Packet`
- `Defect Ledger Packet`
- `Correction Loop Packet`
- `Seam Proof Packet`
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
- local review / closure action: <none|prepare-review|prepare-closure|manual-debug-exception>
- single-threaded exception: <reason or n/a>
```

For calibration-only or read-only benchmark slices, keep the packet bounded.
Do not inflate it with execution lanes the current slice is only evaluating.

When `.accelerate/` local status already exists, this packet should prefer the
compact local handoff read first:

- `review/handoff-summary.md`
- otherwise `read-local-handoff.sh`

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
- local review / closure action transition: <A -> B or n/a>
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

## Requested-Vs-Implemented Packet

```text
Requested-Vs-Implemented Packet

- slice / batch id: <id>
- assigned scope: <bounded scope>
- actual scope touched: <scope actually landed>
- files / evidence touched: <...>
- authority source:
  - <path|artifact|contract>
- requested items:
  - <item>
- implemented items:
  - <item>
- comparison judgment:
  - <requested item> -> <met|partial|missed>
- variance notes: <...>
- promotion posture: <promotable|blocked|follow-up-required>
```

Use this packet to keep slice-level comparison explicit.

## Defect Ledger Packet

```text
Defect Ledger Packet

- slice / batch id: <id>
- defect summary:
  - id=<id>, type=<type>, severity=<severity>, owner=<owner>, status=<status>
- blocking defects: <ids or none>
- newly opened defects: <ids or none>
- defects fixed this slice: <ids or none>
- defects awaiting reproof: <ids or none>
- waived defects: <ids or none>
- evidence roots:
  - <path|packet|capture>
- promotion impact: <clear|blocked|follow-up-required>
```

Use this packet when defect status must stay visible before closure.

## Correction Loop Packet

```text
Correction Loop Packet

- slice / batch id: <id>
- trigger defect(s): <ids>
- detection evidence: <path|packet|capture>
- owner who corrected: <owner>
- correction summary: <what changed>
- fresh proof run: <tests|browser capture|runtime output>
- corrected-state evidence: <path|packet|capture>
- comparison result: <defect cleared|partial improvement|still failing>
- promotion posture: <promotable|blocked|follow-up-required>
```

Use this packet when a meaningful in-scope defect was corrected and reproved
before promotion.

## Seam Proof Packet

```text
Seam Proof Packet

- seam id / label: <label>
- slice / batch id: <id>
- seam type: <ui|backend|runtime|governance>
- authorities compared:
  - <layer|artifact>
  - <layer|artifact>
- states compared:
  - <state>
  - <state>
- evidence used:
  - <capture|packet|output>
- defect verdict: <none|found>
- defect ids: <ids or none>
- residual uncertainty: <...>
- temporary evidence root: <project-root/.tmp/...|n/a>
```

Use this packet when seam-focused proof is the honest comparison shape.

## Subagent Return Packet

```text
Subagent Return Packet

- scope handled: <bounded scope>
- files changed / surfaces inspected: <...>
- evidence used: <...>
- requested-vs-implemented: <summary or packet reference>
- tests / verification run: <...>
- self-review: <summary>
- self-forensic review: <summary>
- defects found and disposition: <summary or packet reference>
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
- defect ids: <ids or none>
- residual gaps: <...>
- readiness impact: <none|moved-to-review-ready|still-blocked>
- next canonical local action: <prepare-review|prepare-closure|manual-debug-exception|n/a>
```

## Closure Packet

```text
Closure Packet

- requested vs implemented: <...>
- promised vs delivered: <...>
- issue scope vs landing: <...>
- defect ledger status: <clear|open defects remain|waived defects present>
- correction loop status: <not-needed|completed|incomplete>
- seam-proof status: <not-needed|present|missing|insufficient>
- readiness summary: <status + next blocking gate>
- timeline closure checkpoint: <present|missing|n/a>
- learning registration status: <none|ephemeral|candidate|durably-registered|required-before-closure>
- local review / closure preparation: <prepare-review used|prepare-closure used|manual-debug-exception|n/a>
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
