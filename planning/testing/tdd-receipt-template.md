# TDD Receipt Template

Use this receipt to record observed baseline, correction, and fresh proof for
one bounded change. It is evidence, not a substitute for Test Design or root
acceptance.

## Identity And Generations

- Receipt ID: `TDD-RECEIPT-<stable-id>`
- Governing requirement(s):
- Task / issue:
- Accepted Test Design:
- Change kind: `feature | bug | refactor | docs | governance | migration | security | ui | external-provider | hybrid`
- Proof mode: `red-green-refactor | failing-repro | characterization | semantic-contract | migration-contract | security-contract | ui-contract | provider-contract | hybrid`
- Hybrid constituent modes: list at least two distinct non-hybrid proof modes, or give a substantive not-applicable reason
- Implementation / correction owner:
- Test / fixture writer:
- Independent reviewer:
- Correction generation: `0`
- Proof generation: `0`
- State: `planned | baseline-observed | corrected | reproved | reviewed | stale | blocked`

Increment `correction generation` after every material correction. All earlier
proof becomes stale immediately. Review or closure requires fresh observed
proof whose `proof generation` equals the current correction generation.
The first implementation after baseline advances correction generation from 0
to 1; a baseline-only receipt cannot satisfy post-change freshness.

## Baseline Evidence

- Baseline type:
- Command / action:
- Fixture, route, or scenario:
- Expected signal:
- Observed signal:
- Exit status / runtime result:
- Evidence locator:
- Observed at:
- Generation observed:

For a feature, record an actually observed Red caused by missing behavior—not a
syntax error or an already-passing test. For other modes, name the honest
baseline. Never relabel an unexecuted expectation, old log, planned command, or
test written after implementation as Red.

## Correction / Green Evidence

- Correction summary:
- Changed owner surface:
- Correction generation after change:
- Focused command / action:
- Expected result:
- Observed result:
- Exit status / runtime result:
- Evidence locator:
- Observed at:
- Proof generation:

## Refactor Or Mode-Specific Reproof

- Refactor performed or substantive not-applicable reason:
- Characterization / contract retained:
- Migration forward and rollback proof:
- Security negative / abuse proof:
- UI interactive browser truth:
- External-provider failure, idempotency, and authorized readback:
- Fresh regression command / action:
- Observed result and locator:
- Proof generation:

Do not require every field to contain an artifact. Require every field to hold
observed evidence or a substantive `not-applicable` reason appropriate to the
selected mode.

## Proof Order

Record each applicable lane in order. A later lane cannot repair a missing
earlier lane.

| Lane | Status | Evidence / substantive not-applicable reason | Generation |
| --- | --- | --- | --- |
| Implementation proof |  |  |  |
| Backend / frontend QA |  |  |  |
| Interactive browser truth |  |  |  |
| Persistent regression proof |  |  |  |
| Forensic closure review |  |  |  |

For UI work, establish browser truth before persisting Playwright or equivalent
regression automation. Planned proof must remain labelled `planned` and cannot
authorize promotion or closure.

## Independence And Freshness Decision

- Did the reviewer author any test or fixture under review? `yes | no`
- If yes, replacement independent reviewer:
- Current correction generation:
- Current proof generation:
- Any stale evidence excluded from the verdict:
- Independent review verdict: `pass | fail | blocked | pending`
- Root acceptance / closure decision: `accepted | rejected | pending`
- Residual risks and exceptions:

Self-review is useful but is not independent acceptance. A test-only writer
loses independent review authority for their own tests and fixtures.
