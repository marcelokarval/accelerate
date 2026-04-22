# Local Ambiguity And Markdown Size Audit Result

## Executive Summary

Audited the local `accelerate` repository for markdown size, duplicate
authority, and ambiguity after the design-system extraction/application updates.

The active markdown corpus, excluding `.git`, `.backups`, and `.tmp`, contains:

- 226 markdown files
- 876,628 bytes of markdown

The highest-risk ambiguity was not exact duplicate files. It was duplicated
operational authority between `references/` and native `core/` modules.

## Correction Applied

The following `references/` files were reduced to authority pointers because
their full operational content now lives in native `core/` modules:

- `references/branch-enforcement-matrix.md`
- `references/workflow-catalog.md`
- `references/premium-interface-production.md`
- `references/product-critical-surfaces.md`

Size reduction:

| File | Before | After | Reduction |
| --- | ---: | ---: | ---: |
| `references/branch-enforcement-matrix.md` | 15,366 bytes | 558 bytes | -14,808 bytes |
| `references/workflow-catalog.md` | 5,116 bytes | 660 bytes | -4,456 bytes |
| `references/premium-interface-production.md` | 5,504 bytes | 860 bytes | -4,644 bytes |
| `references/product-critical-surfaces.md` | 6,700 bytes | 815 bytes | -5,885 bytes |

Total reduction across those references: 29,793 bytes.

## Why These Files

These files duplicated live branch/workflow/review rules already present under
`core/`. Keeping complete copies in `references/` made it easier for future
agents to read stale rows, miss new lanes, or treat supporting doctrine as
co-equal authority.

The replacement files preserve discoverability while forcing the agent to open
the native authority.

## Kept As-Is

Large files under `docs/architecture/` and `planning/executive/` were not
reduced in this slice because they are historical, planning, or architecture
records rather than active routing authority.

The large `extract-html-design-system-v2` skill was also kept intact because it
is currently the active source of a complex artifact-generation workflow. Its
future cleanup should be a deliberate split into references/scripts, not a
blind shortening pass.

## Additional Alignment

Updated `docs/architecture/accelerate-control-plane.md` so the visual /
artifact-driven frontend branch now names both:

- `extract-html-design-system-v2`
- `apply-design-system-contract`

Updated `references/adjacent-skill-trigger-audit.md` so the new post-extraction
application skill is discoverable in the adjacent trigger audit.

## Validation

- `git diff --check` passed.
- No exact duplicate markdown files were found between `core/` and
  `references/` by hash.
- The remaining duplicate names are intentional native/supporting pairs or
  generic `README.md` files.
