# Swimlane / Journey Template

Use for user, lead, owner, operator, provider, or agent paths across time.

## Must Include

- actors/lanes
- ordered steps
- handoffs
- responsibility at each step
- friction/risk points

## Template

```text
╔══════════╦══════════════╦══════════════╦══════════════╦══════════════╗
║ Actor    ║ Step 1       ║ Step 2       ║ Step 3       ║ Step 4       ║
╠══════════╬══════════════╬══════════════╬══════════════╬══════════════╣
║ Lead     ║ submits form ║ confirms     ║ waits        ║ receives CTA ║
║ System   ║ validates    ║ enriches     ║ scores       ║ notifies     ║
║ Agent    ║              ║ checks risk  ║ flags gap[1] ║ suggests     ║
║ Owner    ║              ║              ║ reviews      ║ contacts     ║
╚══════════╩══════════════╩══════════════╩══════════════╩══════════════╝
```

## Callouts

- [1] Mark ambiguity, manual intervention, compliance risk, or expected delay.

## Common Mistakes

- describing a journey with no actor responsibility
- hiding system/operator handoffs
- omitting unhappy paths when they affect product behavior
