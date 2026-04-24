# Active Correction Loop

## Purpose

This surface defines the short corrective loop that sits between defect
detection and promotion.

Its job is to stop the branch from treating review as:

- describe the issue
- defer the fix
- close anyway

when the defect is actually in-scope to correct immediately.

## Loop

The canonical loop is:

```text
capture
  -> inspect
  -> register defect
  -> assign owner
  -> fix
  -> recapture / reprobe
  -> compare corrected state
  -> only then promote
```

## Rule

If a meaningful defect is found during the active slice and the fix belongs to
that slice, correct it before promotion.

Do not normalize:

- "I noticed the problem and will fix it later"
- "the screenshot shows drift, but the main task is done"
- "the test failed once, but the implementation is basically correct"

## Domain-Agnostic Semantics

The evidence changes by domain, but the loop does not.

Frontend:

- screenshot or interactive browser truth shows the defect

Backend:

- output, runtime proof, or contract validation shows the defect

Runtime / governance:

- packet mismatch, wrapper mismatch, or claimed-vs-actual behavior shows the
  defect

In all cases:

- defect registration
- correction
- fresh proof
- side-by-side confirmation

## Waiver Rule

When the defect cannot be corrected inside the current slice, the branch must
say why.

Allowed dispositions:

- deferred
- blocked by dependency
- outside scope
- disproven after investigation

Without explicit disposition, the defect remains `open`.

## Relationship To QA / Proof Stack

This loop does not replace proof ordering.

The ordering remains:

1. implementation proof
2. backend/frontend QA proof
3. browser truth
4. persistent regression proof
5. forensic closure

The change is that defects found at any lane should drive correction and
reproof instead of passive commentary.
