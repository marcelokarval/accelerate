# Workflow Adapters

Workflow adapters implement the same orchestration concepts for different issue
backends.

Every workflow adapter should support:

- issue bootstrap
- issue topology
- metadata hygiene
- lifecycle state transitions
- AI review reporting
- traceable closure

The current imported doctrine still reflects a strong Linear-shaped default.
That material remains valid as the current default distribution, but it is no
longer the only acceptable architectural target.

