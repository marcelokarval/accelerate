# Deploy Verification Packet

- provider adapter: <adapter name and capability manifest path>
- deploy target: <environment, project, region, or release target>
- CI/check status: <passed|blocked|not-applicable with rationale>
- deployment action: <merge|deploy|release|manual handoff|not-requested>
- canary evidence: <path or not-applicable with rationale>
- rollback posture: <rollback path, investigate path, or explicit waiver>
- production readiness result: <ready|blocked|not-requested>

This template is not production evidence. Replace every placeholder before
running `check-production-readiness.sh`.
