# Napkin Runbook

## Curation Rules
- Re-prioritize on every read.
- Keep recurring, high-value notes only.
- Max 10 items per category.
- Each item includes date + "Do instead".

## Execution & Validation (Highest Priority)
1. **[2026-04-24] Accelerate must stay self-contained**
   Do instead: import/adapt/register/enforce useful external skills or corpora inside repo `skills/` before treating them as governed behavior; user-home catalogs are optional exports only.
2. **[2026-05-02] Non-trivial runs need outcome-first preambles**
   Do instead: declare goal, observable success criteria, constraints, expected output, and stop rules before branch-specific process detail; `done` must trace back to those criteria.
3. **[2026-05-02] Reasoning effort is not task size or agent count**
   Do instead: choose the lowest safe effort from success criteria, risk, and evidence needs; re-evaluate `low`/`medium` before escalating and trace future agent selection back to the effort rationale.
4. **[2026-04-24] Design-system packages need canonical theme CSS**
   Do instead: require `design-system.theme.css` / `design-system.premium-theme.css` with stable `--ds-*` tokens and run `onboarding/local-workspace/check-design-system-artifact-consistency.sh` before using the package as implementation law.
5. **[2026-04-24] Premium/de-AI design needs benchmark consequences**
   Do instead: use `skills/design-system/premium-design-benchmark-corpus/`, require a Benchmark Influence Map, and reject benchmark names that do not change tokens/components/states/layout/forbidden patterns.
6. **[2026-04-24] Design-system artifacts need runtime proof before UI closure**
   Do instead: route mutation-bearing design-system or premium UI work through `core/control-plane/design-implementation-proof-gate.md` and require artifact comparison plus corrected-state browser evidence.
7. **[2026-04-15] Preserve root laws before reorganizing structure**
   Do instead: verify that topology ownership, risk enforcement, closure mode, and agent optionality remain intact before accepting any refactor.
8. **[2026-04-15] Architecture docs govern implementation here**
   Do instead: consult `docs/architecture/` before starting extraction, migration, adapter, or onboarding slices.
9. **[2026-04-15] Prefer bounded architectural commits**
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
3. **[2026-04-16] New local workspace slices must beat the legacy before replacing it**
   Do instead: only treat `.accelerate/` as ready to replace the legacy local model when it is superior or equal in operational value, desconsiderando agents because the legacy still works there today.
