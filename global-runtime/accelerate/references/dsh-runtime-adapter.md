# DSH Runtime Adapter

Use this mapping when the runtime exposes the DeepSeek Harness collaboration
surface. Accelerate remains classification and closure authority; this file only
maps its decisions to native tools.

## Route Mapping

| Need | Native tool | Model alias |
| --- | --- | --- |
| Bounded factual research | `subagent_fast` | `auto/best-fast` |
| Ambiguity, architecture, root cause, material risk, critical review | `subagent_reasoning` | `auto/best-reasoning` |
| Bounded implementation or QA | `subagent` | `auto/best-coding` |
| Multiple independent implementation or proof lanes | `workflow` | `auto/best-coding` |

The root model uses `auto/best-coding`. Keep at most four concurrent children.

## Proportional Entry

- Conversational/no-op: respond directly; do not delegate.
- Trivial bounded: emit `goal | target | constraints | proof | residuals` and
  remain direct unless one scoped sidecar has clear value.
- Non-trivial: produce the hardened packet from
  `../assets/hardened-execution-packet.template.json`; use reasoning only when
  ambiguity, architecture, risk, root cause, or critical review requires it.
- Orchestrated: use `workflow` only for genuinely independent lanes.

Reasoning children propose a packet. The root adopts, adjusts, or rejects it.
Child output is not execution authority.

## Root-Retained Duties

The root retains hardening, fan-in, integration, review-of-review, and closure.
Missing Accelerate, unknown tools, unknown child types, or required-dispatch
failure must produce an explicit blocked or governed degradation result. Never
invent a fallback. Material mutation invalidates affected proof.

## Enforcement Claim

The `code-orchestrated` preset makes this entry contract prompt-mandatory and
session events make tool use observable. This is `prompt-enforced`, not
mechanical enforcement. A future Cordis plugin may validate receipts before
mutation, but its status is planned and it must not become another classifier.
