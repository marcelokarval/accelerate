# Attack Class Matrix

Use this reference to choose the relevant hostile-path classes for the surface
under review.

## Core Attack Classes

- enumeration
- IDOR / ownership drift
- privilege escalation or privilege drift
- replay / resend abuse
- brute force
- redirect poisoning
- upload or import abuse
- race and concurrency abuse
- query amplification / N+1 as availability abuse
- provider/source leakage
- secret or config leakage

## Mapping Questions

For each class, ask:

1. what is the protected asset?
2. what is the attacker-controlled input?
3. what backend control should stop the attack?
4. what proof would confirm or reject the concern?

## Use Discipline

Do not force every class onto every slice.

Choose the subset that actually matches the trust boundary and protected asset.
