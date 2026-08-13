---
name: playwright-patterns
description: Govern browser-truth-first Playwright work in Accelerate. Use when Codex needs to operate or diagnose the installed Playwright MCP, use the pinned Playwright CLI or Playwright Test for persistent regression, or preserve a stabilized browser flow with selectors, auth state, fixtures, traces, network evidence, and flake triage.
---

# Playwright Patterns

## Core Rule

Establish browser truth before automating an uncertain flow. Use Chrome DevTools
for first-pass runtime truth, Playwright MCP for controlled interactive browser
operations, and Playwright CLI/Test to preserve stable behavior as persistent
regression proof.

Do not treat configured registration, `--help`, `--version`, or an isolated
launcher check as a successful MCP handshake.

## Runtime Router

Read [references/codex-runtime.md](references/codex-runtime.md) whenever the work
touches installed versions, runtime paths, MCP capabilities, CLI commands,
startup diagnosis, or runtime upgrades. It records the pinned MCP, CLI, and
Firefox build plus the confirmed 24-tool handshake surface.

Run `scripts/check-runtime.sh` before relying on the installed runtime. The
checker validates exact package versions, launcher and CLI version output,
the dedicated Firefox payload, owner-only write permissions, and a headless
`about:blank` launch without printing environment values.

## Core Rules

1. Browser truth comes first. Playwright persists known behavior; it does not
   replace exploratory browser proof.
2. Every scenario must name its source browser-proof packet or mark the lane
   `out of order`.
3. Prefer user-facing locators and stable app-owned selectors over brittle DOM
   structure.
4. Auth state, fixtures, setup, and teardown must be explicit.
5. Failed or flaky tests need trace/screenshot/network evidence before closure.
6. Treat `browser_run_code_unsafe` as a deliberate high-risk capability. Scope
   and review its code before execution; never use it as a routine shortcut.
7. Keep the Codex-owned launcher and browser cache independent from Hermes
   packages and global npm fallback.
8. Keep the complete Codex-owned executable chain owned by the current user
   and clear group/other write permissions after every install or update.

## Lane Selection

- Use MCP for bounded interactive navigation, inspection, interaction, and
  evidence collection through the configured Codex server.
- Use CLI/Test for checked-in tests, code generation, traces, reports, and
  reproducible project-owned regression suites.
- Return to Chrome DevTools when runtime truth is unresolved; do not stabilize
  a test around behavior that has not been understood.

## Proof Checklist

- scenario class: smoke, regression, persistence, route-family, or project-owned
  extension
- source browser-proof packet
- lane selected: MCP interactive or CLI/Test persistent
- exact command and project/package path
- fixture and auth-state setup
- selectors and assertions worth preserving
- screenshot/trace/network artifact when failures or runtime-sensitive flows are
  involved
- flake classification and rerun policy
- MCP work: successful `initialize` plus `tools/list`, followed by the intended
  browser operation
- runtime change: exact-version checker, Firefox smoke, fresh handshake, and
  fresh writable Codex startup proof

## Failure Modes

- writing Playwright before understanding the flow in a browser
- asserting implementation details instead of user-visible behavior
- hiding auth/session setup in global state
- closing with "Playwright passed" and no proof packet
- rerunning flaky tests until green without classifying the failure
- claiming MCP health from `codex mcp list`, help text, or version output alone
- pointing the launcher back to a project-local `node_modules` tree
