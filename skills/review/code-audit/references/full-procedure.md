---
name: code-audit
description: Comprehensive code audit following P0-P3 quality patterns with automated quality gates. Use for security reviews, architecture validation, code quality assessment, compliance checking, or CI/CD quality enforcement.
disable-model-invocation: false
user-invocable: true
allowed-tools: Read, Grep, Bash
---

# Code Audit Skill

P0-P3 quality checks for security, architecture, maintainability, and
documentation. Use stack-specific commands from the active project profile
rather than treating the examples below as universal law.

## Severity Classification

| Priority | Category | Action |
|----------|----------|--------|
| **P0** | Security | Blocks PR/merge |
| **P1** | Architecture | Fix in current sprint |
| **P2** | Maintainability | Backlog |
| **P3** | Documentation | Nice to have |

## P0 - Security Critical (BLOCKING)

### SEC-001: IDOR Protection
```bash
# Potential IDOR: direct PK access without ownership
grep -rn "\.get(pk=" --include="*.py" src/ | grep -v "get_owned_object_or_404\|request.user\|owner="
# Exposed PKs in serialization
grep -rn "\.pk\|\.id" --include="*.py" src/ | grep "serialize\|to_dict\|json"
```
**Fix**:
```python
# WRONG: user = User.objects.get(pk=user_id)
# RIGHT:
user = get_owned_object_or_404(User, public_id=user_public_id, owner=request.user)
```

### SEC-002: Race Conditions
```bash
# Financial ops without atomic protection
grep -rn "balance\|credits\|amount\|price" --include="*.py" src/ | grep "\.save()" | grep -v "select_for_update\|F(\|atomic"
```
**Fix**:
```python
# WRONG: user.balance -= amount; user.save()
# RIGHT:
with transaction.atomic():
    user = User.objects.select_for_update().get(id=user_id)
    user.balance = F('balance') - amount
    user.save()
```

### SEC-003: Timing Attacks
```bash
grep -rn "== .*token\|== .*secret\|== .*password" --include="*.py" src/ | grep -v "hmac.compare_digest"
```
**Fix**: Always use `hmac.compare_digest(provided_token, stored_token)`

### SEC-004: Webhook Validation
```bash
grep -rn "@csrf_exempt" --include="*.py" src/ | grep -v "verify_signature\|validate_webhook"
```

### SEC-005: Cache Serialization
```bash
grep -rn "pickle\|cPickle" --include="*.py" src/
grep -rn "cache\.set.*password\|cache\.set.*token" --include="*.py" src/
```

## P1 - Architecture Critical

### ARCH-001: Service Layer Enforcement
```bash
# Business logic in views (should be in services/)
grep -rn "def.*view\|class.*View" --include="*.py" src/ | xargs grep -l "@transaction\|if.*else.*if"
# Missing service layer
find src/ -name "services" -type d | wc -l
```
**Rule**: Every domain app must have `services/`. Complex logic belongs there, not in views or models.

### ARCH-002: Base Model / Identifier Conventions

Check model inheritance, public identifiers, ownership fields, and audit fields
against the active project's data conventions. Do not assume one universal base
class or identifier name.

### ARCH-003: Decimal for Money
```bash
grep -rn "FloatField" --include="*.py" src/ | grep -i "price\|amount\|balance\|cost\|fee"
```
**Fix**: Use `DecimalField(max_digits=10, decimal_places=2)` and `Decimal(str(value))`.

### ARCH-004: Import Structure
```bash
# Circular import risks in tasks
grep -rn "from.*models import\|from.*services import" --include="*.py" src/*/tasks/ | grep "\.\."
```

## P2 - Maintainability

### MAINT-001: File Size
```bash
find src/ -name "*.py" -exec wc -l {} \; | awk '$1 > 400 {print "CRITICAL: " $2 " (" $1 " lines)"}'
find src/ -name "*.py" -exec wc -l {} \; | awk '$1 > 200 && $1 <= 400 {print "WARNING: " $2 " (" $1 " lines)"}'
```

### MAINT-002: Soft Delete
```bash
grep -rn "\.delete()" --include="*.py" src/ | grep -v "soft_delete\|really_delete"
```

## P3 - Documentation

### DOC-001: Service Documentation
```bash
grep -rn "class.*Service\|def.*service" --include="*.py" src/*/services/ | xargs grep -L '"""'
```

## Frontend Checks

### FE-001: Component Hierarchy Violations
```bash
# ui/ importing from higher levels (forbidden)
grep -rn "import.*\.\./shared\|import.*\.\./features" --include="*.tsx" frontend/src/components/ui/
# shared/ importing from features (forbidden)
grep -rn "import.*from.*\.\./\.\./features" --include="*.tsx" frontend/src/components/shared/
```

### FE-002: Hard-coded Text
```bash
grep -rn '"[A-Z][a-z].*"' --include="*.tsx" frontend/src/ | grep -v "t(\|className\|testId\|key=\|data-\|aria-"
```

### FE-003: JS-based Responsiveness (anti-pattern)
```bash
grep -rn "useIsMobile\|isMobile\|window\.innerWidth" --include="*.tsx" frontend/src/
```

## Quality Gates

Automated enforcement at key development checkpoints.

| Gate | P0 Policy | P1 Policy | Trigger |
|------|-----------|-----------|---------|
| Pre-commit | Block | Warn | `git commit` |
| Pull Request | Block | Warn (>5 blocks) | PR open/sync |
| Release | Block | Block if >5 | Tag/release |

### Pre-Commit Gate

```bash
#!/bin/bash
CHANGED=$(git diff --cached --name-only --diff-filter=ACM)
[ -z "$CHANGED" ] && exit 0

# Quick scan changed files for P0 issues
P0_COUNT=0
for f in $CHANGED; do
  case "$f" in *.py)
    # IDOR check
    grep -n "\.get(pk=" "$f" | grep -v "get_owned_object_or_404\|request.user" && P0_COUNT=$((P0_COUNT+1))
    # Timing attack check
    grep -n "== .*token\|== .*secret" "$f" | grep -v "hmac.compare_digest" && P0_COUNT=$((P0_COUNT+1))
  ;; esac
done

[ "$P0_COUNT" -gt 0 ] && echo "COMMIT BLOCKED: $P0_COUNT P0 issues" && exit 1
exit 0
```

### PR Gate

```bash
#!/bin/bash
CHANGED=$(git diff origin/main --name-only)

# Run full audit on changed files
P0_COUNT=$(grep -rn "\.get(pk=" --include="*.py" $CHANGED 2>/dev/null | grep -v "get_owned_object_or_404" | wc -l)

if [ "$P0_COUNT" -gt 0 ]; then
  echo "PR BLOCKED: $P0_COUNT P0 critical issues"
  exit 1
fi
exit 0
```

### CI/CD Integration

```yaml
# .github/workflows/quality.yml
name: Quality Gate
on:
  pull_request:
    branches: [main, develop]
jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - name: Run P0 Security Checks
        run: |
          P0=$(grep -rn "\.get(pk=" --include="*.py" src/ | grep -v "get_owned_object_or_404" | wc -l)
          RACE=$(grep -rn "balance\|amount" --include="*.py" src/ | grep "\.save()" | grep -v "select_for_update\|F(" | wc -l)
          echo "IDOR=$P0 RACE=$RACE"
          [ "$P0" -gt 0 ] || [ "$RACE" -gt 0 ] && exit 1
          exit 0
```

## Quick Health Check Script

```bash
#!/bin/bash
echo "=== P0 Security ==="
IDOR=$(grep -rn "\.get(pk=" --include="*.py" src/ | grep -v "get_owned_object_or_404\|request.user" | wc -l)
RACE=$(grep -rn "balance\|amount" --include="*.py" src/ | grep "\.save()" | grep -v "select_for_update\|F(" | wc -l)
TIMING=$(grep -rn "== .*token\|== .*secret" --include="*.py" src/ | grep -v "hmac.compare_digest" | wc -l)
echo "IDOR: $IDOR | Race: $RACE | Timing: $TIMING"
[ $IDOR -gt 0 ] || [ $RACE -gt 0 ] || [ $TIMING -gt 0 ] && echo "BLOCKING" && exit 1

echo "=== P1 Architecture ==="
SERVICES=$(find src/ -name "services" -type d | wc -l)
MODEL_CONVENTIONS=$(grep -rn "class.*Model):" --include="*.py" src/*/models/ | grep -v "Mixin\|Abstract" | wc -l)
echo "Services dirs: $SERVICES | model convention checks: $MODEL_CONVENTIONS"

echo "=== P2 Quality ==="
LARGE=$(find src/ -name "*.py" -exec wc -l {} \; | awk '$1 > 400' | wc -l)
echo "Files >400 lines: $LARGE"
echo "=== Done ==="
```

## Usage

```bash
# Run specific category
/project:audit --category=security      # P0 only
/project:audit --category=architecture  # P1 only
/project:audit --category=quality       # P2-P3
/project:audit --category=gates         # Quality gate scripts

# Run on specific paths
/project:audit src/domains/identity/
/project:audit frontend/src/components/
```
