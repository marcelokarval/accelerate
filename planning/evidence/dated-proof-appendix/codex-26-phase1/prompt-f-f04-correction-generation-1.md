# Prompt F — TASK-F04 Correction Generation 1

## Disposition

- issue: `CODEX-26`
- timestamp: `2026-09-03T22:49:30-04:00`
- trigger: first durable F04 run exited `1`
- first broken boundary: root `SKILL.md` omitted the governed
  `## Execution Routes` anchor and route/classification invariant
- classification: in-scope root-router regression; active test is not stale
- prior F04 proof: invalidated for acceptance after this source correction
- F05: remains blocked pending a fresh terminal F04 PASS

## Bounded correction

Root performed an integration-only repair:

1. renamed `## Classification and Routes` to `## Execution Routes`;
2. restored the exact route-versus-classification invariant after the three
   route definitions.

No test, C14 candidate file, R1 harness file, runtime mirror, user-home file,
Plane item, provider, deployment, or promotion surface changed.

## Focused proof

- `bash tests/direct-fast-path-routing.sh`: PASS
- `bash tests/classification-golden.sh`: PASS
- `git diff --check`: PASS
- corrected root `SKILL.md` SHA-256:
  `a96bc85ca1e9b3ae024f16e2c4b5ea36b59923be89fdafca63d3e7de09309087`
- corrected root router size: 201 lines / 9,782 bytes

## Frozen integrity

- C14: 23/23 zero mismatch; aggregate
  `cbf26086ca9af5e7d927d7ee324818af35d74d972dfcdbfcce0cd562bc3780d4`
- C14 freeze-file SHA-256:
  `7215486904c9fee3172ad1f53c3c3a63d4aa9ba62cea424d5bf8da60fcf72bc2`
- R1: 5/5 zero mismatch; aggregate
  `aa9551f4b2f33fe382b043059034fe1b107e50ee8b99c5975869bdc67e5eaeed`
- R1 freeze-file SHA-256:
  `23ec174a784f5a0570419086cbccda39f9b08f8dd780889b0e30e449c0a73ecb`

## Independent review

- HCOM Agy, Gemini 3.8 Flash High: `CORRECTION_G1_PASS`, message `3154`
- HCOM Codex, GPT-5.6 Terra High: `CORRECTION_G1_PASS`, message `3175`
- root review-of-review: both reviewers inspected current repository bytes and
  independently required a fresh F04 run; no correction blocker remains

## Next gate

Run exactly one fresh durable normal-environment `bash tests/all.sh` as F04
generation G2. Advance to F05 only on an attributable terminal `exit=0`.
