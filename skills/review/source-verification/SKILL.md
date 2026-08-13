---
name: source-verification
description: Verify material engineering claims against identifiable governing or primary sources with version, freshness, scope, corroboration, contradiction, and uncertainty controls. Use for disputed or version-sensitive behavior, dependency/platform decisions, copied recommendations, external technical claims, benchmark assertions, or any design, review, or implementation conclusion whose authority must be proved rather than merely discovered.
---

# Source Verification

Turn a claim and its supporting material into an auditable confidence decision.
Finding or reading a source is acquisition; verification begins when the source
is matched to the precise claim, authority, version, scope, and current evidence.

## Core Rule

Prefer the nearest governing or primary source. Record identity, version/date,
applicability, and evidence for every material claim. Preserve contradictions
and uncertainty instead of averaging them into false certainty.

## Boundaries

- Use repository search or web/browser tools to acquire material; this skill
  governs how acquired sources support a claim, not how URLs are collected.
- Repo-local instructions and accepted decisions outrank external advice for
  governed repository behavior.
- `architecture` owns the design decision; this skill assesses its evidence.
- `code-audit` owns implementation findings; this skill may verify a factual
  premise or cited remediation.
- This skill does not accept specifications, mutate providers, or close issues.

## Workflow

### 1. Atomize The Claim

Rewrite the assertion into a falsifiable statement. Separate fact, inference,
recommendation, forecast, and preference. Attach the required environment,
version, configuration, and time horizon.

### 2. Establish Authority

Read [references/claim-evidence-matrix.md](references/claim-evidence-matrix.md).
Identify the governing source for repo policy and the primary source for
external behavior. Treat summaries, search snippets, popularity, and generated
answers as discovery aids, not automatic authority.

### 3. Bind Identity And Freshness

Record source owner, title/path, stable locator, publication or commit version,
access date when relevant, and the version/environment to which it applies.
Refresh sources when the claim is plausibly unstable. Do not apply latest docs
to an older runtime without checking version compatibility.

### 4. Inspect The Supporting Evidence

Capture the smallest relevant evidence and explain how it supports or refutes
the claim. Prefer executable local/runtime evidence for claims about actual
behavior and official specifications or source code for normative behavior.
Distinguish documentation promises from observed runtime truth.

### 5. Corroborate Proportionally

One direct governing source may be sufficient for a stable policy claim. Add an
independent source, implementation evidence, or controlled reproduction when
the claim is high-impact, disputed, surprising, externally supplied, or
version-sensitive. Source count alone does not establish independence.

### 6. Reconcile Contradictions

Compare scope, date, version, authority, definitions, and methods before choosing
a winner. Never silently discard adverse evidence. Use
[references/uncertainty-contract.md](references/uncertainty-contract.md) for the
verdict and escalation shape.

## Verdicts

- `verified`: sufficient applicable authority and evidence support the claim
- `disputed`: credible applicable evidence materially conflicts
- `unsupported`: available sources do not establish the claim
- `stale`: evidence does not cover the active version or time boundary
- `uncertain`: evidence is incomplete or ambiguity cannot yet be resolved
- `not-verifiable`: the claim is preference, future state, or otherwise lacks a
  testable truth condition

## Return Contract

For each claim return:

- claim ID and normalized statement
- claim type and materiality
- governing/primary source identity, locator, version/date, and scope
- supporting and conflicting evidence
- corroboration and independence assessment
- freshness and applicability decision
- verdict and calibrated confidence
- inference boundary, unresolved uncertainty, and next verification action

Do not convert confidence into fake numeric precision. A `verified` external
claim does not override repo-local authority or authorize mutation.

## Verification

Before returning, reopen every cited locator, confirm it directly supports the
adjacent claim, check version/date compatibility, and label inferences. If a
required source or runtime cannot be accessed, report the limitation and lower
the verdict rather than relying on memory.
