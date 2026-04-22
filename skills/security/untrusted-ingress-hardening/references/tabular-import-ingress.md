# Tabular Import Ingress

Use this reference when the incoming artifact is a tabular import such as
`.csv`, `.xls`, or `.xlsx`.

## Main Questions

1. what exact formats are allowed?
2. how large can the import become?
3. how is the file parsed and normalized before downstream use?
4. are unsupported spreadsheet behaviors rejected?

## Baseline Rules

- accept only formats the product truly supports
- bound file size, row count, column count, sheet count, and parse time where
  possible
- normalize headers and field mappings before domain use
- transform imports into canonical internal structures before persistence
- reject unsupported workbook behavior instead of silently carrying it forward

## Safety Review

Review:

- malformed row handling
- duplicate header handling
- oversized workbook behavior
- parser failure handling
- formula or macro posture when spreadsheet formats are accepted

The default posture should be: support the minimum useful subset, not the full
spreadsheet world.

## Common Smells

- treating `.xls`/`.xlsx` as if they were just bigger `.csv`
- no row-count bound
- domain logic directly consuming raw parser output
- silent coercion of malformed headers into ambiguous fields
