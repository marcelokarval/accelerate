# Fix-First Taxonomy

Accelerate reviews classify findings before correction.

## Classes

| Class | Handling |
| --- | --- |
| auto-fix | Mechanical, local, low-risk correction with clear proof path. |
| ask | Judgment, user-visible behavior, security, data, scope, or large change. |
| blocker | Must be resolved or explicitly waived before closure. |
| informational | Worth recording but not closure-blocking. |

## Auto-Fix Requirements

- finding has evidence
- fix is localized
- no one-way-door category applies
- proof is rerun after fix
- correction is recorded in the task ledger or defect ledger

## Ask Requirements

Ask before changing security boundaries, persisted data, billing, auth, public API
contracts, user-visible semantics, or broad architecture.
