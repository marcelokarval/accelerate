# Agent Templates

This directory contains governed template-only contracts for bounded specialist
capabilities.

They are not installed runtime agents yet. They are promotion targets that make
the expected shape explicit before any host-specific `*.toml`, YAML, or native
agent registration is generated.

## Current Templates

- `base-agent.md`
- `architecture-reviewer.md`
- `qa-regression-reviewer.md`
- `security-reviewer.md`
- `backend-worker.md`
- `frontend-worker.md`
- `governance-auditor.md`
- `specification-engineer.md`
- `code-reviewer.md`
- `test-engineer.md`
- `web-performance-auditor.md`

## Rules

Every template must:

- extend `../base-agent-contract.md`
- declare exactly one selected role family
- declare required skills / profiles
- declare prohibited authority
- declare return contract
- declare cleanup behavior
- avoid claiming final closure or `Done`

Templates become live only through a runtime adapter and promotion process.
Configuration is not isolation: a template or logical collaboration profile
does not prove per-agent tool, MCP, credential, process, or filesystem
isolation.

Before logical or physical promotion, run empirical replay against
representative work and prove both containment and material value. Until that
evidence is accepted, the new specialist contracts remain template-only and
on-demand.

Before any template moves beyond `template-only`, complete
`../../planning/promotion/template-promotion-readiness-packet.md` and satisfy
`../promotion/template-promotion-readiness.md`.
