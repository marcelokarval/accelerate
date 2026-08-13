# Fresh Proof Contract

## Receipt Fields

Record:

- governing requirement and task IDs
- change kind and selected proof mode
- baseline command/action, fixture, time, result, and evidence locator
- baseline interpretation and any harness correction
- implementation boundary
- correction generation and proof generation
- focused proof and affected regression locators
- applicable QA, browser, persistent, and forensic proof dispositions
- test/fixture author and independent reviewer
- stale evidence excluded from the verdict
- defects, residual risks, and root promotion boundary

## Generation Rule

Start at `correction_generation = 0` and `proof_generation = 0`. The first
material implementation advances correction to 1. Every later material change
advances it again and invalidates affected prior proof. Only new evidence at the
same generation can authorize review:

```text
proof_generation == correction_generation
```

If a correction changes requirements, risk, fixtures, or the oracle, return to
Specification Lifecycle and Test Design before reproof.

## Proof Order

1. implementation proof
2. backend/frontend QA when applicable
3. interactive browser truth for runtime/UI behavior
4. persistent regression after the path is stable
5. independent forensic closure review

A later lane cannot compensate for a missing earlier lane. Use a substantive
scope-specific not-applicable reason, not a blank or generic `none`.

## Independence

An implementation owner may self-review but cannot independently accept the
result. A test-only writer loses independent review authority for tests,
fixtures, and oracles they authored. If no independent reviewer is available,
return `blocked` or `pending`.
