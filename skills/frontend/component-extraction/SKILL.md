---
name: component-extraction
description: DRY patterns for identifying and extracting reusable React components. Use when auditing pages for duplication or refactoring to shared components.
disable-model-invocation: false
user-invocable: true
allowed-tools: Read, Edit, Glob
---

# DRY Component Extraction Skill

Patterns for identifying and extracting reusable components from pages.

## When to Use

Auditing pages for code duplication, creating reusable components, or refactoring to DRY.

## 1. Detection Patterns

### Rule of Three
If a pattern appears **3+ times**, extract it.

| Signal | Example | Action |
|--------|---------|--------|
| Same JSX structure | Footer link in 4 pages | Extract component |
| Same className combo | `"text-center pt-4"` repeated | Extract or variant |
| Same handler pattern | `router.visit("/auth/login")` | Extract to hook |
| Same conditional render | `{errors?.field && <Error />}` | Extract component |

## 2. Extraction Patterns

### Pattern A: UI Component

**Before** (in 4 pages):
```tsx
<div className="text-center pt-4">
  <span className="text-small text-default-500">
    Nao tem uma conta?{" "}
    <Link className="text-sm text-primary cursor-pointer hover:underline" onPress={handleRegister}>
      Cadastre-se
    </Link>
  </span>
</div>
```

**After**:
```tsx
// components/auth/auth-footer-link.tsx
interface AuthFooterLinkProps {
  text: string;
  linkText: string;
  onPress: () => void;
}

export const AuthFooterLink = ({ text, linkText, onPress }: AuthFooterLinkProps) => (
  <div className="text-center pt-4">
    <span className="text-small text-default-500">
      {text}{" "}
      <Link className="text-sm text-primary cursor-pointer hover:underline" onPress={onPress}>
        {linkText}
      </Link>
    </span>
  </div>
);
```

### Pattern B: Hook Extraction

**Before** (in 4 pages):
```tsx
const handleGoogleLogin = () => router.visit("/auth/google/login")
const handleRegister = () => router.visit("/auth/register")
```

**After**:
```tsx
// hooks/use-auth-navigation.ts
export const useAuthNavigation = () => {
  const navigate = React.useCallback((path: string) => router.visit(path), []);
  return {
    toLogin: () => navigate("/auth/login"),
    toRegister: () => navigate("/auth/register"),
    toForgotPassword: () => navigate("/auth/forgot-password"),
    toGoogleLogin: () => navigate("/auth/google/login"),
    toDashboard: () => navigate("/dashboard"),
  };
};
```

### Pattern C: Form Handler

**Before** (in 4 pages):
```tsx
const handleInputChange = (field: keyof FormData) => (value: string | boolean) => {
  setData(field, value as FormData[typeof field])
}
```

**After**: Integrate into a shared `useForm` wrapper that provides `handleInputChange` automatically.

### Pattern D: Conditional Render

**Before**:
```tsx
{errors?.general && (
  <div className="p-3 bg-danger-50 border border-danger-200 rounded-lg">
    <p className="text-sm text-danger">{errors.general}</p>
  </div>
)}
```

**After**:
```tsx
// components/ui/form-error-banner.tsx
interface FormErrorBannerProps { error?: string }

export const FormErrorBanner = ({ error }: FormErrorBannerProps) => {
  if (!error) return null;
  return (
    <div className="p-3 bg-danger-50 border border-danger-200 rounded-lg">
      <p className="text-sm text-danger">{error}</p>
    </div>
  );
};
```

### Pattern E: Compound Component Wrapper

**Before** (verbose):
```tsx
<Checkbox checked={data.remember} onCheckedChange={handleChange}>
  <CheckboxIndicator />
  <Label className="text-sm text-muted-foreground">Remember me</Label>
</Checkbox>
```

**After**:
```tsx
// components/ui/labeled-checkbox.tsx
interface LabeledCheckboxProps {
  label: React.ReactNode;
  checked: boolean;
  onCheckedChange: (selected: boolean) => void;
}

export const LabeledCheckbox = ({ label, checked, onCheckedChange }: LabeledCheckboxProps) => (
  <Checkbox checked={checked} onCheckedChange={onCheckedChange}>
    <CheckboxIndicator />
    <Label className="text-sm text-muted-foreground">{label}</Label>
  </Checkbox>
);
```

## 3. Placement Rules

```
components/
├── ui/       # Generic, reusable across app (FormErrorBanner, LabeledCheckbox)
├── auth/     # Feature-specific (AuthFooterLink)
├── shared/   # Cross-feature reusable
└── layout/   # Layout components (AuthLayout)
```

**Decision tree**: Used across features? -> `ui/`. Layout? -> `layout/`. Otherwise -> `{feature}/`.

## 4. Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| UI Component | Descriptive noun | `FormErrorBanner` |
| Feature Component | Feature prefix | `AuthFooterLink` |
| Hook | `use` prefix | `useAuthNavigation` |

## 5. Anti-Patterns

**DON'T over-extract**:
```tsx
// BAD: const RedText = ({ children }) => <span className="text-danger">{children}</span>
```

**DON'T use too many props** - use variants instead:
```tsx
// BAD: <Button textColor="primary" bgColor="transparent" ... 10 more props />
// GOOD: <Button variant="ghost" size="sm">Click</Button>
```

**DON'T put business logic in UI components** - keep pure, pass handlers via props.

## 6. Extraction Checklist

- [ ] Component has single responsibility
- [ ] Props interface defined
- [ ] Exported from barrel file (`index.ts`)
- [ ] Old inline code replaced with component
- [ ] Types exported from barrel file

## 7. Metrics

| Metric | Target |
|--------|--------|
| Lines per page | < 150 |
| Inline JSX blocks | 0 |
| Repeated patterns | 0 |
| Import statements | < 15 per file |
