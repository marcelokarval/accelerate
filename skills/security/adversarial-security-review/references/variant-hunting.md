# Variant Hunting

Use this reference when a real finding suggests the same root cause may exist
elsewhere.

## Workflow

1. identify the confirmed root cause
2. generalize the structural pattern
3. search adjacent routes, services, presenters, or helpers
4. classify each potential variant as:
   - confirmed
   - partial
   - rejected

## Common Variant Families

- one ownership check exists in detail view but not in adjacent mutation view
- one resend flow has cooldown, adjacent resend flow does not
- one upload path strips metadata, adjacent upload path preserves it
- one list uses bounded query posture, adjacent report path amplifies N+1
- one sensitive redirect is validated, adjacent transition path is not

## Reporting Rule

Do not collapse all variants into one vague sentence.

List what was checked and what was actually confirmed.
