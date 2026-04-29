# Agent Promotion

Native home for promotion criteria, suggestion-vs-promotion rules, return
contracts, and runtime installation policy for governed agents.

In the current `standalone pre-agents` phase, this sublayer must remain
strictly conservative.

It should already make one thing explicit:

- detecting a gap is not the same as promoting an agent

And it should refuse to imply:

- automatic promotion
- required runtime installation
- agent creation just because a family shape looks useful

This is where the platform should later define the real transition from:

- gap detection
- recommendation
- approval
- promotion
- runtime installation

The first native contract artifact now lives in:

- `promotion-contract.md`
- `execution-contract.md`
- `return-contract.md`

Read in this order:

1. `promotion-contract.md`
2. `execution-contract.md`
3. `return-contract.md`
