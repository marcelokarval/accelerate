# Lead journey sample

- diagram type: Swimlane / journey
- source truth: example-only pattern, not project runtime truth
- binding: demonstrates visual-modeling packet shape

## Artifact

```text
╔══════════╦══════════════╦══════════════╦══════════════╗
║ Actor    ║ Intake       ║ Qualification║ Follow-up    ║
╠══════════╬══════════════╬══════════════╬══════════════╣
║ Lead     ║ submits form ║ confirms     ║ receives CTA ║
║ System   ║ validates    ║ enriches     ║ notifies     ║
║ Agent    ║              ║ flags risk   ║ suggests     ║
║ Owner    ║              ║ reviews      ║ contacts     ║
╚══════════╩══════════════╩══════════════╩══════════════╝
```

## Callouts

- [1] Mark validation, authority, cardinality, or async behavior when relevant.
- [2] Bind the diagram to audit/proof/implementation surfaces when used in real work.

## Residuals

- Replace placeholder entities and actors with inspected project truth before using this as evidence.
