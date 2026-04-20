# Runtime Adapters

Runtime adapters translate capability-level expectations into concrete commands
and tools.

Examples:

- Python via `uv`
- Node package/runtime commands
- Chrome DevTools for browser truth
- agent-browser-style CLI automation for bounded browser operations
- Playwright for persistent regression proof

The core should speak in capabilities first. Runtime-specific commands belong
here or in stack profiles, not in the permanent core law.

Native pre-agents reading order:

1. `adapter-contract.md`
2. `python-uv/README.md`
3. `node/README.md`
4. `chrome-devtools/README.md`
5. `agent-browser/README.md`
6. `playwright/README.md`
