# OMO-Slim Agent Provenance GREEN Receipt

- Proof status: `observed-green`
- Governing issue: `CODEX-5`
- Correction generation: `2`
- Proof generation: `2`
- Runtime deployment receipt:
  `/home/marcelo-karval/.codex/backups/skill-sync-20260813T230825Z-1059973/sync-receipt.json`
- Runtime receipt SHA256:
  `d2370cd6d48783e7e0b4657cd33aeeae1369c3d579f8dd097e403b6987412d1e`
- Runtime receipt state: schema `4`, status `installed`, operations `130`

## Requirement and Case Evidence

| Requirement | Case | Observed result |
| --- | --- | --- |
| `REQ-OMO-001` | `CASE-OMO-001` | all eight logical agents match the approved primary, secondary, equivalence, and adaptation mapping |
| `REQ-OMO-002` | `CASE-OMO-002` | the ordered exact eight-role OMO-Slim denominator and adapted-influence boundary pass |
| `REQ-OMO-003` | `CASE-OMO-003` | missing, unknown, and duplicated donor roles fail closed in disposable fixtures |
| `REQ-OMO-004` | `CASE-OMO-004` | repo and global `AGENTS.md` rows match the approved machine mapping exactly |
| `REQ-OMO-005` | `CASE-OMO-005` | generated Codex profiles remain compatible and do not leak donor metadata into runtime authority |

## Fresh Proof

- `bash tests/codex-logical-agent-topology.sh`: PASS, including
  `CASE-OMO-001` through `CASE-OMO-005`.
- Affected contract suites: PASS for collaboration policy, spawn packets,
  logical install, routing hardening `7/7`, and catalog truth
  `inventory=131 enabled=13`.
- `PYTHONDONTWRITEBYTECODE=1 bash tests/all.sh`: PASS with final diagnostic
  `all tests passed`.
- `CODEX_RUNTIME_PROOF=1 bash tests/codex-logical-agent-runtime-proof.sh`:
  PASS in a fresh Codex process for root plus all seven specialists.
- `bash scripts/check-global-skill-mirror.sh`: PASS with static installed-state
  parity for root plus all seven specialists.
- `git diff --check`: PASS.
- cache scan: no `__pycache__` or `.pyc` artifact under `scripts/` or `skills/`.

## Authority Boundary

`adapters/runtime/codex/logical-agent-topology.toml` remains the machine
authority. The repository and global `AGENTS.md` files are human-readable
views. OMO-Slim is recorded as adapted design provenance only; it is not a
runtime, closure, isolation, model, tool, skill, or MCP authority.

The global `AGENTS.md` view was updated directly after the governed runtime
sync because it is an operational bootstrap document, not one of the generated
logical profile targets in the schema-4 receipt.

## Review Provenance

The first requested independent spawn did not start because the host failed to
initialize its required Playwright MCP. That failure did not weaken the tests
or alter the workspace. The already initialized, bounded read-only
`codex3-generation2-contract-review` lane reviewed generation 1, found three
gaps, then independently re-reviewed generation 2 and returned `ACCEPTED` with
zero P0-P3 findings.
