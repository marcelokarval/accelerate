# Next.js AdonisJS AdminJS Profile

This profile governs projects that intentionally use:

- Next.js as frontend/app shell and limited edge/server runtime
- AdonisJS as backend truth, service boundary, validation authority, and database
  runtime
- AdminJS as the admin/operator dashboard
- React + TypeScript + shadcn/Radix + Tailwind for product UI componentization

## Authority Split

- AdonisJS owns domain truth, persistence, migrations, backend validation,
  authentication, authorization, service orchestration, jobs, and provider
  callbacks.
- Next.js owns product UI composition, routing shell, client/server component
  boundaries, frontend state, and user-facing interaction surfaces.
- AdminJS owns operator/admin workflows only through explicit resources, actions,
  policies, masking, and audit posture.
- PostgreSQL is the default relational target unless the project explicitly
  chooses another database through database governance.

## Non-Goals

- No Django/Inertia requirement.
- No AdminJS claim of Django Admin parity.
- No Next.js server action or route handler as hidden second backend truth layer.
- No whole-database AdminJS exposure by default.

Execution validation for this profile lives in:

- `validation-bundle.md`

Backend parity tracking lives in:

- `backend-parity-matrix.md`
