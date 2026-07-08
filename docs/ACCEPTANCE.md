# Acceptance Notes

## Implemented Scope

- `SloTarget` basis-point target model.
- `RequestWindow` good/bad request aggregation.
- Error-budget reports.
- Burn-rate reports.
- Burn-rate alert rules.
- Multi-window evaluation.
- JSON export and CLI demo.

## Verification

```text
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon run cmd/main
```

The library core is backend-neutral and contains no platform-specific IO.
