# Quality Engineering Stack Test Design

## Status

- ID: `TEST-DESIGN-CODEX-QUALITY-001`
- Status: `accepted`
- Owner: `test-engineering-lane`
- Independent reviewer: `quality_spec_review`
- Accepted by: `accelerate-root`
- Date: 2026-08-12
- Governing issue: `CODEX-1`
- Source SDD:
  `../architecture/2026-08-12-quality-engineering-stack-sdd.md`
- TDD modes: semantic-contract RED/Green/Refactor, negative fixtures, and
  characterization for existing behavior.

## Test Objective

Prove the deterministic contracts without substituting prose or fixture shape
for runtime behavior: mutations cannot bypass proportional
specification; artifact and review contracts fail closed; specialists remain
bounded; skills remain progressively disclosed and recoverable;
source/runtime parity is deterministic; and no restart-dependent or LLM-routing
claim is fabricated. Real routing and return behavior requires the separate
fresh no-history replay level below.

## Test Levels

| Level | Purpose | Preferred surface |
| --- | --- | --- |
| static contract | required names, links, owners, dispositions | shell + `rg`/Python parser |
| semantic validator | valid/invalid artifact and policy fixtures | focused Python CLI or shell harness |
| integration | registry, catalog, role policy, topology, export/parity | existing repository test suite |
| replay | realistic routing and return behavior | fresh no-history subagent or isolated Codex process |
| runtime | prompt discovery/startup and profile selection | fresh Codex process after restart only |

## Required Dimension Dispositions

| Dimension | Disposition for this change | Lowest effective level / oracle |
| --- | --- | --- |
| happy behavior | required | focused semantic contract test |
| negative behavior | required | invalid fixture must exit non-zero with exact diagnostic |
| boundary values | required | mode transitions, missing fields, duplicate IDs, and empty values |
| permission / ownership | required | role-policy and agent-template validation |
| concurrency / idempotency | applicable to provider/runtime receipts | duplicate operation/receipt fixture; no concurrent product state exists here |
| failure / recovery | required | invalid artifact, stale proof, parity drift, and rollback receipt cases |
| fixtures / data | required | disposable JSON/TOML/Markdown fixtures and brownfield dirty-tree fixture |
| observability | required | exact diagnostic, command, exit status, proof state, and receipt locator |
| security | required | STRIDE, trust boundary, supply-chain provenance, wildcard, and authority-collapse negatives |
| browser truth | not applicable pre-restart | no product UI mutation; fresh Codex TUI proof is a separate post-restart unit |
| persistent E2E | not applicable pre-restart | no product journey; fixture-contract validation is the effective pre-restart layer and is not LLM replay |
| external integration | applicable only to governed Plane/mirror operations | idempotency/readback receipt; no copied credentials or provider payloads |

No row may be silently omitted. A changed scope requires this table and the
canonical traceability matrix to be updated before implementation continues.

## Case Matrix

### Specification and decisions

- `CASE-SPEC-001` negative: mutating work declares `none` or omits mode;
- `CASE-SPEC-002` happy/boundary: micro has a non-empty Spec Capsule; standard
  has a delta SDD; hierarchical links child dispositions; critical has separate
  ADR, threat model, Test Design, and rollback. Under-classified auth,
  cross-domain, external-write, and workflow mutations fail closed;
- `CASE-SPEC-003` negative: `draft` SDD authorizes execution;
- `CASE-SPEC-004` negative: any required disposition is missing or empty;
- `CASE-SPEC-005` boundary: docs/governance mutation uses semantic contract
  proof and stable terminology rather than a
  fabricated behavioral red test;
- supporting negative: durable one-way decision omits ADR backlink;
- supporting negative: structural UI work silently omits DESIGN disposition.

### Traceability and TDD

- `CASE-TRACE-001` happy/negative: every behavioral `REQ-*` maps to a task and
  test or justified exception; missing mappings and duplicate IDs fail;
- `CASE-TRACE-002` negative: planned proof is presented as observed or used to
  authorize implementation/closure;
- `CASE-TEST-001` boundary: Test Design omits any required dimension or lacks a
  substantive not-applicable reason;
- `CASE-TEST-002` happy/negative: feature records observed Red/Green/Refactor;
  bug records failing repro; refactor records characterization before/after;
  docs use semantic validation; a test authored after code is not called TDD;
  migration/security/UI/external integration choose an appropriate
  contract mode and explicit not-applicable fields.
- `CASE-TEST-003` negative: stale proof timestamp/state is accepted after a
  material correction.

### Review, security, QA, and performance

- `CASE-REV-001` happy: review covers all declared axes and verification story;
- `CASE-REV-002` negative: category fixes severity (for example all security P0
  or all docs P3), or a grep hit is emitted as confirmed without inspection;
- `CASE-REV-003` negative: a finding omits evidence, confidence, affected
  behavior, failure scenario, severity rationale, correction, proof, or waiver;
- `CASE-REV-004` negative: reviewer skips docs/config/workflow, modifies the
  candidate, stashes, commits, publishes, or
  accepts its own work;
- `CASE-SEC-001` happy/negative: security report covers trust boundaries,
  STRIDE, abuse variants, supply-chain provenance, exploitability, safe PoC
  disposition, remediation, and negative proof; any silent omission fails;
- `CASE-QA-001` negative: test engineer writes tests and then independently
  accepts them;
- `CASE-PERF-001` happy/negative: quick-static marks metrics unavailable;
  fabricated Lighthouse/CrUX/trace data cannot be presented as observed.

### Minimalism

- `CASE-LEAN-001` happy: solution checks project reuse, standard library and
  native platform before an approved dependency;
- `CASE-LEAN-002` negative: simplification removes validation, authorization,
  rollback,
  observability, accessibility, or a required negative test;
- `CASE-LEAN-003` happy/negative: rejected complexity has rationale and a
  measurable upgrade trigger; LOC/file count cannot produce a closure verdict;
- supporting negative: a code-first patch precedes an accepted specification.

### Agents and routing

- `CASE-AGENT-001` happy: specification, code, test, security, and performance
  templates have bounded roles and independent returns;
- `CASE-AGENT-002` negative: template/config presence is reported as physical
  promotion or isolation without empirical replay;
- `CASE-AGENT-003` negative: any specialist return omits required fields or
  claims issue topology, external-write, integration,
  review-of-review, or closure authority;
- supporting negative: wildcard skills, tools, MCPs, scope, or write scope;
- supporting negative: executor is also the acceptance reviewer without an exception and
  residual-risk record.

### Skills, evals, and parity

- `CASE-SKILL-001` structure: `SKILL.md` stays under the official ceiling and
  targets the local 180-220
  lines/10KB shape; long depth is one hop away;
- `CASE-SKILL-002` fixture contract: every package declares one substantive
  positive, negative, collision, behavioral-diagnosis, pressure, and brownfield
  case; fixtures name the intended owner, excluded owner, adjacent owner or
  preserved brownfield state as applicable; placeholder and marker-stuffed
  cases fail. This case validates the replay inputs, not LLM routing outcomes;
- supporting structure: registry, metadata, links, source/mirror staging are
  complete; no `README.md`, empty resource folder, cache, `.pyc`, or `__pycache__` is added
  inside a finished skill;
- no global meta-router or foreign hook is introduced.

### Runtime and parity

- `CASE-RUNTIME-001` happy/negative: repo source precedes mirror sync; recursive
  parity catches missing and stale files; backup/rollback receipt is produced;
- `CASE-RUNTIME-002` runtime: post-restart proof records exact root and
  specialist inventories, executes successful ephemeral read-only turns with
  zero skill-budget errors, and records a bounded no-history spawn/return
  without claiming native profile injection or isolation.

## Golden Replays

These scenarios define the post-contract replay denominator. Their presence in
this accepted Test Design is not evidence that an isolated Codex process or LLM
has executed them.

1. Historical hierarchical SDD scenario:
   `019ff777-3338-7eb0-98ae-c2935b6e9e10` must produce hierarchical mode,
   stable IDs, current/target/transition truth, ADR/DESIGN/Test Design
   dispositions, correction/re-review, and no operational-completion claim.
2. Docs-only governance change must select micro or standard mode, semantic
   validator proof, docs review, and no fake Red/Green claim.
3. Auth/ownership change must select critical mode, threat/security proof, and
   independent security review.
4. Web performance review without measured data must stay quick-static and
   explicitly unmeasured.
5. Lean review must reject both speculative abstraction and unsafe deletion of
   required guards.

## Planned Commands

- focused new contract tests under `tests/`;
- existing collaboration/topology/template/registry/parity tests;
- `bash tests/all.sh`;
- `git diff --check`;
- official skill validators for every new or materially changed skill;
- clean-tree and cache scans;
- disposable no-history subagent replays before promotion; these remain a
  distinct empirical proof and cannot be inferred from eval JSON validation;
- post-restart Codex prompt/startup proof through the opt-in runtime gate and
  a separate no-history spawn/return receipt.

## Exit Criteria

- every focused RED test was observed failing for the intended missing rule;
- minimal implementation makes focused and full suites pass;
- independent review findings are corrected or explicitly dispositioned;
- source/global parity passes without treating the global mirror as authority;
- eval packages pass the fixture contract without being reported as observed
  LLM behavior;
- fresh-start proof is observed through a new process and never inferred from
  static validation.
