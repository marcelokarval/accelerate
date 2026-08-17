# Accelerate Contract V1 Wave 4 Evals Enforcement Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn Contract V1 behavior, packaging, schemas, authority boundaries, and wave coverage into deterministic enforcement rather than narrative expectations.

**Architecture:** A structured JSON eval corpus feeds one runner with separate
scenario, workflow/action, persisted class, persisted mode, core-gate partition,
and canonical outcome assertions. Package and semantic validators inspect only
the repository source package in this wave. All `global-runtime/`, sync/mirror,
exporter, and generated-manifest mutations are deferred to Wave 5.

**Tech Stack:** Python 3, the accepted Wave 1 Draft 2020-12 engine, explicit
semantic checks, JSON, and Bash test wrappers. Runtime export scripts are out of
scope until Wave 5.

---

## Wave Packet

- Wave ID: `ACV1-W4`
- Class/mode: `orchestrated-nontrivial / wave`
- Dependencies: `ACV1-W3-009` is accepted and merged; typed evidence can record eval and package proof.
- Frozen denominator: `W4-C01` through `W4-C07`; the eval-case denominator is separately frozen by manifest count and digest before runner implementation.
- Coverage threshold: `100%` of required eval cases and `7/7` acceptance capabilities. A passing percentage cannot hide missing case IDs.
- Non-goals: model-quality benchmarking, provider-specific API calls, executing arbitrary commands embedded in eval fixtures, treating generated runtime files as canonical, or silently rewriting broken packages.
- Stop conditions: incident mode is absent; an expected gate/outcome is unchecked; corpus count changes without re-freeze; malformed schemas pass semantic checks; generated exports outrank repository source; broken relative links pass.

## Scenario Mapping, Gates, And Outcomes

The six legacy labels below are scenario/workflow dimensions only. The corpus
must test their explicit mapping to the SDD's independent persisted fields;
legacy labels are never accepted in `class`, `mode`, or `outcome`.

| Scenario label | Persisted class | Persisted mode | Workflow/action dimension | Canonical outcome examples |
| --- | --- | --- | --- | --- |
| `conversational` | `conversational-noop` | none | `answer`, `no-op` | `answer-without-accelerate` |
| `trivial-bounded` | `trivial-bounded` | `single` | `proceed`, `block`, `close` | `minimal-valid-skips`, `bounded-execution`, `blocked` |
| `bounded-slice` | `trivial-bounded` | `single` | `proceed`, `correct`, `block` | `bounded-execution`, `rerun-invalidated-only`, `blocked` |
| `orchestrated` | `orchestrated-nontrivial` | `single` unless topology proves another mode | `proceed`, `correct`, `escalate`, `block` | `execute`, `approval-required`, `scope-required`, `proposal-only-unless-proven`, `blocked` |
| `wave-gated` | `orchestrated-nontrivial` | `wave` | `advance`, `correct`, `block` | `execute`, `rerun-invalidated-only`, `blocked` |
| `incident` | `orchestrated-nontrivial` | `incident` | `contain`, `mitigate`, `rollback`, `escalate`, `recover`, `block` | `bounded-execution`, `rerun-invalidated-only`, `approval-required`, `blocked` |

Every activated case asserts a complete, unique decision partition for all 18
SDD `core.*` gates. Adapter/profile gates are namespaced extensions. Proof stages
and scenario actions remain claims/metadata, not gate IDs, evidence types,
modes, or outcomes. Triggered core gates cannot be waived.

## Target Files

| Action | Exact file | Responsibility |
| --- | --- | --- |
| Create | `core/contracts/v1/schemas/eval-case.schema.json` | Structural contract for scenario/class/mode/outcome/action mapping. |
| Create | `core/contracts/v1/schemas/eval-result.schema.json` | Runner result and aggregate result contract. |
| Create | `evals/contract-v1/cases.json` | Canonical repository-local scenario/class/mode/gate/outcome/action cases. |
| Create | `evals/contract-v1/denominator.json` | Frozen case IDs, count, digest, exclusions, and change policy. |
| Create | `scripts/run-contract-evals.py` | Structured eval runner and coverage reporter. |
| Create | `scripts/validate-contract-package.py` | Canonical `core/contracts/v1/` source-package validator. |
| Create | `scripts/validate-contract-schemas.py` | Semantic schema checks and valid/invalid fixture runner. |
| Create | `tests/fixtures/contract-v1-schemas/valid/cases.json` | One minimal valid case per Contract V1 schema. |
| Create | `tests/fixtures/contract-v1-schemas/invalid/cases.json` | Boundary and cross-field failures with expected labels. |
| Create | `tests/fixtures/contract-v1-package/valid/package.json` | Valid canonical source-package inventory fixture. |
| Create | `tests/fixtures/contract-v1-package/invalid/cases.json` | Named source-package drift/path/authority failures. |
| Create | `core/contracts/v1/schemas/release-backup-manifest.schema.json` | Typed prior-release backup, digest, retention, and restore contract for Wave 5. |
| Create | `tests/contract-v1-evals.sh` | Eval mapping tests, including incident and class/mode traps. |
| Create | `tests/contract-package-validator.sh` | Missing, extra, path, mode, schema, and authority-overclaim source-package tests. |
| Create | `tests/contract-v1-schema-semantic.sh` | Schema behavior tests beyond JSON syntax. |
| Modify | `tests/authority-set-gate.sh` | Assert eval/package authority and forbidden user-home authority. |
| Modify | `tests/markdown-link-integrity.sh` | Validate repository-source package/docs links. |
| Modify | `tests/ci-contract.sh` | Require the three new suites and existing authority/link gates. |
| Create | `scripts/validate-accelerate-contract-v1-forensic.py` | Catalog/checklist/final reconciliation CLI created before independent review. |
| Create | `tests/accelerate-contract-v1-forensic.sh` | TDD for `--catalog`, `--checklist`, and `--final`. |

## Runner Input And Output Contract

Each case has an immutable `id`, `prompt`, `scenario_label`,
`expected_trigger`, `expected_class`, `expected_mode`, `expected_outcome`,
`expected_action`, a complete 18-gate decision partition, evidence capabilities,
`required_terms`, and optional incident/wave expectations. The runner consumes a
supplied structured candidate result; it does not call a model or execute
fixture commands.

```json
{
  "case_id": "incident-production-regression",
  "observed": {
    "triggered": true,
    "scenario_label": "incident",
    "class": "orchestrated-nontrivial",
    "mode": "incident",
    "gate_decisions": {"core.mode-contract": "run", "core.scope-owner": "run"},
    "outcome": "bounded-execution",
    "action": "contain",
    "explanation": "Preserve evidence, stop rollout, assign severity and owner."
  }
}
```

Results distinguish `pass`, `assertion-failed`, `invalid-case`, `invalid-observation`, and `denominator-drift`. Aggregate output includes frozen count/digest, executed IDs, missing IDs, extra IDs, pass/fail counts, and coverage.

### ACV1-W4-001: Freeze Eval And Seven-Capability Denominators

**Depends on:** `ACV1-W3-009`

**Files:**
- Create: `evals/contract-v1/denominator.json`
- Modify: `planning/execution/accelerate-contract-v1-wave-denominator.json`
- Modify: active Wave 4 Packet

- [ ] Verify the Wave 3 closure record and post-merge evidence against its merge commit.
- [ ] Run `bash tests/all.sh` and record the baseline as typed evidence.

Expected: exit `0`; final line `all tests passed`.

- [ ] Inventory every intended eval ID before runner work. Freeze IDs, sorted canonical digest, count, selection rule, and explicit exclusions in `evals/contract-v1/denominator.json`.
- [ ] Validate the file created by this task with `python3 -m json.tool evals/contract-v1/denominator.json`; do not invoke the future eval test or runner from this entry task.
- [ ] Require cases for all six scenario labels, all three classes, all four
persisted modes, all 18 core gate decisions, all nine canonical outcomes, one
ambiguous classification, one false positive, one false negative, one stale
denominator, and at least three incident variants.

## Chunk 1: Structured Eval Runner

### ACV1-W4-002: Define Eval Schemas And Canonical Corpus

**Depends on:** `ACV1-W4-001`

**Files:**
- Create: `core/contracts/v1/schemas/eval-case.schema.json`
- Create: `core/contracts/v1/schemas/eval-result.schema.json`
- Create: `evals/contract-v1/cases.json`
- Modify: `evals/contract-v1/denominator.json` (created and owned by `ACV1-W4-001`)
- Create: `tests/contract-v1-evals.sh`

- [ ] **Red:** Assert unique IDs; exact three-class/four-mode/nine-outcome
vocabularies; complete 18-core-gate partitions; tested legacy-scenario mapping;
mode-compatible incident/wave fields; and exact case/denominator equality.
- [ ] Run `bash tests/contract-v1-evals.sh`.

Expected: non-zero with `missing eval case schema`.

- [ ] **Green:** Add schemas, the complete case corpus, and a denominator generated from sorted IDs. Record the generation command in the denominator but make updates explicit review events, not implicit runner mutations.
- [ ] Run the focused test.

Expected: structural checks pass and test stops at `missing eval runner`.

- [ ] Commit checkpoint: `test(evals): freeze contract v1 behavior corpus`.

### ACV1-W4-003: Implement Structured Eval Assertions

**Depends on:** `ACV1-W4-002`

**Files:**
- Create: `scripts/run-contract-evals.py`
- Modify: `tests/contract-v1-evals.sh`
- Create: `tests/fixtures/contract-v1-evals/valid/full.json`
- Create: `tests/fixtures/contract-v1-evals/invalid/wrong-mode.json`
- Create: `tests/fixtures/contract-v1-evals/invalid/missing-required-gate.json`
- Create: `tests/fixtures/contract-v1-evals/invalid/forbidden-gate.json`
- Create: `tests/fixtures/contract-v1-evals/invalid/incompatible-outcome.json`
- Create: `tests/fixtures/contract-v1-evals/invalid/missing-incident-gate.json`
- Create: `tests/fixtures/contract-v1-evals/invalid/executed-subset.json`

- [ ] **Red:** Add observation fixtures that intentionally use the wrong mode, omit one required gate, include a forbidden gate, choose an incompatible outcome, omit incident containment, and execute fewer IDs than frozen.
- [ ] Run `python3 scripts/run-contract-evals.py --cases evals/contract-v1/cases.json --denominator evals/contract-v1/denominator.json --observations tests/fixtures/contract-v1-evals/invalid/missing-incident-gate.json`.

Expected before implementation: non-zero because the runner does not exist.

- [ ] **Green:** Implement `validate-corpus`, `evaluate`, and `coverage` behavior. Emit deterministic JSON to stdout, diagnostics to stderr, exit `0` for full pass, `1` for assertion/coverage failure, and `2` for malformed input.
- [ ] Do not use substring-only scoring for mode/gate/outcome; compare structured fields. `required_terms` is supplemental explanation coverage only.
- [ ] Run valid and invalid focused fixtures.

Expected: valid full corpus reports `"coverage_percent": 100.0` and `"decision": "pass"`; missing incident gate reports case failure and exit `1`.

- [ ] Commit checkpoint: `feat(evals): add structured contract v1 runner`.

### ACV1-W4-004: Enforce Eval Denominator Membership And Coverage

**Depends on:** `ACV1-W4-003`

**Files:**
- Modify: `scripts/run-contract-evals.py`
- Modify: `tests/contract-v1-evals.sh`
- Create: `tests/fixtures/contract-v1-evals/invalid/denominator-added.json`
- Create: `tests/fixtures/contract-v1-evals/invalid/denominator-removed.json`
- Create: `tests/fixtures/contract-v1-evals/invalid/denominator-renamed.json`
- Create: `tests/fixtures/contract-v1-evals/invalid/denominator-duplicate.json`
- Create: `tests/fixtures/contract-v1-evals/invalid/denominator-skipped.json`
- Create: `tests/fixtures/contract-v1-evals/valid/denominator-reordered.json`

- [ ] **Red:** Test added, removed, renamed, duplicate, skipped, and reordered IDs. Reordering canonical input must not drift the digest; changing membership must.
- [ ] **Green:** Recompute canonical sorted-ID digest at startup and compare count, IDs, and digest before evaluating observations. Coverage denominator is frozen case membership, never only cases that happened to execute.
- [ ] Run `bash tests/contract-v1-evals.sh`.

Expected: exit `0`; invalid denominator fixtures each produce `denominator-drift`.

- [ ] Commit checkpoint: `feat(evals): enforce frozen case denominator`.

## Chunk 2: Package And Schema Enforcement

### ACV1-W4-005: Implement Repository Source Package Validation

**Depends on:** `ACV1-W4-004`

**Files:**
- Create: `scripts/validate-contract-package.py`
- Create: `tests/contract-package-validator.sh`
- Create: `tests/fixtures/contract-v1-package/valid/package.json`
- Create: `tests/fixtures/contract-v1-package/invalid/cases.json`

- [ ] **Red:** Build temporary canonical-package fixtures for a missing required
file, undeclared extra file, content/mode drift from the source manifest, path
traversal, symlink escape, remote schema reference, and authority text that
claims a generated or user-home package is canonical.
- [ ] Run `bash tests/contract-package-validator.sh`.

Expected: non-zero with `contract package validator missing`.

- [ ] **Green:** Validate the canonical `core/contracts/v1/` source-package
allowlist, SHA-256 digests, relative paths, local schema references, no escaping
symlinks, all required SDD files, and repository-source authority. Add
`--package-root` for an explicit repo package root or fixture; never default to
`$HOME` and never inspect/mutate `global-runtime/` in Wave 4.
- [ ] Run `bash tests/contract-package-validator.sh`.

Expected: all negative fixtures fail with stable labels; the canonical package reports `contract package valid`.

- [ ] Commit checkpoint: `feat(contract-v1): validate canonical source package`.

### ACV1-W4-006: Implement Semantic Schema Validation

**Depends on:** `ACV1-W3-002`, `ACV1-W4-005`

**Files:**
- Create: `scripts/validate-contract-schemas.py`
- Create: `core/contracts/v1/schemas/release-backup-manifest.schema.json`
- Create: `tests/contract-v1-schema-semantic.sh`
- Create: `tests/fixtures/contract-v1-schemas/valid/cases.json`
- Create: `tests/fixtures/contract-v1-schemas/invalid/cases.json`

- [ ] **Red:** Add valid/invalid fixtures for every Contract V1 schema. Test
cross-field rules including time order, passed evidence requirements, incident
containment, rejection of every triggered core-gate waiver, governed waiver
fields only for registered extension/profile gates, and closure revision
matching post-merge evidence.
- [ ] Run `bash tests/contract-v1-schema-semantic.sh`.

Expected: non-zero with `schema semantic validator missing`.

- [ ] **Green:** Run every schema/fixture through the accepted Wave 1 Draft
2020-12 engine, then apply explicit repository-specific cross-field semantic
checks. Keep engine validation and custom semantics separately reported.
- [ ] Require each invalid fixture to declare the expected stable failure label so a fixture cannot pass for the wrong reason.
- [ ] Run the focused test.

Expected: exit `0`; final line `contract v1 schema semantic tests passed`.

- [ ] Commit checkpoint: `test(contract): enforce schema semantics`.

## Chunk 3: Authority, Links, And CI

### ACV1-W4-007: Enforce Authority, Links, CI, And Forensic Validation

**Depends on:** `ACV1-W4-005`, `ACV1-W4-006`

**Files:**
- Modify: `tests/authority-set-gate.sh`
- Modify: `tests/markdown-link-integrity.sh`
- Modify: `tests/ci-contract.sh`
- Modify: `tests/contract-v1-evals.sh`
- Modify: `tests/contract-package-validator.sh`
- Modify: `tests/contract-v1-schema-semantic.sh`
- Create: `scripts/validate-accelerate-contract-v1-forensic.py`
- Create: `tests/accelerate-contract-v1-forensic.sh`

- [ ] **Red:** Add fixtures/repository assertions that fail on a user-home authority path, a generated export claiming authority, a missing repository-relative link, an absolute local Markdown link, and a package manifest target outside the repository.
- [ ] Run `bash tests/authority-set-gate.sh && bash tests/markdown-link-integrity.sh`.

Expected during red: at least one new fixture is not rejected.

- [ ] **Green:** Extend existing gates rather than creating competing
authority/link definitions. New Wave 4 fixtures and assertions cover repository
source packages/evals only; do not add generated-runtime mutation or package
validation behavior.
- [ ] **Red:** Add forensic CLI tests for exact catalog/detail ID and dependency
parity, checklist task references, command/file sequencing, created-file owner
uniqueness, capability counts, and final approval completeness. Require distinct
`--catalog`, `--checklist`, and `--final` modes.
- [ ] **Green:** Implement
`scripts/validate-accelerate-contract-v1-forensic.py` with stable 0/1/2 exits and
all three CLI surfaces; it reads repository planning/evidence only and performs
no side effects.
- [ ] Wire CI checks for `tests/contract-v1-evals.sh`,
`tests/contract-package-validator.sh`,
`tests/contract-v1-schema-semantic.sh`,
`tests/accelerate-contract-v1-forensic.sh`, authority, and links.
- [ ] Run all six scripts.

Expected: each exits `0` with its named pass line.

- [ ] Commit checkpoint: `test(governance): enforce contract authority and links`.

### ACV1-W4-008: Verify, Independently Review, And Close Wave 4

**Depends on:** `ACV1-W4-002`, `ACV1-W4-003`, `ACV1-W4-004`, `ACV1-W4-005`, `ACV1-W4-006`, `ACV1-W4-007`

- [ ] Run `python3 -m py_compile scripts/run-contract-evals.py scripts/validate-contract-package.py scripts/validate-contract-schemas.py scripts/validate-accelerate-contract-v1-forensic.py`.

Expected: exit `0` and no output.

- [ ] Run the structured runner against the complete valid observation set.

Expected: all frozen IDs execute; no extra/missing ID; coverage `100.0`; incident cases pass.

- [ ] Run `bash tests/contract-v1-evals.sh`, `bash tests/contract-package-validator.sh`, `bash tests/contract-v1-schema-semantic.sh`, and `bash tests/accelerate-contract-v1-forensic.sh`.

Expected: all exit `0`.

- [ ] Run `bash tests/authority-set-gate.sh`, `bash tests/markdown-link-integrity.sh`, and `bash tests/all.sh`.

Expected: authority and links pass; final line `all tests passed`.

- [ ] Run `git diff --check`.

Expected: exit `0` and no output.

- [ ] Persist typed evidence for corpus digest/count, full result JSON, each negative fixture class, package check, schema semantics, authority gate, link gate, and full suite. Evidence must identify the exact source revision and command digest.
- [ ] Run `python3 scripts/validate-accelerate-contract-v1-forensic.py --catalog planning/executive/accelerate-contract-v1-task-catalog.md`, then `--checklist planning/executive/accelerate-contract-v1-validation-checklist.md`; reserve `--final` for Wave 5 after human approvals and runtime/export proof exist.
- [ ] Have an independent evaluation reviewer inspect all IDs, incident/safety cases, package inventory, authority direction, and every negative class; classify findings and run correction/reproof before the advance/block decision.

## Rollout

1. Land schemas, corpus, and runner in report-only mode while requiring exact denominator reporting.
2. Make malformed corpus and denominator drift blocking.
3. Make incident/mode/gate/outcome failures blocking after the first full valid baseline.
4. Enable repository source-package and semantic validators in CI.
5. Require authority/link and forensic structure gates before Wave 5 runtime/export work.

## Rollback

- Revert CI wiring only if the validator itself is defective; retain failed reports and frozen denominator.
- Never lower coverage by deleting/ignoring cases. Correct the runner or explicitly re-freeze through a reviewed denominator change.
- If source-package checks block, keep runtime/export work disabled and correct
  repository source; Wave 4 has no generated-runtime rollback.
- If schema semantics regress, block new closure records while preserving Wave 3 evidence; do not reinterpret old data silently.

## Exit Gate And Acceptance

| ID | Acceptance capability | Required evidence |
| --- | --- | --- |
| `W4-C01` | Structured eval runner | Structured fields, deterministic results, stable exit codes. |
| `W4-C02` | Canonical vocabulary and mapping | Three classes, four modes, six scenario labels, and all 18 core gates have positive/negative mapping cases. |
| `W4-C03` | All canonical outcomes including incident scenarios | All nine SDD outcomes are covered; three incident variants enforce containment without inventing incident outcomes. |
| `W4-C04` | Repository source-package validator | Missing/extra/path/mode/schema/authority failures in `core/contracts/v1/` are detected. |
| `W4-C05` | Schema semantics | Valid fixtures pass and invalid fixtures fail for declared reasons. |
| `W4-C06` | Authority and link integrity | Repo-local source wins; user-home and broken/escaping links fail. |
| `W4-C07` | Denominator and forensic structure | Membership/count/digest drift blocks; catalog/checklist/dependency/owner sequencing validates before final review. |

- [ ] Emit a Wave Closure Packet with capability coverage and eval-case coverage as separate denominators.
- [ ] Exit only at `7/7`, eval coverage `100%`, full suite green, zero
denominator/source-package drift, catalog/checklist forensic modes passing, no
`global-runtime/` or sync/mirror mutation, and fresh typed proof attached.
