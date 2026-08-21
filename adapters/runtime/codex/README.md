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

The portable delegation meanings are defined by
[`core/delegation/runtime-neutral-delegation.schema.json`](../../../core/delegation/runtime-neutral-delegation.schema.json)
and its [consumer registry](../runtime-consumer-registry.json). This Codex
entry is `legacy-reference` only: it does not load the semantic core, change
this contract, or claim runtime callability.

The root's Sol/medium binding is the recommended default; the session's
effective root remains the session choice. Specialist assignment packets carry
their explicit Terra/medium or Luna/low override with `fork_turns = none` by
default, or an explicit bounded integer from `1..5`. `fork_turns = all` is
prohibited whenever a model or reasoning override is present. The logical
research profile is the Luna/low leaf. Separately, the collaboration role
policy may bind prescribed mechanical work to Luna/medium without creating a
ninth OMO logical identity. A Terra-to-Luna nested request needs explicit root
authorization, exactly one Luna, prescribed mechanical scope, a global
delegation budget exactly three (Terra parent, Luna child, independent
reviewer), and disjoint scopes. These are assignment contracts, not technical
isolation claims.

`render-codex-spawn-packet.py` is fail-closed by default and emits `No nested
spawn`. To render the sole exception, a Terra/medium parent must supply
`--nested-luna-child` plus its parent task/reference/write scope, literal
`root-authorized-only` authorization, `required` Terra accountability, and a
global physical budget exactly `3` (Terra parent, Luna child, independent
reviewer). The rendered child-supplement authorization is delivered through the
named Terra parent; it is Luna/medium `mechanical-fixer` with `fork_turns =
none`, not a replacement identity for the `--agent` parent or an invocation or
technical isolation guarantee.

## Install and prove

First install the rendered global catalog base in `config.toml`; it is the
source-controlled skills input. `scripts/install-codex-logical-agents.py`
reconciles the root `model` and `model_reasoning_effort` from the topology while
preserving unrelated configuration. Profile entries are specialist overlays, not
standalone skill discovery. Then generate/install through
`scripts/install-codex-logical-agents.py` and use
`scripts/codex-logical-agent.sh`. Use `orchestrator` as an alias for bare
`codex`, never as `-p orchestrator`. The launcher verifies both that global base
and the installed specialist profile against the source render before invoking
Codex, so an unknown or ineffective profile cannot silently run as the base
configuration.

Use `tests/codex-logical-agent-topology.sh` and
`tests/codex-logical-agent-install.sh` for source and installation proof.
`tests/codex-logical-agent-runtime-proof.sh` additionally proves the exact
visible skills for all eight profiles in a disposable Codex home.

The current Codex CLI exposes model and reasoning effort in the rendered TOML,
but has no supported effective-config inspector for those values. They are
therefore statically validated by the topology and render gates, not claimed as
runtime-observable proof.
