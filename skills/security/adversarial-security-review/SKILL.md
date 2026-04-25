---
name: adversarial-security-review
description: Codex-native evidence-first adversarial security review covering hostile-path analysis, variant hunting, and issue-oriented hardening without vulnerability theater.
metadata:
  category: security
  origin: accelerate-native-adapted
---

# Adversarial Security Review

Use this skill when the goal is to review the system as an attacker would, but
inside an authorized, evidence-first, repo-hardening workflow.

This skill is adapted for Accelerate from strong public security-audit patterns,
including skills.sh materials such as `vulnhunter` and `owasp-security-check`,
then rewritten for stack-aware issue workflow and review discipline.

## When to Use

Use this skill when:

- auditing a sensitive user flow
- hunting for variants of a known security or abuse bug
- reviewing a new trust boundary before broader rollout
- performing evidence-based hostile-path analysis of auth, billing, upload,
  import, export, deletion, or ownership-sensitive surfaces
- checking whether a defensive change really closes adjacent attack paths

Do not use it for:

- unactionable security theater
- speculative exploit fiction with no code or runtime evidence
- work that is really just a normal implementation slice

## Authorization Contract

This skill assumes the review is authorized by the user and bounded to the
current repo and environment.

It exists to harden the system, not to perform uncontrolled offensive activity.

## Core Principle

Review the system through hostile intent, but report only what the evidence
supports.

The skill must stay grounded in:

- trust boundaries
- attack classes
- concrete evidence
- variant hunting
- bounded remediation or follow-up

## Output Contract

The result should make these things explicit:

1. attack surface under review
2. trust boundary and protected asset
3. attack classes checked
4. evidence found
5. severity and exploitability judgment
6. variant search scope
7. remediation or issue follow-up

For fixture-driven review, use the repo-local `Hostile-Path Fixture` in
`core/risk/security-abuse-fixtures.md`. The fixture is required when hostile-path
evidence needs to be reusable across branch packets, review reports, or follow-up
work.

## Workflow

### 1. Map The Attack Surface

Identify:

- entrypoints
- identifiers
- trust boundaries
- state transitions
- sensitive assets
- places where frontend behavior may disguise weak backend enforcement

### 2. Choose Attack Classes

At minimum, review the relevant subset of:

- enumeration
- IDOR / ownership drift
- privilege drift
- replay / resend abuse
- brute force
- open redirect / poisoned return flows
- upload or import abuse
- query amplification / N+1 as availability abuse
- race and concurrency abuse
- provider/source leakage
- secret or config leakage

### 3. Check The Backend First

Before discussing frontend mitigations, inspect:

- ownership checks
- authorization logic
- validation authority
- concurrency posture
- rate limits or cooldowns
- serving/storage posture for sensitive artifacts

### 4. Hunt Variants, Not Just The First Finding

If a real finding appears:

- identify the root cause
- generalize the pattern
- search adjacent modules or similar routes for the same family of bug
- classify variants as confirmed, partial, or rejected by evidence

Do not stop at the first isolated seam if the pattern obviously repeats.

### 5. Judge Exploitability Honestly

For every finding, say:

- what makes it reachable
- what impact it would have
- what assumptions are required
- whether it is confirmed, partial, or only a plausible suspicion

### 6. Route The Result Correctly

If the correction is local:

- recommend or implement the bounded fix

If the correction is systemic:

- create or recommend a workflow hardening follow-up
- classify the miss as local vs workflow-level

## Accelerate Usage Rules

- pair with `anti-abuse-review` for misuse resistance
- pair with `security-patterns` for ownership, auth, token, IDOR, secret, and
  race review
- pair with `product-runtime-review` when the flow is user-facing
- pair with `systematic-debugging` if the main challenge is reproducing a
  reported exploit path rather than reviewing the surface family
- findings should be strong enough to produce a bounded issue, adapter ticket,
  or bounded no-finding conclusion

## Typical Smells

- reporting a single seam but not checking variants
- calling something exploitable without stating assumptions
- using frontend behavior as evidence of backend safety
- treating N+1 or query amplification as “just performance” when it can be an
  availability abuse vector
- vague “security concern” language with no asset, boundary, or impact model

## Required References

Read these when needed:

- `core/risk/security-abuse-fixtures.md`
- `references/attack-class-matrix.md`
- `references/variant-hunting.md`
- `references/reporting-and-follow-up.md`

## Verification

This skill is being used correctly if:

- the trust boundary is explicit
- the attack classes are named
- backend evidence comes before narrative confidence
- variants are checked when a root pattern repeats
- findings are bounded, evidenced, and actionable
