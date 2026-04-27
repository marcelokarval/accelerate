# Review Finding Schema

Review findings are JSONL records.

Required fields:

- `finding_id`
- `fingerprint`
- `severity`
- `confidence`
- `category`
- `summary`
- `evidence`
- `recommended_fix`
- `classification`
- `reviewer`
- `status`

Optional fields: `path`, `line`, `scenario`, `linked_task`, `linked_defect`.

Allowed classifications: `auto-fix`, `ask`, `blocker`, `informational`.
