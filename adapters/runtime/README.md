# Runtime Adapters

Runtime adapters translate capability-level expectations into concrete commands
and tools.

Examples:

- Python via `uv`
- Node package/runtime commands
- Chrome DevTools for browser truth
- generic browser proof helpers for local screenshot/console/network capture
- agent-browser-style CLI automation for bounded browser operations
- physical agent runtime delegation when a real agent runtime exists
- Codex collaboration for explicitly model-bound, bounded subagents
- OpenHands native subagents generated from
  `model-lanes/cross-runtime-agent-parity.toml` into the canonical user registry
  `~/.agents/agents`; Agent Profiles remain launch configurations, while these
  Markdown definitions are the spawnable `AgentDefinition` layer

The `default` and `orchestrator` Agent Profiles also receive a governed routing
prompt from the same parity manifest. It asks the parent to delegate independent
bounded slices and retain integration/closure. This is behavioral routing, not
a deterministic classifier. Child `write_mode` metadata is likewise not a
sandbox: enforcement comes from tool scope, confirmation policy, task-tool
omission, iteration/budget limits, and explicit parent/child contracts.
- Playwright for persistent regression proof
- web content reader for bounded external source observation
- locale-pack parity checks for i18n proof
- Node runtime proof for Next.js, AdonisJS, Prisma, Drizzle, Vercel, and hosted
  Postgres slices
- Tailwind theme-token mapping for CSS-variable-driven visual systems

The core should speak in capabilities first. Runtime-specific commands belong
here or in stack profiles, not in the permanent core law.

Native pre-agents reading order:

1. `adapter-contract.md`
2. `python-uv/README.md`
3. `node/README.md`
4. `chrome-devtools/README.md`
5. `agent-browser/README.md`
6. `physical-agent/README.md`
7. `codex-collaboration/README.md`
8. `playwright/README.md`
9. `web-content-reader/README.md`
10. `locale-pack-parity/README.md`
11. `proof-fixtures/README.md`
12. `tailwind/theme-token-mapping.md`
13. `host-export-contract.md`

## Current Runtime Expansion

The Node and Playwright adapters now support the current Next.js fullstack
profile family:

- `profiles/nextjs-prisma/`
- `profiles/nextjs-drizzle/`
- `profiles/nextjs-adonis-adminjs/`

Runtime adapters translate profile expectations into proof classes. They should
not make profile-selection decisions themselves.

The Playwright adapter remains persistent-regression authority, not first-pass
browser truth. Browser/runtime understanding should come before persisted E2E
unless the flow is already stable and explicitly known.
