# Reasoning Effort Gate

## Purpose

Use this gate to choose the smallest reasoning effort that can safely satisfy the
run's success criteria.

GPT-5.5 makes `low` and `medium` more capable than older prompt stacks assumed.
Do not escalate to `high` or `xhigh` just because a task feels important or has
many steps.

## Effort Levels

### `low`

Use for:

- simple factual answers
- mechanical doc or formatting edits
- tiny bounded code/doc changes with obvious acceptance
- already-localized corrections with low risk

`low` still needs outcome clarity and honest verification.

### `medium`

Use for:

- ordinary bounded engineering work
- small multi-file changes
- normal bug diagnosis with limited hypotheses
- standard prompt hardening or planning where risks are known
- routine review where the failure modes are familiar

Prefer `medium` as the default for bounded non-trivial work until evidence shows
more effort is needed.

### `high`

Use when correctness depends on deeper analysis, such as:

- architecture or migration decisions
- security, billing, auth, authorization, ownership, or sensitive data changes
- cross-layer contract changes
- competing hypotheses or contradictory evidence
- visual/product acceptance where proof must reconcile design, runtime, and user
  behavior
- review/closure decisions with meaningful release risk

### `xhigh`

Use only for exceptional work:

- irreversible or one-way-door decisions
- financial/source-of-truth integrity
- incident response or adversarial security posture
- broad migrations with persistent data or multi-system rollback risk
- final forensic closure for high-impact multi-agent or multi-surface execution
- unresolved contradictions after `high` effort already found material risk

## Decision Rule

Start from the lowest effort that can satisfy the declared success criteria with
available evidence.

Before escalating, ask:

- Can `low` or `medium` satisfy the success criteria safely?
- Is the blocker evidence, tool access, or missing context rather than reasoning
  effort?
- Would escalation materially improve correctness, safety, or closure quality?

Escalate only when the answer is yes.

## De-Escalation Rule

De-escalate once the uncertainty is resolved.

Examples:

- discovery started at `high`, but the implementation slice is now mechanical ->
  execute at `medium`
- security review found no sensitive path and the edit is docs-only -> close at
  `medium`
- architecture ambiguity collapsed into one bounded correction -> continue at
  `medium` or `low`

## Agent Selection Rule

Reasoning effort informs future agent selection, but it is not the same as agent
count.

- `low`: root-only by default; do not spawn agents unless independent review has
  clear value.
- `medium`: root-only or one bounded agent/sidecar when it reduces latency or
  improves proof.
- `high`: consider specialized implementation, review, governance, security, or
  browser/proof sidecars when slices are independent and review isolation matters.
- `xhigh`: keep root orchestration explicit; use specialists only for bounded
  evidence gathering or review, never for final closure authority.

Do not use a higher effort label to justify a vague agent. If no honest agent
family fits the dominant risk, keep the risk root-owned and register the gap.

## Packet Requirements

Every non-trivial Branch Entry Packet must include:

- `reasoning effort`
- `effort rationale`
- `escalation triggers`
- `de-escalation triggers`
- `agent/delegation implication`

Trivial packets may state this compactly:

```text
reasoning effort: low
effort rationale: bounded mechanical change with obvious done means
```

## Closure Blockers

Block closure when:

- effort is omitted for non-trivial work
- `high` or `xhigh` is used without a material risk rationale
- `low` or `medium` is used despite unresolved high-impact risk
- agent selection ignores the effort rationale
- escalation is used to compensate for missing evidence instead of getting the
  evidence

## Failure Labels

- `reasoning-effort-missing`
- `effort-over-escalated`
- `effort-under-escalated`
- `effort-confused-with-agent-count`
- `agent-selection-not-traced-to-effort`
- `escalation-used-instead-of-evidence`
