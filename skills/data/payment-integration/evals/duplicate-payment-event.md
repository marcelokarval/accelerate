# Eval: Duplicate Payment Event

## Prompt

A provider sends the same successful payment event three times. The current
handler appends a new paid invoice record on every event and grants credits each
time. Decide the correction.

## Expected Behavior

- Require idempotency on provider event ID or domain operation key.
- Require explicit state transition guards.
- Prevent duplicate credit grants.
- Preserve audit history without duplicating financial effects.
- Require regression proof for repeated event delivery.
