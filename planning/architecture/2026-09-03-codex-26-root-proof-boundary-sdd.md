# CODEX-26 Root Proof Boundary Correction — SDD-lite

## Status

- correction generation: `0`
- implementation status: `TASK-016 APPROVE_SOURCE_ONLY_BOUNDARY_FIX; ready for bounded implementation`
- governing prompt: `planning/evidence/dated-proof-appendix/codex-26-phase1/phase1-root-proof-boundary-prompt-d.md`
- Phase-1 candidate: `C14`, immutable and outside this change denominator

## Problem

Canonical repository tests currently seed disposable runtime-mirror fixtures by
copying the ambient installed `~/.codex/skills` projection. Their result
therefore varies by host state, even though the repository declares itself the
only governing source. Three fixtures also duplicate a literal
`expected=211 verified=211` assertion that becomes stale when repository-owned
references change.

## Invariants

1. Repository source is the only governing input.
2. Canonical tests must pass with an empty, isolated `HOME`.
3. Runtime-mirror fixtures are disposable generated projections.
4. The existing three-path transactional repair remains separately testable,
   but it is not a general projection generator.
5. Missing and different target files must still fail closed.
6. Expected and verified counts come from the checker/source denominator, not a
   second hard-coded number.
7. Real installed-projection audit is explicit and never part of
   `tests/all.sh`.
8. No C14 file or user-home catalog may be mutated.

## Bounded design

### Fixture materializer

Add one test-only helper below `tests/helpers/` that accepts an already-created,
marker-bound temporary root. For each requested mirror it builds a complete
projection using only:

- `global-runtime/accelerate/`;
- repo `references/` mapped to `accelerate/references/`;
- the Codex collaboration role-policy projection;
- delegation schema/validator projections;
- `agents/openai.yaml` when present;
- repo `skills/` and `docs/codex-skill-seeds/skills/` through the existing
  target-overridden capability/standalone exporter.

It must never derive initial bytes from an installed runtime. It is a fixture
builder, not a promotion path, and it must refuse an unmarked or non-temporary
target. The marker root and every target ancestor must be real directories,
not symlinks, and every target must remain contained below the resolved marked
root.

### Checker modes

Preserve explicit `CODEX_SKILLS_DIR`/`HERMES_SKILLS_DIR` target checks. When no
explicit target roots are supplied, require
`ACCELERATE_ALLOW_INSTALLED_MIRROR_AUDIT=1` before resolving user-home defaults.
This retains an installed audit while making it unambiguously opt-in.
Explicit disposable mode requires both Codex and Hermes roots. A partial pair,
including a lone legacy `GLOBAL_SKILLS_DIR`, fails closed instead of resolving
the missing root from `HOME`.

### Canonical fixtures

Replace ambient HOME copies in:

- `tests/global-skill-mirror-stage.sh`;
- `tests/runtime-sync-codex-collaboration.sh`;
- `tests/runtime-sync-direct-fast-path.sh`.

Every fixture starts from the repo-only materializer. The three-path repair
test still introduces drift only into its allowlisted files and proves their
transactional repair. It does not claim to generate the broader runtime.

Parse `Accelerate runtime mirror: expected=N verified=M`, require positive
integers and `N == M`, and never duplicate a literal catalog count.

### Negative proof

Against a fully generated disposable fixture:

1. remove one governed reference and require checker failure;
2. alter one governed reference and require checker failure;
3. restore/regenerate and require success;
4. run under an empty `HOME` and require success;
5. invoke the checker without explicit roots and without opt-in and require
   refusal before user-home inspection.

## Candidate write denominator

Expected implementation candidates:

- `scripts/check-global-skill-mirror.sh`;
- `tests/helpers/stage-runtime-mirror-fixture.sh` (new);
- `tests/global-skill-mirror-stage.sh`;
- `tests/runtime-sync-codex-collaboration.sh`;
- `tests/runtime-sync-direct-fast-path.sh`;
- focused test additions if the implementer proves they are necessary.

Excluded:

- all 23 C14 files;
- `scripts/sync-accelerate-governed-drift.py` behavior and pin;
- broad exporter semantics;
- user-home contents;
- Plane state transition;
- proposal v0.7.25 bytes.

## Proof mode

- change kind: bug correction plus harness refactor;
- honest baseline: existing Prompt-C failure and a fresh focused empty-HOME
  reproduction before implementation;
- correction generation increments on every material post-Green fix;
- focused proof precedes the one allowed full-suite proof;
- independent reviewer receives only frozen objective, diff, and evidence.

## Rollback

Rollback is the exact pre-change content/hash set of the harness denominator.
No runtime rollback is necessary because no persistent runtime is in scope.

## Acceptance

- boundary reviewer explicitly approves this revised design;
- empty-HOME canonical fixture proof passes;
- negative missing/different checks fail for the expected reason;
- no canonical test references ambient `$HOME/.codex/skills`;
- no literal `expected=211` remains in the affected tests;
- C14 remains 23/23 and aggregate-identical;
- one fresh `tests/all.sh` passes;
- one fresh real-OpenSpec confirmation passes;
- independent adversarial tester and root review-of-review pass.
