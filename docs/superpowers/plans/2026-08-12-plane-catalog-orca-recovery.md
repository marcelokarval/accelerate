# Plane, Catalog, and Orca Recovery Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development when subagents are available. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Prevent incomplete Plane issue creation, make Accelerate consult a measured runtime skill catalog, and remove the non-enforcing Orca hook from the Codex runtime.

**Architecture:** Add a pre-creation readiness contract to the governed Plane MCP and bind its digest to the exact mutation receipt. Add an Accelerate catalog-truth gate and a generated, source-owned runtime catalog manifest. Replace the active Orca hook configuration with no hook until a fail-closed hook protocol is implemented and proven.

**Tech Stack:** Python 3.12, FastMCP, TOML/JSON, Bash contract tests, Codex CLI prompt-input proof.

---

### Task 1: Plane pre-creation readiness gate

**Files:**

- Create: `src/plane_mcp_karval/issue_creation_readiness.py`
- Modify: `src/plane_mcp_karval/server.py`
- Modify: `tests/test_plane_mcp_karval.py`

- [ ] Write a failing test proving `issue__add_issue` rejects no readiness document and makes no provider call.
- [ ] Write a failing test proving an incomplete readiness document is rejected with named fields.
- [ ] Write a failing test proving a valid document and matching digest reaches exactly one provider mutation.
- [ ] Implement the minimal validator and server boundary; never forward readiness metadata to Plane.
- [ ] Run the focused test file and inspect both failure and green output.

### Task 2: Accelerate catalog truth gate

**Files:**

- Create: `adapters/runtime/codex/skill-catalog-manifest.toml`
- Create: `references/skill-catalog-truth-gate.md`
- Modify: `global-runtime/accelerate/SKILL.md`
- Modify: `scripts/check-global-skill-mirror.sh`
- Create: `tests/codex-skill-catalog-truth.sh`

- [ ] Write a failing shell test for a manifest with duplicate paths, uncovered disabled skills, and stale catalog count.
- [ ] Add the minimal source-owned manifest and deterministic validator.
- [ ] Route the runtime root through the catalog truth gate before specialist selection or global thinning.
- [ ] Verify exported Accelerate includes the reference and the validator passes without consulting user-home files as authority.

### Task 3: Remove the passive Orca hook

**Files:**

- Create: `adapters/runtime/codex/codex-hooks.json`
- Create: `tests/codex-hook-contract.sh`
- Modify: active `~/.codex/hooks.json` only after the test proves no Orca executable is referenced.

- [ ] Write a failing test that rejects `~/.orca`, unconditional success, and discarded hook results in a generated Codex hook file.
- [ ] Generate an explicit empty hook configuration; it makes no claim of enforcement.
- [ ] Back up the active hook file, install the generated file, and validate JSON plus absence of Orca references.

### Task 4: Runtime proof and blind rehydration

**Files:**

- Create: `planning/evidence/dated-proof-appendix/codex-plane-catalog-orca-recovery-2026-08-12.md`

- [ ] Run Plane MCP focused tests and the Accelerate catalog/hook tests.
- [ ] Restart only the governed Plane MCP runtime after source validation; verify its changed input schema.
- [ ] Start a fresh subagent with no prior conversation, give only the requested outcome and `CODEX-1` URL, and require it to use Accelerate and Plane.
- [ ] Reconcile every Plane write by independent GET, then have an independent reviewer compare the resulting issue against the creation/lifecycle contracts.

## 2026-08-12 reconciliation

The Plane MCP source was found to be an untracked editable runtime, so its
hardening is deliberately owned by the clean Hermes worktree and commit
`c0c4b97` rather than this Accelerate catalog worktree. Its immediate public
boundary containment is complete there; semantic manifest operations and
runtime promotion remain a separate follow-up.

The CODEX-1 catalog root is live and empirically proven with fresh prompt
inputs: root has 37 visible skills, `django-backend` has 48 including
`python-pro` and excluding `nextjs-app-router-patterns`, and
`next-react-frontend` has 54 with the inverse exclusion. These are runtime
observations, not cache-directory inference.
