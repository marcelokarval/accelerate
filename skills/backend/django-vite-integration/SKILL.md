---
name: django-vite-integration
description: Django-Vite + Inertia.js asset pipeline patterns. Use when configuring Vite build, debugging blank pages, managing dev/prod asset modes, or understanding how Django serves React assets.
compatibility: Django 6.0+, django-vite 3.x, Vite 7.x, Inertia.js 2.x, React 19
metadata:
  author: accelerate
  version: "1.0.0"
  stack: django-inertia
  category: fullstack
  related-skills: inertia-shared-props django-inertia-integration inertia-patterns
---

# Django-Vite Integration

How Django serves React assets via django-vite, in dev and production.

## Architecture Overview

```
DEV MODE (Vite running):
  Browser ──> Django:8000 (HTML) ──> Vite:3333 (JS/CSS/HMR)

PROD MODE (Vite NOT running):
  Browser ──> Django:8000 (HTML + static assets from build)
```

django-vite has ONE job: generate the correct `<script>` and `<link>` tags
in Django templates depending on which mode is active.

## Two Modes of Operation

### Dev Mode (`dev_mode: True`)

Requires Vite dev server running (`npm run dev`).

Template tags generate URLs pointing to Vite dev server:
```html
{% vite_hmr_client %}      → <script src="http://localhost:3333/static/@vite/client">
{% vite_react_refresh %}   → <script> import RefreshRuntime from '.../@react-refresh' ...
{% vite_asset "src/..." %} → <script src="http://localhost:3333/static/src/web-entry.tsx">
```

Provides: HMR, React Fast Refresh, no build needed, instant updates.

### Prod Mode (`dev_mode: False`)

Requires `npm run build` executed. No Vite server needed.

Template tags read `manifest.json` and generate hashed URLs:
```html
{% vite_hmr_client %}      → (nothing)
{% vite_react_refresh %}   → (nothing)
{% vite_asset "src/..." %} → <link rel="stylesheet" href="/static/assets/globals-5U1u.css">
                              <script type="module" src="/static/assets/web-Bpmr.js">
                              <link rel="modulepreload" href="/static/assets/vendor-*.js">
```

Assets served by Django/WhiteNoise as regular static files.

## Auto-Detection Pattern (CRITICAL)

Instead of manually toggling `dev_mode`, we auto-detect if Vite is running:

```python
# config/settings/base.py

_VITE_DEV_HOST = "localhost"
_VITE_DEV_PORT = 3333


def _detect_vite_dev_mode() -> bool:
    """Auto-detect if Vite dev server is running.

    Priority:
    1. Explicit DJANGO_VITE_DEV_MODE env var (overrides auto-detection)
    2. Non-dev environments (production/staging) → always False
    3. TCP socket check to Vite dev server (<100ms timeout)
    """
    explicit = os.getenv("DJANGO_VITE_DEV_MODE", "").lower()
    if explicit in ("true", "1", "yes"):
        return True
    if explicit in ("false", "0", "no"):
        return False

    # Only auto-detect in local/development
    if not is_development():
        return False

    import socket

    try:
        with socket.create_connection(
            (_VITE_DEV_HOST, _VITE_DEV_PORT), timeout=0.1
        ):
            return True
    except (ConnectionRefusedError, OSError, TimeoutError):
        return False


DJANGO_VITE = {
    "default": {
        "dev_mode": _detect_vite_dev_mode(),
        "dev_server_protocol": "http",
        "dev_server_host": _VITE_DEV_HOST,
        "dev_server_port": _VITE_DEV_PORT,
        "static_url_prefix": "",
        "manifest_path": BASE_DIR / "static" / "manifest.json",
    }
}
```

### Why auto-detect?
- **Problem**: `dev_mode: is_development()` was always True in local env,
  causing blank pages when Vite wasn't running but built assets existed.
- **Solution**: TCP check runs once at Django startup (<100ms), zero config.
- **Override**: Set `DJANGO_VITE_DEV_MODE=true|false` to force either mode.

## Vite Config (vite.config.ts)

```typescript
export default defineConfig({
  base: '/static/',              // MUST match Django STATIC_URL
  build: {
    outDir: '../src/static/',    // Build output goes INTO Django's static dir
    manifest: 'manifest.json',  // Generates manifest for django-vite
    emptyOutDir: true,
    rollupOptions: {
      input: {
        web: 'src/web-entry.tsx',  // Main entry point
      },
      output: {
        manualChunks: {            // Optional: vendor splitting
          'vendor-inertia': ['react', 'react-dom', '@inertiajs/react'],
          'vendor-i18n': ['react-i18next', 'i18next'],
        },
      },
    },
  },
  server: {
    host: '0.0.0.0',
    port: 3333,           // Must match DJANGO_VITE port config
    strictPort: true,
  },
})
```

Critical alignment: `base: '/static/'` must match `STATIC_URL` in Django.

## Django Template (base.html)

```html
{% load django_vite %}
<html>
<head>
    {% vite_hmr_client %}                     {# Dev only: HMR websocket #}
    {% vite_react_refresh %}                  {# Dev only: React Fast Refresh #}
    {% vite_asset "src/web-entry.tsx" %}       {# Dev: Vite URL / Prod: manifest lookup #}
</head>
<body>
    {% block inertia %}{% endblock %}         {# Inertia mounts here #}
</body>
</html>
```

## The manifest.json

Generated by `npm run build`. Maps source files to hashed output files.

```json
{
  "src/web-entry.tsx": {
    "file": "assets/web-BpmrSNPY.js",
    "isEntry": true,
    "css": ["assets/globals-5U1uCX7w.css"],
    "imports": ["_vendor-inertia-DA-hhXgS.js"],
    "dynamicImports": ["src/pages/auth/login.tsx", "..."]
  },
  "src/pages/auth/login.tsx": {
    "file": "assets/login-eAG44YkO.js",
    "isDynamicEntry": true,
    "imports": ["_vendor-ui-B8s8UfAf.js", "..."]
  }
}
```

django-vite reads this to resolve:
- Entry `file` → `<script src="...">`
- Entry `css` → `<link rel="stylesheet">`
- Entry `imports` → `<link rel="modulepreload">`
- `dynamicImports` are loaded on-demand by the browser (code splitting)

## File Flow Diagram

```
frontend/src/web-entry.tsx    (source)
        │
        ├── npm run dev ──────> Vite:3333 serves directly (dev)
        │
        └── npm run build ───> src/static/assets/web-*.js  (prod)
                                src/static/manifest.json
                                        │
                                django-vite reads manifest
                                        │
                                base.html {% vite_asset %} tags
                                        │
                                Browser loads /static/assets/*
```

## Page Resolution (Inertia + Vite)

```
Django view                    web-entry.tsx                    Browser
─────────────                  ─────────────                    ───────
render(req,                    const pages = import.meta.glob(  Loads
  'auth/login',  ──JSON──>       './pages/**/*.tsx')            login
  props={...})                 pages['./pages/auth/login.tsx']  chunk
                               → dynamic import()              lazily
```

With `{ eager: true }`: all pages bundled in one chunk (simpler, larger).
Without `eager`: each page is a separate chunk (code splitting, smaller initial load).

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| Blank page, console shows `localhost:3333` errors | `dev_mode=True` but Vite not running | Auto-detect handles this; or set `DJANGO_VITE_DEV_MODE=false` |
| Blank page, no console errors | manifest.json missing or wrong path | Run `npm run build`, check `manifest_path` in settings |
| HMR not working | Vite port mismatch | Align `server.port` in vite.config.ts with `dev_server_port` in settings |
| CSS not loading in prod | `base` mismatch | Ensure `base: '/static/'` matches `STATIC_URL` |
| Assets 404 in prod | `outDir` wrong | Ensure `outDir: '../src/static/'` and `STATICFILES_DIRS` includes it |

## Key Rules

1. **Auto-detect mode** - Never hardcode `dev_mode` to `is_development()`
2. **Align base/STATIC_URL** - `vite.config.ts base` must equal Django `STATIC_URL`
3. **Build before prod** - Always `npm run build` before deploying
4. **manifest_path must exist** - Point to the actual manifest.json location
5. **Port alignment** - Vite server port must match django-vite config
6. **Override when needed** - Use `DJANGO_VITE_DEV_MODE` env var to force a mode
