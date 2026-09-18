# Playwright MCP Runtime AI Review

## Verdict

Approved for scoped deployment. The Codex-owned Playwright MCP, CLI, Firefox
payload, launcher, configuration, and governed skill satisfy the implementation
plan and security gates.

## Review Lanes

- Runtime specification: approved after adding a real vendored-Firefox smoke.
- Configuration specification: approved; the initial delta was limited to the
  Playwright command and timeout, and the final gated delta added only
  `required = true`.
- Runtime security: approved after removing group/other write permission from
  the executable chain and adding a regression assertion.
- Skill specification: approved for progressive disclosure, exact versions,
  paths, capabilities, and MCP-versus-CLI guidance.
- Skill quality: approved after making filesystem traversal fail closed and
  assigning viewport/timeouts to the installed README/schema rather than the
  truncated help output.

## Decisive Evidence

- `@playwright/mcp 0.0.79`
- Playwright CLI/runtime `1.63.0-alpha-2026-08-05`
- Firefox build `v1539`
- MCP `initialize` and `tools/list`: passed with 24 tools
- Browser calls: `browser_navigate`, `browser_snapshot`, and `browser_close`
  passed against `about:blank`
- Launcher negatives: missing Node, entrypoint, and browser fail before startup
- Security negatives: inaccessible tree, dangling/external symlink, and
  cross-filesystem mount fail closed
- Fresh Codex TUI: no Playwright ENoENT or Playwright interrupted status; `/mcp`
  exposes all 24 tools
- Repository skill, active global mirror, and hidden-skill catalog entry were
  validated after promotion

## Residual State

Codex CLI `0.147.0` still reports interrupted startup for other optional MCP
servers while their cached or later tool catalogs may appear in `/mcp`. This is
not attributed to Playwright and was not changed by this scoped slice.
