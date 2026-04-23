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
