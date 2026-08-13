# OMO-Slim Agent Provenance Test Design

## Contract

- ID: `TEST-DESIGN-OMO-SLIM-AGENT-PROVENANCE-001`
- Status: `accepted`
- Owner: `codex5-test-author`
- Independent reviewer: `codex3-generation2-contract-review`
- Accepted by: `accelerate-root`
- Governing SDD:
  `../architecture/2026-08-13-omo-slim-agent-provenance-sdd.md`
- TDD mode: `semantic-contract`

## Dimensions

| Dimension | Scenario | Oracle |
| --- | --- | --- |
| happy | all eight agents carry the exact approved mapping | validator and focused test pass |
| negative | a mapping field is absent or a donor role is unknown | validator exits nonzero |
| boundary | only current OMO-Slim built-ins appear | exact role-set comparison passes |
| ownership | donor provenance cannot change local authority | existing model/write/closure assertions remain unchanged |
| compatibility | generated profiles ignore provenance metadata safely | renderer and installer tests pass |
| rollout | topology digest changes | governed sync receipt, mirror, and fresh runtime pass |
| observability | human and machine views agree | `AGENTS.md` table is checked against the TOML mapping |

The first requested independent spawn could not initialize its required
Playwright MCP. The already initialized, read-only
`codex3-generation2-contract-review` lane then independently reviewed both
generations and accepted generation 2 with zero P0-P3 findings.
