# Playwright MCP Runtime Design

## Goal

Provide Codex with a durable Playwright MCP and CLI installation that survives
Hermes workspace dependency cleanup, while keeping the governed Playwright
skill explicit about versions, capabilities, paths, and verification.

## Architecture

- Install the pinned runtime below `${CODEX_HOME:-$HOME/.codex}/vendor/playwright-runtime`.
- Pin `@playwright/mcp` to `0.0.79` and its compatible Playwright CLI to
  `1.63.0-alpha-2026-08-05`.
- Install Firefox into the same Codex-owned runtime tree and persist
  `PLAYWRIGHT_BROWSERS_PATH` in the launcher for every MCP process.
- Launch the MCP through a Codex-owned preflight wrapper instead of a Hermes
  `node_modules/.bin` path.
- Mark Playwright as a required Codex MCP so startup waits for its terminal
  handshake instead of misreporting the optional runtime refresh as an
  interruption.
- Keep `skills/runtime/playwright-patterns/` as the repository source of truth,
  then export that skill to the global Codex mirror.

## Failure Handling

The launcher must resolve an explicit Node override or the current `PATH`,
forward every MCP argument unchanged, and fail with a specific message when
Node, the MCP entrypoint, or the Firefox browser payload is missing. It must not
fall back silently to a global package or a Hermes project installation.

## Proof

Completion requires exact-version output, a successful Firefox launch, an MCP
initialize and tools/list exchange, repository-to-runtime skill parity, and an
uninterrupted fresh Codex TUI bootstrap without a Playwright startup failure or
Playwright in the interrupted-server list. Warnings for other optional MCPs are
tracked separately and do not invalidate the scoped Playwright proof.
