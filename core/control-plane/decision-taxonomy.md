# Decision Taxonomy

Accelerate classifies workflow decisions before acting on them.

## Classes

| Class | Meaning | Default Handling |
| --- | --- | --- |
| mechanical | Local, reversible, low-risk implementation choice. | May auto-decide with rationale. |
| preference | Reversible user taste or workflow preference. | May reuse trusted user preference. |
| taste | Product/design direction with subjective tradeoffs. | Surface in final gate even if recommended. |
| one-way-door | Hard to reverse, risky, destructive, security-sensitive, or external-write decision. | Must ask. |
| user-challenge | Agent proposes changing the user's stated direction. | Must ask. |
| proof-skip | Any request to skip required proof. | Must ask and record exception if accepted. |

## Required Record

Every non-mechanical decision recorded in Accelerate artifacts must include:

- stable decision ID
- class
- question ID when applicable
- recommendation
- selected option
- rationale
- rejected alternatives
- affected artifacts
- source of authority

## Boundary

Auto-decisions never override root safety gates, local workspace validation,
design-system authority, browser-proof requirements, or closure blockers.
