# Accelerate Global Runtime Bundle

This directory is the repo-governed portable source for the globally installed
`accelerate` skill bundle at:

- `~/.codex/skills/accelerate/`

It exists because the standalone product repository also has a root `SKILL.md`
for repository-local bootstrap, and that root file is not a drop-in portable
replacement for the globally installed skill.

## Authority Split

- repository root `SKILL.md`
  - authorizes bootstrap inside the standalone `accelerate` repository itself
- `global-runtime/accelerate/SKILL.md`
  - authorizes the portable global runtime bundle
- `references/`
  - portable bundled doctrine copied into the runtime mirror

## Sync Rule

Do not hand-edit `~/.codex/skills/accelerate/` as the primary source.

Update this repo-owned bundle and synchronize it with:

```bash
bash scripts/sync-skills-to-global.sh
```

Then verify:

```bash
bash scripts/check-global-skill-mirror.sh
git diff --check
```

When local workspace state is active, this portable bundle should expose:

- readiness dashboard status
- continuity timeline status
- learning disposition
- local review / closure action

And when the target repo already has `.accelerate/` local status, it should
prefer the canonical composed local commands for handoff preparation:

- `prepare-review.sh`
- `prepare-closure.sh`

Those commands are expected to leave the local workspace with a complete
handoff surface, including:

- review / closure artifacts
- pre-review / closure bundles
- persisted branch entry packet
- persisted runtime delta packet
- persisted handoff summary

For fast reentry, the preferred compact read is:

- `review/handoff-summary.md`

Then, only when needed, expand into the individual packets and bundles.
