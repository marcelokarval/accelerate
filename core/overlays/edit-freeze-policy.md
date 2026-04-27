# Edit Freeze Policy

Freeze mode restricts edits to declared paths for bounded debugging or focused
implementation.

## Required State

- mode owner
- allowed paths
- reason
- start timestamp
- unblock condition

Writes outside allowed paths must fail unless the freeze is explicitly lifted or
the user approves a new boundary.
