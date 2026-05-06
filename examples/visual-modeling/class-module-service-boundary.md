# Service boundary sample

- diagram type: Class/module/function relationship
- source truth: example-only pattern, not project runtime truth
- binding: demonstrates visual-modeling packet shape

## Artifact

```text
lead_service.py
  ├─ qualify_lead(lead_id)
  │   ├─ load_lead_for_owner()
  │   ├─ apply_qualification_policy()
  │   └─ record_lead_event()
  └─ reject_lead(lead_id)
      ├─ load_lead_for_owner()
      └─ record_lead_event()

views.py ─────→ lead_service.py ─────→ models.py
        allowed call direction only
```

## Callouts

- [1] Mark validation, authority, cardinality, ordering, retry, or async behavior when relevant.
- [2] Bind the diagram to audit/proof/implementation surfaces when used in real work.

## Residuals

- Replace placeholder entities and actors with inspected project truth before using this as evidence.
