# Runtime Adapters

Runtime adapters translate capability-level expectations into concrete commands
and tools.

Examples:

- Python via `uv`
- Node package/runtime commands
- Chrome DevTools for browser truth
- agent-browser-style CLI automation for bounded browser operations
- Playwright for persistent regression proof
- web content reader for bounded external source observation
- locale-pack parity checks for i18n proof
- Node runtime proof for Next.js, AdonisJS, Prisma, Drizzle, Vercel, and hosted
  Postgres slices

The core should speak in capabilities first. Runtime-specific commands belong
here or in stack profiles, not in the permanent core law.

Native pre-agents reading order:

1. `adapter-contract.md`
2. `python-uv/README.md`
3. `node/README.md`
4. `chrome-devtools/README.md`
5. `agent-browser/README.md`
6. `playwright/README.md`
7. `web-content-reader/README.md`
8. `locale-pack-parity/README.md`
9. `proof-fixtures/README.md`

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
