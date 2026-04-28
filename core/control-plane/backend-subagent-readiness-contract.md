# Backend Subagent Readiness Contract

Backend subagents are not ready just because backend skills exist. They are ready
only when the root can enforce the safety rails they must obey.

## Required Rails Before Promotion

- Django Backend Safety Gate
- Django ORM Query Shape Gate
- Ownership / IDOR Gate
- Django Service Layer Contract
- backend validation command expectations for the active profile
- negative security tests for scoped mutations
- query-shape proof for N+1-risk reads

## Subagent Contract Requirements

Every backend subagent must declare:

- allowed file families
- forbidden patterns
- required gates
- required proof commands
- escalation conditions
- review checklist

## Forbidden Subagent Behavior

- Generating view-level business logic without service boundary justification.
- Adding object lookups by `id`/`pk` without ownership scope.
- Adding list/detail queries with related-object access and no query-shape proof.
- Claiming closure with only happy-path tests.
