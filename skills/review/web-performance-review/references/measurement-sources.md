# Measurement Sources

## CrUX Field Data

Record origin or URL scope, metric percentile, form factor, collection period,
eligibility, and retrieval timestamp. CrUX describes a historical eligible-user
population; it does not prove the current local build caused a change.

## Lighthouse Lab Data

Record target URL/build, Lighthouse and browser versions, execution location,
device/emulation, throttling, cache state, run count, per-run results, and
chosen aggregation. Keep the report or JSON locator. Lab scores are diagnostic,
not field population truth.

## Browser Trace

Record browser/build, page state, capture steps, CPU/network conditions, cache
state, trace locator, and relevant events. Use traces to connect long tasks,
resource loading, layout, paint, or interaction timing to an observed run.

## Application Telemetry

Record metric definition, sampling, release/build, route, geography/device
population, time window, exclusions, and query/dashboard locator. Compare only
compatible definitions and populations.

## Static Evidence

Bundle manifests, source inspection, dependency graphs, image metadata, and
headers can reveal opportunity. Label them `static`; do not attach observed
runtime metrics unless a separate measured artifact supports them.
