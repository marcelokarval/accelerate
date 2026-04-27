# Browser Security Boundary Contract

Required security boundaries:

- localhost-only default
- scoped tokens for remote/shared sessions
- no root token over tunnels
- command allowlists for remote callers
- unsafe URL and metadata IP blocking
- safe directory model for file reads/writes
- no cookie values in logs
- untrusted page content wrapped before model exposure
