# Agent Templates

This directory contains governed template contracts for future physical agents.

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
