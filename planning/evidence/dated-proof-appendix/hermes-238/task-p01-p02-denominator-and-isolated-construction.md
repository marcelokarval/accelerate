# HERMES-238 — TASK-P01/P02 Denominator and Isolated Construction Receipt

## Result

`PARTIAL_GO_ADVERSARIAL_REVIEW_REQUIRED`

The full Plane MCP import is reproducible as a 29-file, runnable isolated
candidate without changing the shared Hermes index or worktree. It is not yet
eligible for source-promotion review because the complete suite has one
externally dependent parity failure (`P02-01`) that must be adversarially
classified and then corrected or explicitly excluded by contract.

## Source and preservation receipt

- Source repository: `~/.hermes` at `HEAD`
  `5273a7250dc1166381f306f43245817ac80251e6`.
- `HEAD` contains no Plane MCP application tree.
- Source target status and hashes were equal before and after construction.
- The isolated candidate lived only under
  `/tmp/hermes238-plane-mcp.mjZybn`; it is disposable and did not modify the
  shared index, worktree, runtime, Plane provider or external catalog.

## Frozen denominator

| Disposition | Count | Paths / role |
| --- | ---: | --- |
| staged initial import | 15 | hygiene, package, Plane API, MCP runtime and lock surfaces |
| staged import plus unstaged delta | 6 | README, package manifest, Plane client/work-item/server and MCP test |
| untracked candidate | 8 | lifecycle contract, tests and contract/evidence documentation |
| excluded generated content | n/a | `.venv`, `dist`, caches and proof lock only |

The 29 paths and hashes are frozen by the executor return packet. Their
functional closure is:

```text
CLI -> server
server -> plane_api + lifecycle + issue + title + work-item contracts
plane_api -> client -> registry + manifest
manifest/registry -> operation_registry.json + source_contract.json
wheel -> pyproject force-included package resources
focused tests -> the complete runtime closure above
parity test -> docs parity map -> external runtime catalog path
```

The sparse lifecycle surfaces retain the prior candidate hashes:

- lifecycle contract:
  `2d081fc65d8de1b67cc510284db84e03b79436a390ba47a9d3e2afb9c10190ec`;
- server:
  `1341d58a9851d31df475703573df086f1881823c12551c6953da40e111e5323f`;
- sparse registry:
  `d8730e4f20432c3687ec3d439d314eebab63bb0f30df1375760e0bf9c53e6bc3`;
- lifecycle tests:
  `2566e51552d2765ba0174314c83fc9a7b5f3c271763fa66cb1a2a8043beeac3b`.

## Isolated proof

The executor copied only the explicit 29 paths via an archive snapshot and
compared source pre-copy, source post-copy and candidate SHA-256 values.

```text
uv sync --frozen --all-groups                 # pass
uv lock --check                               # pass
uv build --wheel                              # pass
installed-wheel import (outside source tree)  # pass
focused package/runtime tests                 # 133 passed, 1 third-party warning
full suite                                    # 1 failed, 137 passed
```

Wheel fingerprint:
`113aa0453a143caa04032a1e4a32d800872f3ca6b9e1bbfa08fdc4639f64d461`.

## P02-01 — external parity failure

`test_plane_skill_parity_v2_inventory_is_complete_and_fail_closed` fails
because its recorded OpenCode destination hash differs from a current external
runtime catalog path. The test dereferences that external path directly, so it
is non-hermetic and the failure does not by itself prove a package omission.
This is a real gating defect until the adversarial reviewer confirms the
denominator, source/runtime boundary and correct remediation.

## Next gate

TASK-P03 must independently try to find a missing candidate file, accidental
shared-state dependency, package omission, secret-bearing inclusion or an
invalid `P02-01` classification. No source promotion, commit, runtime action or
provider call is authorized by this receipt.
