# Napkin Runbook

## Curation Rules
- Re-prioritize on every read.
- Keep recurring, high-value notes only.
- Max 10 items per category.
- Each item includes date + "Do instead".

## Execution & Validation (Highest Priority)
1. **[2026-04-15] Preserve root laws before reorganizing structure**
   Do instead: verify that topology ownership, risk enforcement, closure mode, and agent optionality remain intact before accepting any refactor.
2. **[2026-04-15] Architecture docs govern implementation here**
   Do instead: consult `docs/architecture/` before starting extraction, migration, adapter, or onboarding slices.
3. **[2026-04-15] Prefer bounded architectural commits**
   Do instead: land one coherent migration or doctrine slice per commit instead of mixing import, refactor, and cleanup noise.

## Repository Structure
1. **[2026-04-15] `SKILL.md` stays at root**
   Do instead: treat the repository root as the home of the standalone `accelerate` skill and keep deeper folders for supporting doctrine only.
2. **[2026-04-15] `references/` remain authoritative until rehomed**
   Do instead: preserve inherited references as readable source material and move them under the target architecture only through deliberate slices.
3. **[2026-04-15] `docs/bootstrap/` is historical context, not dead weight**
   Do instead: keep bootstrap docs available for provenance while using `docs/architecture/` as the live forward path.

## Platform Direction
1. **[2026-04-15] Extract by layer, not by old tree shape**
   Do instead: classify changes as core, workflow adapter, runtime adapter, stack profile, agent factory, or overlay before moving files.
2. **[2026-04-15] Strong defaults are product value**
   Do instead: keep the opinionated default distribution while adding adapters and profiles, instead of flattening the platform into generic flexibility.
3. **[2026-04-15] Agent suggestion is not promotion**
   Do instead: keep the distinction between gap detection, recommendation, promotion, and runtime installation whenever agent work appears.

## User Directives
1. **[2026-04-15] The new repo is now the build surface**
   Do instead: continue platform architecture, onboarding, and adapter work here instead of back in the incubator repo.
2. **[2026-04-15] Temporary development-stage runbooks stay out of git**
   Do instead: keep stage-specific notes in `.claude/napkin.dev.md` or similar ignored files, and commit only durable runbook guidance to `.claude/napkin.md`.
