---
name: anti-abuse-review
description: Use when implementing or reviewing auth, session, OTP, billing, export, deletion, upload, list, search, settings, or other user-driven flows that could be spammed, enumerated, replayed, bypassed, raced, or otherwise misused.
user-invocable: true
related-skills: security-patterns, active-backend-stack, product-runtime-review, active-test-stack
---

# anti-abuse-review

Use this skill to extend normal security review into misuse resistance.

Security bugs are not only "can user B see user A's record?" They are also:

- can this be spammed?
- can this be brute-forced?
- can this be replayed or raced?
- can the UI hide an unsafe backend assumption?
- can query shape or ingress shape be abused to degrade availability?

## Load When

Load this skill when the work touches:

- auth, login, remember-me, redirect, session, logout, session extension
- OTP, MFA, phone verification, email verification, resend flows
- billing, wallet, payment methods, balances, credits, checkout, invoices
- uploads, exports, deletion, invitations, notifications
- list/search/filter endpoints that may leak existence or ownership
- self-service features that change trust-sensitive state

Do not use this skill for:

- purely visual styling work
- read-only content pages with no sensitive interaction
- generic vulnerability theater detached from the actual flow

## Core Contract

For each sensitive flow, answer:

1. what asset or state is being protected?
2. who can interact with it?
3. how could the flow be abused instead of merely used?
4. which protection must exist in the backend regardless of frontend behavior?

Treat these as mandatory red flags rather than optional observations:

- little or inconsistent enforcement
- signals of IDOR
- loose admin/staff permissions

## Abuse Categories

Classify each flow against these categories:

### 1. Enumeration

- does the response reveal whether a user, phone, email, session, or payment
  object exists?

### 2. Replay and Resend Abuse

- can a code, token, or action be resent or replayed without meaningful guard?

### 3. Brute Force

- can verification attempts be guessed repeatedly?
- is there rate limiting, lockout, or bounded retry?

### 4. Ownership and Privilege Drift

- does the frontend assume ownership that the backend does not enforce?
- can identifiers, defaults, or wallet actions target another user's state?

### 5. Forced Navigation and Redirect Abuse

- can `next`, return URLs, or flow transitions be poisoned?
- is the backend validating safe local destinations?

### 6. Concurrency and State Abuse

- can rapid retries or parallel requests create broken defaults, duplicate
  actions, or race conditions?

### 7. Workflow-Layer Abuse

- does the frontend hide or soften a dangerous action without backend friction?
- does the UI suggest a safer behavior than the backend actually enforces?

### 8. Ingress And Import Abuse

- can uploads or imports be oversized, malformed, replayed, or privacy-leaking?
- can metadata, workbook structure, or file shape carry more risk than the UI
  implies?

### 9. Availability Amplification

- can list/search/report/query behavior be amplified into N+1, expensive scans,
  parser exhaustion, or other availability abuse?

## Workflow

1. identify the asset, actor, entrypoint, and trust boundary
2. enumerate plausible misuse paths from the categories above
3. inspect the authoritative backend checks first
4. verify whether the frontend is reinforcing or obscuring the backend truth
5. classify each abuse path as:
   - covered
   - partially covered
   - uncovered
   - out-of-scope residual
6. recommend the smallest effective hardening change
7. require the forensic review to include an `Anti-Abuse` section whenever this
   skill applied

For fixture-driven review, use the repo-local `Abuse-Path Fixture` in
`core/risk/security-abuse-fixtures.md`. The fixture is required when abuse-path
evidence needs to be reusable across branch packets, review reports, or follow-up
work.

When attacker behavior is detected or strongly indicated, explicitly frame the
response posture:

- which sensitive actions should fail closed?
- which surfaces should tighten cooldowns or rate limits?
- which behaviors should be degraded rather than left open?

Do not turn this into “shut the whole product down.” Prefer bounded
containment or quarantine of sensitive capabilities.

## Accelerate Usage Rules

- pair with `product-runtime-review` whenever the flow is both user-facing and
  sensitive
- do not treat frontend validation or disabled UI as a security control
- prefer backend-owned guards, bounded status messages, and rate limits over
  UI-only friction
- treat upload/import abuse and query amplification as real misuse classes, not
  “just validation” or “just performance”
- if the active workflow backend has a closure report, it must include an
  `Anti-Abuse` section whenever this skill applied

## Typical Smells

- weak enforcement that depends on UI rather than backend policy
- staff/admin access broader than the real product policy
- ownership checked in some endpoints but not in adjacent ones
- open redirect via `next`
- resend-code with no cooldown or bounded copy
- payment-method delete/detach without default replacement guard
- session refresh or extension with no ownership or rate control
- verification status leakage through different messages
- list/search endpoints revealing object existence through timing or wording
- destructive self-service actions without server-side revalidation
- uploads/imports accepted with weak limits or no normalization posture
- relational surfaces that can be amplified into N+1 or expensive scans under
  hostile usage
- “attacker detected” narratives with no bounded containment policy

## References

Use local abuse checklists, stack profiles, threat models, and domain overlays
when the current project defines sensitive surfaces.

Repo-local fixture authority:

- `core/risk/security-abuse-fixtures.md`

## Output Discipline

Every use of this skill should produce:

- asset and trust boundary
- abuse paths checked
- backend controls present or missing
- frontend reinforcement or drift
- file-level evidence
- whether `Anti-Abuse` passed or failed

## Anti-Patterns

- equating anti-abuse with generic OWASP copy
- reviewing only the frontend and assuming the backend is safe
- closing a flow because the happy path works
- assuming a disabled button is a real protection
- inventing speculative threats unrelated to the actual product surface
