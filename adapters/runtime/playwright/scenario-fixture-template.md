# Playwright Scenario Fixture Template

Use this template when converting stable browser truth into persistent
regression proof.

## Scenario Identity

- Scenario name:
- Scenario class:
- Owning surface:
- Related issue / plan:

## Source Browser Truth

- Browser-proof packet:
- Browser tool used:
- Date:
- Intensity:
- Observed stable path:

## Preconditions

- App command:
- Required environment:
- Required seed data:
- Auth/session state:
- External service assumptions:

## User Path

1. Navigate to:
2. Action:
3. Expected visible state:
4. Action:
5. Expected visible state:

## Assertions

- Must assert:
- Must not assert:
- Selectors or accessible names:
- Network or console expectations:

## Rerun Command

```bash
npx playwright test <path-or-grep>
```

## Failure Handling

- If setup fails:
- If selector drift appears:
- If runtime error appears:
- If product behavior changes intentionally:

## Residual Gaps

- Browser gaps:
- Data gaps:
- Accessibility gaps:
- CI gaps:
