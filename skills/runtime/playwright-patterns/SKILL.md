---
name: playwright-patterns
description: Use for persistent Playwright regression, Playwright or Chrome DevTools MCP versions and capabilities, agent-browser headless automation, SSH/CI execution, Missing X failures, XRDP fallback questions, browser revision preflight, screenshots, sanitized network evidence, selectors, fixtures, traces, retries, and flake triage.
---

# playwright-patterns

Use this skill when a flow is ready to be preserved as persistent Playwright
regression proof.

## Core Rules

1. Browser truth comes first. Playwright persists known behavior; it does not
   replace exploratory browser proof.
2. Every scenario must name its source browser-proof packet or mark the lane
   `out of order`.
3. Prefer user-facing locators and stable app-owned selectors over brittle DOM
   structure.
4. Auth state, fixtures, setup, and teardown must be explicit.
5. Failed or flaky tests need trace/screenshot/network evidence before closure.
6. On SSH or CI hosts, declare `headless: true` explicitly. XRDP/Xorg is an
   exceptional manual backend, never an automatic fallback for a failing test.

## Local Runtime Contract

Keep project Playwright Test separate from the global MCP runtime:

- Codex Playwright MCP: `@playwright/mcp` `0.0.79`, Playwright
  `1.63.0-alpha-2026-08-05`, Firefox `153.0` build `1539`.
- Hermes Playwright MCP: the same MCP/Playwright/Firefox versions in its
  owner-only browser runtime.
- Chrome DevTools MCP: `chrome-devtools-mcp` `1.7.0`, using system Chrome
  `151.0.7922.71` through a pinned owner-only headless launcher.
- Hermes agent browser: `agent-browser` `0.34.0`, with owner-only per-session
  receipts, short private sockets and a bounded 120-second idle policy.
- A repository's `@playwright/test` version remains repository-owned and must
  match its lockfile and materialized browser revision.

The global launchers provide interactive MCP tools such as navigation,
accessibility snapshots, screenshots, console/network inspection, forms and
tab management. They do not replace the repository test runner, its fixtures,
or its retry and artifact policy.

Do not use `npx ...@latest`, download a browser, or install Playwright during a
user workflow. A missing package, executable or browser revision is a failed
preflight. Correct materialization first, then repeat the proof in a fresh
process.

## Interactive Browser Capabilities

Use Chrome DevTools MCP for exploratory browser truth when the flow is not yet
stable. Its governed launcher is headless, disables telemetry, CrUX and update
checks, redacts network headers, isolates its profile, and rejects caller
arguments. Registration or `tools/list` alone is not proof: perform the actual
navigation, snapshot or screenshot call needed by the task.

Use `agent-browser` only through the governed wrapper. The supported surface is
intentionally narrow:

- navigation, snapshot and exact-session close;
- screenshot with an optional selector and safe display flags; caller paths are
  hints, while the real PNG is confined to a private session artifact;
- `network requests` list with bounded filters. Output removes header fields,
  URL userinfo and every query value recursively while retaining useful URL
  structure and parameter names.

Request detail/body, route mutation, HAR, clear, arbitrary executable/config/
endpoint/profile paths, sandbox weakening and TLS bypass are not supported.
Sessions longer than 64 characters fail preflight. Cleanup and residue claims
must use the session receipt and exact process identity; never use broad
`pkill`, a global-empty-directory assertion, or retry a socket failure until it
passes.

## Proof Checklist

- scenario class: smoke, regression, persistence, route-family, or project-owned
  extension
- source browser-proof packet
- exact Playwright Test and browser revision from the project lock/runtime
- explicit `headless: true` on SSH/CI
- exact command and project/package path
- fixture and auth-state setup
- selectors and assertions worth preserving
- screenshot/trace/network artifact when failures or runtime-sensitive flows are
  involved
- flake classification and rerun policy

## Failure Modes

- writing Playwright before understanding the flow in a browser
- asserting implementation details instead of user-visible behavior
- hiding auth/session setup in global state
- confusing MCP connection/tool inventory with a successful browser action
- treating an unsanitized URL, query value or network header as safe evidence
- assuming a caller-provided screenshot path is the actual private artifact
- working around `Missing X server` by silently starting a virtual desktop
- installing a floating package or browser inside the test action
- closing with "Playwright passed" and no proof packet
- rerunning flaky tests until green without classifying the failure
