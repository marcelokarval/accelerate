# Runtime Adapters

## v1 ownership

These are optional technical resources, not automatic Accelerate workflow policy. The active entry classifier hands non-trivial work to ASDS, which selects planning, delegation, review, and completion procedures. References below to a root or coordinator mean that execution owner, not a second Accelerate controller. Legacy issue/workspace/closure recipes run only when selected by that owner and compatible with user and project instructions. Profiles provide stack knowledge and verification guidance; they do not activate ASDS or impose an independent task lifecycle.

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

The `default` Agent Profile receives an entry-routing prompt from the same
parity manifest. It classifies and hands non-trivial work to ASDS rather than
forcing native delegation. Child `write_mode` metadata is not a sandbox:
enforcement comes from the runtime's actual tools and permissions. ASDS decides
whether delegation is appropriate and can select these optional resources.

The canonical OpenHands chat parent is `default`: it alone receives the root
delegation prompt and `enable_sub_agents=true`. `orchestrator` remains a
non-root compatibility profile and cannot spawn. The root's ChatGPT
subscription binding is supported. Since this repository has no independently
proven non-subscription child binding, the specialist catalog is deliberately
`binding_unavailable`: no child definition is materialized. This is not native
enforcement: Agent Canvas can inject a child-conversation launcher outside the
Agent Profile. The contract is therefore prompt-only, and current-runtime
preflight intentionally returns `BLOCKED` until a session tool readback proves
a supported mechanical disable. The current semantic evidence is bound to the
installed `openhands-agent-server` 1.42.1 package and requires explicit version
readback; it is not inferred from the unrelated OpenHands SDK banner. `scripts/validate-openhands-native-task.py
--dry-run` is read-only and does not make provider calls or inspect credentials.
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
