# OmniRouter Runtime Adapter

OmniRouter is the model-routing boundary used by the DSH adapter. It owns model
availability, pool priority, concurrency, and failover. It does not classify
agent work, authorize mutation, validate completion, or own closure.

Operational procedures live in
`skills/operations/omnirouter-operations/`. Accelerate decides when that skill
is needed.
