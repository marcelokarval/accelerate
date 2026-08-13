# Test Design Template

Use this template before implementation to define how each requirement can be
disproved and what evidence will count. Keep the design proportional, but do
not silently omit a required dimension.

## Status

- ID: `TEST-DESIGN-<stable-id>`
- Status: `draft | accepted | superseded`
- Owner:
- Independent reviewer:
- Date:
- Governing issue or request:
- Accepted SDD / Spec Capsule:
- Change kind: `feature | bug | refactor | docs | governance | migration | security | ui | external-provider | hybrid`
- TDD / proof mode:

Implementation may start only when this artifact is `accepted` by the owning
root. The author may recommend acceptance but may not self-accept.

## Objective And Scope

- Behavior or contract to prove:
- In scope:
- Out of scope:
- Primary risks:
- Trust / ownership boundaries:
- Compatibility and rollback constraints:

## Requirement Traceability

Distinguish planned proof from observed proof. Planning a command, test, or
capture does not prove that it ran.

| Requirement ID | Task | Planned test or justified exception | Lowest effective level | Planned proof locator | Observed proof locator |
| --- | --- | --- | --- | --- | --- |
| `REQ-*` |  |  |  |  | `pending` |

Every behavioral requirement needs a task, a test or substantive exception,
and a proof locator. Keep observed proof `pending` until execution evidence
exists.

## Required Dimension Dispositions

Use `covered` or `not-applicable` for every row. A `not-applicable` disposition
requires a scope-specific reason; `none`, `not needed`, or a blank cell fails
the gate.

| Dimension | Status | Scenario / substantive reason | Test level | Oracle / expected result | Fixture or evidence locator |
| --- | --- | --- | --- | --- | --- |
| Happy behavior |  |  |  |  |  |
| Negative behavior |  |  |  |  |  |
| Boundary values / transitions |  |  |  |  |  |
| Permission / ownership |  |  |  |  |  |
| Concurrency / idempotency |  |  |  |  |  |
| Failure / recovery |  |  |  |  |  |
| Fixtures / test data |  |  |  |  |  |
| Observability / diagnostics |  |  |  |  |  |
| Lowest effective test level |  |  |  |  |  |

## Lowest Effective Level Decision

- Candidate levels considered:
- Selected level:
- Why a lower level is insufficient:
- Why a higher level is unnecessary or additionally required:
- Cross-boundary or runtime proof required:

Prefer the lowest level that exercises the real owner and failure mechanism.
Do not replace a focused unit or semantic contract with a broad end-to-end test,
or use a mock-only unit test when the risk lives at a boundary.

## Mode-Specific Proof

Complete the applicable row and give a substantive reason for every other row.

| Change kind | Required baseline / proof | Disposition and locator |
| --- | --- | --- |
| Feature | Observed Red, Green, then Refactor/reproof |  |
| Bug | Failing repro before correction, then regression proof |  |
| Refactor | Characterization baseline before and after |  |
| Docs / governance | Semantic validator with valid and invalid fixtures |  |
| Migration | Forward, compatibility, rollback, and data-integrity proof |  |
| Security | Trust-boundary, abuse/negative, remediation, and safe-PoC disposition |  |
| UI | Functional QA, interactive browser truth, then persistent regression when stable |  |
| External provider | Contract/sandbox fixture, failure handling, idempotency, and provider readback when authorized |  |

Do not fabricate a Red event for a mode whose honest baseline is
characterization, semantic validation, migration rehearsal, security analysis,
browser truth, or provider evidence.

## Execution And Review Plan

- Baseline command / action:
- Expected failing or characterization signal:
- Focused proof command / action:
- Broader regression command / action:
- Browser truth plan or not-applicable reason:
- Persistent regression plan or not-applicable reason:
- Test / fixture writer:
- Independent regression reviewer:
- Cleanup / isolation plan:

A test-only writer loses independent review authority over the tests or
fixtures they authored. Assign a different reviewer before acceptance.

## Acceptance

- All dimensions dispositioned: `yes | no`
- Traceability complete: `yes | no`
- Fixtures and isolation safe: `yes | no`
- Reviewer independence satisfied: `yes | no`
- Root acceptance decision:
- Residual risks / explicit exceptions:
