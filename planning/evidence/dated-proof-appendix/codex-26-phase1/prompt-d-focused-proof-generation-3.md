# CODEX-26 Prompt D — Focused Proof Generation 3

## Change mode

- kind: bug correction plus harness refactor
- correction generation: `3`
- proof generation: `3`
- pre-change RED: empty-HOME runtime-sync fixture exited `1` while attempting
  to copy ambient `$HOME/.codex/skills/accelerate`

## Root-observed Green

| Check | Result |
| --- | --- |
| empty explicit roots | expected fail-closed exit `2` before target scan |
| `tests/runtime-sync-codex-collaboration.sh` under empty HOME | PASS |
| `tests/global-skill-mirror-stage.sh` under empty HOME | PASS |
| `tests/runtime-sync-direct-fast-path.sh` under empty HOME | PASS |
| missing/different target negatives | PASS through test assertions |
| partial roots and no-opt-in negatives | PASS through test assertions |
| outside and contained symlink negatives | PASS through test assertions |
| literal `expected=211`/ambient mirror copy scan | no matches in affected fixtures |
| derived mirror denominator | `expected=220 verified=220` |
| `git diff --check` | PASS |
| C14 integrity | `23/23`, zero mismatch, aggregate unchanged |

## Boundary

No full-suite, real-OpenSpec, Plane, runtime, global mirror, proposal, or C14
mutation is represented by this focused proof.
