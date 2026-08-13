# Quality Stack Global Runtime Sync Receipt

## Identity

- Governing issue: `CODEX-1`
- Deployment date: `2026-08-13`
- Source authority: repository
- Runtime target: `/home/marcelo-karval/.codex`
- Receipt schema: `3`
- Receipt status: `installed`
- Test allowlist: `false`

## Receipt And Recovery

- Backup:
  `/home/marcelo-karval/.codex/backups/skill-sync-20260813T112142Z-3821303`
- Machine receipt:
  `/home/marcelo-karval/.codex/backups/skill-sync-20260813T112142Z-3821303/sync-receipt.json`
- Changed governed packages: `108`
- Changed runtime files: `16`
- Backup complete: `true`
- Rollback command is the exact argv stored in the machine receipt; use the
  receipt rather than reconstructing a shell string.

The receipt fingerprints every pre-existing target. A rollback preflights the
complete required backup set and refuses missing or corrupted state before
moving the installed runtime.

This generation-five receipt supersedes the earlier pre-hygiene/intermediate
receipts and the original post-hygiene receipt
`skill-sync-20260813T054640Z-1522618` and
`skill-sync-20260813T060409Z-1798602`, including
`skill-sync-20260813T060925Z-1837455`. The earlier transaction was required
because the real parity checker correctly detected EOF normalizations in three
reviewed packages; their reviewed package snapshot was refreshed before this
sync. Generation five was required because post-restart startup exposed the
skills-description budget warning under the old `131/39` default selection.

## Readback

Command:

```bash
CODEX_HOME=/home/marcelo-karval/.codex bash scripts/check-global-skill-mirror.sh
```

Observed result:

```text
Global Codex runtime mirror is in sync. This is static installed-state proof only.
```

The readback validated:

- catalog `inventory=131`, `enabled=13`;
- base root configuration;
- `python-backend`, `nextjs-frontend`, `research`, `reviewer`, and `qa`
  logical profiles;
- recursive package parity;
- migration of the five governed legacy symlinks into regular deployed
  directories;
- presence of the six new quality/workflow packages;
- the new `superpowers-on-demand` recovery profile.

## Boundary

This file is deployment and static readback evidence. Fresh startup and bounded
spawn/return behavior are separately observed in
`quality-stack-post-restart-runtime-proof-2026-08-13.md`. `CODEX-1` remains open
through final independent review and provider lifecycle readback.

## Plane Progress Readback

- Lifecycle phase: `PROGRESS`
- Provider comment ID: `7d5b8b92-048d-4666-9f4a-193edf32ede9`
- External ID: `CODEX-1:progress:t10-global-deployment:20260813`
- Mutation applied: `true`
- Readback verified: `true`
- Work-item preservation readback: In Progress, high priority, one assignee,
  five labels, start date `2026-08-12`, no target date

This comment predates generation five. It records that the historical `125/37`
issue-body baseline was superseded by the then-validated `131/39` catalog and
leaves restart proof as an explicit residual. A new governed Plane lifecycle
update is required for the current `131/13` result; this historical comment does
not transition or close the issue.
