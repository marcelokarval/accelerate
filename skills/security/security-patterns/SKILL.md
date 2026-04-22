---
name: security-patterns
description: Use when implementing or reviewing security-sensitive behavior, especially ownership checks, auth boundaries, secret handling, fail-closed mutations, untrusted input, and race-safe critical operations.
user-invocable: true
related-skills: active-backend-stack, active-test-stack, anti-abuse-review, payment-integration
---

# security-patterns

Use this skill when implementing or reviewing security-sensitive behavior.

## Purpose

Provide a mandatory security baseline for backend and user-facing work,
especially around:

- ownership and IDOR prevention
- authentication and authorization
- secret comparison
- secrets and configuration hygiene
- rate-limited or sensitive endpoints
- financial and concurrency-sensitive flows

This skill can overlap `Backend Query Correctness`, but it does not replace it:
ownership-safe code may still have weak query shape, and efficient query shape
does not prove ownership safety.

## Load When

Load this skill when the task touches:

- private object access
- auth, password, OTP, tokens, sessions
- billing, subscription, payments, credits, balances
- uploads, imports, remote-ingress, or serving-sensitive flows
- any mutation that could expose or alter another user's data
- backend reviews where ownership and query shape interact, but security must
  remain a distinct judgment from `Backend Query Correctness`

## Operating Lens

- IDOR and ownership first
- secret handling and safe comparisons
- fail-closed posture for sensitive mutations
- race-safe critical mutations
- read-only review by default unless the user asked for remediation

## Context Minimum

Before implementing or reviewing, identify:

- the target domain or change set
- affected interfaces or mutations
- the trust boundary being evaluated
- whether the task is review-only or implementation

## Core Rules

1. Avoid exposing internal primary keys in URLs or public payloads.
2. Use stable public identifiers for externally visible object references when
   the active stack supports them.
3. Verify ownership for private object access.
4. Use constant-time comparison for secrets or tokens.
5. Use transaction and locking patterns for money or critical state.
6. Apply defense in depth: authenticated access, ownership checks, validation,
   and rate limiting where appropriate.
7. Do not rely on frontend validation for security.
8. Do not hardcode secrets, environment values, provider keys, or sensitive
   configuration into source code.
9. Treat frontend identity, hidden fields, disabled UI, and client-side checks
   as untrusted input, not as security controls.
10. Sensitive mutations should fail closed when ownership, validation, or
    state integrity cannot be established.

## Security Baseline

### Access Control

- private resources must be filtered or fetched with ownership-aware helpers
- interface layers should never trust client-supplied object identity alone
- do not assume the frontend selected the “right” object, tenant, workspace, or
  next state

### Sensitive Mutations

- billing and finance flows require explicit concurrency-safe patterns
- token or OTP verification must avoid naive `==` comparison
- settings or self-service mutations should prefer explicit server-side
  revalidation over optimistic frontend assumptions

### Secrets And Configuration Hygiene

- configuration belongs in environment-backed settings, not hardcoded literals
- do not embed provider keys, webhook secrets, internal endpoints, or fallback
  credentials in source code
- absence of a required secret or env-backed setting should fail loudly and
  explicitly, not silently fall back to insecure behavior

### Frontend

- frontend behavior can improve UX, but the backend remains authoritative for
  access control and validation
- user-facing safety affordances do not reduce the need for backend checks

## Review Checklist

- Are public IDs used everywhere user-facing?
- Is ownership enforced?
- Are token or secret comparisons safe?
- Are secrets and env-backed settings kept out of source code?
- Is the backend explicitly distrusting frontend-selected identity and state?
- Are race conditions considered for critical flows?

## Handoff And Escalation

- hand off to the active backend stack skill when code remediation is the
  primary deliverable after review
- pair with the active test stack when findings need regression coverage
- stay read-only unless the user explicitly asks for fixes

## References

Use the active project's security utilities, auth layer, database layer,
interfaces, and domain modules.
