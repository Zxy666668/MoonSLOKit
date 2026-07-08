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
