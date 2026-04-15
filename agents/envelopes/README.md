# Agent Envelopes

Reserved for reusable skill-envelope and execution-envelope definitions that
future bounded agents inherit from the root control plane.

In the current phase, this sublayer is not a runtime template library yet.

Its current role is to reserve the place where the platform will later define:

- what every bounded agent must inherit from the root
- what runtime packet shape a bounded agent must return
- what proof and closure surfaces cannot be skipped
- what local `accelerate` discipline means inside a bounded session
