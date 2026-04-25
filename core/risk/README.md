# Risk

This layer is the native home of the active risk-enforcement model, including
detectors, surfaces, owners, blockers, and release conditions.

Native authority now starts here:

- `risk-enforcement-matrix.md`
- `enforcement-surfaces.md`
- `external-skill-vetting-gate.md`
- `financial-provider-fixtures.md`
- `security-abuse-fixtures.md`

Security and anti-abuse review fixtures live in
`security-abuse-fixtures.md`. They define the local packet shape for
hostile-path and abuse-path evidence without binding core risk doctrine to a
specific runtime tool or command surface.

Root-facing risk gates that classify failures, ownership, and artifact
sufficiency live in `../control-plane/` so every branch can inherit them before
specialized risk doctrine applies.

Supporting inherited doctrine may still exist in:

- `references/codex-agents/risk-enforcement-model.md`
- `references/codex-agents/risk-enforcement-matrix.md`
