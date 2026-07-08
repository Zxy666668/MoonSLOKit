///|
test "slo target clamps basis points" {
  let target = SloTarget::new("api", 9990, 30 * 24 * 60)
  assert_eq(target.target_bp, 9990)
  assert_eq(target.allowed_error_bp(), 10)
}

///|
test "request window computes availability" {
  let window = RequestWindow::new("5m", 5, 1000, 998)
  assert_eq(window.bad(), 2)
  assert_eq(window.availability_bp(), 9980)
  assert_eq(window.error_bp(), 20)
}

///|
test "budget report measures consumed error budget" {
  let target = SloTarget::new("checkout", 9900, 30)
  let window = RequestWindow::new("30m", 30, 10000, 9950)
  let report = evaluate_budget(target, window)
  assert_eq(report.allowed_bad, 100)
  assert_eq(report.actual_bad, 50)
  assert_eq(report.consumed_bp, 5000)
  assert_true(report.healthy())
}

///|
test "burn rate compares observed and allowed error" {
  let target = SloTarget::new("search", 9900, 30)
  let window = RequestWindow::new("5m", 5, 1000, 980)
  let report = calculate_burn_rate(target, window)
  assert_eq(report.allowed_error_bp, 100)
  assert_eq(report.observed_error_bp, 200)
  assert_eq(report.burn_rate_x100, 200)
  assert_eq(report.rate_label(), "2.00x")
}

///|
test "burn rule turns high burn rate into alert decision" {
  let target = SloTarget::new("api", 9900, 30)
  let report = calculate_burn_rate(
    target,
    RequestWindow::new("5m", 5, 1000, 980),
  )
  let decision = evaluate_burn_rule(
    report,
    BurnRule::new("fast-burn", Page, 150),
  )
  assert_true(decision.is_alert())
  assert_eq(decision.reason, "threshold_exceeded")
}
