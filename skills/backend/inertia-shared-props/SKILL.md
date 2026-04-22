---
name: inertia-shared-props
description: "Fullstack skill. Backend: InertiaShareMiddleware implementation,
  _get_auth_data(), set_flash_message(). Frontend: usePage().props TypeScript
  contract (auth.user, flash, app, locale)."
compatibility: Django 6.0+, Inertia.js 2.x, React 19
metadata:
  author: accelerate
  version: "1.0.0"
  stack: django-inertia
  category: fullstack
  related-skills: django-middleware-patterns django-inertia-integration inertia-patterns
---

# Inertia Shared Props Pattern

Auto-inject shared data into ALL Inertia responses via middleware.

## InertiaShareMiddleware

```python
# interfaces/web/middleware/inertia_share.py
import logging
from typing import Callable

from django.http import HttpRequest, HttpResponse
from django.conf import settings
from inertia import share

logger = logging.getLogger(__name__)


class InertiaShareMiddleware:
    """
    Auto-inject shared props into all Inertia responses.

    Shared props available via usePage().props:
    - auth: User data and authentication status
    - flash: Flash messages (success, error, info, warning)
    - app: Application config (name, version, environment)
    - locale: Language settings
    """

    def __init__(self, get_response: Callable[[HttpRequest], HttpResponse]):
        self.get_response = get_response

    def __call__(self, request: HttpRequest) -> HttpResponse:
        # Share data BEFORE view processing
        self._share_data(request)
        return self.get_response(request)

    def _share_data(self, request: HttpRequest) -> None:
        """Share common data for all Inertia pages."""
        # App configuration
        share(request, app={
            "name": getattr(settings, "APP_NAME", "Application"),
            "version": getattr(settings, "APP_VERSION", "1.0.0"),
            "environment": getattr(settings, "APP_ENV", "development"),
        })

        # Locale settings
        share(request, locale={
            "language": getattr(request, "LANGUAGE_CODE", "en"),
        })

        # Auth data
        share(request, auth=self._get_auth_data(request))

        # Flash messages
        share(request, flash=self._get_flash_data(request))

    def _get_auth_data(self, request: HttpRequest) -> dict:
        """Get authentication data."""
        user = getattr(request, "user", None)

        if user and user.is_authenticated:
            return {
                "user": {
                    "public_id": getattr(user, "public_id", None),
                    "email": user.email,
                    "first_name": user.first_name,
                    "last_name": user.last_name,
                    "full_name": user.get_full_name(),
                    "is_staff": user.is_staff,
                    "email_verified": getattr(user, "email_verified", False),
                    "setup_status": getattr(user, "setup_status", None),
                    "is_delinquent": getattr(user, "is_delinquent", False),
                },
                "is_authenticated": True,
            }

        return {"user": None, "is_authenticated": False}

    def _get_flash_data(self, request: HttpRequest) -> dict:
        """Get flash messages from session (consumed after read)."""
        flash = {"success": None, "error": None, "info": None, "warning": None}

        session = getattr(request, "session", None)
        if session:
            for msg_type in flash.keys():
                if msg_type in session:
                    flash[msg_type] = session.pop(msg_type)

        return flash
```

## Frontend Usage (React)

```tsx
// In any React component:
import { usePage } from '@inertiajs/react';

interface SharedProps {
  auth: {
    user: {
      public_id: string;
      email: string;
      first_name: string;
      last_name: string;
      full_name: string;
      is_staff: boolean;
      email_verified: boolean;
      setup_status: string;
      is_delinquent: boolean;
    } | null;
    is_authenticated: boolean;
  };
  flash: {
    success: string | null;
    error: string | null;
    info: string | null;
    warning: string | null;
  };
  app: {
    name: string;
    version: string;
    environment: string;
  };
  locale: {
    language: string;
  };
}

function MyComponent() {
  const { auth, flash, app, locale } = usePage<SharedProps>().props;

  return (
    <div>
      {auth.is_authenticated && <span>Welcome, {auth.user?.first_name}</span>}
      {flash.success && <p className="text-sm text-green-600">{flash.success}</p>}
      <span>Language: {locale.language}</span>
    </div>
  );
}

// Use the active project's toast or alert primitive for flash messages.
import { toast } from 'sonner';
import { usePage } from '@inertiajs/react';
import { useEffect } from 'react';

function useFlashMessages() {
  const { flash } = usePage().props;
  useEffect(() => {
    if (flash.success) toast.success(flash.success);
    if (flash.error) toast.error(flash.error);
    if (flash.info) toast.info(flash.info);
    if (flash.warning) toast.warning(flash.warning);
  }, [flash]);
}
```

## Setting Flash Messages (Django)

```python
# interfaces/web/shared/context.py
def set_flash_message(request, msg_type: str, message: str):
    """Set a flash message to show on next page."""
    if hasattr(request, "session"):
        request.session[msg_type] = message


# Usage in views:
from interfaces.web.shared import set_flash_message

def my_view(request):
    # ... process ...
    set_flash_message(request, "success", "Item created successfully!")
    return redirect("/items/")
```

## TypeScript Types (frontend/src/types/inertia.d.ts)

```typescript
import { PageProps } from '@inertiajs/core';

declare module '@inertiajs/core' {
  interface PageProps {
    auth: {
      user: AuthUser | null;
      is_authenticated: boolean;
    };
    flash: FlashMessages;
    app: AppConfig;
    locale: LocaleConfig;
  }
}

interface AuthUser {
  public_id: string;
  email: string;
  first_name: string;
  last_name: string;
  full_name: string;
  is_staff: boolean;
  email_verified: boolean;
  setup_status: 'incomplete' | 'basic' | 'complete';
  is_delinquent: boolean;
}

interface FlashMessages {
  success: string | null;
  error: string | null;
  info: string | null;
  warning: string | null;
}

interface AppConfig {
  name: string;
  version: string;
  environment: 'development' | 'staging' | 'production';
}

interface LocaleConfig {
  language: 'en' | 'pt' | 'es';
}
```

## Key Rules

1. **Use middleware** - Don't call get_shared_data() manually in views
2. **Share BEFORE view** - Call share() before get_response()
3. **Consume flash messages** - Pop from session after reading
4. **Never expose PK** - Use public_id in auth.user
5. **Type your props** - Use TypeScript interfaces for safety
