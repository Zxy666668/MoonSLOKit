///|
fn main {
  let target = @slo.SloTarget::new("checkout-api", 9900, 30 * 24 * 60)
  let window = @slo.RequestWindow::new("5m", 5, 1000, 980)
  let budget = @slo.evaluate_budget(target, window)
  let burn = @slo.calculate_burn_rate(target, window)
  let alert = @slo.evaluate_burn_rule(
    burn,
    @slo.BurnRule::new("fast-burn", @slo.AlertLevel::Page, 150),
  )
  let forecast = @slo.forecast_budget(target, window, 5)
  let service = @slo.evaluate_service_objective(
    @slo.ServiceObjective::new(
      "checkout",
      target,
      @slo.standard_burn_rules(),
    ),
    @slo.RequestWindow::new("30m", 30, 10000, 9950),
    [
      @slo.RequestWindow::new("5m", 5, 1000, 980),
      @slo.RequestWindow::new("1h", 60, 10000, 9970),
      @slo.RequestWindow::new("6h", 360, 60000, 59850),
      @slo.RequestWindow::new("24h", 1440, 240000, 239200),
    ],
    @slo.ReleaseGate::new("prod", 8000, true),
  )

  println("MoonSLOKit demo")
  println("availability_bp: \{window.availability_bp()}")
  println("burn_rate: \{burn.rate_label()}")
  println("budget: \{budget.to_json()}")
  println("alert: \{alert.to_json()}")
  println("forecast: \{forecast.to_json()}")
  println("service: \{service.to_json()}")
}
