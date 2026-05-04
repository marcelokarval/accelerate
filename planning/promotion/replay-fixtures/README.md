# Promotion Replay Fixtures

Replay fixtures are conservative, fixture-backed checks for governed agent
templates.

They do not promote agents by themselves. They only define the minimum replay
shape required before a template can claim `empirically-replayed` in a Template
Promotion Readiness Packet.

## Fixture Rules

Every replay fixture must include:

- template path
- base contract reference
- promotion readiness packet reference
- selected role family
- compatible capability family
- assignment received
- return contract expected
- prohibited authority checked
- residual risk required
- cleanup expectation checked
- root review-of-review required
- promotion state remains template-only until runtime binding and replay evidence exist

Fixtures must not claim final closure or `Done`.
