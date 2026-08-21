- Non-trivial work defaults to multi-agent execution.
- At least one bounded subagent should normally be spawned for non-trivial work.
- Each spawned subagent should load `accelerate` first, then leave
  `self-review` and `self-forensic review` output before returning.
