# DESIGN.md Local Corpus Task Ledger

## Ledger Rule

This ledger follows the `One-Shot Side-By-Side Gate`: every task must compare
requested vs implemented, record defects, correct in-scope gaps, and reproof
before closure.

## Tasks

| ID | Requested Outcome | Implemented Evidence | Expected Proof | Actual Proof | Side-By-Side Judgment | Defects Found | Correction Owner | Correction Summary | Reproof Evidence | Closure Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| T1 | Create executive plan and one-shot task ledger | `planning/executive/design-md-local-corpus-executive-plan.md`, this ledger | Plan and ledger exist before implementation | plan/ledger created | met | none | n/a | n/a | n/a | closed |
| T2 | Add failing tests for corpus integrity and semantics | `tests/design-md-corpus-integrity.sh`, `tests/design-md-corpus-semantic.sh` | Tests fail before corpus exists | red then green | met | test helper bug | master | added `rg --` before patterns | corpus tests passed | closed |
| T3 | Seed curated DESIGN.md corpus | `references/design-md/<slug>/DESIGN.md`, metadata, index | Real local corpus files with provenance | seed files and metadata created | met | none | n/a | n/a | corpus integrity passed | closed |
| T4 | Wire corpus governance into core and design-system stack | core review doc, skill, manifest, extraction/application docs | Corpus supports stack without replacing artifacts | governance docs and skill registered | met | missing skill metadata | master | added `metadata.yaml` | registry validation passed | closed |
| T5 | Validate and forensic-review delivery | test outputs, final reconciliation | All tests pass and final side-by-side review is complete | validation passed | met | none open | n/a | n/a | final validation passed | closed |
| T6 | Expand corpus to all remaining public DESIGN.md entries | `references/design-md/<slug>/DESIGN.md`, `metadata.md`, import helper | 69 local corpus entries with provenance | imported 64 missing entries, preserving 5 existing entries | met | none | n/a | n/a | full corpus integrity passed | closed |
| T7 | Update index and tests for full-corpus coverage | `references/design-md/index.md`, `tests/design-md-corpus-integrity.sh` | Index says 69 and test validates every entry dynamically | index now lists 69 entries; test loops over all entry directories | met | none | n/a | n/a | corpus tests passed | closed |
| T8 | Validate expanded corpus with same review standard | doctrine, registry, profile, whitespace checks | All repo validation commands pass | all validation commands passed | met | none open | n/a | n/a | final validation passed | closed |

## Review Log

### T1 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Executive plan | `design-md-local-corpus-executive-plan.md` | met |
| Task ledger | `design-md-local-corpus-task-ledger.md` | met |
| One-shot method | Ledger includes task review, defects, correction, reproof, closure status | met |

No correction required.

### T2 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Failing integrity test | `tests/design-md-corpus-integrity.sh` failed before corpus existed | met |
| Failing semantic test | `tests/design-md-corpus-semantic.sh` failed before governance existed | met |
| Strong anchors | Tests check files, seeds, metadata, registry, docs, non-bypass semantics | met |

Correction: test helper initially failed on `--ds-*` because `rg` parsed it as a
flag. Added `rg -n --` in both corpus tests.

Reproof: both corpus tests passed.

### T3 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Local corpus directory | `references/design-md/` | met |
| Seed entries | `airbnb`, `stripe`, `linear`, `vercel`, `notion` | met |
| Real DESIGN.md content | Each seed has imported `DESIGN.md` content from `getdesign.md` | met |
| Provenance | Each seed has `metadata.md` with source, fetch date, trust limit, disclaimer | met |
| Index | `references/design-md/index.md` maps use cases and categories | met |

No correction required.

### T4 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Core governance | `core/review/design-md-corpus.md` | met |
| Skill | `skills/design-system/design-md-corpus-patterns/SKILL.md` | met |
| Metadata | `skills/design-system/design-md-corpus-patterns/metadata.yaml` | met after correction |
| Registry | `skills/_registry/manifest.md` includes `design-md-corpus-patterns` | met |
| Extraction/application docs | `html-design-system-extraction.md` and `design-system-contract-application.md` mention DESIGN.md corpus guardrails | met |
| README | README mentions repo-local curated DESIGN.md corpus | met |

Correction: added missing `metadata.yaml` after registry validation failed.

Reproof: `bash scripts/validate-skill-registry.sh` passed.

### T5 Validation Evidence

| Validation | Result |
| --- | --- |
| `bash tests/design-md-corpus-integrity.sh` | passed |
| `bash tests/design-md-corpus-semantic.sh` | passed |
| `bash tests/doctrine-integrity.sh` | passed and ran one-shot + corpus tests |
| `bash scripts/validate-skill-registry.sh` | passed after metadata correction |
| `bash tests/profile-integrity.sh` | passed |
| `git diff --check` | passed |

## Final Forensic Reconciliation

| Comparison | Expected | Actual | Judgment |
| --- | --- | --- | --- |
| User correction vs implementation | Add curated DESIGN.md corpus inside Accelerate, not replace current stack | `references/design-md/` with five seeds and governance | met |
| Corpus vs source truth | Corpus is local reference/influence material, not direct implementation authority | README, core doc, skill, tests enforce non-bypass rule | met |
| Existing design-system stack | Preserve `design-system.html`, `design-system.contract.md`, `design-system.theme.css` | Governance requires mapping corpus influence into local artifacts and `--ds-*` tokens | met |
| Premium capacity | Provide real premium examples for influence maps and anti-template work | Seeded Airbnb, Stripe, Linear, Vercel, Notion with index guidance | met |
| Provenance | Every seed records source URL, date, disclaimer, trust limits | Each seed has `metadata.md` | met |
| Tests | Strong corpus tests, not superficial presence only | Integrity + semantic tests plus doctrine integration | met |
| Auto-correction | In-scope validation defects corrected and reproved | Fixed test helper and missing skill metadata | met |

No open in-scope defects remain.

## Expansion Review Log

### T6 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Download all missing DESIGN.md files | Imported 64 missing public entries from `getdesign.md` | met |
| Preserve existing seeds | Existing 5 entries remain present and indexed | met |
| Use same provenance pattern | Every imported entry has `metadata.md` with source URL, fetch date, not-official flag, category, influence, use guidance, provenance, and trust limits | met |
| Keep local authority boundary | Metadata repeats no brand cloning and contract/theme/token mapping requirements | met |

No correction required.

### T7 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Full index | `references/design-md/index.md` now lists `Total entries: 69` and all slugs | met |
| Full test coverage | `tests/design-md-corpus-integrity.sh` loops over every corpus directory | met |
| Prevent partial corpus regression | Test requires at least 69 entries and index coverage for each slug | met |

No correction required.

### T8 Validation Evidence

| Validation | Result |
| --- | --- |
| `bash tests/design-md-corpus-integrity.sh` | passed |
| `bash tests/design-md-corpus-semantic.sh` | passed |
| `bash tests/doctrine-integrity.sh` | passed and ran one-shot + corpus tests |
| `bash scripts/validate-skill-registry.sh` | passed |
| `bash tests/profile-integrity.sh` | passed |
| `git diff --check` | passed |

## Expansion Forensic Reconciliation

| Comparison | Expected | Actual | Judgment |
| --- | --- | --- | --- |
| User follow-up | Download all remaining entries, not just representative seeds | 69 total entries present locally | met |
| Review standard | Same one-shot side-by-side pattern | T6-T8 ledger entries, side-by-side review, validation evidence, final reconciliation | met |
| Governance preservation | Expanded corpus must not weaken design-system artifact authority | Existing core doc, skill, semantic tests, and metadata still require contract/theme/token mapping | met |
| Regression protection | Future validation catches missing entries or missing index coverage | Dynamic corpus integrity test validates every directory and `Total entries: 69` | met |

No open in-scope defects remain after expansion.
