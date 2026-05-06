# Class / Module / Function Relationship Template

Use when code structure, dependency direction, class responsibility, or function
call relationships are the decision surface.

## Must Include

- modules/classes/functions involved
- dependency/call direction
- ownership boundary
- prohibited import or cycle when relevant

## Class Template

```text
╔════════════════════╗
║ LeadMatcher        ║
╠════════════════════╣
║ + match(lead)      ║
║ + score(property)  ║
╚══════════╦═════════╝
           │ uses
           ▼
╔════════════════════╗
║ ScoringPolicy      ║
╠════════════════════╣
║ + calculate(input) ║
╚════════════════════╝
```

## Function Call Template

```text
handleWebhook()
  ├─ verifySignature()
  ├─ parseEvent()
  ├─ routeEvent()
  │   ├─ handleInvoicePaid()
  │   └─ handleSubscriptionDeleted()
  └─ recordAuditEvent()
```

## Common Mistakes

- drawing classes without responsibility boundaries
- hiding imports/cycles
- mixing runtime sequence with static dependency shape without labeling it
