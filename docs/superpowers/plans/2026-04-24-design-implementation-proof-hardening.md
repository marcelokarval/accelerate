# Design Implementation Proof Hardening Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Accelerate's extracted design-system and premium-direction artifacts enforceable during real UI implementation, browser proof, visual review, correction, and closure.

**Architecture:** Add one native control-plane gate that joins design-system application, UI mutation ownership, browser proof, visual defect disposition, and corrected-state closure. Keep concrete browser commands in runtime adapters, not core law. Wire the new gate into existing review, proof, and enforcement authorities without importing GLM/Z.ai runtime assumptions directly.

**Tech Stack:** Markdown doctrine and runtime adapter documentation inside the standalone `accelerate` repository.

---

## Executive Summary

Accelerate is already strong at extracting design systems, producing premium variants, and creating implementation contracts. The weak point is the transition from those artifacts into real UI mutation and visual proof. This plan hardens that transition by making design application a closure-blocking proof lane instead of a prose recommendation.

The GLM/Z.ai material should be used as pattern evidence, not copied. Preserve the useful behavior: browser automation recipes, screenshot review loops, viewport coverage, and fix-before-send discipline. Reject or adapt runtime-specific assumptions such as remote installer pipelines, sandbox-only Next.js rules, unrestricted cookie capture, and platform-bound package choices.

## File Map

- Create: `core/control-plane/design-implementation-proof-gate.md`
  - Owns the mandatory gate between design-system artifacts and UI closure.
- Modify: `core/control-plane/README.md`
  - Registers the new gate as native control-plane authority.
- Modify: `core/review/design-system-contract-application.md`
  - Routes implementation/proof through the new gate.
- Modify: `core/review/ui-polishing-observer.md`
  - Clarifies observer output feeds the new gate but does not own closure.
- Modify: `core/runtime-packets/qa-proof-stack.md`
  - Adds design implementation proof as a browser-proof specialization.
- Modify: `adapters/runtime/chrome-devtools/README.md`
  - Replaces placeholder with a concrete browser-truth recipe.
- Modify: `adapters/runtime/agent-browser/README.md`
  - Adds a bounded repeatable visual proof recipe and safety requirements.
- Modify: `core/risk/enforcement-surfaces.md`
  - Adds closure blockers for design application and corrected-state visual proof.
- Modify: `README.md`
  - Adds the new gate to the design-system/premium rollout path.
- Modify: `SKILL.md`
  - Adds the new gate to non-trivial/premium UI reference list.

## Chunk 1: Executive Plan And Native Gate

### Task 1: Persist This Plan

**Files:**
- Create: `docs/superpowers/plans/2026-04-24-design-implementation-proof-hardening.md`

- [x] **Step 1: Write the executive implementation plan**

Create this document with the goal, architecture, file map, tasks, validation, and non-goals.

- [x] **Step 2: Verify the plan path exists**

Run: `test -f docs/superpowers/plans/2026-04-24-design-implementation-proof-hardening.md`
Expected: exit code `0`.

### Task 2: Add Design Implementation Proof Gate

**Files:**
- Create: `core/control-plane/design-implementation-proof-gate.md`
- Modify: `core/control-plane/README.md`

- [x] **Step 1: Create the gate**

Add a concise doctrine file that defines activation, required inputs, mutation packet, viewport/state proof, defect loop, closure blockers, and allowed runtime lanes.

- [x] **Step 2: Register the gate in the control-plane README**

Add it to the native authority list.

## Chunk 2: Review And Proof Integration

### Task 3: Wire Design-System Application To The Gate

**Files:**
- Modify: `core/review/design-system-contract-application.md`
- Modify: `core/review/ui-polishing-observer.md`

- [x] **Step 1: Route implementation through the new gate**

Add explicit references that design-system application cannot close without the gate when UI is mutated.

- [x] **Step 2: Clarify observer lane relationship**

State that observer findings feed the gate and defect ledger but do not replace implementation proof or root closure.

### Task 4: Strengthen Proof Stack

**Files:**
- Modify: `core/runtime-packets/qa-proof-stack.md`
- Modify: `core/risk/enforcement-surfaces.md`

- [x] **Step 1: Add design implementation proof specialization**

Define it as a browser-proof sublane for design-system and premium UI implementation.

- [x] **Step 2: Add closure-blocking enforcement**

Add blockers for missing browser screenshots, missing viewport coverage, hidden residual drift, and skipped corrected-state proof.

## Chunk 3: Runtime Adapter Operationalization

### Task 5: Make Browser Truth Executable

**Files:**
- Modify: `adapters/runtime/chrome-devtools/README.md`
- Modify: `adapters/runtime/agent-browser/README.md`

- [x] **Step 1: Expand Chrome DevTools adapter**

Define a capability-first recipe for route load, console/errors, viewport sweep, interaction checks, screenshot capture, and proof packet output.

- [x] **Step 2: Add agent-browser bounded visual proof recipe**

Adapt the GLM/Z.ai command pattern as optional local runtime guidance while preserving session safety.

## Chunk 4: Root Wiring And Validation

### Task 6: Wire Root Docs

**Files:**
- Modify: `README.md`
- Modify: `SKILL.md`

- [x] **Step 1: Update root reading maps**

Add the new gate to the relevant design-system/premium UI references.

- [x] **Step 2: Keep root law compact**

Avoid expanding `SKILL.md` into implementation detail.

### Task 7: Validate The Slice

**Files:**
- All modified markdown files

- [x] **Step 1: Search for broken references**

Run: `rg "design-implementation-proof-gate|Design Implementation Proof" .`
Expected: references appear in the intended control-plane, review, proof, risk, and root docs.

- [x] **Step 2: Review git diff**

Run: `git diff -- docs/superpowers/plans core/control-plane core/review core/runtime-packets adapters/runtime core/risk README.md SKILL.md`
Expected: one coherent documentation/governance slice, no unrelated edits.

## Non-Goals

- Do not import GLM/Z.ai skills verbatim.
- Do not add a promoted `*.toml` agent.
- Do not make `agent-browser` mandatory for every UI change.
- Do not replace Chrome DevTools with Playwright or agent-browser.
- Do not add code-level browser tests in this slice.
- Do not change workflow adapter implementation.

## Acceptance Criteria

- A new native gate exists for design implementation proof.
- Design-system application explicitly routes through that gate for mutation-bearing UI work.
- Browser proof has executable runtime-adapter guidance.
- Visual defects discovered in proof require correction and corrected-state proof before closure.
- The root docs point future sessions at the new gate without bloating `SKILL.md`.
