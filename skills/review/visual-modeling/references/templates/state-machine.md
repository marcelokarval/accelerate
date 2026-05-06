# State Machine Template

Use for lifecycle/status transitions, terminal states, and allowed recovery paths.

## Must Include

- states
- named transitions
- terminal states
- invalid/prohibited transitions when important
- actor/system responsible for transition when relevant

## Template

```text
╔══════════╗   submit   ╔══════════╗   approve   ╔══════════╗
║ draft    ║━━━━━━━━━━→ ║ pending  ║━━━━━━━━━━━━→║ active   ║
╚══════════╝            ╚══════════╝             ╚════╦═════╝
     ▲                       │ reject                 │ expire
     │ edit                  ▼                        ▼
╔══════════╗           ╔══════════╗             ╔══════════╗
║ revised  ║←━━━━━━━━━ ║ rejected ║             ║ archived ║
╚══════════╝  reopen   ╚══════════╝             ╚══════════╝

Invalid:
active ×→ draft
archived ×→ pending
```

## Callouts

- Mark who can trigger each transition.
- Mark transitions that require proof, audit, or external provider confirmation.

## Common Mistakes

- listing statuses without transition rules
- hiding terminal states
- not showing recovery/retry paths
