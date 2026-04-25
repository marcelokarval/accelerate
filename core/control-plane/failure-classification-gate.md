# Failure Classification Gate

## Purpose

Failure-driven work must classify the failure before fixing, auditing, or
claiming closure.

This prevents shallow fixes that treat symptoms as root cause, security theater
that lacks exploitability boundaries, and regression closure without fresh proof.

## When Required

Use this gate for:

- bug, failure, or regression branches
- adversarial security review and hostile-path review
- failed validation, build, test, lint, browser, or runtime proof
- production/runtime defects or user-reported failures
- any branch where a concrete defect is discovered during execution

## Required Classification

Record the smallest accurate class:

- `reproducible-defect`
- `intermittent-defect`
- `configuration-failure`
- `environment-failure`
- `data-shape-failure`
- `contract-drift`
- `ownership-boundary-failure`
- `validation-gap`
- `security-finding`
- `abuse-path`
- `tooling-failure`
- `documentation-drift`
- `not-yet-reproduced`

If the class is `not-yet-reproduced`, closure may only claim investigation or
mitigation, not that the defect is fixed.

## Minimum Packet

A satisfying packet names:

- observed failure
- reproduction status
- affected surface
- suspected root-cause boundary
- evidence used to narrow the failure
- fix or mitigation scope
- regression proof needed before closure

## Blocking Conditions

Do not proceed to closure when:

- the failure was not reproduced or explicitly classified as unreproduced
- the fix scope is broader than the classified cause
- evidence proves only that a command was run, not that the failure mode changed
- a security or abuse finding lacks trust-boundary and exploitability judgment
- corrected-state proof was skipped after an in-scope defect was changed

## Closure Rule

Closure requires fresh proof after the fix or mitigation. Historical failing
output is useful for diagnosis, but cannot prove corrected state.
