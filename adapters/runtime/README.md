# Runtime Adapters

Runtime adapters translate capability-level expectations into concrete commands
and tools.

Examples:

- Python via `uv`
- Node package/runtime commands
- Chrome DevTools for browser truth
- Playwright for persistent regression proof

The core should speak in capabilities first. Runtime-specific commands belong
here or in stack profiles, not in the permanent core law.

