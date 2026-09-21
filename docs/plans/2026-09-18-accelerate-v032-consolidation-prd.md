# PRD: Accelerate v0.3.2 Consolidation & Harness Hardening

- **Document ID**: PRD-ACC-032
- **Date**: 2026-09-18
- **Status**: APPROVED
- **Target Cycle**: v0.3.2
- **Author**: Platform Architecture & Governance (W-CONTRACT)

---

## 1. Executive Summary

Cycle v0.3.2 hardens the Accelerate OpenCode plugin and runtime harness against prompt injection, prompt bloat, quote-nesting truncation, and unauthorized tool invocation. It formalizes deterministic role separation (Master Orchestrator vs. Atomic Worker vs. Subagent), eliminates fragile regex-only suppressions through structured AST/delimited parsing, introduces canonical envelope integrity hashing, and locks down execution boundaries across parallel Git worktrees.

---

## 2. Problem Statement & Gap Analysis (G01 - G08)

The v0.3.1 operating experience surfaced eight operational vulnerabilities and gaps:

- **G01 (Quotation Nesting & Truncation)**: Injection of nested prompt quotes or markdown codeblocks caused premature parser cuts and prompt truncation in downstream tools.
- **G02 (Lack of Provenance Verification)**: Worker completion reports and receipts lacked cryptographically verifiable origins, enabling prompt spoofing of task outcomes.
- **G03 (Collateral Text Destruction)**: Superpowers suppression filters greedily stripped legitimate user code snippets containing pattern overlaps.
- **G04 (Message Part Disintegration)**: Multi-part messages (tool calls, thinking tokens, images, text parts) lost structure across the OpenCode plugin transform lifecycle.
- **G05 (Role Boundary Ambiguity)**: Workers could access master orchestration tools (`acc_dispatch_worker`, `acc_dispatch_wave`), triggering uncontrolled recursive delegation.
- **G06 (Ad-hoc Validation & Mock Fallbacks)**: Verification gates relied on mock heuristics instead of deterministic, real-runtime validations (PostgreSQL 18, actual test runners).
- **G07 (Documentation Fragmentation)**: Disconnected architecture specs, stale contracts, and drift between execution plans and implemented code.
- **G08 (Distribution Drift)**: Variations across runtime distributions caused configuration inconsistencies between developer machines and CI/CD pipelines.

---

## 3. Functional Requirements (RF01 - RF08)

### RF01: Resilient Quoted Text Handling (Covers G01)
- The plugin message transformer MUST parse nested quotations, backtick fences (```` ````), and escaped markdown blocks without terminating envelope delimiters prematurely.
- Multi-layer quote depth MUST be normalized while preserving raw payload semantics byte-for-byte.

### RF02: Cryptographic Provenance Verification (Covers G02)
- Every execution receipt, delegation task, and worker completion report MUST carry a canonical SHA-256 envelope hash.
- The runtime MUST reject unverified or mismatched receipts before allowing state transitions (e.g., in Plane or Git fan-in).

### RF03: Surgical Superpowers Suppression & Legitimate Content Preservation (Covers G03)
- Superpowers prompt artifacts MUST be suppressed via exact delimited boundaries or AST tokens rather than unbounded greedy regular expressions.
- Legitimate code containing words such as "superpowers", "skills", or XML tags MUST remain 100% untouched outside targeted suppression envelopes.

### RF04: Multi-Part Message Integrity & Transformation Pipeline (Covers G04)
- The hook `experimental.chat.messages.transform` MUST preserve array ordering, part IDs, metadata, and distinct content blocks (e.g. `text`, `image`, `tool_use`, `tool_result`, `thinking`).
- Non-text parts MUST pass through unmodified without coercion to strings.

### RF05: Enforced Role Separation & Anti-Recursion (Covers G05)
- **Master Orchestrator**: Authorized to plan, dispatch waves (`acc_dispatch_worker`, `acc_dispatch_wave`), execute fan-in (`acc_fanin_worker`), and sync Plane states. Strictly forbidden from writing direct application mutations.
- **Atomic Worker**: Confined to dedicated Git worktree. Tool access strictly scoped to local file edits, local test commands, and `acc_fanin_worker` report generation. Hard block on dispatch tools.
- **Subagents (Explore/Librarian/Oracle)**: Strictly read-only; zero mutation tools.

### RF06: Deterministic Real-Runtime Validators (Covers G06)
- Automated verification pipelines MUST execute real local commands (e.g., Vitest, Pytest, cargo test, local PG18 instances).
- Mocks or simulated test returns for acceptance gates are strictly prohibited. Exit codes != 0 MUST abort promotion.

### RF07: Unified Documentation & Architectural Traceability (Covers G07)
- The documentation chain (PRD -> ADR -> SDD -> Tasks DAG) MUST be materialized physically in repo-tracked paths (`docs/plans`, `docs/architecture/adr`, `docs/architecture/sdd`, `docs/tasks`).
- Every wave and task in the DAG must map back to an approved PRD requirement and SDD component.

### RF08: Hermetic Runtime Packaging & Distribution (Covers G08)
- Runtime configurations, model lanes, and plugin bundles MUST be packaged with deterministic checksums to guarantee identical behavior across developer environments and CI.

---

## 4. Acceptance Criteria (Release v0.3.2)

1. **Test Suite**: 100% pass rate on unit, integration, and E2E plugin transform test suites.
2. **Deterministic Suppression**: 0 false positives on a corpus of 1,000 code samples containing nested markdown/code tags.
3. **Role Enforcement**: Workers attempting to call `acc_dispatch_worker` receive a deterministic authorization denial.
4. **Receipt Validation**: 100% of Plane sync and Git fan-in operations validate the SHA-256 envelope hash and reject tampered payloads.
5. **Zero AI Slop**: Clean forensic diff inspection across all changed files; no swallowed exceptions (`except: pass`, empty `catch {}`).

---

## 5. Non-Goals

- Deprecation or replacement of OpenCode SDK core engine.
- Re-architecting remote Plane API endpoints (transitions remain governed client-side).
- Support for distributed multi-host worktree synchronization outside local git worktrees.
