# Guard Policy

Guard mode combines careful command policy and edit freeze policy.

## Required Behavior

- dangerous commands trigger careful confirmation
- edits outside declared paths are blocked
- guard state must name owner, reason, and allowed paths

Guard is appropriate for production incidents, migrations, broad refactors, and
security-sensitive corrections.
