# Review Finding Schema

Store one finding object per file or validate each object independently.
The human-readable contract covers location, category, affected behavior,
failure scenario, evidence, confidence, severity, correction, proof,
false-positive disposition, and waiver state.

## Required Fields

| Field | Contract |
| --- | --- |
| `id` | stable non-empty finding identifier |
| `location` | repo-relative `path:line`, or known `artifact:`/`runtime:`/`provider:` locator |
| `category` | exactly `correctness`, `legibility`, `architecture`, `security`, `performance`, `tests`, or `verification-story` |
| `affected_behavior` | behavior or contract placed at risk |
| `failure_scenario` | concrete trigger and resulting failure |
| `evidence` | non-empty list of inspected proof locators |
| `confidence` | `low`, `medium`, or `high` |
| `severity` | `P0`, `P1`, `P2`, or `P3` |
| `severity_rationale` | exact object containing `impact`, `reach`, `reproducibility`, and `exploitability_basis` |
| `exploitability` | exact object containing canonical `status` and substantive `rationale` |
| `finding_state` | exactly `candidate`, `confirmed`, `rejected`, or `waived` |
| `correction` | smallest safe corrective action |
| `required_proof` | non-empty list of proof required after correction |
| `false_positive_disposition` | why the signal is confirmed, rejected, or still uncertain |
| `waiver` | null, or a bounded waiver object |

## Example

```json
{
  "id": "FINDING-001",
  "location": "src/domain/service.py:44",
  "category": "correctness",
  "affected_behavior": "reject invalid state",
  "failure_scenario": "an invalid transition is persisted",
  "evidence": ["test:tests/domain/test_service.py::test_rejects_invalid"],
  "confidence": "high",
  "severity": "P1",
  "severity_rationale": {
    "impact": "invalid state persists and violates the domain integrity contract",
    "reach": "all callers share the affected transition boundary",
    "reproducibility": "the focused negative test fails deterministically before correction",
    "exploitability_basis": "no hostile actor path is required for this integrity defect"
  },
  "exploitability": {
    "status": "not-applicable",
    "rationale": "the correctness defect has no hostile actor or trust-boundary path"
  },
  "finding_state": "confirmed",
  "correction": "validate the transition at the domain boundary",
  "required_proof": ["test:tests/domain/test_service.py::test_rejects_invalid"],
  "false_positive_disposition": "inspected-confirmed",
  "waiver": null
}
```

## Waiver Object

When non-null, record exactly `reason`, `approver`, future ISO `expires`, and
`residual_risk`. A waiver is valid only with `finding_state: waived`, and that
state requires a waiver. The validator checks schema coherence, not business
authorization.

`not-applicable` and `not-exploitable` must agree with
`exploitability_basis` and explain why no attacker path applies. `exploitable`
and `conditionally-exploitable` require a coherent attacker path; the
conditional state also names its prerequisite.

`false_positive_disposition` must agree with `finding_state`: a candidate stays
visibly unconfirmed, a rejected signal says why it is a false positive or not a
defect, a confirmed finding records confirmation, and a waived finding records
the accepted exception. Candidate and rejected states cannot contain a
confirmatory disposition.

Evidence and required proof must be substantive locator values prefixed with
`test:`, `artifact:`, `runtime:`, `provider:`, `log:`, `trace:`, `command:`, or
`url:`. Placeholder prose is rejected.
