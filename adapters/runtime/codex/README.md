# Codex Logical-Agent Runtime Contract

This directory describes two distinct Codex mechanisms:

- the default `codex` process is the sole root `orchestrator`;
- a specialist profile is a separate process launched through `codex -p <name>`;
- a collaboration spawn receives only the bounded assignment packet plus
  explicit model and reasoning effort.

The topology is source-owned in `logical-agent-topology.toml`. It defines one
root `orchestrator` and seven logical specialists: `python-backend`,
`nextjs-frontend`, `research`, `reviewer`, `qa`, `data-db`, and
`integrations-ops`.

Profiles are logical capability selection, never proof of process, filesystem,
tool, MCP, credential, or physical-agent isolation. Root retains issue
topology, external writes, integration, review-of-review, and closure.

## Install and prove

The repository-to-runtime deployment entrypoint is
`scripts/sync-skills-to-global.sh`. One transaction reconciles the governed
skill directories, only the managed `[skills].config` entries, the two public
recovery profiles, the root orchestrator defaults, and every logical specialist
profile. Raw catalog-group aliases are removed transactionally.
It preserves unrelated skill packages, unmanaged skill entries, MCP sections,
and other operator configuration. The transaction stages files on their target
filesystems and emits one rollback receipt at the direct child path
`<backup>/sync-receipt.json`; `scripts/rollback-global-skill-sync.sh` restores
both package and runtime-config lanes.

`scripts/install-codex-skill-catalog.py` owns managed skill overrides and the
public `on-demand` / `superpowers-on-demand` recovery profiles.
`scripts/install-codex-logical-agents.py` then owns the root
`model` / `model_reasoning_effort` and logical profiles. Profile entries are
specialist overlays, not standalone skill discovery. Use
`scripts/codex-logical-agent.sh`. Use `orchestrator` as an alias for bare
`codex`, never as `-p orchestrator`. The launcher verifies both that global base
and the installed specialist profile against the source render before invoking
Codex, so an unknown or ineffective profile cannot silently run as the base
configuration. `scripts/check-global-skill-mirror.sh` verifies all three
surfaces recursively. A passing mirror check is static installed-state proof;
it does not claim fresh-process discovery or startup proof before restart.

The default skill budget is exact: eight repo-governed orchestration skills
plus five Codex system skills. Specialist capability is additive through named
profiles. The 14 host Superpowers skills remain cataloged and recoverable
through `superpowers-on-demand`; they are disabled by default because their
duplicate workflow surface exceeds the effective description budget when
combined with the quality profiles.

Use `tests/codex-logical-agent-topology.sh` and
`tests/codex-logical-agent-install.sh` for source and installation proof.
`tests/codex-logical-agent-runtime-proof.sh` additionally renders a disposable
installation, verifies the real installed mirror, compares the exact effective
inventory for all eight contexts, and executes an ephemeral read-only turn in
each context. The opt-in test fails on any startup item error, including skill
description shortening. It reads the installed Codex home but does not mutate
it.

The current Codex CLI exposes model and reasoning effort in the rendered TOML,
but has no supported effective-config inspector for those values. They are
therefore statically validated by the topology and render gates, not claimed as
runtime-observable proof.
