# Specification Traceability Template

## Authority

- ID: `TRACE-<SCOPE>-<NUMBER>`
- Status: `draft | accepted | superseded`
- Governing issue:
- Source SDD:
- Engineering Artifact Manifest:
- Canonical mapping: `yes`

## Requirement Matrix

| Requirement | Task | Test case or justified exception | Planned proof locator | Current proof status | Observed proof locator | Proof generation |
| --- | --- | --- | --- | --- | --- | --- |
| `REQ-...` | `T...` | `CASE-...` |  | `planned | observed-red | observed-green | blocked` |  | `0` |

Every behavioral requirement maps to a task, a test or substantive exception,
and a proof locator. IDs are stable and unique. Planned proof and observed proof
remain separate; a command listed for later execution is not observed evidence.

## Correction Freshness

- Current correction generation:
- Current proof generation:
- Stale proof invalidated at:
- Reproof command:
- Fresh proof locator:

Any correction increments the correction generation and invalidates earlier
proof for the affected requirement. Promotion is blocked until proof generation
is equal to or newer than correction generation.
