---
name: security-patterns
description: Implement or review security-sensitive behavior across trust boundaries, authorization and ownership, secrets, hostile input, supply-chain provenance, provider ingress, and race-safe critical mutations. Use for auth, PII, billing, uploads, webhooks, dependencies, or other work requiring STRIDE analysis, exploitability judgment, safe proof, and fail-closed negative coverage.
---

# Security Patterns

Apply a security baseline during implementation or provide specialist evidence
during review. This skill does not duplicate the security reviewer authority:
the assigned reviewer remains read-only and independently judges the candidate;
implementation needs an explicit bounded write assignment.

## Core Rule

Start from trust boundaries and assets, not a generic vulnerability checklist.
Trace untrusted actors and data through authorization, validation, storage,
execution, provider, and observability boundaries. Fail closed when ownership,
integrity, authenticity, or safe state cannot be established.

## Workflow

1. Read the accepted specification, repository security authority, data flow,
   dependencies, and intended proof.
2. Identify assets, actors, entrypoints, trust boundaries, privileges, secrets,
   external providers, and critical state transitions.
3. Apply STRIDE and domain abuse variants using
   [threat-review-contract.md](references/threat-review-contract.md).
4. Inspect authorization and ownership, hostile input, secret handling,
   concurrency/idempotency, failure behavior, logging, and supply-chain
   provenance.
5. Separate candidate signals from confirmed findings. Judge impact, reach,
   exploitability, reproducibility, and confidence independently.
6. Decide whether a safe PoC is useful. Never execute a destructive,
   privacy-invasive, production-impacting, persistence-creating, or
   credential-exposing PoC.
7. Implement only when explicitly assigned; otherwise return a bounded
   remediation and negative-proof contract to a separate executor.
8. Require fresh negative proof at the affected trust boundary after
   correction and leave acceptance to the independent security reviewer/root.

Route general correctness, architecture, legibility, performance, test, and
verification-story findings to the adjacent `code-audit` owner. This skill
owns the specialist security evidence, not the full multi-axis audit.

## Mandatory Lenses

- authentication, authorization, ownership, tenant/workspace isolation;
- internal/public identifiers and direct-object access;
- validation, encoding, path/query/template/shell/deserialization boundaries;
- tokens, OTPs, sessions, constant-time comparison, and secret lifecycle;
- billing, balances, retries, races, transactions, and idempotency;
- uploads, webhooks, remote ingress, third parties, and provider failure;
- dependency integrity, lockfiles, build inputs, artifacts, and supply-chain
  provenance;
- logging, auditability, redaction, detection, recovery, and rollback.

## Evidence Rules

- Record the exact trust boundary, asset, actor, abuse path, and affected
  behavior.
- Cover STRIDE categories with evidence or a substantive not-applicable reason.
- Exercise abuse variants: alternate actor, tenant, object, order, timing,
  encoding, replay, failure, and dependency/provider state.
- State exploitability and prerequisites; do not infer it from category.
- Record the safe PoC disposition: executed with authorization, designed but
  not executed, or not applicable with reason.
- Require negative proof that the abuse path fails safely without secret or PII
  disclosure.
- Verify dependency/provider claims against authoritative provenance; do not
  equate popularity with integrity.

## Return Contract

Return:

- scope, assets, actors, data flow, and trust boundaries;
- STRIDE and abuse-variant dispositions;
- supply-chain and provider provenance evidence;
- findings with exploitability, confidence, correction, and residual risk;
- safe PoC disposition and negative proof;
- requested versus implemented work, self-review, and self-forensic review;
- explicit independent reviewer and root closure boundary.

## Resource Router

- Read [threat-review-contract.md](references/threat-review-contract.md) for the
  complete threat, abuse, provenance, PoC, and proof matrix.
- [full-procedure.md](references/full-procedure.md) preserves the byte-exact
  legacy procedure for migration evidence only; this router supersedes it.

## Verification

- Every trust boundary and STRIDE category is dispositioned.
- Authorization and ownership are backend-authoritative.
- Secret, race, provider, and supply-chain risks are proven or explicit.
- A safe PoC never exceeds authorization or containment.
- Negative proof covers the hostile path after the latest correction.
- Implementer, security reviewer, and root acceptance remain separate roles.
