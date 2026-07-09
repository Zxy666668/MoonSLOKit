# Acceptance Notes

## Implemented Scope

- `SloTarget` basis-point target model.
- `RequestWindow` good/bad request aggregation.
- `TrafficSample` aggregation for recent windows.
- Error-budget reports.
- Error-budget exhaustion forecasts.
- Burn-rate reports.
- Burn-rate alert rules.
- Standard burn-rate templates.
- Multi-window evaluation.
- Release gate decisions.
- Service-level SLO evaluation.
- Deploy and incident annotations.
- JSON export and CLI demo.

## Verification

```text
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon run cmd/main
```

The library core is backend-neutral and contains no platform-specific IO.

The enhanced version intentionally goes beyond the original prototype. It now
supports a realistic reliability workflow from traffic aggregation to CI release
gating, with regression tests covering each added module.
