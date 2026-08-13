# OMO-Slim Agent Provenance RED Receipt

- Proof status: `observed-red`
- Governing issue: `CODEX-5`
- Observed at: `2026-08-13T22:47:00Z`
- Command: `bash tests/codex-logical-agent-topology.sh`
- Exit: `1`
- First failing stable case: `CASE-OMO-001`
- Diagnostic: `KeyError: 'omo_slim_primary_role'`

The existing topology validator passed its pre-existing contract, then the new
semantic mapping case failed because no logical agent carried OMO-Slim
provenance. This is the intended missing behavior, not a harness or syntax
failure.

Covered requirements pending GREEN: `REQ-OMO-001`, `REQ-OMO-002`,
`REQ-OMO-003`, `REQ-OMO-004`, and `REQ-OMO-005`.

## Generation 2 Review RED

Independent generation-1 review found three contract gaps: duplicate donor
roles were accepted, the two human views were not compared exactly, and
`qa → observer` overstated OMO-Slim's visual/media-only observer influence.
After strengthening the test first, `bash tests/codex-logical-agent-topology.sh`
exited `1` at `CASE-OMO-001` because the topology still declared
`qa` as `adapted-composite`. That is the honest generation-2 RED before the
correction.
