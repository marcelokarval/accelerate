# Browser Truth Contract

Browser truth should include screenshots/captures, console evidence, network
evidence, target route/URL, viewport, auth/session posture, and residual gaps.

Screenshot-only proof is insufficient for UI/runtime behavior.

`onboarding/local-workspace/capture-browser-proof.sh` is the repo-local browser
proof helper. It defaults to localhost-only URLs, writes a JSON proof packet, and
records screenshot, console, network, viewport, URL, and privacy metadata. Remote
URLs are blocked until a request-intercepting adapter can prevent page-triggered
private network and metadata-host subresource requests.
