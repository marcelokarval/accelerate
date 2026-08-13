# Playwright MCP Runtime Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the broken Hermes-local Playwright MCP path with a pinned Codex-owned runtime and document its exact usage contract.

**Architecture:** A version-pinned npm prefix owns the MCP package, compatible Playwright CLI, and Firefox payload. A small launcher performs deterministic preflight and the governed `playwright-patterns` skill records capabilities and verification commands before being mirrored globally.

**Tech Stack:** Node.js, npm, `@playwright/mcp`, Playwright CLI, Bash, Codex MCP configuration, Agent Skills.

---

## Chunk 1: Runtime and configuration

### Task 1: Install the pinned runtime

**Files:**
- Create: `/home/marcelo-karval/.codex/vendor/playwright-runtime/package.json`
- Generate: `/home/marcelo-karval/.codex/vendor/playwright-runtime/package-lock.json`
- Create: `/home/marcelo-karval/.codex/bin/playwright-mcp-launcher.sh`

- [x] Create a private package manifest with exact dependencies
  `@playwright/mcp: 0.0.79` and
  `playwright: 1.63.0-alpha-2026-08-05`.
- [x] Generate `package-lock.json`, then install from it with
  `npm ci --prefix /home/marcelo-karval/.codex/vendor/playwright-runtime`.
- [x] Assert `npm ls --json` resolves both exact root dependency versions.
- [x] Install Firefox with
  `PLAYWRIGHT_BROWSERS_PATH=/home/marcelo-karval/.codex/vendor/playwright-runtime/browsers`
  and the pinned runtime's `playwright install firefox` command.
- [x] Implement the launcher with `exec "$node" "$entrypoint" "$@"`, the
  same runtime-local `PLAYWRIGHT_BROWSERS_PATH`, explicit preflight messages,
  and executable mode.
- [x] Negative-test missing Node, MCP entrypoint, and Firefox payload through
  isolated launcher overrides; each must fail before starting MCP.
- [x] Verify MCP/CLI versions and launch Firefox headlessly against `about:blank`.

### Task 2: Point Codex at the durable launcher

**Files:**
- Modify: `/home/marcelo-karval/.codex/config.toml`

- [x] Preserve a timestamped backup of the current config and confirm it parses.
- [x] Atomically change only `[mcp_servers.playwright]` to
  `command = "/home/marcelo-karval/.codex/bin/playwright-mcp-launcher.sh"`,
  retain the Firefox/headless/profile args, and set
  `startup_timeout_sec = 120.0` plus `required = true` so Codex waits for the
  Playwright handshake.
- [x] Parse the resulting TOML, read back the exact command/args/timeout, confirm
  the old Hermes path is absent, and verify the backup can still be parsed.

## Chunk 2: Skill contract and proof

### Task 3: Document runtime versions and capabilities

**Files:**
- Modify: `skills/runtime/playwright-patterns/SKILL.md`
- Create: `skills/runtime/playwright-patterns/references/codex-runtime.md`
- Create: `skills/runtime/playwright-patterns/scripts/check-runtime.sh`
- Export: `/home/marcelo-karval/.codex/skills/playwright-patterns/`

- [x] Extend the trigger contract to include MCP/CLI use and diagnosis.
- [x] Document pinned versions, owned paths, functional boundaries, and update rules.
- [x] Add a redaction-safe runtime checker.
- [x] Validate with the official `quick_validate.py`, the repo skill registry,
  the runtime checker, and recursive source-to-mirror parity.

### Task 4: Prove the repaired startup

**Files:**
- Inspect: `/home/marcelo-karval/.codex/config.toml`
- Inspect: `/home/marcelo-karval/.codex/vendor/playwright-runtime/`

- [x] Save redaction-safe receipts under `.tmp/playwright-mcp-runtime/`.
- [x] Complete MCP `initialize`, `notifications/initialized`, and `tools/list`
  within 20 seconds; pass when server info is
  `Playwright@1.63.0-alpha-2026-08-05`, launcher version is `0.0.79`, and the 24
  browser tools are returned.
- [x] Run a minimal Firefox `about:blank` navigation with a 30-second timeout;
  pass when launch, page creation, and close exit successfully.
- [x] Start a fresh writable Codex TUI, wait at least 20 seconds without sending
  `Esc` or `Ctrl-C`, and capture its startup transcript.
- [x] Pass the scoped TUI proof when the transcript contains neither the old
  Playwright `No such file or directory` failure nor Playwright in an
  interrupted/incomplete server list, and `/mcp` exposes its 24 tools. Record
  warnings for other optional MCPs separately instead of attributing them to
  Playwright.
- [x] Record an AI review and closure verdict without committing unrelated worktree changes.
