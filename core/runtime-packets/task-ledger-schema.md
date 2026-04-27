# Task Ledger Schema

Required task fields:

- `id`
- `parent_work_item`
- `status`
- `owner`
- `source_requirement`
- `expected_surfaces`
- `proof_required`
- `review_required`
- `implementation_notes`
- `defects_found`
- `correction_reproof_status`
- `closure_status`

Allowed statuses: `pending`, `in_progress`, `blocked`, `implemented`,
`under_review`, `needs_correction`, `reproof_required`, `accepted`, `closed`.
