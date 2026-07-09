# Related Work

MoonSLOKit avoids overlap with MoonBit web frameworks, task libraries, and
general data-processing packages.

## Differentiation

- Web frameworks expose HTTP routing and middleware. MoonSLOKit only evaluates
  reliability windows and returns SLO decisions.
- Metrics collectors gather time-series data. MoonSLOKit consumes already
  aggregated request counts.
- Dashboard or chart libraries visualize metrics. MoonSLOKit produces the
  deterministic SLO/budget/burn-rate numbers to visualize.
- General statistics packages expose formulas. MoonSLOKit encodes reliability
  semantics such as target, budget, burn rate, and alert level.

## Intended Use

- CI gates for release reliability checks.
- Monitoring alert logic.
- Service-level dashboards.
- Teaching examples for SLO and error-budget concepts.

## Response to Review Feedback

The project is now framed as an SLO decision engine rather than a broad
monitoring platform. The implementation adds traffic aggregation, standard
multi-window burn templates, budget exhaustion forecasts, release-gate
decisions, service-level evaluation, annotations, expanded JSON exports, and
regression tests. These additions make the repository a reusable reliability
library instead of a minimal demonstration.
