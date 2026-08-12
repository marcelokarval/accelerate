# Codex Logical-Agent Runtime Contract

This directory describes two distinct Codex mechanisms:

- a profile is a separate process launched through `codex -p <name>`;
- a collaboration spawn receives only the bounded assignment packet plus
  explicit model and reasoning effort.

The topology is source-owned in `logical-agent-topology.toml`. It defines one
root `orchestrator` and five logical specialists: `python-backend`,
`nextjs-frontend`, `research`, `reviewer`, and `qa`.

Profiles are logical capability selection, never proof of process, filesystem,
tool, MCP, credential, or physical-agent isolation. Root retains issue
topology, external writes, integration, review-of-review, and closure.

## Install and prove

First install the rendered global catalog base in `config.toml`; profile entries
are overlays, not standalone skill discovery. Then generate/install through
`scripts/install-codex-logical-agents.py` and use
`scripts/codex-logical-agent.sh`. The launcher verifies both that global base
and the installed profile against the source render before invoking Codex, so
an unknown or ineffective profile cannot silently run as the base configuration.

Use `tests/codex-logical-agent-topology.sh` and
`tests/codex-logical-agent-install.sh` for source and installation proof.
`tests/codex-logical-agent-runtime-proof.sh` additionally proves the exact
visible skills for all six profiles in a disposable Codex home.

The current Codex CLI exposes model and reasoning effort in the rendered TOML,
but has no supported effective-config inspector for those values. They are
therefore statically validated by the topology and render gates, not claimed as
runtime-observable proof.
