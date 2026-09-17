# CODEX-26 Prompt D — Authority and Status Reconciliation

## Provider truth

- `CODEX-25` is complete in Plane; `completed_at` is
  `2026-09-02T12:09:07.470945Z`.
- `CODEX-26` is `In Progress`; `completed_at` is null.
- Proposal v0.7.25 is the accepted/reaffirmed Phase-0 candidate. Historical
  CODEX-25 description text that names v0.7.23 is predecessor context, not the
  current accepted-byte binding.

## Authority matrix

| Surface | Authority class | Current state | May govern repository tests? |
| --- | --- | --- | --- |
| Repository source | `governing-authority` | current working source | yes |
| Prompt D and bounded receipts | `decision-artifact` | current through receipt expiry/revocation | only for TASK-014..027 |
| Plane CODEX-25/CODEX-26 | `backend-authority` | fresh provider read | lifecycle facts only |
| Repo-generated export | `generated-export` | derived projection | proof target only |
| Disposable generated target | `generated-export` | temporary test target | proof target only |
| `~/.codex/skills` installed mirror | `forbidden-authority` | ambient projection with nine known missing references | no |
| Imported references | `supporting-reference` | explanatory | no |

## Status-header disposition

The accepted v0.7.25 proposal still contains presentation text saying that
Phase-0 acceptance is pending. Editing accepted bytes in place would invalidate
their digest. Prompt D therefore preserves the proposal and records the current
status here. A later bounded decision may create a status index or a formally
versioned successor proposal; this is not part of the proof-harness correction.

## Local workspace disposition

The repository-local `.accelerate/` workspace exists but its durable status is
`partial-reonboarding` and it has no materialized handoff summary. Its detailed
state correctly points at CODEX-26 and is usable as an index, but cannot replace
fresh Plane reads or the Prompt-D receipts. Prompt D does not broaden into a
local-workspace migration.

## Decision

`READY_FOR_INDEPENDENT_BOUNDARY_REVIEW`. Repository source governs. User-home
mirrors are excluded from correction authority and from canonical test input.
