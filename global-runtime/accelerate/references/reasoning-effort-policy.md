# Codex Reasoning Effort Policy

This is the Codex-native decision contract. Machine authority is `../assets/reasoning-effort-policy.json`; validation belongs to this skill package and never falls back to the Hermes copy.

## Minimum sufficient effort

1. Prefer a shell command or deterministic script (`no-model`) for mechanics with no semantic judgment.
2. Use `low` for bounded repository lookups, clear classifications, small patches and direct proof.
3. Use `medium` for non-trivial engineering when repo-local `AGENTS.md`, documentation, observability and acceptance are sufficient.
4. Use `high` only after a machine-listed trigger survives root readback and a complete receipt is recorded.

The global Codex default may remain `medium`. Do not rewrite `config.toml` per task. Issue priority, task size, user emphasis or multi-agent use are not `high` triggers.

## Native authority order

Repo-local `AGENTS.md` and project documentation remain authoritative after entry classification. The global Codex Accelerate skill governs effort selection only when local rules do not define a stricter compatible boundary.

## Prompt hardening

Classify separately from reasoning effort:

- `not-needed`: the current request or packet already supplies goal, done, constraints and proof;
- `micro`: add only the missing compact outcome constraints;
- `full`: produce Prompt A/B for material ambiguity, governance mutation, side effects or multi-surface work.

Full hardening does not imply `high`.

## High receipt

Record decision metadata, never raw chain-of-thought. Receipts conform to
`../assets/reasoning-decision-receipt.schema.json` and are validated with
`../scripts/validate_reasoning_receipt.py`:

```text
receipt_version / receipt_kind / runtime
denominator / dependencies / side_effect_boundaries
execution_mode / mode_basis
prompt_hardening / selected_effort / basis_code / observable_status
trigger / typed evidence / lower_effort_insufficiency
budget / stop_condition
```

For `high`, `lower_effort_insufficiency` cannot be `not-applicable`, and `budget.model_calls` must be at least `1`; field presence without material values fails closed.

Missing or unsupported fields fail closed. `xhigh`, `max` and `ultra` require separate explicit scope, budget, eval and stop condition.
