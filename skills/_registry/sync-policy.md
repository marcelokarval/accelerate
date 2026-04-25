# Skill Runtime Export Policy

Root `skills/` is the authoring source.

Accelerate is self-contained. Governed skills, references, corpora, gates, and
examples must live inside this repository before they can be treated as
Accelerate behavior.

User-home skill catalogs are not source of truth and are not required for this
repository to operate.

## Direction

Runtime export direction is one-way by default:

```text
accelerate/skills/ -> optional runtime export target
```

Runtime changes made outside this repository must be backported into
`accelerate/skills/` before they are treated as governed Accelerate behavior.

## Export Rule

For each governed skill:

- local `skills/<category>/<name>/SKILL.md` is canonical
- optional runtime exports are generated from the local canonical file
- export drift is a deployment concern, not a change in source authority
- missing runtime exports must not block local repository governance

## Transitional Location

`docs/codex-skill-seeds/` is a migration bridge only.

No new governed runtime skill should be authored there after root `skills/`
exists.

## Verification

Before optional runtime export, run:

```bash
bash scripts/validate-skill-registry.sh
```

After optional runtime export, run the runtime-export drift check only when the
target runtime is part of the current task:

```bash
bash scripts/check-global-skill-mirror.sh
git diff --check
```

Do not use runtime export drift checks as proof that Accelerate itself is
correct. Accelerate correctness is proved against this repository.
