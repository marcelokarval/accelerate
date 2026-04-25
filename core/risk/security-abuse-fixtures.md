# Security Abuse Fixtures

## Purpose

This file defines repo-local fixture shapes for hostile-path and abuse-path
review.

Use these fixtures when a branch touches sensitive state, trust boundaries,
identity, recovery, money, upload/import/export, search/listing, deletion, or
other user-driven flows that can be attacked, replayed, spammed, enumerated,
raced, or amplified.

The fixtures are capability-oriented. Tool-specific commands, framework-specific
checks, and profile-local test invocations belong in adapters, profiles, or
branch packets.

## Fixture Selection

Use the smallest fixture that honestly covers the risk:

- `Hostile-Path Fixture` for security review of trust boundaries, ownership,
  authorization, secrets, provider leakage, and exploitability.
- `Abuse-Path Fixture` for misuse resistance across replay, rate, enumeration,
  brute-force, race, spam, and availability-amplification behavior.
- Use both when a flow has sensitive state and repeatable user-triggered actions.

## Hostile-Path Fixture

```md
# Hostile-Path Fixture

## Surface

- Entry point:
- Protected asset or state:
- Trust boundary:
- Authoritative owner:

## Actor Model

- Legitimate actor:
- Untrusted or hostile actor:
- Privilege assumptions:
- Data or identifier controlled by actor:

## Attack Classes Checked

- Ownership / IDOR:
- Privilege drift:
- Validation authority bypass:
- Secret / config / provider leakage:
- Upload / import / storage exposure:
- Redirect / navigation poisoning:
- Concurrency-sensitive mutation:
- Availability amplification:

## Evidence

- Backend enforcement evidence:
- Frontend reinforcement or drift:
- Runtime or artifact evidence:
- Variant search scope:

## Findings

- Confirmed findings:
- Partial findings:
- Rejected hypotheses:
- Severity and exploitability judgment:

## Remediation Or Follow-Up

- Smallest effective hardening change:
- Owner for follow-up:
- Release blocker status:

## Residual Risk

- Remaining assumptions:
- Out-of-scope surfaces:
- Required future proof:
```

## Abuse-Path Fixture

```md
# Abuse-Path Fixture

## Flow

- Entry point:
- User-visible action:
- Protected asset or state:
- Trust boundary:
- Authoritative owner:

## Actor Model

- Legitimate actor:
- Misuse actor:
- Automated or repeated-action capability:
- Data or identifier controlled by actor:

## Abuse Probes

- Enumeration probe:
- Replay / resend probe:
- Rate-limit or cooldown probe:
- Brute-force or guessing probe:
- Race / parallel request probe:
- Spam or notification amplification probe:
- Query / parser / workload amplification probe:
- Frontend-only friction bypass probe:

## Controls And Evidence

- Backend controls present:
- Backend controls missing or unclear:
- Frontend reinforcement or drift:
- Observed or documented evidence:
- Evidence gaps:

## Disposition

- Covered paths:
- Partially covered paths:
- Uncovered paths:
- Out-of-scope residual paths:

## Hardening

- Smallest effective mitigation:
- Fail-closed or degraded behavior:
- Containment or quarantine posture:
- Follow-up owner:

## Residual Risk

- Remaining assumptions:
- Abuse budget still tolerated:
- Required future proof:
```

## Evidence Rules

- Backend controls are the primary proof for sensitive state and mutation.
- Frontend disabled states, hidden buttons, optimistic copy, or client-side
  validation are reinforcement only; they are not authoritative controls.
- Evidence may be code, tests, runtime captures, review packets, issue records,
  or other branch artifacts, but the fixture must identify what kind of evidence
  was used.
- Unknown evidence must be recorded as a gap, not converted into a passed check.

## Closure Rules

A fixture is closure-ready only when it names:

- actor and trust boundary
- replay, rate, enumeration, and race disposition when relevant
- backend evidence or a documented backend evidence gap
- confirmed, partial, rejected, and residual paths
- smallest hardening change or bounded no-finding conclusion
