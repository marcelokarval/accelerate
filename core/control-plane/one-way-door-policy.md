# One-Way Door Policy

One-way-door decisions require explicit user approval before execution.

## One-Way Door Categories

- destructive filesystem operations
- force push, history rewrite, or hard reset
- production deploy, merge, rollback, or release
- schema migration, data deletion, or irreversible data rewrite
- auth, session, permission, ownership, or security boundary change
- billing, payment, subscription, refund, or financial state change
- PII import, export, deletion, retention, or sharing
- external provider write
- scope expansion beyond stated request
- user-visible behavior change with ambiguous intent
- skipping required tests, browser proof, review, or closure proof

## Required Packet

Approval must be recorded in a decision audit trail with:

- exact risk
- selected action
- rejected safer alternatives
- proof required after action
- rollback or recovery posture when applicable

## Non-Suppression

Preferences, prior defaults, or agent confidence cannot suppress this policy.
