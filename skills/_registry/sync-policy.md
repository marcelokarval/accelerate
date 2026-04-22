# Skill Sync Policy

Root `skills/` is the authoring source.

The global runtime mirror is:

- `~/.codex/skills/`

## Direction

Sync direction is one-way by default:

```text
accelerate/skills/ -> ~/.codex/skills/
```

Global runtime changes must be backported into this repository before they are
treated as governed Accelerate behavior.

## Mirror Rule

For each governed skill:

- local `skills/<category>/<name>/SKILL.md` is canonical
- global `~/.codex/skills/<name>/SKILL.md` is generated or synchronized
- divergence is a validation failure unless explicitly documented

## Transitional Location

`docs/codex-skill-seeds/` is a migration bridge only.

No new governed runtime skill should be authored there after root `skills/`
exists.

## Verification

After syncing, run:

```bash
bash scripts/validate-skill-registry.sh
bash scripts/check-global-skill-mirror.sh
```

Then run:

```bash
git diff --check
```

Use `check-global-skill-mirror.sh` in CI or pre-push contexts when the goal is
to fail on drift without mutating `~/.codex/skills/`.
