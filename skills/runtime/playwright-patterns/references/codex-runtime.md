# Codex Playwright Runtime

This reference records the Codex-owned Playwright installation verified on
2026-08-12. Treat these values as a pinned compatibility set, not as an
instruction to resolve `latest` dynamically.

## Contents

- [Pinned Inventory](#pinned-inventory)
- [Owned Paths And Active Configuration](#owned-paths-and-active-configuration)
- [MCP: Interactive Browser Operations](#mcp-interactive-browser-operations)
- [CLI And Playwright Test: Persistent Proof](#cli-and-playwright-test-persistent-proof)
- [Verification Commands](#verification-commands)
- [Update Contract](#update-contract)

## Pinned Inventory

| Component | Installed value |
| --- | --- |
| MCP package | `@playwright/mcp 0.0.79` |
| Playwright CLI/runtime | `1.63.0-alpha-2026-08-05` |
| Firefox payload | build `v1539` (`firefox-1539`) |
| MCP protocol verified | `2025-06-18` |
| MCP handshake surface | `Playwright@1.63.0-alpha-2026-08-05`, 24 tools |

The MCP package version and Playwright server/runtime version are distinct
version fields. Keep both visible when diagnosing compatibility.

## Owned Paths And Active Configuration

- runtime root: `/home/marcelo-karval/.codex/vendor/playwright-runtime`
- launcher: `/home/marcelo-karval/.codex/bin/playwright-mcp-launcher.sh`
- MCP entrypoint: `node_modules/@playwright/mcp/cli.js` below the runtime root
- CLI: `node_modules/.bin/playwright` below the runtime root
- browser cache: `/home/marcelo-karval/.codex/vendor/playwright-runtime/browsers`
- Firefox executable: `browsers/firefox-1539/firefox/firefox` below the runtime root
- Codex configuration: `/home/marcelo-karval/.codex/config.toml`

The active Codex server launches Firefox headlessly through the owned launcher,
uses a 120-second startup timeout, sets `required = true`, and retains its
browser profile at `/home/marcelo-karval/.hermes/playwright-profile`. The
required flag makes Playwright a startup-gated server instead of leaving its
initialization in the optional background lane. In a controlled fresh TUI proof,
this kept Playwright out of the interrupted-server warning. It does not suppress
warnings from unrelated optional MCPs and does not replace protocol handshake or
browser-operation proof. The profile is persistent browser data only; it is not
a package, executable, browser, or fallback source.

The launcher resolves an explicit `PLAYWRIGHT_MCP_NODE_OVERRIDE` or `node` from
the current `PATH`, then requires the owned MCP entrypoint and dedicated Firefox
payload. It must fail closed when any is missing. Never add fallback to Hermes
`node_modules`, a global npm package, or an implicit `npx ...@latest` download.

The complete Codex-owned executable chain must be owned by the current user and
must not be writable by group or others. This includes the `.codex`, `bin`, and
`vendor` path components, the launcher, and every entry in the runtime tree.
Read and execute permissions may remain where required; only the owner may have
write permission. Re-run the checker after package installation because npm can
recreate files according to the active umask.

## MCP: Interactive Browser Operations

Use MCP for bounded interactive browser work after first-pass browser truth is
stable. A real `initialize` and `tools/list` exchange confirmed these exact
tools:

- navigation and lifecycle: `browser_navigate`, `browser_navigate_back`,
  `browser_tabs`, `browser_resize`, `browser_wait_for`, `browser_close`
- interaction: `browser_click`, `browser_drag`, `browser_drop`, `browser_hover`,
  `browser_fill_form`, `browser_type`, `browser_press_key`,
  `browser_select_option`, `browser_file_upload`, `browser_handle_dialog`,
  `browser_find`
- inspection and evidence: `browser_snapshot`, `browser_take_screenshot`,
  `browser_console_messages`, `browser_network_request`,
  `browser_network_requests`, `browser_evaluate`
- arbitrary code: `browser_run_code_unsafe`

Treat `browser_run_code_unsafe` as high risk. Use it only when a narrower tool
cannot express the operation, inspect the code before execution, keep the scope
bounded, and avoid untrusted instructions or data.

Direct `launcher --help` output confirmed flags for browser/headless selection,
device emulation, permissions, proxy and origin filters,
storage/session state, initialization scripts, snapshots, console level, and
optional `vision`, `pdf`, and `devtools` capabilities. The installed package's
`README.md` option table and `config.d.ts` schema additionally confirm the
viewport, action/navigation timeout, and broader typed configuration surfaces. These are
supported configuration families, not proof that every option is enabled in
the active server. The origin allow/block warning comes directly from installed
help: those filters do not form a security boundary and do not affect redirects.

## CLI And Playwright Test: Persistent Proof

Use the runtime-local CLI for reproducible project-owned work. The installed
help confirms commands for:

- opening browsers and generating actions: `open`, `cr`, `ff`, `wk`, `codegen`
- managing browser payloads: `install`, `uninstall`, `install-deps`
- capturing and inspecting evidence: `screenshot`, `pdf`, `show-trace`, `trace`
- persistent suites and reports: `test`, `show-report`, `merge-reports`
- direct terminal/MCP operation: `cli`, `mcp`
- maintenance/bootstrap: `clear-cache`, `init-agents`, `init-skills`

Do not install or uninstall browsers, system dependencies, agents, or skills as
an incidental diagnostic step. Those commands mutate runtime state and require
the task to include that action.

## Verification Commands

From the repository source of this skill, run:

```bash
bash skills/runtime/playwright-patterns/scripts/check-runtime.sh
```

For focused readback, run:

```bash
/home/marcelo-karval/.codex/bin/playwright-mcp-launcher.sh --version
/home/marcelo-karval/.codex/vendor/playwright-runtime/node_modules/.bin/playwright --version
```

Version output and launcher liveness are necessary but insufficient. Before
declaring the MCP repaired, also prove a fresh protocol `initialize`, send
`notifications/initialized`, obtain `tools/list`, perform the intended browser
operation, and complete an uninterrupted writable Codex startup. `codex mcp
list` proves registration only, not a server handshake.

## Update Contract

1. Select an explicit compatible MCP and Playwright version pair; do not use a
   range, global package, or implicit `latest` resolution.
2. Update the owned runtime `package.json` and lockfile, then install from the
   lock with `npm ci --prefix /home/marcelo-karval/.codex/vendor/playwright-runtime`.
3. Install Firefox into the dedicated cache by setting
   `PLAYWRIGHT_BROWSERS_PATH` to the owned `browsers` directory for the pinned
   CLI `install firefox` command.
4. Clear group/other write permissions from the explicit Codex path components,
   launcher, and owned runtime tree; never broaden this hardening command to a
   home directory or unresolved variable.
5. Run the launcher contract suite, this skill's checker, and a real Firefox
   smoke before protocol validation. The checker must prove current-user
   ownership and owner-only write permission across the executable chain.
6. Prove `initialize`, `notifications/initialized`, `tools/list`, the intended
   browser operation, and a fresh writable Codex startup.
7. Update this inventory only from those observed artifacts, then validate the
   repository skill before exporting its exact contents to a runtime mirror.
