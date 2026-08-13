# Quality Engineering Stack SDD

## Status

- ID: `SDD-CODEX-QUALITY-001`
- Status: `accepted`
- Mode: `hierarchical`
- Owner: Accelerate root/orchestrator
- Date: 2026-08-12
- Governing issue: `CODEX-1`
- Source request: implement every approved pre-restart phase from the complete
  addyosmani/agent-skills and Ponytail analysis.
- Source snapshots:
  - `addyosmani/agent-skills@be42637c5af93fdc8526b68ec2f2651b930f316c`
  - `DietrichGebert/ponytail@2ed6c52c9d7e5e56942508591085fd45dea277d3`
- Supersedes: no prior quality-stack SDD; it narrows and extends the existing
  specification layer without replacing CODEX-1 catalog/runtime decisions.
- Related decision: `2026-08-12-quality-engineering-stack-adr.md`
- Related test design:
  `../testing/2026-08-12-quality-engineering-stack-test-design.md`
- Related execution ledger:
  `../execution/2026-08-12-quality-engineering-stack-task-breakdown.md`
- Related traceability matrix:
  `../specification/2026-08-12-quality-engineering-stack-traceability.md`
- Related Engineering Artifact Manifest:
  `../specification/2026-08-12-quality-engineering-stack-manifest.json`
- Related selective-adoption evidence:
  `../evidence/dated-proof-appendix/quality-stack-selective-adoption-matrix-2026-08-12.md`
- Related visual model:
  `2026-08-12-quality-engineering-agent-communication.md`

## Problem And Current Behavior

Accelerate already has issue-first execution, planning, SDD, isolated review,
QA proof, runtime profiles, and root-owned closure. The current contracts still
leave important behavior dependent on operator memory:

- SDD is conditional rather than semantically required for every mutation;
- `SDD` ambiguously means a lifecycle and a document;
- test design and Red/Green/Refactor receipts are not first-class artifacts;
- ADR and DESIGN dispositions are implicit;
- traceability does not enforce `requirement -> task -> test -> proof`;
- generic code review is stack-biased and maps category to severity;
- the current review skill may skip docs/config, mutate the baseline, auto-commit,
  and overstate local verification;
- security, test strategy, code quality, and web performance do not yet have
  complete specialist contracts;
- solution minimalism is not explicitly subordinate to specification,
  correctness, security, and proof;
- skill trigger/collision/behavior evaluation is not a uniform governed surface.

The historical session `019ff777-3338-7eb0-98ae-c2935b6e9e10` proved a stronger
hierarchical documentation shape: stable requirement IDs, explicit ownership,
trust boundaries, current/target/transition truth, corrections followed by
re-review, and no false operational-completion claim.

## Desired Behavior

Every mutation passes through a proportional specification lifecycle before
implementation. The root selects the materialization mode, accepts the design,
assigns bounded specialists, reconciles their independent returns, and alone
owns issue topology, integration, review-of-review, external writes, and
closure.

The target chain is:

```text
request / Plane
  -> Specification Entry
  -> SDD mode and accepted design
  -> ADR / DESIGN / Test Design dispositions
  -> task and traceability breakdown
  -> TDD, characterization, repro, or contract baseline
  -> implementation
  -> code quality / security / test review
  -> correction and reproof
  -> browser / persistent regression / release proof when applicable
  -> execution-to-spec reconciliation
  -> review-of-review
  -> root forensic closure
```

## Scope

In scope:

- proportional specification, decision, design, test-design, and TDD contracts;
- stable artifact terminology and lifecycle states;
- control-plane gates, owner index, branch routing, packets, and planning docs;
- specialist templates and collaboration routing contracts;
- progressive-disclosure skills and one-hop references;
- code-audit and requesting-code-review correction;
- deterministic contract tests, negative fixtures, evals, and golden replay;
- repo-owned source registration and governed global runtime mirror sync;
- all static/runtime checks that do not require a newly started Codex process.

## Non-Goals

- importing foreign hooks, commands, personas, or meta-orchestrators;
- installing either upstream repository as a global package;
- using LOC, file count, coverage percentage, Lighthouse score, or latency as a
  universal closure gate;
- using minimalism to bypass design, security, compatibility, observability,
  testing, or explicit product scope;
- making a logical Codex profile a claimed tool, MCP, credential, filesystem,
  or process isolation boundary;
- promoting a physical agent without empirical replay;
- claiming fresh startup, prompt inventory, or discovery proof before the first
  post-install restart;
- closing CODEX-1 before fresh runtime proof, independent review, full reproof,
  and governed Plane readback.

## Authority Set

Governing authorities:

- `AGENTS.md`
- `SKILL.md`
- `core/issue-topology/issue-driven-mutation-stack.md`
- `core/control-plane/branch-enforcement-matrix.md`
- `agents/base-agent-contract.md`
- `agents/doctrine/capability-matrix.md`
- `adapters/runtime/codex-collaboration/role-policy.json`
- `adapters/runtime/codex/logical-agent-topology.toml`
- Plane provider readback for `CODEX-1`

Supporting evidence:

- frozen upstream source snapshots listed in Status;
- the historical SDD session named above;
- current repository tests and runtime adapter validators.

Forbidden authorities:

- user-home runtime files as authoring truth;
- unverified benchmark claims;
- foreign hooks or Claude-specific command semantics;
- generated exports as source;
- subagent self-review as acceptance proof.

## Requirements

### Deterministic SDD Mode Selection

Choose the first matching row from top to bottom. A higher-risk row always wins.
The root records both the selected mode and the observed trigger; an override may
only increase the mode unless a written exception names the missing trigger,
evidence, approver, expiry, and residual risk.

| Priority | Observable trigger | Required mode | Minimum materialization |
| --- | --- | --- | --- |
| 1 | auth, billing, PII, irreversible migration, destructive/provider write, or safety-critical behavior | `critical` | separate SDD, ADR, threat model, Test Design, rollback |
| 2 | cross-domain ownership, architecture boundary, multi-runtime migration, or several independently deployable surfaces | `hierarchical` | root SDD, child dispositions, separate traceability |
| 3 | externally visible behavior, bug, refactor with behavioral risk, multi-file workflow/governance contract, or new specialist capability | `standard` | separate delta SDD, task ledger, explicit test disposition |
| 4 | local, known, reversible mutation with one owner and one focused proof | `micro` | non-empty Spec Capsule and all artifact dispositions |
| 5 | no mutation | `no-op` | no SDD; read-only outcome only |

Escalate immediately if discovery adds a trust boundary, durable decision,
cross-owner contract, concurrency/idempotency concern, external side effect, UI
structure, migration, rollback need, or more than one independent proof lane.
Under-classification is a failing condition: an auth fix cannot be `standard`, a
cross-domain migration cannot be `micro`, and a workflow mutation cannot be
`no-op`. If classification evidence is incomplete, choose the higher plausible
mode until the root resolves it.

### Specification lifecycle

- `REQ-SPEC-001`: every mutation declares `micro`, `standard`, `hierarchical`,
  or `critical` SDD mode; mutation may not use `none`.
- `REQ-SPEC-002`: `micro` may consolidate a non-empty Spec Capsule; `standard`
  requires a delta SDD; `hierarchical` requires a root SDD plus explicit child
  dispositions; `critical` adds separate ADR, threat model, Test Design, and
  rollback artifacts.
- `REQ-SPEC-003`: a design authority used for execution must be `accepted` or
  `implementing`, never only `draft`.
- `REQ-SPEC-004`: every run records ADR, DESIGN, Test Design, agent, rollout,
  rollback, observability, and AGENTS/docs dispositions with a substantive
  reason when consolidated or not applicable.
- `REQ-SPEC-005`: `Specification Lifecycle`, `SDD.md`, `Source Verification`,
  `TEST-DESIGN.md`, `TDD Receipt`, `DESIGN.md`, and `ADR` have one unambiguous
  meaning each.

### Traceability and testing

- `REQ-TRACE-001`: every behavioral requirement maps to a task, test or
  justified exception, and proof locator.
- `REQ-TRACE-002`: traceability distinguishes planned proof from observed proof.
- `REQ-TEST-001`: Test Design covers happy, negative, boundary, permission or
  ownership, concurrency/idempotency, failure/recovery, fixtures, observability,
  and the lowest effective test level, with explicit not-applicable reasons.
- `REQ-TEST-002`: behavioral features use Red/Green/Refactor; bugs use a failing
  repro; refactors use a characterization baseline; docs/governance use a
  semantic validator; migrations, security, UI, and external integrations use
  their appropriate contract/proof modes rather than a fabricated red test.
- `REQ-TEST-003`: correction invalidates stale proof and requires reproof.

### Review and security

- `REQ-REV-001`: code review covers correctness, legibility, architecture,
  security, performance, tests, and verification story without collapsing
  specialist security or QA authority.
- `REQ-REV-002`: finding severity derives from impact, reach, exploitability,
  reproducibility, and evidence; category does not determine severity.
- `REQ-REV-003`: each finding records location, affected behavior, scenario,
  evidence, confidence, severity rationale, correction, required proof, and
  false-positive/waiver disposition.
- `REQ-REV-004`: docs/config/workflow changes remain reviewable; review does not
  stash, auto-commit, publish, or mark itself accepted.
- `REQ-SEC-001`: security review starts from trust boundaries and covers STRIDE,
  abuse/variant cases, supply chain, exploitability, safe PoC where useful,
  remediation, and negative proof.
- `REQ-QA-001`: test engineering owns pre-code strategy and independent post-code
  proof; a test-only writer loses independence over its own authored tests.
- `REQ-PERF-001`: web performance reports declare `quick-static` or
  `deep-measured` and identify the source of every metric; unmeasured opportunity
  is not reported as a measured regression.

### Minimalism and delivery

- `REQ-LEAN-001`: use the ladder `real need -> project reuse -> standard library
  -> native platform -> approved installed dependency -> smallest legible
  correct solution`.
- `REQ-LEAN-002`: minimalism is a post-spec and post-green lens; it may not
  delete required guards, compatibility, observability, rollback, accessibility,
  security, or proof.
- `REQ-LEAN-003`: rejected complexity is registered with rationale and an
  explicit upgrade trigger when future conditions may justify it.

### Agents, skills, and runtime

- `REQ-AGENT-001`: add bounded contracts for specification engineer, code
  reviewer, test engineer, security auditor evolution, and web performance
  auditor; preserve root-exclusive authority and review isolation.
- `REQ-AGENT-002`: templates may be introduced before physical promotion;
  logical/runtime promotion requires empirical replay and may remain deferred.
- `REQ-AGENT-003`: every return contains requested-vs-implemented, evidence,
  self-review, self-forensic review, defects, residual risk, and root boundary.
- `REQ-SKILL-001`: governed skills follow concise progressive disclosure, one-hop
  references, deterministic scripts only, metadata, registry, and parity rules.
- `REQ-SKILL-002`: trigger evals include positive, negative, collision,
  behavioral-diagnosis, pressure, and brownfield fixtures, with no global
  meta-router. Pre-restart validation proves fixture structure and substantive
  routing intent only; actual LLM selection and return behavior require a
  disposable no-history replay before promotion.
- `REQ-RUNTIME-001`: repo source is changed before any global mirror; generated
  runtime/install outputs never become source authority.
- `REQ-RUNTIME-002`: post-restart discovery/startup claims require a new Codex
  process, exact effective inventories, successful root and specialist turns,
  zero context-budget warnings, and a bounded no-history spawn/return receipt.

## Target Architecture And Ownership

| Surface | Owner | Responsibility |
| --- | --- | --- |
| Root control plane | Accelerate root | classify, accept SDD, open gates, staff, integrate, review reviews, close |
| Specification layer | specification-engineer capability | draft IDs, non-goals, dispositions, traceability; read-only and non-accepting |
| Architecture | architecture reviewer | boundaries, alternatives, ADR, migration and durable consequences |
| Implementation | bounded stack implementer | code and TDD receipt inside explicit write scope |
| Code quality | code-reviewer capability | independent correctness, clarity, simplicity, maintenance and spec compliance |
| Security | evolved security-auditor capability | trust boundaries, hostile paths, exploitability and negative proof |
| Testing | test-engineer capability | pre-code Test Design and independent regression proof |
| Product runtime | web performance / QA capabilities | source-labelled browser, performance, accessibility and runtime proof |
| Governance | governance auditor | artifact chain, issue state, authority, source/mirror parity |

Specialists communicate only through bounded assignment and return packets.
They do not communicate by assuming another agent's hidden state. The root owns
cross-slice reconciliation.

The authoritative agent-communication diagram, scope, callouts, implementation
binding, and residual ambiguity live in the related visual-model artifact. That
model is a design constraint for templates, collaboration profiles, spawn
packets, review returns, and root review-of-review.

## Agent Promotion Disposition

- specification engineer: template/capability contract now; empirical replay
  before logical/physical promotion;
- code reviewer: collaboration profile may be added only when validator and
  independent replay prove containment; physical promotion deferred;
- test engineer: template and two-mode contract now; test-only writer requires a
  separate assignment; physical promotion deferred;
- security auditor: evolve the existing security reviewer; do not create a
  duplicate family;
- web performance auditor: template-only/on-demand until replay on a real web
  application with source-labelled metrics;
- lean code: review lens/skill, not a root mode and not an autonomous closer.

## Compatibility And Migration

- Preserve the current root-orchestrator and six installed logical profiles.
- New capability families may map to existing normalized role families until a
  measured need justifies topology expansion.
- Existing `qa-regression` remains the normalized QA family; `test-engineer` is
  a capability family with `test-design` and `regression-proof` modes.
- Existing `security` remains normalized; evolve its template/envelope.
- Existing `governance` can host specification/code-review read-only passes
  initially, while their capability identities remain explicit.
- Do not silently reclassify `reviewer` or `qa` as promoted new specialists.

## Decision Dispositions

- ADR: separate artifact required because proportional SDD and selective
  upstream adoption are durable cross-surface decisions.
- DESIGN: not applicable; no product UI or interaction structure changes.
- Visual Modeling: separate agent-communication artifact required because this
  change introduces several delegated roles and return-authority boundaries.
- Test Design: separate artifact required because multiple validators, routing
  contracts, eval classes, and parity surfaces are involved.
- Threat model: consolidated here; primary risks are authority collapse,
  foreign-hook execution, wildcard capability grants, false proof, benchmark
  contamination, and source/runtime divergence.
- AGENTS: update required only if the implemented owner/gate contract changes
  global bootstrap law; avoid duplicating procedures already owned by gates.
- Rollout: repo source -> focused tests -> full suite -> independent review ->
  global mirror sync -> first-restart proof.
- Rollback: restore runtime mirror from its generated backup/receipt and revert
  only this source slice; never delete unrelated skills/profiles.
- Observability: gate ledgers, TDD receipts, eval reports, parity hashes, Plane
  lifecycle comments, and explicit pending fresh-start proof.

## Alternatives

| Option | Benefit | Cost / risk | Decision |
| --- | --- | --- | --- |
| Import both upstreams wholesale | fastest apparent adoption | duplicate orchestrator, foreign hooks, context pressure, unsafe semantics | rejected |
| Keep current process unchanged | no migration | operator-memory gaps and weak pre-code enforcement remain | rejected |
| One universal quality agent | fewer profiles | authority collapse and shallow review across domains | rejected |
| Selective contracts plus bounded capabilities | preserves mature root and adds missing quality layers | more explicit schemas and eval work | selected |

## Rollout And Rollback

1. Materialize this SDD, ADR, Test Design, and task ledger.
2. Write focused RED contract tests and observe intended failures.
3. Implement artifact/gate contracts, then agent contracts, then skills/evals.
4. Run focused proof and the full repository suite.
5. Run independent skeptical review and correct/reprove findings.
6. Stage and validate repo-owned runtime mirror changes.
7. Sync the governed runtime mirror with a backup/receipt where supported.
8. Stop before any fresh-process claim.
9. After the user's restart, prove prompt discovery, routing, spawn packets,
   specialist returns, root review-of-review, and no budget regression.
10. If runtime proof exposes a defect, reenter specification/TDD, correct the
    repo source first, deploy through the governed transaction, and repeat
    runtime proof before review or closure.

Rollback preserves existing catalog/profile behavior and restores only files
identified by the install receipt. No plugin, skill, MCP, credential, or cache is
deleted.

## Traceability

The canonical 27-row requirement-to-task/stable-case/proof mapping lives in the
related traceability matrix. The task ledger and Test Design may summarize it
but must not become competing traceability authorities. Planned proof is never
presented as observed proof.

## Handoff Decision

- Ready for task breakdown: `yes`
- Ready for RED tests: `yes`; intended initial failures have been observed
- Ready for implementation: `yes`; T0 and the 27-case T1 RED baseline were
  independently accepted, and the dated Engineering Artifact Manifest passes
  the implementation-stage semantic validator
- Fresh-start proof available: `yes`; generation five records exact discovery,
  startup, routing, and bounded spawn/return evidence; final independent review,
  root review-of-review and governed CODEX-1 closure subsequently passed
