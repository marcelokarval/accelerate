# P4Y-1305 Dogfood V2 Subset Validator Final Review — 2026-05-10

## Scope

P4Y-1305 adds a dedicated validator for the committed repo-safe dogfood V2 subset without weakening or repurposing the full generated workspace validator.

## Requested vs Implemented

- Inspect existing V2 validator and dogfood contract tests -> met. Reviewed `onboarding/local-workspace/validate-v2.sh` and `tests/dogfood-workspace-contract.sh`.
- Add a dedicated validator for committed repo-safe dogfood V2 subset -> met. Added `onboarding/local-workspace/validate-dogfood-v2-subset.sh`.
- Validate only committed subset surfaces -> met. The validator scopes structural checks to `.accelerate/state.yaml`, `.accelerate/workflow/adapter.yaml`, `.accelerate/workflow/active-work-item.yaml`, `.accelerate/status/readiness-dashboard.yaml`, `.accelerate/README.md`, and `.accelerate/workflow/README.md`.
- Wire into canonical dogfood contract -> met. `tests/dogfood-workspace-contract.sh` invokes the subset validator before its wider tracked-file and ignore-boundary checks.
- Document subset validator versus full generated V2 validator -> met. Added usage notes in `.accelerate/README.md` and `.accelerate/workflow/README.md`.

## Proof

Subagent attempted implementation and began proof, but root killed the Codex process after confirming it spawned broad MCP sidecars that were unnecessary for this bounded P4Y-1305 slice. Root then independently inspected and verified the resulting working tree.

Root verification:

- `bash onboarding/local-workspace/validate-dogfood-v2-subset.sh .` -> passed (`dogfood V2 subset validator passed`)
- `bash tests/dogfood-workspace-contract.sh` -> passed
- `bash tests/recursive-self-improvement-contract.sh` -> passed
- `bash tests/all.sh` -> passed (`all tests passed`)
- `git diff --check` -> passed

## Self-Review

- The full generated V2 validator remains unchanged.
- The committed dogfood subset does not claim full generated V2 compliance.
- The validator is intentionally limited to repo-safe committed state, docs, lifecycle identifiers, proof locators, and generated/private boundary wording.
- `tests/dogfood-workspace-contract.sh` now delegates subset-specific semantic checks to the dedicated validator and keeps its broader generated/private boundary checks.

## Self-Forensic Review

- Secrets/private payload check: passed through subset validator, dogfood contract, and root changed-file probe. Only secret-regex definitions are present; no secret values or provider payloads were found.
- Lifecycle/status truth check: passed. The accepted dogfood cycle remains accepted and the validator rejects drift back to top-level `status: active` in accepted dogfood state surfaces.
- Generated/full-v2 overclaim check: passed. Docs distinguish the committed dogfood V2 subset validator from `onboarding/local-workspace/validate-v2.sh`, which remains reserved for full generated V2 workspaces.
- Process/server/browser state: no repo server/browser/playwright/chromium process was required or retained for P4Y-1305. The initial Codex subagent process `proc_4b08a1d04175` was killed by root after it spawned unnecessary MCP sidecars; a targeted `ps`/`pgrep` check found no remaining P4Y-1305 validator/test/codex process.

## Root Final Review

Verdict: supported for P4Y-1305.

Caveat: the subagent did useful local implementation work but violated the “no unnecessary MCP/tool exposure” intent of the handoff because the Codex CLI booted its configured MCP sidecars. Root actively terminated it, completed independent verification, and did not treat the subagent as an approval.

## Residuals

- Future Codex CLI delegation for bounded local-only slices should use a stricter no-MCP/disabled-MCP invocation path if available, or prefer Hermes `delegate_task` with explicit `toolsets` when local filesystem mutation is not required.
- P4Y-1306/P4Y-1307/P4Y-1308 remain shaped follow-up lanes under P4Y-1304; none were implemented by this slice.
