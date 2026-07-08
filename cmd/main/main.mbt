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

  println("MoonSLOKit demo")
  println("availability_bp: \{window.availability_bp()}")
  println("burn_rate: \{burn.rate_label()}")
  println("budget: \{budget.to_json()}")
  println("alert: \{alert.to_json()}")
}
