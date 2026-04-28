# Ownership / IDOR Gate

Any backend surface that reads or mutates scoped data must prove that object
identity is not sufficient authority.

## Required Ownership Shape

Object lookup should bind identity to an authority scope, for example:

- `user`
- `account`
- `organization`
- `tenant`
- `project`
- `team`
- explicit membership/role relation
- a service-level permission decision that is tested negatively

## Fail-Closed Rules

- Missing ownership proof blocks closure.
- Cross-owner access must fail before data is exposed or mutation occurs.
- Public IDs are useful for enumeration resistance, but public ID usage does not
  replace ownership checks.
- Admin/operator actions still require authorization; hiding actions in the UI is
  not authorization.

## Required Negative Tests

- User A cannot read User B's object.
- User A cannot mutate User B's object.
- Tenant/account/project boundaries are enforced when present.
- The failure mode does not leak sensitive object details.
