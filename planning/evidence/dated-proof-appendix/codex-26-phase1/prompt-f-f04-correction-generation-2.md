# Prompt F — TASK-F04 Correction Generation 2

## Disposition

- issue: `CODEX-26`
- timestamp: `2026-09-03T23:01:15-04:00`
- trigger: durable F04 generation G2 exited `1`
- duration: `real 414.87`
- full log SHA-256:
  `ae4bf639be45fba1eda3687f4b0056e4c4d644599a9c86442501b3f328b25792`
- first broken boundary:
  `v3 template invalid: unexpected planning pointer schema or value`
- classification: stale V3 template pointer; validator and test are not stale
- F04 G2: invalidated for acceptance after this source correction
- F05: remains blocked pending a fresh terminal F04 PASS

## Bounded correction

Root changed only `governing_design_sha256` in
`onboarding/local-workspace/v3-template/.accelerate/planning-pointer.yaml` from
the intermediate proposal digest to the canonical proposal digest already
bound by C14:

`749d829a5b5868370b05007ad71e4b4b285623db79cbefeaa47ba9a3b07e7cca`

The validator and tests were not changed. The V3 files are untracked relative
to HEAD, so traceability relies on this whole-file digest and direct content
validation, not on a Git single-field-delta claim.

## Focused proof

- direct V3 template validator: PASS
- `bash tests/local-workspace-v3-contract.sh`: PASS
- `git diff --check`: PASS
- corrected planning-pointer SHA-256:
  `ecf5627f1314bcb574d26916ac1ec638cf2c42fa9b24eff167b3247d4216f0de`

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

- HCOM Agy, Gemini 3.8 Flash High: `CORRECTION_G2_PASS`, message `3563`
- HCOM Codex, GPT-5.6 Terra High: `CORRECTION_G2_PASS`, message `3573`
- root review-of-review: canonical design, C14 binding, validator computation,
  template content, and frozen denominators now agree

## Next gate

Run exactly one fresh durable normal-environment `bash tests/all.sh` as F04
generation G3. Advance to F05 only on an attributable terminal `exit=0`.
