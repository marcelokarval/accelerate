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
- `Prompt Upgrade Approval Packet`
- `One-Shot Side-By-Side Review Packet`
- `Review Isolation Packet`
- `Final Forensic Reconciliation Packet`
- `Execution-To-Spec Loop Packet`
- `Systemic UI Inconsistency Audit Packet`
- `Document Cohesion Size Packet`
- `Manual Review Contradiction Packet`
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

## Prompt Upgrade Approval Packet

```text
Prompt Upgrade Approval Packet

- raw prompt source: <inline|path|summary>
- target repo / project: <...>
- stack basis: <...>
- active Accelerate gates inferred: <...>
- ambiguity removed: <...>
- scope added: <...>
- non-goals added: <...>
- proof lanes added: <...>
- persisted artifacts required: <...>
- approval boundary phrase: <...>
- improved prompt presented: <yes|no>
- approval status: <waiting|approved|rejected|rework-requested>
- post-approval artifacts: <paths|missing|n/a>
- execution authorization: <not-requested|requested|approved|blocked>
- commit/push authorization: <not-requested|requested|approved|blocked>
```

Use this packet when the `Prompt Upgrade Approval Gate` is active.

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

## One-Shot Side-By-Side Review Packet

```text
One-Shot Side-By-Side Review Packet

- task id: <id>
- requested outcome: <what the task required>
- executor identity/role: <...>
- reviewer identity/role: <...>
- review independence: <independent|same-agent-exception|missing>
- implemented evidence: <files|packets|runtime evidence>
- expected proof: <proof required by the plan/profile/gate>
- actual proof: <proof actually run>
- requested vs implemented: <met|partial|missed|not-applicable>
- defects found: <ids or none>
- correction owner: <master|subagent|n/a>
- correction summary: <summary or n/a>
- reproof evidence: <fresh proof or n/a>
- open defects: <ids or none>
- closure status: <closed|blocked|waived>
```

Use this packet for task-level side-by-side review in one-shot execution runs.

## Review Isolation Packet

```text
Review Isolation Packet

- task or slice id: <id>
- executor: <agent/persona/root role>
- executor self-review: <present|missing|n/a>
- skeptical reviewer: <agent/persona/root role|missing>
- reviewer independence: <independent|same-agent-exception|not-provided>
- reviewer posture: <skeptical|summary-only|unclear>
- orchestrator final reviewer: <agent/persona/root role>
- orchestrator review-of-review: <accepted|corrected|blocked|missing>
- isolation exception: <none|reason>
- residual risk: <...>
- closure impact: <clear|blocked|waived-with-risk>
```

Use this packet when review independence affects closure confidence.

## Final Forensic Reconciliation Packet

```text
Final Forensic Reconciliation Packet

- executive plan vs final landing: <met|partial|missed + evidence>
- task ledger vs completed work: <met|partial|missed + evidence>
- requested-vs-implemented packets: <complete|incomplete|blocked>
- defects found vs disposition: <clear|open defects|waived defects>
- corrections without reproof: <ids or none>
- validation expected vs validation run: <met|partial|missed>
- subagent claims vs master review-of-review: <accepted|corrected|blocked|n/a>
- review isolation: <independent|exception|missing|blocked>
- manual review contradictions: <none|classified|unclassified|reopened-loop>
- final closure judgment: <done|blocked|follow-up-required>
```

Use this packet before closure when the `One-Shot Side-By-Side Gate` is active.

## Execution-To-Spec Loop Packet

```text
Execution-To-Spec Loop Packet

- user operating mode requested: <...>
- active plan artifact: <path|inline|missing>
- active task ledger artifact: <path|inline|missing>
- one-shot batch scope: <...>
- planned task count: <n>
- implemented task count: <n>
- task-by-task review status: <complete|partial|missing>
- requested-vs-implemented status: <met|partial|missed|blocked>
- QA proof run: <commands|blocked|n/a>
- browser proof run: <captures|blocked|n/a>
- visual proof run: <required-present|required-missing|not-needed>
- defects detected: <ids|none>
- correction loop status: <not-needed|open|complete|blocked>
- corrected-state reproof: <evidence|missing|n/a>
- remaining partial/missed tasks: <ids|none>
- waived/deferred items: <ids|none>
- final forensic reconciliation: <present|missing|blocked>
- loop verdict: <converged|continue-loop|blocked|user-scope-change-required>
```

Use this packet when the `Execution-To-Spec Loop Gate` is active.

## Systemic UI Inconsistency Audit Packet

```text
Systemic UI Inconsistency Audit Packet

- audit scope requested: <...>
- route inventory source: <path|runtime|manual|blocked>
- route count discovered: <n|unknown>
- modal/dialog/sheet/popover inventory source: <path|runtime|manual|blocked>
- interactive surface count discovered: <n|unknown>
- source search patterns used: <patterns>
- viewport matrix: <desktop|tablet|mobile + evidence paths>
- browser proof intensity: <sampled|targeted|broad sweep|full route-family audit>
- hard-coded/mock data findings: <ids|none|untriaged>
- data-truth unknowns: <ids|none>
- missing-info findings: <ids|none>
- visual/layout findings: <ids|none>
- analogous-surface comparisons: <summary|missing>
- AI smell findings: <ids|none|not-requested>
- dashboard/professionalism findings: <ids|none>
- strategic improvements by screen/screen family: <summary|missing>
- wireframes produced: <paths|inline|grouped|not-requested|missing>
- defects opened: <ids|none>
- defects fixed in loop: <ids|none>
- corrected-state proof: <paths|missing|n/a>
- deferred/out-of-scope items: <ids|none>
- residual route/modal/viewport gaps: <...>
- loop verdict: <continue-loop|converged|blocked|scope-narrowed>
```

Use this packet when the `Systemic UI Inconsistency Audit Gate` is active.

## Document Cohesion Size Packet

```text
Document Cohesion Size Packet

- audit scope: <all md|core md|changed docs|specific paths>
- line-count source: <command|tool|manual>
- largest live doctrine files:
  - <path>: <lines>, classification=<single-authority|aggregator|reference-corpus|archive/plan|mixed-authority|duplicated-authority>
- size-band thresholds applied: <yes|no>
- split candidates:
  - <path>: <reason|none>
- merge/pointer candidates:
  - <path>: <reason|none>
- duplicated authority findings:
  - <paths + owner decision|none>
- context preservation risks:
  - <risk|none>
- index/README updates required:
  - <path|none>
- action taken: <none|split|merged|pointer-added|index-updated>
- residual gaps: <...>
```

Use this packet when the `Document Cohesion Size Gate` is active.

## Manual Review Contradiction Packet

```text
Manual Review Contradiction Packet

- prior closure claim: <done|complete|loop-converged|other>
- review source: <manual review|code review|QA|operator audit|other>
- original task ids affected:
  - <id>
- contradiction findings:
  - id: <finding-id>
    task: <task-id|new-defect>
    reviewer claim: <summary>
    evidence cited: <file/line/runtime/path>
    classification: <valid-reopen|valid-new-defect|already-covered-with-evidence|false-positive|out-of-scope|blocked>
    required status change: <reopen|partial|new-defect|none>
    correction proof required: <code|test|browser|data|cross-view|cleanup>
- coverage reconciliation:
  - routes required vs inventoried: <...>
  - views/modes required vs inspected: <...>
  - data cases required vs proved: <...>
  - temporary artifacts expected removed vs present: <...>
- reopened tasks: <ids|none>
- new defects: <ids|none>
- false positives with evidence: <ids|none>
- loop verdict: <reopen-loop|closure-still-valid|blocked|scope-change-required>
```

Use this packet when the `Manual Review Contradiction Gate` is active.

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
  - UX/UI Fullstack Surface=<present|missing|blocked|not-applicable>
  - Design Implementation Proof=<present|missing|blocked|not-applicable>
  - Product-Critical Closure=<present|missing|blocked|not-applicable>
  - Requested-Vs-Implemented=<present|missing|blocked>
  - AI Review=<present|missing|blocked>
- blocking lane: <lane or none>
- residual risk: <...>
- recommendation: <done|partial|follow-up|blocked>
```

## Authority

Inherited reference depth still lives in:

- `references/runtime-packet-templates.md`

This native file is the primary local authority.
