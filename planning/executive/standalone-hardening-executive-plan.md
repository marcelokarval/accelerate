# Standalone Hardening Executive Plan

## Goal

Finish the next standalone hardening layer for `accelerate` without weakening
the root control plane or reintroducing user-home catalog authority.

This plan turns the current backlog into bounded tasks that can be executed,
verified, and resumed by a zero-context operator.

## Current Context

Already landed in the active working tree:

- repo-local design-system and premium enforcement
- repo-local i18n closure gate and locale-pack parity adapter
- repo-local web-content-reader adapter and source-observer review surface
- gate ownership index
- materialized `Truth Ownership Check`, `Failure Classification Gate`, and
  `Artifact Sufficiency Check`
- doctrine integrity regression harness

The remaining hardening work should now focus on underrepresented proof lanes
and fixtures rather than broad architecture rewrites.

## Execution Principles

- Keep core docs capability-oriented; concrete commands belong in adapters or
  profiles.
- Add a gate only when it has a local owner and a regression hook or clear
  validation path.
- Do not register a skill unless the skill directory, metadata, and manifest
  entry all exist.
- Do not treat external or user-home material as authority.
- Prefer small fixtures/templates that make future implementation safer over
  large speculative adapters.

## Task Sequence

### T1 - Accessibility Closure Gate

Create a native accessibility review surface for UI/product work.

Files:

- `core/review/accessibility-closure-gate.md`
- `core/review/README.md`
- `core/control-plane/gate-ownership-index.md`
- `core/control-plane/branch-enforcement-matrix.md`

Done when:

- the gate defines keyboard, focus, semantics, contrast, reduced-motion, and
  screen-reader proof expectations
- product-critical and visual branches can inherit it without adding command
  specifics to core

### T2 - Observability And Performance Proof Packet

Create a native packet for observability/performance/N+1 proof.

Files:

- `core/runtime-packets/observability-performance-packet.md`
- `core/runtime-packets/README.md`
- `core/runtime-packets/qa-proof-stack.md`
- `core/control-plane/gate-ownership-index.md`

Done when:

- the packet separates metrics, logs, query-shape, traces, and residual gaps
- performance closure cannot rely on generic claims

### T3 - Runtime Proof Lane Fixtures

Add reusable runtime proof templates without binding core to one tool.

Files:

- `adapters/runtime/proof-fixtures/README.md`
- `adapters/runtime/proof-fixtures/runtime-proof-packet-template.md`
- `adapters/runtime/proof-fixtures/browser-truth-template.md`
- `adapters/runtime/README.md`

Done when:

- runtime proof lanes have local templates outside core
- browser truth and persistent regression remain separate

### T4 - Security And Anti-Abuse Eval Fixtures

Add local fixture templates for hostile-path and abuse-path review.

Files:

- `core/risk/security-abuse-fixtures.md`
- `core/risk/README.md`
- `skills/security/anti-abuse-review/SKILL.md`
- `skills/security/adversarial-security-review/SKILL.md`

Done when:

- fixture shape covers actor, boundary, replay/rate/enumeration/race probes,
  evidence, and residual risk

### T5 - Financial/Payment/Stripe Fixture Packets

Add local fixture templates for money/provider correctness.

Files:

- `core/risk/financial-provider-fixtures.md`
- `skills/data/financial-source-truth/SKILL.md`
- `skills/data/payment-integration/SKILL.md`
- `skills/data/stripe-integration/SKILL.md`

Done when:

- charge/refund/subscription/webhook/idempotency/reconciliation scenarios have
  a repeatable packet shape

### T6 - Profile-Local Validation Bundles

Strengthen profile bundles without moving commands into core.

Files:

- `profiles/*/validation-bundle.md`
- `tests/doctrine-integrity.sh`

Done when:

- every active profile has a validation bundle or an explicit not-yet-active
  exception

### T7 - Workflow Adapter Depth

Convert GitHub/Linear adapter docs from placeholders into capability contracts.

Files:

- `adapters/workflow/github/README.md`
- `adapters/workflow/linear/README.md`
- `adapters/workflow/adapter-contract.md`

Done when:

- adapters describe issue/PR/status/comment capabilities, identity rules,
  metadata rehydration, and failure handling without pretending implementation
  exists where it does not

## Verification

Run after each bounded slice:

- `bash tests/doctrine-integrity.sh`
- `bash tests/i18n-doctrine.sh`
- `bash tests/design-system-artifact-consistency.sh`
- `bash tests/local-workspace-proof-gates.sh`
- `bash tests/core-command-boundary.sh`
- `bash onboarding/local-workspace/validate-v2.sh onboarding/local-workspace/v2-template`
- `bash scripts/validate-skill-registry.sh`
- `git diff --check`

Run skill export drift proof after skill registry or skill content changes:

- `bash scripts/sync-skills-to-global.sh && bash scripts/check-global-skill-mirror.sh`

## Immediate Execution Slice

Execute T1, T2, and T3 first. They are high-leverage, repo-local, and do not
require domain-specific fixture semantics.

## Execution Status

Current status: T1-T7 executed in the active worktree.

Execution evidence and subagent/master aggregation are recorded in:

- `standalone-hardening-execution-ledger.md`

Closure note: the initial forensic review found that gate ownership validation
was too narrow. The closure correction updated the doctrine integrity harness to
parse mandatory-gate cells and added owners for the remaining matrix gates.
