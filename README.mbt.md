# MoonSLOKit

MoonSLOKit is a MoonBit foundation library for SLO evaluation, error-budget
tracking, and burn-rate alert decisions.

It is intended for service reliability tooling, CI gates, API stability checks,
and monitoring dashboards that need deterministic SLO math.

## Features

- SLO target definition in basis points.
- Request windows with good/bad request counts.
- Minute-level traffic sample aggregation into request windows.
- Availability and error-rate calculation.
- Error-budget consumed and remaining reports.
- Error-budget exhaustion forecasting.
- Burn-rate calculation.
- Burn-rate alert rules with page/ticket decisions.
- Standard multi-window burn-rate templates.
- Multi-window evaluation.
- Release gate decisions for CI and rollout workflows.
- Service-level objective evaluation.
- Deploy and incident annotations for explainable windows.
- Stable JSON export and CLI demo.

## Quick Example

```mbt nocheck
///|
test {
  let target = SloTarget::new("api", 9900, 30 * 24 * 60)
  let window = RequestWindow::new("5m", 5, 1000, 980)
  let burn = calculate_burn_rate(target, window)

  assert_eq(burn.rate_label(), "2.00x")
}
```

## Commands

```bash
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon run cmd/main
```

## Boundary

MoonSLOKit is not a metrics collector, storage engine, web server, or dashboard.
It provides the reusable SLO math and explainable decision layer that those
systems can embed.

## Industrial Scenario

MoonSLOKit now covers a complete small reliability workflow:

1. Aggregate traffic samples into SLO windows.
2. Evaluate availability and error-budget consumption.
3. Compute burn rates across standard short and long windows.
4. Forecast budget exhaustion from recent traffic.
5. Produce a release-gate decision for CI or rollout tooling.
6. Attach deploy or incident annotations to explain window behavior.
