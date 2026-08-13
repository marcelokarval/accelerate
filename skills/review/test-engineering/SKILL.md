---
name: test-engineering
description: Design proportionate test strategy before code and independently assess regression proof after code. Use when a change needs lowest-effective-level test selection, negative or nonfunctional coverage, fixture and suite-health judgment, or a test-only implementation lane whose acceptance independence must be explicit.
---

# Test Engineering

Own test strategy and evidence quality, not product implementation or root
acceptance. A test author loses independent reviewer authority over the tests
they authored; assign a separate reviewer or record a visible exception.

## Core Rule

Test affected behavior at the lowest effective level that can prove it. Add
higher layers only for distinct integration, runtime, or user-flow risk.

## Pre-Code Strategy

1. Read accepted requirements, design, traceability, and known baseline.
2. Identify affected behavior, invariants, state transitions, trust boundaries,
   integrations, and failure modes.
3. Choose the TDD contract: feature Red/Green/Refactor, bug failing repro,
   refactor characterization, docs/governance semantic contract, or a named
   migration/security/UI/provider proof mode.
4. Cover happy, negative, boundary, permission/ownership,
   concurrency/idempotency, failure/recovery, fixtures/data, observability, and
   lowest effective level. Use substantive `not-applicable` reasons.
5. Add relevant nonfunctional dimensions: security, accessibility,
   compatibility, performance, resilience, localization, or rollback.
6. Map requirement -> task -> test -> planned proof before implementation.

Read [test-strategy.md](references/test-strategy.md) for the level and dimension
matrix.

Route initial DOM, network, visual, and functional flow truth to the browser QA
authority. Test engineering selects persistent regression coverage after that
truth stabilizes; it does not absorb browser acceptance.

Use the existing `product-browser-qa` catalog group with
`product-runtime-review` for browser/runtime truth and `dogfood` when
exploratory browser QA and issue capture are needed. These are adjacent owners,
not capabilities owned by test engineering.

## Test-Only Writing Lane

When authorized to write tests, change only the bounded test/fixture scope.
Record the observed failing baseline before product correction. Do not weaken
the oracle merely to make implementation green. Preserve unrelated brownfield
state and existing failure counts.

A test-only writer must return authored paths and loses independent review
authority for those paths. Another context must accept their correctness when
independent proof is required.

## Post-Code Proof Review

1. Confirm implementation proof belongs to the current correction generation.
2. Run the smallest focal proof, then proportionate affected suites.
3. Compare with the recorded baseline; separate introduced failures.
4. Inspect logs, traces, screenshots, coverage, or provider receipts only when
   the contract requires them.
5. Evaluate suite health using [suite-health.md](references/suite-health.md).
6. Check that negative and nonfunctional risks were proven or explicitly
   dispositioned.
7. Return gaps for correction; do not patch product code as reviewer.

## Evidence Rules

- Report exact commands, exit status, cases, and proof locators.
- Distinguish planned, observed-red, green, re-proved, stale, and unmeasured.
- Do not equate test count or coverage percentage with behavioral adequacy.
- Do not call a test written after implementation TDD.
- Do not accept quarantined, skipped, flaky, or retried-away failures silently.

## Return Contract

Return:

- requested versus tested behavior;
- strategy and lowest effective level;
- dimension dispositions and traceability;
- baseline, focal, suite, and nonfunctional evidence;
- authored test paths, if any, and resulting independence loss;
- suite-health findings, defects, and residual risk;
- self-review, self-forensic review, and root-owned acceptance boundary.

## Verification

- Strategy predates implementation for feature TDD claims.
- Every behavioral requirement has a test or justified exception.
- Negative, boundary, ownership, failure, and relevant nonfunctional paths are
  not silently omitted.
- Test authorship and independent acceptance are different authorities.
- Proof generation matches the latest material correction.
